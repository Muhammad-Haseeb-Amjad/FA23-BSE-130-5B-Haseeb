# Requirements: Profile Scroll Fix & WhatsApp-like Video Send

## Overview
Fix two Flutter app issues: (1) profile screen slow/janky scrolling, and (2) video sending UX that blocks the user on the preview screen during upload.

---

## PART 1 — Profile Screen Scroll Performance

### R1: Profile screen must scroll smoothly
- The profile screen shall scroll at 60fps without jank on all Android screen sizes.
- Scrolling up and down quickly shall not cause visible lag or dropped frames.

### R2: Root cause — scroll listener calling update on every frame
- `ProfileController.onReady()` adds a `_profileScrollListener` that calls `update([scrollID])` on every scroll frame.
- This triggers a full `GetBuilder` rebuild of the `SliverAppBar` on every pixel of scroll.
- The fix shall throttle or eliminate unnecessary rebuilds during scroll.

### R3: Profile layout uses CustomScrollView with Slivers
- The profile screen already uses `CustomScrollView` with `SliverAppBar`, `SliverToBoxAdapter`, and `SliverFillRemaining`.
- The `FeedsView` inside `SliverFillRemaining` uses `shrinkWrap: false` (correct).
- The `ReelsGrid` uses `shrinkWrap: false` (correct).
- No nested scroll view changes are needed — only the scroll listener rebuild frequency must be fixed.

### R4: Scroll listener shall only rebuild when opacity/size actually changes
- The `_profileScrollListener` computes `currentExtent`, `size`, `opacity`.
- It shall only call `update([scrollID])` when the computed values actually change by a meaningful threshold (e.g., opacity changes by > 0.01).
- This eliminates redundant rebuilds when the user scrolls in the middle of the page where opacity is already 0 or 1.

---

## PART 2 — WhatsApp-like Video Send Flow

### R5: ChatMessage model must support pending/upload state
- `ChatMessage` shall have the following additional fields:
  - `uploadStatus`: `String?` — values: `'uploading'`, `'uploaded'`, `'failed'`, or `null` (for server messages)
  - `uploadProgress`: `double` — 0.0 to 1.0, default 0.0
  - `localThumbnailPath`: `String?` — local file path for thumbnail before upload completes
  - `localVideoPath`: `String?` — local file path for video before upload completes
  - `localId`: `String?` — unique temp ID for matching pending messages

### R6: Tapping SEND on video preview must immediately close the preview
- When the user taps SEND on `WriteDescriptionSheet` for a video:
  1. The `_isSending` guard prevents double-tap.
  2. `Get.back()` is called immediately — the preview sheet closes.
  3. A pending `ChatMessage` is inserted into `controller.messages` instantly.
  4. Upload starts in the background.
  5. The user sees the chat screen with the pending video bubble immediately.

### R7: Pending video message must appear in chat instantly
- `ChattingController.addPendingVideoMessage(localId, localVideoPath, localThumbPath, caption)` shall:
  - Create a `ChatMessage` with `uploadStatus = 'uploading'`, `uploadProgress = 0.0`.
  - Insert it at index 0 of `messages` (newest first, since list is reversed).
  - Call `update()` to refresh the chat list.
  - Scroll to bottom after the next frame using `WidgetsBinding.instance.addPostFrameCallback`.

### R8: Upload progress must be shown on the video bubble
- While `uploadStatus == 'uploading'`, the video bubble shall show:
  - A dark overlay on the thumbnail.
  - Bottom-left corner: a small `CircularProgressIndicator` with `value` set to `uploadProgress`.
  - Bottom-left corner: a `Text` showing `'${(uploadProgress * 100).round()}%'`.
  - The play button shall be replaced by a spinner in the center.
- This UI is already implemented in `chat_tag.dart`'s `imageAndVideoView()`.

### R9: Upload must use progress callback
- `PostService.shared.uploadFileWithProgress(file, onProgress: callback)` already exists and supports progress.
- `ChattingController` shall use this method for video upload.
- On each progress callback: call `updatePendingVideoProgress(localId, progress)` which updates `uploadProgress` on the matching message and calls `update()`.

### R10: On upload complete, pending message must be updated (not duplicated)
- `ChattingController.completePendingVideoMessage(localId, videoURL, thumbnailURL)` shall:
  - Find the pending message by `localId`.
  - Update `uploadStatus = 'uploaded'`, `uploadProgress = 1.0`, `content = videoURL`, `thumbnail = thumbnailURL`.
  - Write the final message to Firestore via `drChatMessages`.
  - Call `update()`.
- No duplicate message shall be added to the list.
- The Firestore listener shall not add a duplicate because the message ID will match an existing entry and trigger `DocumentChangeType.modified`.

### R11: Failed upload must show retry state
- `ChattingController.failPendingVideoMessage(localId)` shall:
  - Find the pending message by `localId`.
  - Set `uploadStatus = 'failed'`.
  - Call `update()`.
- The video bubble shall show a red "Retry" overlay when `uploadStatus == 'failed'`.
- Tapping retry shall call `ChattingController.retryVideoUpload(message)`.
- `retryVideoUpload` shall reset `uploadStatus = 'uploading'`, `uploadProgress = 0.0`, and restart the upload using `localVideoPath` and `localThumbPath`.

### R12: Image sending must not be broken
- The existing image send flow (upload then `commonSend`) shall remain unchanged.
- Only the video branch in `_onSendTap` is changed.

### R13: Text messages must not be broken
- `sendMsg()` and `commonSend(type: MessageType.text)` shall remain unchanged.

### R14: No duplicate messages
- The Firestore real-time listener in `fetchMessages()` handles `DocumentChangeType.added` and `DocumentChangeType.modified`.
- When `completePendingVideoMessage` writes to Firestore, the listener will fire `modified` (not `added`) because the message ID already exists in the local list.
- The implementation shall ensure the local `localId` matches the Firestore document ID used when writing the completed message.

### R15: No Navigator _debugLocked crash
- `Get.back()` shall only be called once per SEND tap.
- The `_isSending` guard prevents double-tap.
- No `Get.back()` shall be called after the sheet is already dismissed.

### R16: Video preview screen responsiveness
- The `WriteDescriptionSheet` shall not overflow on any Android screen size.
- The video thumbnail preview shall use `AspectRatio` or `BoxFit.contain` to avoid overflow.
- The SEND button shall remain accessible at the top-right on all screen sizes.

---

## PART 3 — Build Verification

### R17: flutter analyze must pass with no errors
- After all changes, `flutter analyze` shall report no errors.

### R18: APK must build successfully
- `flutter build apk --release` shall complete without errors.
- Output: `build/app/outputs/flutter-apk/app-release.apk`

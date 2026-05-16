# Tasks: Profile Scroll Fix & WhatsApp-like Video Send

## Task 1: Fix profile screen scroll jank — throttle scroll listener rebuilds
- [x] 1.1 Open `lib/screens/profile_screen/profile_controller.dart`
- [x] 1.2 Add a `double _lastReportedOpacity = -1.0;` field to `ProfileController`
- [x] 1.3 In `_profileScrollListener`, compute `newOpacity` using the same formula as `profile_screen.dart` (based on `currentExtent`)
- [x] 1.4 Only call `update([scrollID])` when `(newOpacity - _lastReportedOpacity).abs() > 0.02`; update `_lastReportedOpacity` when firing
- [x] 1.5 Verify the profile screen still animates the app bar correctly when scrolling near the top

## Task 2: Add upload state fields to ChatMessage model
- [x] 2.1 Open `lib/models/chat.dart`
- [x] 2.2 Add private fields to `ChatMessage`: `_uploadStatus` (String?), `_uploadProgress` (double, default 0.0), `_localThumbnailPath` (String?), `_localVideoPath` (String?), `_localId` (String?)
- [x] 2.3 Add public getters and setters for all new fields
- [x] 2.4 Do NOT add these fields to `toFireStore()` or `fromFireStore()` — they are local-only state
- [x] 2.5 Update the `ChatMessage` constructor to accept optional named parameters for these fields

## Task 3: Add pending video message methods to ChattingController
- [x] 3.1 Open `lib/screens/chats_screen/chatting_screen/chatting_controller.dart`
- [x] 3.2 Add `addPendingVideoMessage({required String localId, required String localVideoPath, required String localThumbPath, required String caption})` — creates a pending `ChatMessage`, inserts at index 0 of `messages`, calls `update()`, and scrolls to bottom via `addPostFrameCallback`
- [x] 3.3 Add `updatePendingVideoProgress(String localId, double progress)` — finds message by `localId`, sets `uploadProgress`, calls `update()`
- [x] 3.4 Add `completePendingVideoMessage({required String localId, required String videoURL, required String thumbnailURL})` — finds message by `localId`, sets `uploadStatus = 'uploaded'`, `uploadProgress = 1.0`, `content = videoURL`, `thumbnail = thumbnailURL`, writes to Firestore via `drChatMessages?.doc(localId).set(message.toFireStore())`, updates chat room last message, calls `update()`
- [x] 3.5 Add `failPendingVideoMessage({required String localId})` — finds message by `localId`, sets `uploadStatus = 'failed'`, calls `update()`
- [x] 3.6 Add `retryVideoUpload(ChatMessage message)` — resets `uploadStatus = 'uploading'`, `uploadProgress = 0.0`, calls `update()`, then re-runs the upload using `message.localVideoPath` and `message.localThumbnailPath` with the same progress/complete/fail callbacks

## Task 4: Fix video send flow in WriteDescriptionSheet
- [x] 4.1 Open `lib/screens/chats_screen/chatting_screen/image_video_chat_picker.dart`
- [x] 4.2 In `_onSendTap`, for the video branch (`widget.type == MessageType.video`):
  - Set `_isSending = true` immediately
  - Capture `localVideoPath`, `localThumbPath`, `caption` before any async work
  - Call `Get.back()` immediately to close the preview sheet
  - Call `controller.addPendingVideoMessage(...)` to insert the pending bubble
  - Start background upload using `PostService.shared.uploadFileWithProgress` with `onProgress` callback
  - On video upload success: upload thumbnail (if available), then call `controller.completePendingVideoMessage`
  - On any failure: call `controller.failPendingVideoMessage`
- [x] 4.3 Ensure the image send branch remains unchanged
- [x] 4.4 Ensure `_isSending` guard prevents double-tap (SEND button is disabled/dimmed while `_isSending == true`)
- [x] 4.5 Do NOT call `controller.startLoading()` or `controller.stopLoading()` for the video branch (no spinner on preview screen)

## Task 5: Run flutter analyze and fix any errors
- [x] 5.1 Run `flutter clean && flutter pub get` in `chatter_flutter/chatter`
- [ ] 5.2 Run `flutter analyze` and fix all errors and warnings introduced by the changes
- [~] 5.3 Confirm no existing functionality is broken (image send, text send, profile display)

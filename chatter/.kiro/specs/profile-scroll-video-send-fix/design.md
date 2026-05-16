# Design: Profile Scroll Fix & WhatsApp-like Video Send

## Architecture Overview

Two independent fixes, each touching a small set of files.

---

## Fix 1: Profile Screen Scroll Performance

### Root Cause
`ProfileController.onReady()` registers `_profileScrollListener` which calls `update([scrollID])` on **every scroll frame**. This triggers a full `GetBuilder` rebuild of the `SliverAppBar` (which contains `BackdropFilter`, `Hero`, `MyCachedImage`, and multiple `Stack` layers) on every pixel of scroll. The result is severe jank.

### Fix Strategy
Throttle the `update([scrollID])` call so it only fires when the computed `opacity` value actually changes by more than a small threshold (0.02). Since opacity is clamped to [0, 1] and the animation only matters near the top of the scroll, this reduces rebuilds from ~60/second to only a handful during the transition zone.

### Files Changed
- `lib/screens/profile_screen/profile_controller.dart`
  - Add `double _lastReportedOpacity = -1.0;` field.
  - In `_profileScrollListener`, compute `newOpacity` before calling `update`.
  - Only call `update([scrollID])` if `(newOpacity - _lastReportedOpacity).abs() > 0.02`.
  - Update `_lastReportedOpacity = newOpacity` when firing.

### No Layout Changes Needed
The profile screen already uses `CustomScrollView` + `SliverFillRemaining` with `shrinkWrap: false`. The `FeedsView` and `ReelsGrid` already lazy-load. The only problem is the scroll listener rebuild frequency.

---

## Fix 2: WhatsApp-like Video Send

### Data Model Changes

#### `lib/models/chat.dart` — `ChatMessage` class
Add fields for pending upload state:
```dart
String? _uploadStatus;   // 'uploading' | 'uploaded' | 'failed' | null
double _uploadProgress = 0.0;
String? _localThumbnailPath;
String? _localVideoPath;
String? _localId;
```
Add getters/setters. These fields are **not** serialized to/from Firestore (they are local-only state). The `toFireStore()` and `fromFireStore()` methods remain unchanged.

### Controller Changes

#### `lib/screens/chats_screen/chatting_screen/chatting_controller.dart`
Add four new methods:

**`addPendingVideoMessage`**
```
- Generate a unique localId (microsecondsSinceEpoch string)
- Create ChatMessage with:
    id = localId
    localId = localId
    msgType = video
    uploadStatus = 'uploading'
    uploadProgress = 0.0
    localThumbnailPath = localThumbPath
    localVideoPath = localVideoPath
    msg = caption
    senderId = myUser?.id
- Insert at index 0 of messages list
- call update()
- addPostFrameCallback: scroll to offset 0 (top of reversed list = newest)
```

**`updatePendingVideoProgress`**
```
- Find message where localId == localId
- Set uploadProgress = progress
- call update()
```

**`completePendingVideoMessage`**
```
- Find message where localId == localId
- Set uploadStatus = 'uploaded', uploadProgress = 1.0
- Set content = videoURL, thumbnail = thumbnailURL
- Clear localVideoPath, localThumbnailPath
- Write to Firestore: drChatMessages?.doc(localId).set(message.toFireStore())
  (this also updates the Firebase chat room last message)
- Also call commonSend-like logic to update chatUserRoom lastMsg
- call update()
```

**`failPendingVideoMessage`**
```
- Find message where localId == localId
- Set uploadStatus = 'failed'
- call update()
```

**`retryVideoUpload`**
```
- Reset uploadStatus = 'uploading', uploadProgress = 0.0
- call update()
- Re-run the upload using message.localVideoPath and message.localThumbnailPath
- Same progress/complete/fail callbacks as original send
```

### Preview Sheet Changes

#### `lib/screens/chats_screen/chatting_screen/image_video_chat_picker.dart`
The `_onSendTap` method in `_WriteDescriptionSheetState`:

**Current (bad) video flow:**
- Sets `_isSending = true`
- Calls `controller.startLoading()`
- Waits for upload to complete
- Then calls `Get.back()` and `commonSend`

**New (correct) video flow:**
```
1. Set _isSending = true (guard double-tap)
2. Capture localVideoPath = widget.file.path
3. Capture localThumbPath = thumbnail?.path ?? ''
4. Generate localId = DateTime.now().microsecondsSinceEpoch.toString()
5. Call Get.back() IMMEDIATELY — close preview
6. Call controller.addPendingVideoMessage(localId, localVideoPath, localThumbPath, caption)
7. Start background upload:
   PostService.shared.uploadFileWithProgress(
     widget.file,
     onProgress: (pct) => controller.updatePendingVideoProgress(localId, pct),
   ).then((videoURL) {
     if videoURL == null: controller.failPendingVideoMessage(localId); return;
     if localThumbPath.isNotEmpty:
       PostService.shared.uploadFileWithProgress(XFile(localThumbPath))
         .then((thumbURL) => controller.completePendingVideoMessage(localId, videoURL, thumbURL ?? ''))
         .catchError((_) => controller.completePendingVideoMessage(localId, videoURL, ''))
     else:
       controller.completePendingVideoMessage(localId, videoURL, '')
   }).catchError((_) => controller.failPendingVideoMessage(localId))
```

### Chat Bubble UI (already implemented)
`chat_tag.dart`'s `imageAndVideoView()` already has the correct UI:
- `message.uploadStatus == 'uploading'` → shows progress overlay at bottom-left
- `message.uploadStatus == 'failed'` → shows red Retry overlay
- Normal state → shows play button

The only thing needed is that `ChatMessage` has the fields these widgets reference.

### Firestore Deduplication
When `completePendingVideoMessage` writes to Firestore using `drChatMessages?.doc(localId).set(...)`, the real-time listener in `fetchMessages()` will receive a `DocumentChangeType.modified` event (not `added`) because the document ID `localId` already exists in the local `messages` list. The `modified` handler updates the existing entry in place — no duplicate.

### Files Changed Summary
1. `lib/models/chat.dart` — add upload state fields to `ChatMessage`
2. `lib/screens/chats_screen/chatting_screen/chatting_controller.dart` — add 5 new methods
3. `lib/screens/chats_screen/chatting_screen/image_video_chat_picker.dart` — fix `_onSendTap` video branch
4. `lib/screens/profile_screen/profile_controller.dart` — throttle scroll listener

---

## Sequence Diagram: Video Send

```
User taps SEND
    │
    ▼
_WriteDescriptionSheetState._onSendTap()
    │── _isSending = true
    │── Get.back()  ◄── preview closes immediately
    │── controller.addPendingVideoMessage(localId, ...)
    │       └── messages.insert(0, pendingMsg)
    │       └── update()  ◄── chat list shows pending bubble
    │
    ▼
PostService.uploadFileWithProgress(videoFile, onProgress: ...)
    │── onProgress(0.1) → controller.updatePendingVideoProgress(localId, 0.1) → update()
    │── onProgress(0.5) → controller.updatePendingVideoProgress(localId, 0.5) → update()
    │── onProgress(1.0) → controller.updatePendingVideoProgress(localId, 1.0) → update()
    │
    ▼ (video upload done)
PostService.uploadFileWithProgress(thumbFile)
    │
    ▼ (thumb upload done)
controller.completePendingVideoMessage(localId, videoURL, thumbURL)
    │── find message by localId
    │── update fields (uploaded, URLs)
    │── drChatMessages.doc(localId).set(...)  ◄── Firestore write
    │── update()  ◄── bubble shows play button
    │
    ▼ (Firestore listener fires DocumentChangeType.modified)
fetchMessages listener
    │── finds existing message by id == localId
    │── updates in place (no duplicate)
```

---

## Non-Goals
- Do not change image send flow
- Do not change text message flow
- Do not change video upload API endpoint
- Do not remove `WriteDescriptionSheet`
- Do not add new dependencies

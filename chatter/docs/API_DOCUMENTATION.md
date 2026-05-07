# CUICHAT — API Documentation

## Base URL

```
https://cuichat.online/api/
```

## Authentication Header

All API endpoints require the following header:

```
apikey: 123
```

This is validated by the `CheckHeader` middleware. Requests without this header receive a `401 Unauthorized` response.

## Response Format

All endpoints return JSON in this format:

```json
{
  "status": true,
  "message": "Success message",
  "data": { ... }
}
```

Error responses:
```json
{
  "status": false,
  "message": "Error description"
}
```

---

## 1. User / Authentication APIs

### POST /api/addUser
Social login and registration (Google, Apple, Email via Firebase).

**Request Body:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| identity | string | Yes | Email or social login identifier |
| full_name | string | No | User's full name |
| login_type | int | Yes | 0=email, 1=google, 2=apple |
| device_type | int | Yes | 0=Android, 1=iOS |
| device_token | string | Yes | Firebase FCM token |

**Response:** `{ status: true, data: { ...User } }`

**Notes:**
- If the user does not exist, a new account is created with `approval_status = 'approved'`.
- If the user exists, their device token is updated and the user object is returned.
- If `approval_status` is not 'approved', the response returns `status: false` with an appropriate message.

---

### POST /api/cuiLogin
Login for CUI-registered users (email + password).

**Request Body:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | Yes | Registered email address |
| password | string | Yes | Account password |
| device_type | int | Yes | 0=Android, 1=iOS |
| device_token | string | Yes | Firebase FCM token |

**Response:** `{ status: true, data: { ...User with approval_status } }`

**Notes:**
- Returns `status: false` if `approval_status` is 'pending', 'rejected', or 'cancelled'.
- Updates `device_token` on successful login.

---

### POST /api/editProfile
Update user profile fields.

**Request Body (multipart/form-data):**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| user_id | int | Yes | Current user's ID |
| username | string | No | New username |
| full_name | string | No | New full name |
| bio | string | No | New bio |
| interest_ids | string | No | Comma-separated interest IDs |
| profile | file | No | Profile image file |
| background_image | file | No | Background image file |
| block_user_ids | string | No | Comma-separated blocked user IDs |
| is_push_notifications | int | No | 0 or 1 |
| is_invited_to_room | int | No | 0 or 1 |
| saved_music_ids | string | No | Comma-separated music IDs |
| saved_reel_ids | string | No | Comma-separated reel IDs |

**Response:** `{ status: true, data: { ...User } }`

---

### POST /api/fetchProfile
Get a user's profile.

**Request Body:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| user_id | int | Yes | Target user's ID |
| my_user_id | int | Yes | Current user's ID (for follow status) |

**Response:** `{ status: true, data: { ...User, followingStatus, stories, interest } }`

---

### POST /api/logOut
Log out and clear device token.

**Request Body:** `{ user_id: int }`

**Response:** `{ status: true, message: "Logged out" }`

---

### POST /api/deleteUser
Permanently delete a user account.

**Request Body:** `{ user_id: int }`

**Response:** `{ status: true, message: "Account deleted" }`

---

### POST /api/followUser
Follow another user.

**Request Body:** `{ user_id: int, my_user_id: int }`

---

### POST /api/unfollowUser
Unfollow a user.

**Request Body:** `{ user_id: int, my_user_id: int }`

---

### POST /api/fetchFollowingList
Get list of users the current user follows.

**Request Body:** `{ my_user_id: int, start: int, limit: int }`

---

### POST /api/fetchFollowersList
Get list of users following the current user.

**Request Body:** `{ user_id: int, start: int, limit: int, keyword: string (optional) }`

---

### POST /api/searchProfile
Search users by name or username.

**Request Body:** `{ my_user_id: int, keyword: string, start: int, limit: int }`

---

### POST /api/fetchRandomProfile
Get a random user profile for discovery.

**Request Body:** `{ my_user_id: int }`

---

### POST /api/checkUsername
Check if a username is available.

**Request Body:** `{ username: string }`

**Response:** `{ status: true }` if available, `{ status: false }` if taken.

---

### POST /api/reportUser
Report a user.

**Request Body:** `{ user_id: int, reason: string, desc: string }`

---

### POST /api/UserBlockedByUser
Block a user.

**Request Body:** `{ user_id: int, my_user_id: int }`

---

### POST /api/UserUnblockedByUser
Unblock a user.

**Request Body:** `{ user_id: int, my_user_id: int }`

---

### POST /api/fetchBlockedUserList
Get list of users blocked by the current user.

**Request Body:** `{ my_user_id: int, limit: int }`

---

### POST /api/fetchPostByUser
Get all posts by a specific user.

**Request Body:** `{ user_id: int, my_user_id: int, start: int, limit: int }`

---

### POST /api/fetchUserNotification
Get user's notification history.

**Request Body:** `{ user_id: int }`

---

### POST /api/profileVerification
Submit a profile verification request.

**Request Body (multipart/form-data):**
| Field | Type | Description |
|-------|------|-------------|
| user_id | int | User ID |
| full_name | string | Name on document |
| document_type | string | Type of ID |
| document | file | ID document image |
| selfie | file | Selfie image |

---

## 2. CUI Registration APIs

### POST /api/sendRegisterOtp
Send a 6-digit OTP to a phone number for CUI registration.

**Request Body:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| phone_number | string | Yes | Pakistani phone (03xxxxxxxxx or +923xxxxxxxxx) |

**Response (debug mode):**
```json
{
  "status": true,
  "message": "OTP generated. Check app logs or use debug OTP below.",
  "otp": "123456",
  "debug_note": "No SMS gateway configured."
}
```

**Response (production with SMS):**
```json
{
  "status": true,
  "message": "OTP sent to your phone number"
}
```

**Error cases:**
- Phone already registered: `{ status: false, message: "Phone number is already registered." }`
- Invalid format: `{ status: false, message: "validation error" }`

---

### POST /api/verifyRegisterOtp
Verify the OTP sent to the phone number.

**Request Body:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| phone_number | string | Yes | Same phone number used in sendRegisterOtp |
| otp | string | Yes | 6-digit OTP code |

**Response:** `{ status: true, message: "Phone number verified" }`

**Error cases:**
- Invalid OTP: `{ status: false, message: "Invalid OTP. Please check and try again." }`
- Expired OTP: `{ status: false, message: "OTP has expired. Please request a new one." }`
- Already used: `{ status: false, message: "OTP already used. Please request a new one." }`

---

### POST /api/register
Submit CUI registration after phone verification.

**Request Body:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| role_type | string | Yes | 'student' or 'faculty' |
| full_name | string | Yes | Full name |
| email | string | Yes | Unique email address |
| phone_number | string | Yes | Verified phone number |
| department | string | Yes | Academic department |
| gender | string | Yes | 'male', 'female', or 'other' |
| password | string | Yes | Min 6 characters |
| password_confirmation | string | Yes | Must match password |
| campus | string | No | COMSATS campus (default: 'Islamabad') |
| registration_number | string | Required if student | e.g. FA23-BSE-130 |
| batch_duration | string | Required if student | e.g. FA23-SP27 |
| device_type | int | No | 0=Android, 1=iOS |
| device_token | string | No | FCM token |

**Response:**
```json
{
  "status": true,
  "message": "Your registration request has been submitted for admin approval",
  "data": { ...User with approval_status: "pending" }
}
```

---

## 3. Posts APIs

### POST /api/addPost
Create a new post.

**Request Body (multipart/form-data):**
| Field | Type | Description |
|-------|------|-------------|
| user_id | int | Post author |
| desc | string | Post caption |
| interest_ids | string | Comma-separated interest IDs |
| hashtags | string | Comma-separated hashtags |
| content[] | file[] | Media files (images/videos/audio) |
| content_type | int | 0=image, 1=video, 2=audio, 3=text |
| thumbnail[] | file[] | Thumbnails for video content |

---

### POST /api/fetchPosts
Get social feed posts.

**Request Body:** `{ my_user_id: int, start: int, limit: int, fetch_post_type: int }`

---

### POST /api/addComment
Add a comment to a post.

**Request Body:** `{ post_id: int, user_id: int, comment: string }`

---

### POST /api/fetchComments
Get comments for a post.

**Request Body:** `{ post_id: int, my_user_id: int, start: int, limit: int }`

---

### POST /api/deleteComment
Delete a comment.

**Request Body:** `{ comment_id: int, user_id: int }`

---

### POST /api/likePost
Like a post.

**Request Body:** `{ post_id: int, user_id: int }`

---

### POST /api/dislikePost
Unlike a post.

**Request Body:** `{ post_id: int, user_id: int }`

---

### POST /api/likeDislikeComment
Toggle like on a comment.

**Request Body:** `{ comment_id: int, user_id: int }`

---

### POST /api/reportPost
Report a post.

**Request Body:** `{ post_id: int, user_id: int, reason: string, desc: string }`

---

### POST /api/deleteMyPost
Delete own post.

**Request Body:** `{ post_id: int, user_id: int }`

---

### POST /api/fetchPostByPostId
Get a single post by ID.

**Request Body:** `{ post_id: int, my_user_id: int }`

---

### POST /api/fetchPostsByHashtag
Get posts by hashtag.

**Request Body:** `{ hashtags: string, my_user_id: int, start: int, limit: int }`

---

### POST /api/searchPost
Search posts by keyword.

**Request Body:** `{ keyword: string, my_user_id: int, start: int, limit: int }`

---

### POST /api/searchPostByInterestId
Get posts filtered by interest.

**Request Body:** `{ interest_id: int, my_user_id: int, start: int, limit: int }`

---

### POST /api/fetchUsersWhoLikedPost
Get users who liked a post.

**Request Body:** `{ post_id: int, my_user_id: int }`

---

### POST /api/searchHashtag
Search hashtags.

**Request Body:** `{ keyword: string }`

---

### POST /api/uploadFile
Upload a media file.

**Request Body (multipart/form-data):** `{ content: file }`

**Response:** `{ status: true, data: "uploads/filename.jpg" }`

---

## 4. Stories APIs

### POST /api/createStory
Create a new story.

**Request Body (multipart/form-data):**
| Field | Type | Description |
|-------|------|-------------|
| user_id | int | Story creator |
| story | file | Media file |
| story_type | int | 0=image, 1=video |
| duration | int | Duration in seconds |

---

### POST /api/fetchStory
Get stories from followed users.

**Request Body:** `{ my_user_id: int }`

---

### POST /api/viewStory
Mark a story as viewed.

**Request Body:** `{ story_id: int, user_id: int }`

---

### POST /api/deleteStory
Delete own story.

**Request Body:** `{ story_id: int, user_id: int }`

---

### POST /api/fetchStoryByID
Get a specific story.

**Request Body:** `{ story_id: int, my_user_id: int }`

---

## 5. Reels APIs

### POST /api/uploadReel
Upload a new reel.

**Request Body (multipart/form-data):**
| Field | Type | Description |
|-------|------|-------------|
| user_id | int | Creator |
| reel | file | Video file |
| thumbnail | file | Thumbnail image |
| desc | string | Description |
| music_id | int | Associated music ID |
| interest_ids | string | Comma-separated interest IDs |
| hashtags | string | Comma-separated hashtags |

---

### POST /api/fetchReelsOnExplore
Get reels for explore/discovery feed.

**Request Body:** `{ my_user_id: int, start: int, limit: int }`

---

### POST /api/likeDislikeReel
Toggle like on a reel.

**Request Body:** `{ reel_id: int, user_id: int }`

---

### POST /api/increaseReelViewCount
Increment view count.

**Request Body:** `{ reel_id: int }`

---

### POST /api/addReelComment / fetchReelComments / deleteReelComment
Manage reel comments. Similar structure to post comments.

---

### POST /api/deleteReel
Delete own reel.

**Request Body:** `{ reel_id: int, user_id: int }`

---

### POST /api/fetchReelsByUserId
Get reels by a specific user.

**Request Body:** `{ user_id: int, my_user_id: int, start: int, limit: int }`

---

### POST /api/fetchReelsByHashtag / searchReelsByInterestId / fetchReelsByMusic
Filter reels by hashtag, interest, or music track.

---

### POST /api/fetchSavedReels
Get reels saved by the current user.

**Request Body:** `{ my_user_id: int, start: int, limit: int }`

---

### POST /api/fetchReelById
Get a single reel.

**Request Body:** `{ reel_id: int, my_user_id: int }`

---

### POST /api/reportReel
Report a reel.

**Request Body:** `{ reel_id: int, user_id: int, reason: string, desc: string }`

---

## 6. Music APIs

### POST /api/fetchMusicWithSearch
Search music library.

**Request Body:** `{ keyword: string, my_user_id: int, start: int, limit: int }`

---

### POST /api/fetchMusicCategories
Get all music categories.

**Request Body:** `{ my_user_id: int }`

---

### POST /api/fetchMusicByCategory
Get music by category.

**Request Body:** `{ category_id: int, my_user_id: int, start: int, limit: int }`

---

### POST /api/fetchSavedMusic
Get music saved by the current user.

**Request Body:** `{ my_user_id: int }`

---

## 7. Rooms APIs

### POST /api/createRoom
Create a new audio room.

**Request Body (multipart/form-data):**
| Field | Type | Description |
|-------|------|-------------|
| user_id | int | Room creator |
| title | string | Room name |
| description | string | Room description |
| photo | file | Cover image |
| interest_id | int | Associated interest |
| is_private | int | 0=public, 1=private |
| is_join_request_enable | int | 0 or 1 |

---

### POST /api/joinOrRequestRoom
Join a public room or request to join a private room.

**Request Body:** `{ room_id: int, user_id: int }`

---

### POST /api/inviteUserToRoom
Invite a user to a room.

**Request Body:** `{ room_id: int, user_id: int, to_user_id: int }`

---

### POST /api/acceptInvitation / rejectInvitation
Accept or reject a room invitation.

**Request Body:** `{ room_id: int, user_id: int }`

---

### POST /api/acceptRoomRequest / rejectRoomRequest
Admin accepts or rejects a join request.

**Request Body:** `{ room_id: int, user_id: int, admin_id: int }`

---

### POST /api/fetchRoomDetail
Get room details.

**Request Body:** `{ room_id: int, user_id: int }`

---

### POST /api/fetchRoomUsersList / fetchRoomAdmins
Get room members or admins.

**Request Body:** `{ room_id: int, user_id: int }`

---

### POST /api/makeRoomAdmin / removeAdminFromRoom
Manage room co-admins.

**Request Body:** `{ room_id: int, user_id: int, admin_id: int }`

---

### POST /api/removeUserFromRoom
Remove a member from a room.

**Request Body:** `{ room_id: int, user_id: int, admin_id: int }`

---

### POST /api/leaveThisRoom
Leave a room.

**Request Body:** `{ room_id: int, user_id: int }`

---

### POST /api/deleteRoom
Delete a room (owner only).

**Request Body:** `{ room_id: int, user_id: int }`

---

### POST /api/editRoom
Update room details.

**Request Body (multipart/form-data):** Room fields + `room_id`.

---

### POST /api/fetchSuggestedRooms / fetchRandomRooms / fetchRoomsByInterest
Discover rooms.

---

### POST /api/fetchMyOwnRooms / fetchRoomsIAmIn
Get rooms owned by or joined by the current user.

---

### POST /api/muteUnmuteRoomNotification
Toggle room notification mute.

**Request Body:** `{ room_id: int, user_id: int, is_mute: int }`

---

### POST /api/reportRoom
Report a room.

**Request Body:** `{ room_id: int, user_id: int, reason: string, desc: string }`

---

### POST /api/getInvitationList
Get pending room invitations for the current user.

**Request Body:** `{ user_id: int }`

---

### POST /api/fetchRoomRequestList
Get pending join requests for a room (admin only).

**Request Body:** `{ room_id: int, admin_id: int }`

---

### POST /api/searchUserForInvitation
Search users to invite to a room.

**Request Body:** `{ room_id: int, user_id: int, keyword: string }`

---

### POST /api/fetchRoomsList
Get all rooms (paginated).

**Request Body:** `{ user_id: int, start: int, limit: int }`

---

## 8. Interests APIs

### POST /api/fetchInterests
Get all available interests.

**Request Body:** `{ my_user_id: int }`

**Response:** `{ status: true, data: [ { id, title, image }, ... ] }`

---

## 9. Settings / Notifications APIs

### POST /api/fetchSetting
Get global app settings (AdMob IDs, interests, report reasons, etc.).

**Request Body:** `{ my_user_id: int }`

---

### POST /api/generateAgoraToken
Generate an Agora RTC token for joining an audio room.

**Request Body:** `{ channelName: string, user_id: int }`

**Response:** `{ status: true, data: "agora_token_string" }`

---

### POST /api/pushNotificationToSingleUser
Send a push notification to a specific user.

**Request Body:** `{ to_user_id: int, user_id: int, description: string }`

---

### POST /api/fetchPlatformNotification
Get admin-sent platform-wide notifications.

**Request Body:** `{ my_user_id: int }`

---

### POST /api/fetchFAQs
Get FAQ content.

**Request Body:** `{ my_user_id: int }`

---

## 10. Moderator APIs

All moderator endpoints are prefixed with `/api/Moderator/`.

| Endpoint | Description |
|----------|-------------|
| POST /api/Moderator/deletePostByModerator | Delete a post (moderator) |
| POST /api/Moderator/deleteCommentByModerator | Delete a comment (moderator) |
| POST /api/Moderator/deleteRoomByModerator | Delete a room (moderator) |
| POST /api/Moderator/deleteStoryByModerator | Delete a story (moderator) |
| POST /api/Moderator/userBlockByModerator | Block a user (moderator) |
| POST /api/Moderator/deleteReelCommentByModerator | Delete a reel comment (moderator) |
| POST /api/Moderator/deleteReelByModerator | Delete a reel (moderator) |

---

## CUI Registration Flow (Complete)

```
Step 1: POST /api/sendRegisterOtp
  Body: { phone_number: "03xxxxxxxxx" }
  Response (debug): { status: true, otp: "123456", debug_note: "..." }
  Response (prod):  { status: true, message: "OTP sent to your phone number" }

Step 2: POST /api/verifyRegisterOtp
  Body: { phone_number: "03xxxxxxxxx", otp: "123456" }
  Response: { status: true, message: "Phone number verified" }

Step 3: POST /api/register
  Body: {
    role_type: "student",
    full_name: "Ali Hassan",
    email: "ali@example.com",
    phone_number: "03001234567",
    department: "Software Engineering",
    gender: "male",
    password: "password123",
    password_confirmation: "password123",
    campus: "Islamabad",
    registration_number: "FA23-BSE-130",   // students only
    batch_duration: "FA23-SP27"            // students only
  }
  Response: {
    status: true,
    message: "Your registration request has been submitted for admin approval",
    data: { ...user, approval_status: "pending" }
  }

Step 4: Admin reviews at https://cuichat.online/registrationRequests
  - Admin clicks Approve → POST /approveRegistrationRequest/{id}
  - Approval email sent to user's email address

Step 5: POST /api/cuiLogin
  Body: { email: "ali@example.com", password: "password123", device_type: 0, device_token: "fcm_token" }
  Response: { status: true, data: { ...user, approval_status: "approved" } }
```

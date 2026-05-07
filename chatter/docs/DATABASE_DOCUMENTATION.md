# CUICHAT — Database Documentation

## Overview

The CUICHAT database is a MySQL relational database with 30+ tables. The schema was built incrementally through Laravel migrations. The most important table is `users`, which was extended with CUI-specific fields in the 2026 migrations.

---

## Core Tables

### `users` — Primary User Table

The central table of the system. Stores all user accounts including social login users and CUI-registered users.

| Column | Type | Nullable | Default | Purpose |
|--------|------|----------|---------|---------|
| id | BIGINT UNSIGNED PK | No | auto | Primary key |
| identity | VARCHAR(255) | No | — | Email or social login identifier (used as login key) |
| email | VARCHAR(255) | Yes | NULL | Email address (CUI users; may differ from identity) |
| password | VARCHAR(255) | Yes | NULL | Bcrypt-hashed password (CUI users only) |
| username | VARCHAR(255) | Yes | NULL | Display username (set during onboarding) |
| full_name | VARCHAR(255) | Yes | NULL | Full display name |
| bio | VARCHAR(255) | Yes | NULL | User bio/description |
| profile | VARCHAR(255) | Yes | NULL | Profile image path (relative to storage) |
| background_image | VARCHAR(255) | Yes | NULL | Background/cover image path |
| interest_ids | TEXT | Yes | NULL | Comma-separated interest IDs (e.g. "1,3,7") |
| login_type | INT | No | — | 0=email, 1=google, 2=apple (CUI uses 2 for email+password) |
| device_type | INT | No | — | 0=Android, 1=iOS |
| device_token | VARCHAR(255) | Yes | NULL | Firebase FCM push notification token |
| is_block | TINYINT | Yes | 0 | Admin block status (1=blocked) |
| is_verified | TINYINT | Yes | 0 | Verification: 0=none, 2=admin-verified, 3=subscription-verified |
| is_moderator | TINYINT | Yes | 0 | Moderator flag (1=moderator) |
| is_push_notifications | TINYINT | Yes | 1 | Push notification preference |
| is_invited_to_room | TINYINT | Yes | 1 | Room invitation preference |
| block_user_ids | TEXT | Yes | NULL | Comma-separated IDs of users blocked by this user |
| saved_music_ids | TEXT | Yes | NULL | Comma-separated saved music IDs |
| saved_reel_ids | TEXT | Yes | NULL | Comma-separated saved reel IDs |
| following | INT | Yes | 0 | Count of users this user follows |
| followers | INT | Yes | 0 | Count of users following this user |
| role_type | VARCHAR(20) | Yes | NULL | 'student' or 'faculty' (CUI users only) |
| approval_status | VARCHAR(20) | Yes | 'pending' | 'pending', 'approved', 'rejected', or 'cancelled' |
| registration_number | VARCHAR(255) | Yes | NULL | Student registration number (e.g. FA23-BSE-130) |
| department | VARCHAR(255) | Yes | NULL | Academic department |
| batch_duration | VARCHAR(255) | Yes | NULL | Batch period (e.g. FA23-SP27, students only) |
| phone_number | VARCHAR(255) | Yes | NULL | Pakistani phone number (private, admin-only) |
| gender | VARCHAR(20) | Yes | NULL | 'male', 'female', or 'other' (private, admin-only) |
| campus | VARCHAR(255) | Yes | 'COMSATS University Islamabad' | COMSATS campus name |
| phone_verified_at | TIMESTAMP | Yes | NULL | Timestamp when phone OTP was verified |
| otp_code | VARCHAR(255) | Yes | NULL | Legacy OTP field (hidden from API responses) |
| otp_expires_at | TIMESTAMP | Yes | NULL | Legacy OTP expiry |
| approved_at | TIMESTAMP | Yes | NULL | Timestamp when admin approved the account |
| approved_by | BIGINT UNSIGNED | Yes | NULL | ID of the admin who approved the account |
| rejected_reason | TEXT | Yes | NULL | Reason provided by admin when rejecting |
| email_verified_or_approval_sent_at | TIMESTAMP | Yes | NULL | Timestamp when approval/rejection email was sent |
| created_at | TIMESTAMP | Yes | NULL | Account creation timestamp |
| updated_at | TIMESTAMP | Yes | NULL | Last update timestamp |

**Notes:**
- `phone_number` and `gender` are private fields — they are only included in API responses when `$includePrivate = true` (admin context).
- Social login users (Google/Apple/Email) have `approval_status = 'approved'` by default (set by migration).
- CUI users start with `approval_status = 'pending'` and cannot log in until approved.
- The `otp_code` field is hidden from API serialization via `$hidden` in the User model.

---

### `registration_otps` — Phone OTP Verification

Stores OTP records for the CUI registration phone verification step.

| Column | Type | Nullable | Purpose |
|--------|------|----------|---------|
| id | BIGINT UNSIGNED PK | No | Primary key |
| phone_number | VARCHAR(255) UNIQUE | No | Pakistani phone number (03xxxxxxxxx) |
| otp_code | VARCHAR(255) | No | SHA-256 hash of the 6-digit OTP |
| otp_expires_at | TIMESTAMP | No | OTP expiry (10 minutes from creation) |
| verified_at | TIMESTAMP | Yes | Set when OTP is successfully verified |
| consumed_at | TIMESTAMP | Yes | Set when registration is completed (prevents reuse) |
| created_at | TIMESTAMP | Yes | Record creation time |
| updated_at | TIMESTAMP | Yes | Last update time |

**Notes:**
- OTP is hashed with SHA-256 (not bcrypt) for performance on shared hosting.
- A record is `updateOrCreate`d on each OTP request, so resending resets the OTP.
- `consumed_at` is set after successful `POST /api/register` to prevent the same OTP from being used twice.

---

### `admins` — Admin Panel Users

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| user_name | VARCHAR(255) | Admin login username |
| user_password | VARCHAR(255) | Encrypted password (Laravel Crypt facade) |
| user_type | INT | Admin type/role level |
| created_at | TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | Last update |

**Notes:**
- Passwords are stored using Laravel's `Crypt::encrypt()` (not bcrypt).
- On first login with a plain-text password (from SQL import), the system auto-upgrades to encrypted storage.
- Password reset uses database credentials as a secondary verification factor.

---

### `posts` — Social Feed Posts

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| user_id | BIGINT UNSIGNED | Foreign key to users |
| desc | TEXT | Post description/caption |
| interest_ids | TEXT | Comma-separated interest IDs |
| hashtags | TEXT | Comma-separated hashtags |
| likes | INT | Like count |
| comments | INT | Comment count |
| is_restricted | TINYINT | Admin restriction flag |
| created_at | TIMESTAMP | Post creation time |
| updated_at | TIMESTAMP | Last update |

### `post_contents` — Post Media Files

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| post_id | BIGINT UNSIGNED | Foreign key to posts |
| content | VARCHAR(255) | File path |
| content_type | INT | 0=image, 1=video, 2=audio, 3=text |
| thumbnail | VARCHAR(255) | Thumbnail path (for video) |

### `comments` — Post Comments

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| post_id | BIGINT UNSIGNED | Foreign key to posts |
| user_id | BIGINT UNSIGNED | Commenter user ID |
| comment | TEXT | Comment text |
| likes | INT | Comment like count |
| created_at | TIMESTAMP | Comment time |

### `likes` — Post Likes

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| post_id | BIGINT UNSIGNED | Foreign key to posts |
| user_id | BIGINT UNSIGNED | User who liked |
| created_at | TIMESTAMP | Like time |

### `like_comments` — Comment Likes

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| comment_id | BIGINT UNSIGNED | Foreign key to comments |
| user_id | BIGINT UNSIGNED | User who liked the comment |

---

### `reels` — Short Video Content

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| user_id | BIGINT UNSIGNED | Creator user ID |
| reel | VARCHAR(255) | Video file path |
| thumbnail | VARCHAR(255) | Thumbnail image path |
| desc | TEXT | Reel description |
| music_id | BIGINT UNSIGNED | Associated music track ID |
| interest_ids | TEXT | Comma-separated interest IDs |
| hashtags | TEXT | Comma-separated hashtags |
| likes | INT | Like count |
| comments | INT | Comment count |
| views | INT | View count |
| created_at | TIMESTAMP | Upload time |

### `reel_comments` — Reel Comments

Similar structure to `comments` but references `reel_id`.

---

### `rooms` — Live Audio Rooms

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| user_id | BIGINT UNSIGNED | Room creator/owner |
| title | VARCHAR(255) | Room name |
| description | TEXT | Room description |
| photo | VARCHAR(255) | Room cover image |
| interest_id | BIGINT UNSIGNED | Associated interest |
| is_private | TINYINT | 0=public, 1=private |
| is_join_request_enable | TINYINT | Whether join requests are required |
| members | INT | Current member count |
| created_at | TIMESTAMP | Room creation time |

### `room_users` — Room Membership

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| room_id | BIGINT UNSIGNED | Foreign key to rooms |
| user_id | BIGINT UNSIGNED | Member user ID |
| is_admin | TINYINT | Co-admin flag |
| is_mute | TINYINT | Mute notification flag |
| status | INT | Membership status (joined, invited, requested) |

---

### `stories` — 24-Hour Stories

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| user_id | BIGINT UNSIGNED | Story creator |
| story | VARCHAR(255) | Media file path |
| story_type | INT | 0=image, 1=video |
| duration | INT | Story duration in seconds |
| views | INT | View count |
| created_at | TIMESTAMP | Creation time (used for 24h expiry) |

---

### `music` — Music Library

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| category_id | BIGINT UNSIGNED | Music category |
| title | VARCHAR(255) | Track title |
| artist | VARCHAR(255) | Artist name |
| music | VARCHAR(255) | Audio file path |
| image | VARCHAR(255) | Cover art path |
| duration | INT | Duration in seconds |

### `music_categories` — Music Categories

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| title | VARCHAR(255) | Category name |
| image | VARCHAR(255) | Category image |

---

### `interests` — Content Interests

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| title | VARCHAR(255) | Interest name (e.g. "Technology") |
| image | VARCHAR(255) | Interest icon/image |

---

### `following_lists` — Follow Relationships

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| my_user_id | BIGINT UNSIGNED | The follower |
| user_id | BIGINT UNSIGNED | The followed user |
| created_at | TIMESTAMP | Follow time |

---

### `reports` — Content Reports

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| user_id | BIGINT UNSIGNED | Reporter |
| reported_user_id | BIGINT UNSIGNED | Reported user (if user report) |
| post_id | BIGINT UNSIGNED | Reported post (if post report) |
| room_id | BIGINT UNSIGNED | Reported room (if room report) |
| reel_id | BIGINT UNSIGNED | Reported reel (if reel report) |
| reason | VARCHAR(255) | Report reason |
| desc | TEXT | Additional description |
| created_at | TIMESTAMP | Report time |

### `report_reasons` — Predefined Report Reasons

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| title | VARCHAR(255) | Reason text |

---

### `settings` — Global App Settings

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| app_name | VARCHAR(255) | Application name |
| is_admob_on | TINYINT | AdMob enabled flag |
| ad_banner_android | VARCHAR(255) | Android banner ad unit ID |
| ad_banner_ios | VARCHAR(255) | iOS banner ad unit ID |
| ad_interstitial_android | VARCHAR(255) | Android interstitial ad unit ID |
| ad_interstitial_ios | VARCHAR(255) | iOS interstitial ad unit ID |

---

### `profile_verifications` — Verification Requests

| Column | Type | Purpose |
|--------|------|---------|
| id | BIGINT UNSIGNED PK | Primary key |
| user_id | BIGINT UNSIGNED | Requesting user |
| full_name | VARCHAR(255) | Name on document |
| document_type | VARCHAR(255) | Type of ID document |
| document | VARCHAR(255) | Document image path |
| selfie | VARCHAR(255) | Selfie image path |
| created_at | TIMESTAMP | Request time |

---

### `user_notifications` / `admin_notifications` — Notifications

Store notification records for in-app notification history.

### `document_types` — Verification Document Types

Configurable list of accepted document types for profile verification.

### `username_restrictions` — Banned Usernames

List of usernames that cannot be registered (profanity filter, reserved names).

### `faqs` / `faq_types` — FAQ Content

Frequently asked questions displayed in the app's FAQ screen.

### `pages` — Static Pages

Content for Privacy Policy and Terms of Use pages.

### `saved_notifications` — Saved Notification History

Persistent notification records for users.

---

## Database Relationships

```
users ──< posts ──< post_contents
      ──< comments
      ──< likes
      ──< reels ──< reel_comments
      ──< stories
      ──< rooms (as owner)
      ──< room_users (as member)
      ──< following_lists (as follower and followed)
      ──< reports (as reporter)
      ──< profile_verifications

rooms ──< room_users
      ──< reports

music ──< reels
music_categories ──< music

interests ──< (referenced by interest_ids in users, posts, reels, rooms)
```

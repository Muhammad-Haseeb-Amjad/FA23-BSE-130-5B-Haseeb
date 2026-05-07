# CUICHAT — Admin Panel Documentation

## Overview

The CUICHAT admin panel is a web-based management interface built with Laravel Blade templates. It is accessible at `https://cuichat.online/` and provides administrators with full control over users, content, registrations, and platform settings.

All admin panel routes are protected by the `CheckLogin` middleware, which validates the session variable `user_name`. Unauthenticated requests are redirected to the login page (`/`).

---

## Admin Authentication

### Login Page (`/`)

**URL:** `https://cuichat.online/`

The login page accepts a username and password. Credentials are validated against the `admins` database table.

**Authentication flow:**
1. Admin submits username + password via `POST /loginForm`
2. `LoginController.checklogin()` looks up the admin by username
3. Password is verified — first tries `Crypt::decrypt()` (for encrypted passwords), then falls back to plain-text comparison (for freshly imported SQL)
4. On plain-text match, the password is automatically upgraded to encrypted storage
5. On success, `user_name` and `user_type` are stored in the session
6. Admin is redirected to `/dashboard`

**Forgot Password:**
- `POST /forgotPasswordForm` — requires database username and password as secondary verification
- On success, resets the admin password to the new value (encrypted)

**Logout:** `GET /logout` — invalidates session and redirects to `/`

---

## Admin Panel Pages

### 1. Dashboard (`/dashboard`)

**Purpose:** Analytics overview with charts showing platform activity.

**Data:** `GET /fetchAllChartData` returns chart data for users, posts, reels, rooms, and stories over time.

---

### 2. Users (`/users`)

**Purpose:** Manage all registered users.

**Tabs:**
- **All Users** — DataTable with search, pagination, block/unblock, view detail
- **Verified Users** — Users with `is_verified = 2` (admin-verified)
- **Subscription Verified** — Users with `is_verified = 3` (subscription-verified)
- **Moderators** — Users with `is_moderator = 1`

**Table columns (All Users):** Profile Image | Full Name (+ approval badge) | Username | Device | Moderator Toggle | Actions

**Actions per user:**
- **Block/Unblock** — `POST /blockUserByAdmin/{id}` / `POST /unblockUserByAdmin/{id}`
- **View** — `GET /usersDetail/{id}` — detailed user profile page
- **Moderator Toggle** — `POST /updateModeratorStatus`

**User Detail Page (`/usersDetail/{id}`):**
- Full profile information
- Edit profile fields
- View user's posts
- Delete profile/avatar images
- Verify user (grants blue tick)

---

### 3. Registration Requests (`/registrationRequests`)

**Purpose:** Review and manage CUI student and faculty registration requests. This is the most important admin workflow for CUICHAT.

**URL:** `https://cuichat.online/registrationRequests`

**Tabs:**
| Tab | Filter | Count shown |
|-----|--------|-------------|
| Pending | `approval_status = 'pending'` | Yes (badge) |
| Approved | `approval_status = 'approved'` OR NULL | Yes |
| Rejected | `approval_status = 'rejected'` | Yes |
| Cancelled | `approval_status = 'cancelled'` | Yes |

**Table columns (11 columns):**
1. Full Name
2. Role (Student / Faculty)
3. Registration Number (students only; '-' for faculty)
4. Department
5. Batch Duration (students only; '-' for faculty)
6. Campus
7. Email
8. Phone Number
9. Gender
10. Submitted At / Approved At / Rejected Reason / Cancelled At (varies by tab)
11. Actions

**Actions:**
- **View** — Opens a modal with full registration details
- **Approve** (pending only) — `POST /approveRegistrationRequest/{id}`
  - Sets `approval_status = 'approved'`
  - Records `approved_at` and `approved_by` (admin ID)
  - Sends approval email to user
- **Reject** (pending only) — `POST /rejectRegistrationRequest/{id}`
  - Requires a rejection reason (validated, max 2000 chars)
  - Sets `approval_status = 'rejected'`
  - Sends rejection email with reason to user
- **Cancel** (pending only) — `POST /cancelRegistrationRequest/{id}`
  - Sets `approval_status = 'cancelled'`
  - No email sent

**Search:** Searches across full_name, email, phone_number, registration_number, department.

---

### 4. Posts (`/viewPosts`)

**Purpose:** View and moderate all posts on the platform.

**Features:**
- View post content (image/video/audio preview in modal)
- Delete posts
- Restrict posts (hides from feed)
- View post reports
- Delete post reports
- View and delete comments

---

### 5. Reels (`/viewReels`)

**Purpose:** View and moderate all reels.

**Features:**
- View reel video in modal
- Delete reels
- View and delete reel comments
- View reel reports

---

### 6. Music (`/musics`)

**Purpose:** Manage the music library used in reels.

**Features:**
- Add/edit/delete music categories
- Add/edit/delete music tracks (upload audio file + cover image)

---

### 7. Stories (`/viewStories`)

**Purpose:** View and delete user stories.

---

### 8. Rooms (`/rooms`)

**Purpose:** View and manage live audio rooms.

**Features:**
- View all rooms with member counts
- Delete rooms
- View room details (members, admins, co-admins)
- Toggle private/public status
- Toggle join request requirement

---

### 9. Interests (`/interests`)

**Purpose:** Manage the interest categories used for content discovery.

**Features:**
- Add new interests (title + image)
- Edit existing interests
- Delete interests

---

### 10. Restrictions (`/restrictions`)

**Purpose:** Manage username restrictions (banned words/usernames).

**Features:**
- Add restricted usernames/words
- Edit restrictions
- Delete restrictions

---

### 11. Reports (`/reports`)

**Purpose:** Review user-submitted reports for users, posts, rooms, and reels.

**Features:**
- View all reports with reporter and reported content
- Delete reports
- Block reported user directly from report
- Delete reported content directly from report

---

### 12. Verification Requests (`/verificationRequests`)

**Purpose:** Review profile verification requests (blue tick).

**Features:**
- View submitted documents and selfies
- Approve verification (grants `is_verified = 2`)
- Reject verification

---

### 13. FAQs (`/faqs`)

**Purpose:** Manage FAQ content displayed in the app.

**Features:**
- Add/edit/delete FAQ categories (types)
- Add/edit/delete FAQ entries

---

### 14. Settings (`/setting`)

**Purpose:** Configure global app settings.

**Settings available:**
- App name
- AdMob configuration (Android and iOS ad unit IDs)
- Document types for profile verification
- Report reasons
- Deep linking configuration (Android `assetlinks.json`, iOS `apple-app-site-association`)

---

### 15. Notifications (`/notification`)

**Purpose:** Send platform-wide push notifications to all users.

**Features:**
- Compose and send notifications
- View notification history
- Repeat previous notifications
- Delete notifications
- Change admin password

---

### 16. AdMob (`/admob`)

**Purpose:** Configure AdMob ad unit IDs for Android and iOS.

---

## Admin Panel Security

- All protected routes use `CheckLogin` middleware
- Session-based authentication (no JWT or API tokens)
- Session invalidated on logout
- Cache-control headers set to prevent browser caching of admin pages:
  ```
  Cache-Control: nocache, no-store, max-age=0, must-revalidate
  Pragma: no-cache
  ```
- Password stored with Laravel `Crypt::encrypt()` (symmetric encryption)
- Password reset requires database credentials as secondary factor

---

## Admin Panel URL Reference

| Page | URL | Method |
|------|-----|--------|
| Login | `/` | GET |
| Dashboard | `/dashboard` | GET |
| Users | `/users` | GET |
| User Detail | `/usersDetail/{id}` | GET |
| Registration Requests | `/registrationRequests` | GET |
| Posts | `/viewPosts` | GET |
| Reels | `/viewReels` | GET |
| Music | `/musics` | GET |
| Stories | `/viewStories` | GET |
| Rooms | `/rooms` | GET |
| Room Detail | `/roomDetails/{id}` | GET |
| Interests | `/interests` | GET |
| Restrictions | `/restrictions` | GET |
| Reports | `/reports` | GET |
| Verification Requests | `/verificationRequests` | GET |
| FAQs | `/faqs` | GET |
| Settings | `/setting` | GET |
| Notifications | `/notification` | GET |
| AdMob | `/admob` | GET |
| Privacy Policy | `/privacyPolicy` | GET (public) |
| Terms of Use | `/termsOfUse` | GET (public) |

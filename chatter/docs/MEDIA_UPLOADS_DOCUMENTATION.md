# CUICHAT — Media Uploads Documentation

## Overview

CUICHAT handles media uploads through the Laravel backend. Files are stored on the server's filesystem and served via a public symlink. The Flutter app compresses images and videos before uploading to reduce bandwidth and storage usage.

---

## Upload Endpoint

### POST /api/uploadFile

**Purpose:** Upload a single media file and get back a storage path.

**Request:** `multipart/form-data`
| Field | Type | Description |
|-------|------|-------------|
| content | file | The media file to upload |

**Response:**
```json
{
  "status": true,
  "data": "uploads/1234567890_filename.jpg"
}
```

The returned path is relative to the storage directory. To construct the full URL:
```
Full URL = https://cuichat.online/storage/ + data
         = https://cuichat.online/storage/uploads/1234567890_filename.jpg
```

In Flutter, the `addBaseURL()` extension on `String` handles this:
```dart
"uploads/filename.jpg".addBaseURL()
// → "https://cuichat.online/storage/uploads/filename.jpg"
```

---

## Storage Configuration

### Server-side Storage Path

```
chatter_backend/
└── storage/
    └── app/
        └── public/
            └── uploads/          ← Files are stored here
                ├── profile_images/
                ├── post_content/
                ├── reel_videos/
                ├── music_files/
                └── story_media/
```

### Public Access via Symlink

Laravel's `php artisan storage:link` creates:
```
chatter_backend/public/storage → chatter_backend/storage/app/public
```

This makes files accessible at:
```
https://cuichat.online/storage/uploads/filename.jpg
```

---

## Media Types and Usage

### Profile Images
- **Uploaded via:** `POST /api/editProfile` (multipart, field: `profile`)
- **Stored at:** `storage/app/public/uploads/`
- **Displayed in:** Profile screen, feed posts, room members, chat
- **Flutter compression:** `Limits.imageSize = 720` (max dimension), `Limits.quality = 50` (JPEG quality)

### Background Images
- **Uploaded via:** `POST /api/editProfile` (multipart, field: `background_image`)
- **Stored at:** `storage/app/public/uploads/`
- **Displayed in:** Profile screen header

### Post Content (Images/Videos/Audio)
- **Uploaded via:** `POST /api/addPost` (multipart, field: `content[]`)
- **Thumbnails:** `thumbnail[]` field for video posts
- **Content types:** 0=image, 1=video, 2=audio, 3=text
- **Stored at:** `storage/app/public/uploads/`

### Reel Videos
- **Uploaded via:** `POST /api/uploadReel` (multipart, field: `reel`)
- **Thumbnail:** `thumbnail` field
- **Flutter processing:** `video_compress` package compresses video before upload
- **Stored at:** `storage/app/public/uploads/`

### Music Files
- **Uploaded via:** Admin panel (`POST /addMusic`)
- **Cover art:** Separate image upload
- **Stored at:** `storage/app/public/uploads/`
- **Served to:** Flutter app via `POST /api/fetchMusicWithSearch` etc.

### Story Media
- **Uploaded via:** `POST /api/createStory` (multipart, field: `story`)
- **Types:** 0=image, 1=video
- **Stored at:** `storage/app/public/uploads/`
- **Expiry:** Stories expire after 24 hours (checked by `created_at` timestamp)

### Profile Verification Documents
- **Uploaded via:** `POST /api/profileVerification` (multipart, fields: `document`, `selfie`)
- **Stored at:** `storage/app/public/uploads/`
- **Access:** Admin panel only — deleted after verification decision

### Room Cover Images
- **Uploaded via:** `POST /api/createRoom` / `POST /api/editRoom` (multipart, field: `photo`)
- **Stored at:** `storage/app/public/uploads/`

---

## Flutter Upload Implementation

The `ApiService.multiPartCallApi()` method handles multipart uploads:

```dart
ApiService.shared.multiPartCallApi(
  url: WebService.editProfile,
  param: {
    'user_id': SessionManager.shared.getUserID(),
    'username': 'new_username',
  },
  filesMap: {
    'profile': [profileImageXFile],
    'background_image': [bgImageXFile],
  },
  completion: (response) {
    // Handle response
  },
);
```

Files are passed as `XFile` objects from `image_picker`. Null files in the list are skipped.

---

## Hostinger-Specific Notes

### Symlink Limitation

Hostinger shared hosting may not support `php artisan storage:link` due to restricted shell access. If the symlink command fails:

**Manual workaround:**
1. In Hostinger File Manager, navigate to `public_html/` (or your Laravel `public/` directory)
2. Create a folder named `storage`
3. Inside `storage`, create a folder named `uploads`
4. Alternatively, configure the `.htaccess` to rewrite storage paths

**Alternative approach — copy instead of symlink:**
```php
// In AppServiceProvider.php boot():
if (!is_link(public_path('storage'))) {
    Artisan::call('storage:link');
}
```

### File Permissions

Ensure the storage directory is writable:
```bash
chmod -R 775 storage/
chmod -R 775 bootstrap/cache/
```

On Hostinger, this is typically done via File Manager → right-click → Permissions.

### Max Upload Size

Check Hostinger's PHP configuration for upload limits:
```
upload_max_filesize = 50M
post_max_size = 50M
max_execution_time = 120
```

These can be set in a `.htaccess` file in the `public/` directory:
```apache
php_value upload_max_filesize 50M
php_value post_max_size 50M
php_value max_execution_time 120
```

---

## Troubleshooting

### Issue: Images not loading in app
**Symptoms:** Broken image icons, 404 errors in logs

**Checks:**
1. Verify symlink exists: `ls -la public/storage` should show `storage -> ../storage/app/public`
2. Check file exists: `ls storage/app/public/uploads/`
3. Verify file permissions: `ls -la storage/app/public/uploads/`
4. Test URL directly in browser: `https://cuichat.online/storage/uploads/filename.jpg`

### Issue: Upload fails with 413 error
**Cause:** File too large for server's PHP configuration

**Fix:** Increase `upload_max_filesize` and `post_max_size` in `.htaccess` or `php.ini`

### Issue: Upload fails with 500 error
**Cause:** Storage directory not writable

**Fix:** `chmod -R 775 storage/` and `chmod -R 775 bootstrap/cache/`

### Issue: Old URLs with `:8000` port in production
**Cause:** Development URLs stored in database

**Fix:** The Flutter app's `addBaseURL()` extension automatically normalizes `:8000` URLs to the configured `baseURL`. For database cleanup, run a SQL update to remove port numbers from stored paths.

### Issue: Videos not playing
**Cause:** Server not sending correct MIME type for video files

**Fix:** Add to `.htaccess`:
```apache
AddType video/mp4 .mp4
AddType video/webm .webm
```

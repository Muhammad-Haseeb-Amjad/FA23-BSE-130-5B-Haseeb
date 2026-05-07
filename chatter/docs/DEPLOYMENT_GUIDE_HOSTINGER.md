# CUICHAT — Deployment Guide (Hostinger)

## Overview

The CUICHAT backend is deployed on Hostinger shared hosting. This guide covers the complete deployment process from file upload to a working production environment.

---

## Prerequisites

- Hostinger shared hosting plan (Business or higher recommended for PHP 8.1)
- MySQL database created in Hostinger hPanel
- FTP/SFTP access or Hostinger File Manager
- Domain pointed to Hostinger nameservers

---

## Step 1: Prepare the Backend Files

### 1.1 Build for Production

On your local machine:

```bash
cd chatter_backend
composer install --optimize-autoloader --no-dev
```

### 1.2 Configure `.env` for Production

Create a production `.env` file:

```dotenv
APP_NAME=CUICHAT
APP_ENV=production
APP_KEY=base64:your_generated_key_here
APP_DEBUG=false
APP_URL=https://cuichat.online

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=u968840278_cuichat_db
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password

MAIL_MAILER=smtp
MAIL_HOST=smtp.hostinger.com
MAIL_PORT=587
MAIL_USERNAME=noreply@cuichat.online
MAIL_PASSWORD=your_email_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@cuichat.online
MAIL_FROM_NAME="CUICHAT"

SMS_PROVIDER=twilio
TWILIO_SID=your_twilio_sid
TWILIO_TOKEN=your_twilio_token
TWILIO_FROM=+1234567890

CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
```

> **Security:** Never commit `.env` to version control. Set `APP_DEBUG=false` in production.

---

## Step 2: Hostinger File Structure

Hostinger's web root is typically `public_html/`. Laravel's web root is the `public/` directory. You need to configure this correctly.

### Recommended Structure on Hostinger

```
/home/username/
├── public_html/          ← Hostinger web root (domain points here)
│   ├── index.php         ← Modified to point to Laravel
│   ├── .htaccess         ← Laravel's .htaccess
│   ├── asset/            ← Admin panel assets
│   └── storage/          ← Symlink or copy of storage/app/public
│
└── chatter_backend/      ← Laravel app (outside web root for security)
    ├── app/
    ├── bootstrap/
    ├── config/
    ├── database/
    ├── public/           ← Laravel's public folder contents go to public_html/
    ├── resources/
    ├── routes/
    ├── storage/
    └── vendor/
```

### Alternative: Deploy Everything to public_html

If you cannot place files outside the web root:

```
public_html/
├── app/
├── bootstrap/
├── config/
├── database/
├── public/               ← Laravel public folder
│   ├── index.php
│   └── .htaccess
├── resources/
├── routes/
├── storage/
└── vendor/
```

Then modify `public/index.php` to use the correct paths.

---

## Step 3: Fix `index.php` Paths

If Laravel is deployed with `public_html/` as the web root but the app files are in a subdirectory, update `public/index.php`:

```php
<?php

// Original paths:
// require __DIR__.'/../vendor/autoload.php';
// $app = require_once __DIR__.'/../bootstrap/app.php';

// Updated paths (if app is in parent directory):
require __DIR__.'/../chatter_backend/vendor/autoload.php';
$app = require_once __DIR__.'/../chatter_backend/bootstrap/app.php';

// ... rest of index.php
```

---

## Step 4: Upload Files

### Via FTP/SFTP

1. Connect using FileZilla or similar FTP client
2. Upload all backend files to the appropriate directory
3. Ensure `.env` is uploaded (it is gitignored, so upload manually)

### Via Hostinger File Manager

1. Log in to hPanel → File Manager
2. Navigate to the target directory
3. Upload a ZIP of the backend files
4. Extract the ZIP

---

## Step 5: Database Setup

### 5.1 Create Database in hPanel

1. hPanel → Databases → MySQL Databases
2. Create a new database (e.g., `u968840278_cuichat_db`)
3. Create a database user and assign full privileges
4. Note the database name, username, and password

### 5.2 Import Database via phpMyAdmin

1. hPanel → Databases → phpMyAdmin
2. Select your database
3. Click **Import**
4. Choose your SQL dump file
5. Click **Go**

### 5.3 Or Run Migrations via SSH

If SSH access is available:

```bash
cd /path/to/chatter_backend
php artisan migrate --force
```

The `--force` flag is required in production environment.

---

## Step 6: Storage Symlink

### Option A: Via SSH

```bash
cd /path/to/chatter_backend
php artisan storage:link
```

### Option B: Manual via File Manager

1. In File Manager, navigate to `public_html/` (or `public/`)
2. Create a folder named `storage`
3. This folder will serve as the public storage directory
4. Upload files directly to `storage/uploads/` for testing

### Option C: .htaccess Rewrite

Add to `public/.htaccess`:

```apache
# Serve storage files
RewriteRule ^storage/(.*)$ /path/to/storage/app/public/$1 [L]
```

---

## Step 7: Set File Permissions

Via SSH:
```bash
chmod -R 755 /path/to/chatter_backend
chmod -R 775 /path/to/chatter_backend/storage
chmod -R 775 /path/to/chatter_backend/bootstrap/cache
```

Via File Manager: Right-click folders → Permissions → set to 755 (directories) and 644 (files), 775 for storage.

---

## Step 8: Clear Caches

Via SSH:
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
```

Or clear all caches:
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

---

## Step 9: Configure PHP Version

In hPanel → Advanced → PHP Configuration:
- Set PHP version to **8.1** or **8.2**
- Enable extensions: `pdo_mysql`, `mbstring`, `openssl`, `tokenizer`, `xml`, `ctype`, `json`, `bcmath`, `fileinfo`, `gd`

---

## Step 10: Flutter APK Build and Distribution

### Build Release APK

```bash
cd chatter_flutter/chatter

# Ensure production URL is set in lib/utilities/const.dart:
# const String baseURL = "https://cuichat.online/";

flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

### Sign the APK

Create a keystore (first time only):
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Configure signing in `android/app/build.gradle`:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
```

### Distribute APK

Options:
1. **Direct download:** Host the APK on the server at `https://cuichat.online/app/cuichat.apk`
2. **Google Play Store:** Upload the `.aab` bundle
3. **Firebase App Distribution:** For beta testing

---

## Common Deployment Errors and Fixes

### Error: 500 Internal Server Error
**Cause:** Usually a misconfigured `.env` or missing `APP_KEY`

**Fix:**
```bash
php artisan key:generate --force
php artisan config:clear
```

### Error: "No application encryption key has been specified"
**Fix:** Ensure `APP_KEY` is set in `.env`. Run `php artisan key:generate`.

### Error: Class not found / Composer autoload issues
**Fix:**
```bash
composer dump-autoload --optimize
```

### Error: Database connection refused
**Fix:** Verify `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` in `.env`. On Hostinger, `DB_HOST` is usually `127.0.0.1`.

### Error: Storage files returning 404
**Fix:** Verify the storage symlink exists or use the `.htaccess` rewrite approach.

### Error: CORS errors from Flutter app
**Fix:** Check `config/cors.php` — ensure `allowed_origins` includes your domain or is set to `['*']` for development.

### Error: "php artisan" commands not available
**Fix:** Use the full PHP path on Hostinger:
```bash
/usr/local/bin/php8.1 artisan migrate
```

### Error: OTP SMS not sending
**Fix:** Verify `SMS_PROVIDER`, `TWILIO_SID`, `TWILIO_TOKEN`, `TWILIO_FROM` in `.env`. Test with `APP_DEBUG=true` first to confirm OTP generation works.

### Error: Email notifications not sending
**Fix:** Verify SMTP settings. Test with Hostinger's built-in email or a service like Mailgun/SendGrid.

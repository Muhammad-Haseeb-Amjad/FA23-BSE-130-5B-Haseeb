# CUICHAT — Known Issues and Limitations

## Overview

This document honestly describes known issues, limitations, and workarounds in the current CUICHAT implementation. Issues are categorized by component and include their current status.

---

## Backend Issues

| # | Issue | Description | Status | Workaround |
|---|-------|-------------|--------|------------|
| BE-01 | OTP SMS requires paid provider | The OTP system supports Twilio and Vonage but neither is configured by default. Without a provider, OTPs are only returned in the API response (debug mode) or logged to `laravel.log`. | Known Issue | Set `APP_DEBUG=true` during development. Configure Twilio or Vonage for production. |
| BE-02 | Email SMTP not configured by default | The `.env.example` has placeholder SMTP values. Approval and rejection emails will fail silently if SMTP is not configured. | Known Issue | Configure SMTP in `.env`. Use Hostinger's built-in email or a service like Mailgun. |
| BE-03 | No OTP rate limiting | The `sendRegisterOtp` endpoint does not limit how many times an OTP can be requested for the same phone number. This could be abused. | Known Issue | Planned Fix: Add rate limiting middleware or a cooldown period in the OTP table. |
| BE-04 | Debug OTP in production risk | If `APP_DEBUG=true` is accidentally left on in production, the OTP is returned in the API response, bypassing SMS verification entirely. | Known Issue | Always set `APP_DEBUG=false` in production `.env`. |
| BE-05 | Admin password uses symmetric encryption | Admin passwords are stored with `Crypt::encrypt()` (reversible) rather than bcrypt (one-way). This is less secure than standard password hashing. | Known Issue | Planned Fix: Migrate to `Hash::make()` (bcrypt) for admin passwords. |
| BE-06 | No API authentication tokens | The API uses a static `apikey: 123` header for all requests. There is no per-user token or JWT authentication. Any request with the correct header can call any endpoint. | Known Issue | The static key provides basic protection. Per-user tokens (Laravel Sanctum) are a planned enhancement. |
| BE-07 | Legacy users have incomplete CUI fields | Users registered before the CUI migration (2026) have `NULL` values for `role_type`, `approval_status`, etc. The migration sets `approval_status = 'approved'` for existing users, but other CUI fields remain NULL. | Known Issue | Workaround Available: The API handles NULL CUI fields gracefully. Legacy users function normally. |
| BE-08 | Self-healing column check on every register | `RegistrationController.ensureUserColumnsExist()` runs `ALTER TABLE` on every registration attempt. This is a defensive measure but adds overhead. | Known Issue | Workaround Available: Run `php artisan migrate` properly to avoid this. The method silently ignores "duplicate column" errors. |
| BE-09 | Hostinger symlink limitations | `php artisan storage:link` may fail on Hostinger shared hosting due to restricted shell access. | Known Issue | Workaround Available: See [Deployment Guide](DEPLOYMENT_GUIDE_HOSTINGER.md) for manual alternatives. |

---

## Flutter App Issues

| # | Issue | Description | Status | Workaround |
|---|-------|-------------|--------|------------|
| FL-01 | Firebase dependency for social login | Google and Apple login require Firebase configuration. Without `google-services.json` and `GoogleService-Info.plist`, the app will not compile. | Known Issue | Required setup step — see [Installation Guide](INSTALLATION_GUIDE.md). |
| FL-02 | Agora credentials are placeholder | `agoraAppId`, `agoraCustomerId`, and `agoraCustomerSecret` in `const.dart` are set to placeholder strings. Audio rooms will not work without real Agora credentials. | Known Issue | Register at agora.io and replace the placeholder values. |
| FL-03 | RevenueCat keys are empty | `revenuecatAppleApiKey` and `revenuecatAndroidApiKey` are empty strings. In-app purchases will not function. | Known Issue | Configure RevenueCat if subscription features are needed. |
| FL-04 | Package name is "untitled" | The Flutter project's internal package name is `untitled` (development placeholder). This needs to be changed before Play Store submission. | Known Issue | Planned Fix: Rename package to `com.cuichat.app` or similar using `flutter_rename` or manual update. |
| FL-05 | No offline mode | The app requires an active internet connection. There is no offline caching for feed content. | Known Issue | Planned Enhancement: Add offline support with local database caching. |
| FL-06 | Chat data not in MySQL | All chat messages are stored in Firebase Firestore, not the MySQL database. This means chat data cannot be moderated or backed up through the admin panel. | Known Issue | By design — Firestore provides real-time capabilities. Admin moderation of chat is a planned feature. |
| FL-07 | iOS build requires macOS | Building for iOS requires a Mac with Xcode. Android builds can be done on any platform. | Known Limitation | Use a Mac or a CI/CD service like Codemagic for iOS builds. |

---

## Database Issues

| # | Issue | Description | Status | Workaround |
|---|-------|-------------|--------|------------|
| DB-01 | No database backups configured | There is no automated backup schedule for the MySQL database. | Known Issue | Configure Hostinger's automated backup feature or set up a cron job. |
| DB-02 | Comma-separated IDs instead of junction tables | `interest_ids`, `block_user_ids`, `saved_music_ids`, and `saved_reel_ids` are stored as comma-separated strings rather than proper junction tables. This limits query efficiency. | Known Issue | Workaround Available: Current implementation works for the expected scale. Migration to junction tables is a planned enhancement. |
| DB-03 | No soft deletes | Most models use hard deletes. Deleted content cannot be recovered. | Known Issue | Planned Fix: Add `SoftDeletes` trait to critical models. |

---

## Security Limitations

| # | Issue | Description | Status | Workaround |
|---|-------|-------------|--------|------------|
| SEC-01 | Static API key | The `apikey: 123` header is a shared secret visible in the Flutter source code. Anyone who decompiles the APK can extract it. | Known Limitation | Planned Fix: Implement per-user JWT tokens with Laravel Sanctum. |
| SEC-02 | No OTP brute force protection | There is no lockout after multiple failed OTP attempts. | Known Issue | Planned Fix: Add attempt counter and lockout period. |
| SEC-03 | Admin password reversible encryption | `Crypt::encrypt()` is reversible. If the `APP_KEY` is compromised, all admin passwords can be decrypted. | Known Issue | Planned Fix: Migrate to bcrypt. |

---

## Deployment Limitations

| # | Issue | Description | Status | Workaround |
|---|-------|-------------|--------|------------|
| DEP-01 | Shared hosting performance | Hostinger shared hosting has limited CPU and memory. High traffic may cause slow responses or timeouts. | Known Limitation | For production scale, migrate to a VPS or cloud hosting (DigitalOcean, AWS). |
| DEP-02 | No queue worker | `QUEUE_CONNECTION=sync` means all jobs (emails, notifications) run synchronously in the request cycle. This can slow down API responses. | Known Issue | Planned Fix: Configure a queue worker with `QUEUE_CONNECTION=database` or Redis. |
| DEP-03 | No HTTPS enforcement in code | HTTPS is enforced at the server/domain level, not in the Laravel application code. | Known Issue | Workaround Available: Hostinger provides free SSL. Ensure it is enabled. |

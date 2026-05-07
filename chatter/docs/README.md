# CUICHAT — COMSATS CUI Social Platform

> A university social platform for COMSATS University Islamabad students and faculty.

**Tech Stack:** Flutter | Laravel 9 | MySQL | Hostinger | Firebase

**Status:** Active Development | Final Year Project

---

## Quick Links
- [Project Overview](PROJECT_OVERVIEW.md)
- [Installation Guide](INSTALLATION_GUIDE.md)
- [API Documentation](API_DOCUMENTATION.md)
- [Admin Panel](ADMIN_PANEL_DOCUMENTATION.md)
- [Complete Documentation](CUICHAT_COMPLETE_PROJECT_DOCUMENTATION.md)

---

## Project Structure

```
cuichat/
├── chatter_backend/          # Laravel backend + admin panel
│   ├── app/
│   │   ├── Http/Controllers/ # API + web controllers
│   │   ├── Models/           # Eloquent models
│   │   └── Http/Middleware/  # Auth middleware
│   ├── database/migrations/  # Database schema
│   ├── routes/
│   │   ├── api.php           # Mobile API routes
│   │   └── web.php           # Admin panel routes
│   ├── resources/views/      # Admin panel Blade templates
│   └── public/               # Public assets
│
└── chatter_flutter/chatter/  # Flutter mobile app
    ├── lib/
    │   ├── main.dart
    │   ├── utilities/        # Constants, URLs, params
    │   ├── models/           # Data models
    │   ├── common/
    │   │   ├── api_service/  # API service classes
    │   │   └── managers/     # Session, notifications
    │   └── screens/          # All app screens
    └── pubspec.yaml
```

## Features

- ✅ Student & Faculty registration with OTP verification
- ✅ Admin approval workflow
- ✅ Social feed (posts, reels, stories)
- ✅ Live audio rooms (Agora RTC)
- ✅ Direct messaging (Firebase Firestore)
- ✅ Music integration
- ✅ Interest-based content discovery
- ✅ Multi-campus support (7 COMSATS campuses)
- ✅ Admin panel for content moderation
- ✅ Push notifications (Firebase FCM)
- ✅ Google & Apple social login
- ✅ AdMob integration

## Live Deployment

- **Backend:** https://cuichat.online/
- **Admin Panel:** https://cuichat.online/dashboard
- **API Base:** https://cuichat.online/api/

## Developer Notes

- Backend URL is configured in `chatter_flutter/chatter/lib/utilities/const.dart`
- Admin credentials are stored in the `admins` database table
- OTP uses debug fallback when `APP_DEBUG=true` and no SMS provider is configured
- Do not commit `.env` files with real credentials
- All API routes require the `apikey: 123` header (enforced by `CheckHeader` middleware)

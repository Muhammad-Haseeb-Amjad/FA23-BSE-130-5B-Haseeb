# CUICHAT — Flutter App Documentation

## Overview

The Flutter app is the primary client for CUICHAT. It is a cross-platform application targeting Android and iOS, built with Flutter 3.5+ and Dart 3.5.4. The app uses GetX for state management and navigation, Firebase for authentication and real-time chat, and communicates with the Laravel backend via a custom HTTP service layer.

The project package name is `untitled` (internal development name). The app is branded as "Chatter" (`appName = "Chatter"` in `const.dart`).

---

## App Structure

```
lib/
├── main.dart                          # App entry point, Firebase init, GetStorage init
├── utilities/
│   ├── const.dart                     # baseURL, colors, limits, Agora config
│   ├── web_service.dart               # All API endpoint URL constants
│   ├── params.dart                    # API parameter name constants
│   └── filters.dart                   # Content filters
├── models/
│   ├── registration.dart              # User model + Registration response
│   ├── users_model.dart               # List of users response
│   ├── setting_model.dart             # Settings + Interest models
│   ├── common_response.dart           # Generic API response
│   ├── post.dart                      # Post model
│   ├── reel.dart                      # Reel model
│   ├── room.dart                      # Room model
│   ├── story.dart                     # Story model
│   └── ...
├── common/
│   ├── api_service/
│   │   ├── api_service.dart           # Base HTTP client (call + multiPartCallApi)
│   │   ├── user_service.dart          # User/auth API calls
│   │   ├── post_service.dart          # Posts API calls
│   │   ├── reel_service.dart          # Reels API calls
│   │   ├── room_service.dart          # Rooms API calls
│   │   ├── notification_service.dart  # Notification API calls
│   │   └── common_service.dart        # Settings fetch
│   ├── managers/
│   │   ├── session_manager.dart       # GetStorage session (user, login state, settings)
│   │   ├── firebase_notification_manager.dart  # FCM setup and handling
│   │   ├── subscription_manager.dart  # RevenueCat in-app purchases
│   │   └── ads/
│   │       └── interstitial_manager.dart  # AdMob interstitial ads
│   ├── controller/
│   │   └── base_controller.dart       # Base GetX controller (loading, snackbar)
│   ├── extensions/
│   │   └── font_extension.dart        # Text style helpers (gilroy, outfit fonts)
│   └── widgets/                       # Reusable UI widgets
├── screens/
│   ├── splash_screen/                 # App launch, session check, settings fetch
│   ├── on_boarding_screen/            # First-time onboarding slides
│   ├── login_screen/                  # Login, social auth, CUI login, OTP, pending
│   ├── registration_screen/           # CUI Student/Faculty registration form
│   ├── interests_screen/              # Interest selection (up to 5)
│   ├── username_screen/               # Username setup
│   ├── profile_picture_screen/        # Profile photo setup
│   ├── tabbar/                        # Main app tab navigation
│   ├── feed_screen/                   # Social feed
│   ├── add_post_screen/               # Create post
│   ├── post/                          # Post detail view
│   ├── single_post_screen/            # Single post screen
│   ├── reels_screen/                  # Short video feed
│   ├── single_reel_screen/            # Single reel view
│   ├── dashboard_reels_screen/        # Reels dashboard
│   ├── saved_reels_screen/            # Saved reels
│   ├── camera_screen/                 # Record reel video
│   ├── audio_space/                   # Live audio rooms (Agora)
│   ├── rooms_screen/                  # Room discovery
│   ├── rooms_you_own/                 # Rooms owned by user
│   ├── room_invitation_screen/        # Room invitations
│   ├── story_screen/                  # Story viewer
│   ├── chats_screen/                  # Direct messages (Firebase Firestore)
│   ├── profile_screen/                # User profile view
│   ├── edit_profile_screen/           # Edit profile
│   ├── search_screen/                 # Search users, posts, hashtags
│   ├── search_post_with_interest_screen/  # Posts filtered by interest
│   ├── search_reel_with_interest_screen/  # Reels filtered by interest
│   ├── notification_screen/           # Notifications
│   ├── setting_screen/                # App settings
│   ├── block_by_admin_screen/         # Shown when user is blocked
│   ├── block_list_screen/             # User's block list
│   ├── faq_screen/                    # FAQ content
│   ├── languages_screen/              # Language selection
│   ├── profile_verification_screen/   # Submit verification documents
│   ├── report_screen/                 # Report content
│   ├── random_screen/                 # Random user discovery
│   ├── tag_screen/                    # Hashtag content
│   ├── follow_button/                 # Reusable follow button widget
│   ├── extra_views/                   # Shared UI components (LogoTag, etc.)
│   └── sheets/                        # Bottom sheet components
└── localization/                      # Multi-language support (GetX translations)
```

---

## Key Configuration Files

### `lib/utilities/const.dart`

The central configuration file. Key constants:

```dart
const String baseURL = "https://cuichat.online/";
const String itemBaseURL = baseURL;
const String apiURL = "${baseURL}api/";
const String notificationTopic = "chatter";

const String agoraAppId = 'agora_app_id';
const String revenuecatAppleApiKey = '';
const String revenuecatAndroidApiKey = '';
```

**To change the backend URL**, edit `baseURL`. Always include the trailing slash.

**Color palette:**
- `cPrimary` = `#40E378` (green)
- `cBlack` = `#0E0E0E`
- `cRed` = `#FF3939`
- `cBlueTick` = `#1D9BF0`

**Limits:**
- `Limits.pagination` = 20 (items per page)
- `Limits.interestCount` = 5 (max interests per user)
- `Limits.username` = 30 (max username length)
- `Limits.bioCount` = 120 (max bio length)

### `lib/utilities/web_service.dart`

All API endpoint URLs as constants. Example:

```dart
static const String cuiLogin = "${apiURL}cuiLogin";
static const String sendRegisterOtp = "${apiURL}sendRegisterOtp";
static const String register = "${apiURL}register";
```

### `lib/utilities/params.dart`

All API parameter name constants. Example:

```dart
static const roleType = "role_type";
static const registrationNumber = "registration_number";
static const batchDuration = "batch_duration";
static const phoneNumber = "phone_number";
```

---

## Main Entry Point (`main.dart`)

On app launch, `main()` performs:
1. `WidgetsFlutterBinding.ensureInitialized()` — Flutter binding
2. `SystemChrome.setPreferredOrientations([portrait])` — Lock to portrait
3. `Firebase.initializeApp()` — Initialize Firebase
4. `FirebaseMessaging.onBackgroundMessage(handler)` — Register background FCM handler
5. `GetStorage.init()` — Initialize local storage
6. `AppTrackingTransparency.requestTrackingAuthorization()` — iOS ATT prompt
7. `MobileAds.instance.initialize()` — Initialize AdMob
8. `AudioSession.instance.configure(speech)` — Configure audio for rooms
9. `runApp(MyApp())` — Launch the app

`MyApp` is a `GetMaterialApp` with:
- GetX translations for localization
- Material 3 disabled (uses Material 2)
- Home: `SplashScreenView`

---

## Screen Documentation

### Splash Screen (`screens/splash_screen/`)
**Purpose:** App launch screen. Checks session state and navigates to the appropriate screen.

**Flow (`SplashController.fetchSettings`):**
1. Fetch fresh user profile from API (if logged in)
2. Fetch global settings (interests, AdMob IDs, report reasons)
3. Navigate based on state:
   - Not logged in → `OnBoardingScreen`
   - Logged in, blocked → `BlockedByAdminScreen`
   - Logged in, no interests → `InterestScreen`
   - Logged in, no username → `UserNameScreen`
   - Logged in, no profile photo → `ProfilePictureScreen`
   - Logged in, complete → `TabBarScreen`

---

### Login Screen (`screens/login_screen/`)
**Files:** `login_screen.dart`, `login_controller.dart`, `sign_in_with_email_screen.dart`, `register_otp_screen.dart`, `registration_pending_screen.dart`

**Login options:**
- **Google Sign-In**: Uses `google_sign_in` package. Calls `POST /api/addUser` with `login_type: 1`.
- **Apple Sign-In**: Uses `sign_in_with_apple` package. Calls `POST /api/addUser` with `login_type: 2`.
- **Email Sign-In**: Bottom sheet with name + email. Calls `POST /api/addUser` with `login_type: 0`.
- **CUI Login**: Separate screen with email + password. Calls `POST /api/cuiLogin`.
- **CUI Register**: Navigates to `CuiRegistrationScreen`.

**Post-login navigation** (`LoginController.registerUser`):
- Checks `approvalStatus` — blocks non-approved CUI users
- Sets session via `SessionManager.shared.setUser(user)` and `setLogin(true)`
- Navigates based on profile completeness (same logic as splash)

---

### CUI Registration Screen (`screens/registration_screen/cui_registration_screen.dart`)
**Purpose:** Multi-field registration form for COMSATS students and faculty.

**Role toggle:** Student / Faculty (switches between different field sets)

**Student fields:** Full Name, Registration Number (FA23-BSE-130 format), Email, Department (35 options), Phone, Gender, Password, Confirm Password, Batch Duration (FA23-SP27 format), Campus (7 options)

**Faculty fields:** Full Name, Department, Gender, Phone, Email, Password, Confirm Password, Campus

**Validation:**
- Phone: `^(03\d{9}|\+923\d{9})$`
- Registration number: `^[A-Z]{2}\d{2}-[A-Z]{2,5}-\d{1,4}(-[A-Z])?$`
- Batch duration: `^[A-Z]{2}\d{2}-[A-Z]{2}\d{2}$`
- Password: minimum 6 characters

**On submit:** Calls `UserService.shared.sendRegisterOtp(phone)` → navigates to `RegisterOtpScreen`

---

### OTP Screen (`screens/login_screen/register_otp_screen.dart`)
**Purpose:** Enter and verify the 6-digit OTP sent to the phone.

**Features:**
- 45-second countdown timer before resend is allowed
- Debug banner (yellow) shown when backend returns OTP in debug mode
- Auto-fills OTP field in debug mode
- On verify: calls `verifyRegisterOtp` then `registerCuiUser`
- On success: navigates to `RegistrationPendingScreen`

---

### Registration Pending Screen (`screens/login_screen/registration_pending_screen.dart`)
**Purpose:** Confirmation screen shown after successful registration submission.

Displays a message informing the user that their request is pending admin approval and they will receive an email when approved. Has a "Back to Sign In" button.

---

### Tab Bar (`screens/tabbar/`)
**Purpose:** Main app navigation with bottom tab bar.

Tabs: Feed, Reels/Explore, Rooms, Chats, Profile

---

### Feed Screen (`screens/feed_screen/`)
**Purpose:** Social feed showing posts from followed users and suggested content.

Supports: text posts, image posts, video posts, audio posts, likes, comments, shares, hashtag navigation.

---

### Reels Screen (`screens/reels_screen/`)
**Purpose:** TikTok-style short video feed.

Features: vertical scroll, like/comment, music info, hashtag navigation, save reel, report.

---

### Audio Space / Rooms (`screens/audio_space/`, `screens/rooms_screen/`)
**Purpose:** Live audio rooms powered by Agora RTC.

Features: join/leave, invite users, request to join private rooms, co-admin management, mute/unmute, room notifications.

---

### Chats Screen (`screens/chats_screen/`)
**Purpose:** Direct messaging using Firebase Firestore.

All chat data is stored in Firestore, not MySQL. The backend is not involved in message delivery.

---

### Profile Screen (`screens/profile_screen/`)
**Purpose:** View user profiles with posts, reels, follow/unfollow, block/report.

---

### Settings Screen (`screens/setting_screen/`)
**Purpose:** App settings including notifications, privacy, language, FAQ, and account deletion.

---

## Session Management (`common/managers/session_manager.dart`)

Uses `GetStorage` for persistent local storage. Key methods:

| Method | Description |
|--------|-------------|
| `isLogin()` | Returns true if user is logged in |
| `setLogin(bool)` | Set login state |
| `setUser(User?)` | Save user object to storage |
| `getUser()` | Retrieve user object from storage |
| `getUserID()` | Get current user's ID as int |
| `setSettings(Settings)` | Save global settings |
| `getSettings()` | Retrieve global settings |
| `clear()` | Erase all stored data (logout) |

---

## Dependencies (pubspec.yaml)

| Package | Version | Purpose |
|---------|---------|---------|
| get | ^4.7.2 | State management, navigation, snackbars |
| get_storage | ^2.1.1 | Local persistent storage |
| http | ^1.5.0 | HTTP requests to backend |
| firebase_core | ^4.1.1 | Firebase initialization |
| firebase_auth | ^6.1.0 | Firebase authentication |
| cloud_firestore | ^6.0.2 | Real-time chat storage |
| firebase_messaging | ^16.0.2 | Push notifications (FCM) |
| google_sign_in | ^7.2.0 | Google OAuth login |
| sign_in_with_apple | ^7.0.1 | Apple Sign-In |
| agora_rtc_engine | ^6.5.3 | Live audio rooms |
| google_mobile_ads | ^6.0.0 | AdMob banner and interstitial ads |
| purchases_flutter | ^9.7.0 | RevenueCat in-app purchases |
| image_picker | ^1.2.0 | Camera and gallery access |
| video_player | ^2.10.0 | Video playback |
| video_compress | ^3.1.4 | Video compression before upload |
| cached_network_image | ^3.4.1 | Cached image loading |
| flutter_local_notifications | ^19.4.2 | Local notification display |
| audio_waveforms | ^1.3.0 | Audio waveform visualization |
| audio_session | ^0.2.2 | Audio session management |
| url_launcher | ^6.3.2 | Open URLs in browser |
| app_tracking_transparency | ^2.0.6+1 | iOS ATT permission |
| permission_handler | ^12.0.1 | Runtime permissions |
| intl | ^0.20.2 | Date/number formatting |
| webview_flutter | ^4.13.0 | In-app web views |
| share_plus | ^12.0.0 | Share content |
| app_links | ^6.4.1 | Deep linking |

**Custom package:**
- `retrytech_plugin` (git): Provides `GoogleSignIn.instance` wrapper and other utilities.

**Fonts:** Gilroy (9 weights) and Outfit (3 weights) — loaded from `assets/fonts/`.

---

## How to Change the Backend URL

1. Open `chatter_flutter/chatter/lib/utilities/const.dart`
2. Change the `baseURL` constant:

```dart
// Local development (Android emulator):
const String baseURL = "http://10.0.2.2:8000/";

// Local development (physical device):
const String baseURL = "http://192.168.1.x:8888/";

// Production:
const String baseURL = "https://cuichat.online/";
```

3. Run `flutter clean && flutter pub get` after changing the URL.

> The `addBaseURL()` extension on `String` handles URL normalization, including replacing stray `:8000` ports and mapping localhost to the configured host.

# CUICHAT — Viva Preparation Notes

## 2-Minute Project Introduction Script

"CUICHAT is a university-specific social networking platform developed as my Final Year Project for COMSATS University Islamabad. The core problem it solves is the lack of a verified, dedicated communication platform for the COMSATS community. Currently, students and faculty rely on fragmented tools like WhatsApp groups and Facebook pages, which have no identity verification and no academic context.

CUICHAT addresses this by providing a closed platform where only verified COMSATS students and faculty can register. The registration process involves phone OTP verification followed by admin approval, ensuring every account belongs to a genuine community member.

The system has two main components: a Flutter mobile app for Android and iOS, and a Laravel 9 REST API backend deployed on Hostinger. The app supports social feeds with posts, reels, and stories; live audio rooms powered by Agora RTC; real-time direct messaging via Firebase Firestore; and a music library for reels. An admin panel allows administrators to approve registrations, moderate content, and manage the platform.

The project is live at cuichat.online and supports all 7 COMSATS campuses."

---

## Technology Justification

### Why Flutter?
- Single codebase for Android and iOS reduces development time by ~40%
- GetX provides lightweight state management without boilerplate
- Strong community and extensive package ecosystem
- Hot reload speeds up UI development significantly

### Why Laravel 9?
- Mature, well-documented PHP framework
- Eloquent ORM simplifies database operations
- Built-in validation, middleware, and routing
- Easy deployment on shared hosting (Hostinger supports PHP 8.1)
- Artisan CLI for migrations and maintenance

### Why MySQL?
- Widely supported on shared hosting
- Relational model suits the structured data (users, posts, relationships)
- phpMyAdmin available on Hostinger for easy management

### Why Firebase?
- Firestore provides real-time chat without building a WebSocket server
- FCM is the industry standard for push notifications
- Firebase Auth simplifies Google and Apple social login
- Free tier is sufficient for the expected user base

### Why Agora RTC?
- Purpose-built for real-time audio/video communication
- Token-based security model
- Low latency suitable for live audio rooms
- Well-documented Flutter SDK

### Why Hostinger?
- Affordable shared hosting suitable for a university project
- Supports PHP 8.1 and MySQL
- Free SSL certificate
- Sufficient for the expected traffic during the project lifecycle

---

## Q&A Preparation

**Q1: What is the main purpose of CUICHAT?**
A: CUICHAT is a verified social platform exclusively for COMSATS University Islamabad students and faculty. It provides a trusted space for academic and social interaction, with identity verification through phone OTP and admin approval to ensure only genuine community members can access the platform.

**Q2: How does the registration process work?**
A: Registration has three steps. First, the user fills a form with their details (name, email, department, phone, password, and for students: registration number and batch). Second, a 6-digit OTP is sent to their phone for verification. Third, after OTP verification, the registration is submitted and placed in a pending queue. An admin reviews and approves or rejects the request. Only approved users can log in.

**Q3: How is the OTP system implemented?**
A: The OTP is a 6-digit random number generated server-side. It is hashed using SHA-256 (not bcrypt, for performance on shared hosting) and stored in the `registration_otps` table with a 10-minute expiry. The phone number is normalized to the `03xxxxxxxxx` format. The system supports Twilio and Vonage for SMS delivery. In debug mode, the OTP is returned in the API response for testing.

**Q4: What is the difference between social login and CUI login?**
A: Social login (Google, Apple, Email via Firebase) creates accounts that are automatically approved — these are for general users. CUI login uses email and password stored in the MySQL database and requires admin approval. CUI users go through the full registration and approval workflow.

**Q5: How does the admin approval workflow work?**
A: When a CUI user registers, their account is created with `approval_status = 'pending'`. The admin sees this in the Registration Requests page of the admin panel. The admin can view the full details, then approve (which sends an approval email), reject (which requires a reason and sends a rejection email), or cancel the request. Only approved users can log in.

**Q6: What database does CUICHAT use and how is it structured?**
A: MySQL with 30+ tables. The most important is the `users` table, which was extended with CUI-specific fields (role_type, approval_status, registration_number, department, batch_duration, phone_number, gender, campus, and several timestamps) through Laravel migrations. There is also a `registration_otps` table for the OTP verification flow.

**Q7: How does real-time chat work?**
A: Chat uses Firebase Firestore, a NoSQL real-time database. Messages are stored in Firestore collections, not in MySQL. The Flutter app subscribes to Firestore document streams, so messages appear instantly without polling. The Laravel backend is not involved in message delivery.

**Q8: How do live audio rooms work?**
A: Audio rooms use Agora RTC Engine. When a user joins a room, the Flutter app requests an Agora token from the backend (`POST /api/generateAgoraToken`). The backend generates the token using the Agora Dynamic Key library with the channel name and user ID. The app then uses this token to join the Agora channel. Room membership and metadata are stored in MySQL.

**Q9: How are media files handled?**
A: Files are uploaded via multipart HTTP requests to `POST /api/uploadFile`. The backend stores them in `storage/app/public/uploads/` and returns the relative path. A symlink makes them publicly accessible at `https://cuichat.online/storage/uploads/filename`. The Flutter app compresses images (max 720px, 50% quality) and videos before uploading.

**Q10: What security measures are in place?**
A: The API uses a shared `apikey: 123` header validated by middleware. Admin panel uses session-based authentication. Passwords are hashed with bcrypt (user passwords) or Laravel Crypt (admin passwords). OTPs are hashed with SHA-256. Phone numbers and gender are private fields not exposed in public API responses. `APP_DEBUG=false` in production prevents OTP leakage.

**Q11: How does the app handle offline scenarios?**
A: Currently, the app requires an active internet connection. The splash screen fetches fresh user data and settings on launch, with a fallback to cached data if the network request fails. This is a known limitation — offline mode is planned as a future enhancement.

**Q12: How is the admin panel secured?**
A: The admin panel uses Laravel session-based authentication. All protected routes are wrapped in the `CheckLogin` middleware, which checks for the `user_name` session variable. Unauthenticated requests are redirected to the login page. Cache-control headers prevent browser caching of admin pages.

**Q13: What are the main limitations of the current implementation?**
A: The main limitations are: (1) the static API key is not per-user, (2) OTP SMS requires a paid provider not yet configured, (3) no OTP brute force protection, (4) admin passwords use reversible encryption instead of bcrypt, (5) no offline mode, and (6) the Flutter package name is still "untitled" and needs to be changed for app store submission.

**Q14: How does the interest-based content discovery work?**
A: Each user selects up to 5 interests during onboarding. Posts, reels, and rooms are tagged with interest IDs. The feed and explore screens use these interest IDs to filter and prioritize content. The `fetchInterests` API returns all available interests, and the `searchPostByInterestId` and `searchReelsByInterestId` endpoints filter content by interest.

**Q15: How does the multi-campus support work?**
A: The `campus` field in the `users` table stores the user's campus (one of 7 options: Islamabad, Lahore, Abbottabad, Wah, Attock, Sahiwal, Vehari). The registration form has a campus dropdown. Currently, campus is stored as metadata — campus-specific feeds and filtering are planned as future enhancements.

**Q16: What is the role of GetX in the Flutter app?**
A: GetX serves three purposes: (1) state management — controllers extend `GetxController` and use reactive variables; (2) navigation — `Get.to()`, `Get.offAll()` for screen transitions without BuildContext; (3) utilities — `Get.snackbar()` for notifications, `GetPlatform.isIOS` for platform detection, `GetUtils.isEmail()` for validation.

**Q17: How does session management work in Flutter?**
A: `SessionManager` uses `GetStorage` (a lightweight key-value store) to persist the user object and login state across app restarts. On login, `setUser(user)` serializes the User object to JSON and writes it to storage. On app launch, `getUser()` deserializes it back. `clear()` erases all stored data on logout.

**Q18: How are push notifications implemented?**
A: Firebase Cloud Messaging (FCM) is used. Each device's FCM token is stored in the `device_token` column of the `users` table. The backend sends notifications using the Google API Client library. The Flutter app registers for notifications via `FirebaseNotificationManager`, subscribes to the "chatter" topic for broadcast notifications, and handles both foreground and background messages.

**Q19: What happens when a user is blocked by an admin?**
A: The `is_block` field in the `users` table is set to 1. On the next login attempt, the API returns an error. If the user is already logged in, the splash screen checks `is_block` on every app launch and redirects to `BlockedByAdminScreen` if blocked. The user cannot access any app features while blocked.

**Q20: How would you scale CUICHAT for a larger user base?**
A: Several improvements would be needed: (1) migrate from shared hosting to a VPS or cloud provider (AWS/DigitalOcean); (2) implement per-user JWT authentication with Laravel Sanctum; (3) add a Redis cache layer for frequently accessed data; (4) configure a queue worker for async jobs; (5) add a CDN for media file delivery; (6) implement database read replicas for heavy read workloads; (7) replace comma-separated IDs with proper junction tables.

---

## Key Talking Points

- **Unique value proposition:** CUICHAT is not just another social app — it's specifically designed for the COMSATS community with verified identity and admin oversight.
- **Technical depth:** The CUI registration flow involves 3 API calls, phone OTP verification, SHA-256 hashing, and a multi-state approval workflow.
- **Real deployment:** The backend is live at cuichat.online — this is not just a prototype.
- **Honest limitations:** Acknowledge the known issues (static API key, no OTP rate limiting) and explain the planned fixes. This shows maturity and self-awareness.
- **Architecture decisions:** Be ready to explain why Firebase was chosen for chat (real-time without WebSockets), why Agora for audio (purpose-built SDK), and why Hostinger (cost-effective for a student project).

---

## Architecture Explanation (for whiteboard)

```
[Flutter App] ←→ [Laravel API] ←→ [MySQL DB]
      ↕                ↕
[Firebase]      [File Storage]
  - Auth
  - Firestore (chat)
  - FCM (notifications)
      ↕
[Agora RTC]
  - Audio rooms
```

The Flutter app is the only client. The admin panel is a separate web interface served by the same Laravel backend. Firebase handles real-time features that would be complex to build from scratch. Agora handles audio streaming. Everything else goes through the Laravel REST API.

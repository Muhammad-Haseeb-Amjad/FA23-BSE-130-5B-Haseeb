# CUICHAT — Authentication and Approval Flow

## 1. Admin Web Authentication Flow

```
Browser → GET /
    │
    └─ LoginController.login()
            ├─ If session has 'user_name' → redirect to /dashboard
            └─ Else → return view('login')

Browser → POST /loginForm { user_name, user_password }
    │
    └─ LoginController.checklogin()
            ├─ Find Admin by user_name
            ├─ Try Crypt::decrypt(stored_password) → compare with input
            ├─ Fallback: compare plain text (for SQL-imported passwords)
            │       └─ If plain text matches → auto-upgrade to encrypted
            ├─ On match:
            │       ├─ Session::put('user_name', ...)
            │       ├─ Session::put('user_type', ...)
            │       └─ Return JSON { status: true, data: admin }
            └─ On fail → Return JSON { status: false, message: 'Wrong credentials.' }

All protected routes → CheckLogin middleware
    │
    └─ If Session::get('user_name') exists → allow request
       Else → redirect to /
```

---

## 2. Social Login Flow (Google / Apple / Email)

```
Flutter App (LoginController)
    │
    ├─ Google: GoogleSignIn.instance.authenticate()
    │       └─ Gets email + displayName
    │
    ├─ Apple: SignInWithApple.getAppleIDCredential()
    │       └─ Gets userIdentifier + givenName + familyName
    │
    └─ Email: Bottom sheet → user enters name + email
    │
    ▼
FirebaseNotificationManager.getNotificationToken(token)
    │
    ▼
UserService.registration(identity, loginType, deviceToken, fullName)
    │
    └─ POST /api/addUser
            {
              identity: "user@email.com",
              full_name: "Ali Hassan",
              login_type: 0|1|2,
              device_type: 0|1,
              device_token: "fcm_token"
            }
    │
    ▼
Backend (UserController.addUser)
    │
    ├─ Find user by identity
    ├─ If not found → create new user with approval_status = 'approved'
    ├─ If found → update device_token
    └─ Return user object
    │
    ▼
Flutter App
    │
    ├─ Check approvalStatus:
    │       ├─ 'pending' → show error, stop
    │       ├─ 'rejected' → show error, stop
    │       └─ 'approved' → continue
    │
    ├─ SessionManager.setUser(user)
    ├─ SessionManager.setLogin(true)
    │
    └─ Navigate based on profile completeness:
            isBlock=1 → BlockedByAdminScreen
            no interests → InterestScreen
            no username → UserNameScreen
            no profile photo → ProfilePictureScreen
            complete → TabBarScreen
```

---

## 3. CUI Student Registration Flow (7 Steps)

```
Step 1: User opens CuiRegistrationScreen
    │
    ├─ Selects role: Student
    ├─ Fills: Full Name, Registration Number, Email, Department,
    │         Phone, Gender, Password, Confirm Password,
    │         Batch Duration, Campus
    └─ Taps "Register" button

Step 2: Client-side validation
    │
    ├─ Phone: must match ^(03\d{9}|\+923\d{9})$
    ├─ Registration number: must match ^[A-Z]{2}\d{2}-[A-Z]{2,5}-\d{1,4}(-[A-Z])?$
    ├─ Batch duration: must match ^[A-Z]{2}\d{2}-[A-Z]{2}\d{2}$
    ├─ Password: min 6 characters
    └─ All required fields non-empty

Step 3: POST /api/sendRegisterOtp { phone_number: "03xxxxxxxxx" }
    │
    Backend:
    ├─ Normalize phone (strip +92 prefix if present)
    ├─ Check phone not already registered in users table
    ├─ Generate 6-digit OTP
    ├─ Hash OTP with SHA-256
    ├─ Store in registration_otps (updateOrCreate)
    ├─ Attempt SMS via configured provider (Twilio/Vonage)
    └─ If APP_DEBUG=true → return OTP in response
    │
    Flutter:
    └─ Navigate to RegisterOtpScreen (pass formData + debug OTP)

Step 4: User enters OTP in RegisterOtpScreen
    │
    ├─ 45-second countdown before resend allowed
    ├─ Debug banner shows OTP if in debug mode
    └─ Taps "Verify"

Step 5: POST /api/verifyRegisterOtp { phone_number, otp }
    │
    Backend:
    ├─ Find registration_otps record by phone_number
    ├─ Check not already consumed
    ├─ Check not expired (10-minute window)
    ├─ Compare SHA-256(input_otp) with stored hash
    ├─ Set verified_at = now()
    └─ Return { status: true, message: "Phone number verified" }

Step 6: POST /api/register { all form fields }
    │
    Backend:
    ├─ Validate all fields (role_type, email unique, phone unique, etc.)
    ├─ Check registration_otps.verified_at is set
    ├─ Check registration_otps.consumed_at is null
    ├─ Create User with approval_status = 'pending'
    ├─ Set registration_otps.consumed_at = now()
    └─ Return { status: true, data: user }
    │
    Flutter:
    └─ Navigate to RegistrationPendingScreen

Step 7: Admin reviews and approves
    │
    Admin Panel → /registrationRequests → Pending tab
    ├─ Admin clicks "View" to see full details
    ├─ Admin clicks "Approve"
    │       └─ POST /approveRegistrationRequest/{id}
    │               ├─ approval_status = 'approved'
    │               ├─ approved_at = now()
    │               ├─ approved_by = admin_id
    │               └─ Send approval email to user
    └─ User can now login via POST /api/cuiLogin
```

---

## 4. CUI Faculty Registration Flow

Same as student flow with these differences:
- No `registration_number` field
- No `batch_duration` field
- `role_type = 'faculty'`
- Backend sets `registration_number = null` and `batch_duration = null`

---

## 5. Approval Status State Machine

```
                    ┌─────────────┐
                    │   pending   │◄──── Initial state after /api/register
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌───────────┐
        │ approved │ │ rejected │ │ cancelled │
        └──────────┘ └──────────┘ └───────────┘
              │
              │ (user can login)
              ▼
        ┌──────────┐
        │  active  │ (no separate status — just approved + not blocked)
        └──────────┘
```

**State transitions:**
| From | To | Trigger | Email sent |
|------|----|---------|------------|
| pending | approved | Admin clicks Approve | Yes (approval email) |
| pending | rejected | Admin clicks Reject + reason | Yes (rejection email with reason) |
| pending | cancelled | Admin clicks Cancel | No |
| rejected | (no transition) | — | — |
| cancelled | (no transition) | — | — |

**Login behavior by status:**
| Status | cuiLogin result |
|--------|----------------|
| approved | Success — user enters app |
| pending | `{ status: false, message: "Your account is pending admin approval." }` |
| rejected | `{ status: false, message: "Your registration request was rejected." }` |
| cancelled | `{ status: false, message: "Your registration request was cancelled." }` |

---

## 6. Login Restriction Logic

### CUI Login (`POST /api/cuiLogin`)
```php
// Backend checks:
1. Find user by email
2. Verify password with Hash::check()
3. Check approval_status:
   - 'pending'   → return error
   - 'rejected'  → return error
   - 'cancelled' → return error
   - 'approved'  → continue
4. Check is_block:
   - 1 → return error (blocked by admin)
5. Update device_token
6. Return user object
```

### Social Login (`POST /api/addUser`)
```php
// Backend checks:
1. Find or create user by identity
2. Check approval_status (same as above)
3. Check is_block
4. Return user object
```

### Flutter-side check (LoginController)
```dart
final approvalStatus = (user?.approvalStatus ?? 'approved').toLowerCase();
if (approvalStatus != 'approved') {
  // Show error snackbar
  return;
}
if (user?.isBlock == 1) {
  // Navigate to BlockedByAdminScreen
}
```

---

## 7. Session Persistence (GetStorage)

The Flutter app uses `GetStorage` for persistent session storage. Data survives app restarts.

**Stored keys:**
| Key | Type | Description |
|-----|------|-------------|
| `isLogin` | bool | Whether user is logged in |
| `user` | Map | Serialized User object (via `toJson()`) |
| `setting` | Map | Serialized Settings object |
| `lang` | String | Selected language code |

**Session lifecycle:**
- **Set on login:** `SessionManager.setUser(user)` + `SessionManager.setLogin(true)`
- **Read on splash:** `SessionManager.isLogin()` + `SessionManager.getUser()`
- **Updated on profile fetch:** `SessionManager.setUser(freshUser)` (splash + profile edits)
- **Cleared on logout:** `SessionManager.clear()` → `GetStorage.erase()`

---

## 8. Splash Screen Navigation Logic

```dart
Widget gotoView() {
  if (SessionManager.shared.isLogin()) {
    var user = SessionManager.shared.getUser();
    
    if (user?.isBlock == 1) {
      return const BlockedByAdminScreen();
    } else if (user?.interestIds == null || user!.interestIds!.trim().isEmpty) {
      return InterestScreen();
    } else if (user?.username == null || user!.username!.trim().isEmpty) {
      return const UserNameScreen();
    } else if (user?.profile == null || user!.profile!.trim().isEmpty) {
      return const ProfilePictureScreen();
    } else {
      return TabBarScreen();
    }
  }
  return const OnBoardingScreen();
}
```

**Before navigation**, the splash controller:
1. Fetches fresh user profile from API (falls back to cached data on network error)
2. Fetches global settings (interests, AdMob IDs, etc.)
3. Then calls `gotoView()` to determine destination

This ensures the user's latest `approval_status` and `is_block` state are always checked on app launch.

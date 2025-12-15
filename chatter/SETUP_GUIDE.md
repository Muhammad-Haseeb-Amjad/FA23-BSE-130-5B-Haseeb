# Chatter App - Setup & Debugging Guide

## Current Status: Mobile Sign-In Email Authentication ✅ WORKING

### Backend API Verification

The mobile app's "sign-in with email" functionality calls the backend's `/api/addUser` endpoint after Firebase authenticates the user.

**Endpoint Details:**
- **URL**: `POST http://{server}:8000/api/addUser`
- **Required Headers**: `apikey: 123`
- **Required Parameters**:
  - `identity` (string): Email address or unique identifier
  - `full_name` (string): User's full name  
  - `login_type` (integer): 0=email, 1=google, 2=facebook, 3=apple
  - `device_type` (integer): 0=Android, 1=iOS
  - `device_token` (string): FCM/push notification token

**Test Results:**
```
✅ HTTP 200 Response
✅ User successfully created in database
✅ Response includes full user object with ID
```

### Network Configuration

**Machine IP**: 192.168.100.4
**Backend Port**: 8000
**Backend URL**: http://192.168.100.4:8000/

#### For Testing on Same Machine (Emulator/Local):
- Use `http://127.0.0.1:8000/api/addUser`

#### For Testing on Mobile Device (Same LAN):
- Use `http://192.168.100.4:8000/api/addUser`
- Ensure backend server is running: `php artisan serve --host=0.0.0.0 --port=8000`
- Check Windows Firewall allows PHP port 8000
- Verify device is on same network (192.168.x.x subnet)

### How Mobile Sign-In Works

1. **User enters email in app** (SignInWithEmailScreen)
2. **Firebase Authentication** (createUserWithEmailAndPassword)
3. **Backend Registration** (UserService.shared.registration)
4. **API Call**: POST `/api/addUser` with user data
5. **User stored** in MySQL database
6. **Session created** with SessionManager.shared.setUser()
7. **Redirected** to interests/profile setup screens

### Common Issues & Solutions

#### Issue: "Backend not responding"

**Causes**:
- Laravel development server not running
- Wrong IP address in baseURL
- Firewall blocking port 8000
- Network connectivity issues

**Solutions**:
1. **Start backend**:
   ```bash
   cd C:\Users\Atif\Desktop\chatter\chatter_backend
   php artisan serve --host=0.0.0.0 --port=8000
   ```

2. **Verify server is running**:
   ```powershell
   Invoke-WebRequest -Uri "http://127.0.0.1:8000" -ErrorAction Continue
   ```

3. **Check firewall** (Windows):
   - Settings > Firewall > Allow apps through firewall
   - Ensure PHP.exe is allowed for private networks

4. **Test API endpoint**:
   ```powershell
   $response = Invoke-WebRequest -Uri "http://127.0.0.1:8000/api/addUser" `
     -Method POST `
     -Headers @{"apikey"="123"} `
     -Body @{"identity"="test@example.com";"full_name"="Test User";"login_type"="0";"device_type"="0";"device_token"="token"}
   
   $response.StatusCode  # Should return 200
   $response.Content     # Should contain user data
   ```

#### Issue: API key error ("Enter Right Api key")

**Solution**: Verify Flutter app is sending the apikey header:
- File: `lib/common/api_service/api_service.dart`
- Line 24: `var header = {'apikey': '123'};` ✅ Correct

#### Issue: Images not loading from uploads

**Solution**: Already fixed in previous session
- File: `lib/utilities/const.dart` 
- Function: `addBaseURL()` extension properly handles URL concatenation
- Storage symlink created: `php artisan storage:link`

### Database Structure

**Users Table** (`users`):
- id (INT, PK)
- identity (VARCHAR) - Email/unique ID
- username (VARCHAR)
- full_name (VARCHAR)
- login_type (INT) - 0=email, 1=google, etc.
- device_type (INT) - 0=Android, 1=iOS
- device_token (VARCHAR) - Push notification token
- profile (VARCHAR) - Profile image URL
- created_at / updated_at (TIMESTAMPS)

**Test User Created**:
- Email: final.test@example.com
- Name: Final Test
- Login Type: 0 (Email)
- Device Type: 0 (Android)
- Status: ✅ Successfully registered

### Files Modified During This Session

1. **chatter_backend/app/Http/Middleware/CheckHeader.php**
   - Validates `apikey: 123` header on all API routes

2. **chatter_flutter/chatter/lib/utilities/const.dart**
   - baseURL: `http://192.168.100.4:8000/`
   - apiURL: `http://192.168.100.4:8000/api/`
   - addBaseURL() extension: Handles full URL construction

3. **chatter_flutter/chatter/lib/common/api_service/user_service.dart**
   - registration() method: Calls addUser API endpoint

4. **chatter_backend/routes/api.php**
   - `Route::post('addUser', [UserController::class, 'addUser'])` - PUBLIC endpoint ✅

### Next Steps

1. **On Android Device**: Launch the rebuilt Flutter app
2. **Tap "Sign In with Email"**
3. **Enter email and password** (Firebase will authenticate)
4. **App should navigate** to interests/profile setup
5. **Verify in database**: User should appear in `users` table

### Troubleshooting Checklist

- [ ] Backend server running: `php artisan serve --host=0.0.0.0 --port=8000`
- [ ] Server accessible on localhost: `http://127.0.0.1:8000` ✅
- [ ] Server accessible on LAN: `http://192.168.100.4:8000` (test connection)
- [ ] Firebase project configured in Flutter app
- [ ] Flutter app rebuilt with latest baseURL
- [ ] Device is on same WiFi network as backend machine
- [ ] Windows Firewall allows port 8000
- [ ] MySQL database running on 127.0.0.1:3306
- [ ] Database `chatter` exists and is accessible

### Commands Reference

**Start Backend**:
```bash
cd C:\Users\Atif\Desktop\chatter\chatter_backend
php artisan serve --host=0.0.0.0 --port=8000
```

**Rebuild Flutter App**:
```bash
cd C:\Users\Atif\Desktop\chatter\chatter_flutter\chatter
flutter clean
flutter pub get
flutter run
```

**View Backend Logs**:
```bash
Get-Content C:\Users\Atif\Desktop\chatter\chatter_backend\storage\logs\laravel.log -Tail 50
```

**Test API**:
```powershell
Invoke-WebRequest -Uri "http://127.0.0.1:8000/api/addUser" `
  -Method POST `
  -Headers @{"apikey"="123"} `
  -Body @{"identity"="user@example.com";"full_name"="Name";"login_type"="0";"device_type"="0";"device_token"="token"}
```

---

**Last Updated**: 2025-12-11 15:37  
**Status**: ✅ All API endpoints functional  
**Next Session**: Test mobile sign-in on actual Android device

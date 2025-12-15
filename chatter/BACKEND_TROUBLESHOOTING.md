# Backend Server Not Responding - Troubleshooting Guide

## Issue
Android app shows "Backend not responding" when trying to sign in with email.

## Root Cause Analysis
The Laravel development server on Windows is not properly binding to the network interface, making it inaccessible from the Android device on the LAN.

## Solution

### Step 1: Start the Backend Server
Double-click the batch file to start the server:
```
C:\Users\Atif\Desktop\chatter\chatter_backend\start_server.bat
```

OR manually run:
```bash
cd C:\Users\Atif\Desktop\chatter\chatter_backend
php artisan serve --host=0.0.0.0 --port=8888
```

The server should show:
```
INFO  Server running on [http://0.0.0.0:8888].
```

### Step 2: Verify Backend URL in Flutter App
The app's backend URL has been updated to:
```
http://192.168.100.4:8888/
```

File: `lib/utilities/const.dart` (Line 7)

### Step 3: Rebuild & Run Flutter App
```bash
cd C:\Users\Atif\Desktop\chatter\chatter_flutter\chatter
flutter clean
flutter pub get
flutter run
```

### Step 4: Test Sign-In
1. Open the app
2. Tap "Sign In With Email"
3. Enter email: `muhammadhasee bamjad90@gmail.com`
4. Enter password
5. Tap "Continue"

Expected: App should authenticate with Firebase and register with backend, then navigate to interests screen.

## If Still Not Working

### Check 1: Network Connectivity
**From Android Device**:
1. Open browser on phone
2. Try: `http://192.168.100.4:8888`
3. Should see Laravel app or error page

### Check 2: Windows Firewall
On Windows machine:
1. Go to: Settings > Firewall & network protection
2. Click "Allow an app through firewall"
3. Look for "PHP" or "php.exe"
4. Check both "Private networks" and "Public networks"
5. If not found, click "Allow another app" > Browse > Find `php.exe` > Add it

### Check 3: Port in Use
```powershell
netstat -ano | Select-String "8888"
```

If port is in use, try a different port (8889, 9000, etc.) and update Flutter's `const.dart`

### Check 4: Firewall Rule (Admin Required)
```powershell
# Run as Administrator:
netsh advfirewall firewall add rule name="PHP 8888" dir=in action=allow protocol=tcp localport=8888
netsh advfirewall firewall add rule name="PHP 8888 Out" dir=out action=allow protocol=tcp localport=8888
```

### Check 5: Antivirus Software
Some antivirus software blocks PHP from binding to ports. Temporarily disable antivirus to test.

## Backend URL Change History

| Port | Host | Status | Notes |
|------|------|--------|-------|
| 8000 | 192.168.100.4 | ❌ Not binding | Windows dev server issue |
| 8000 | 0.0.0.0 | ❌ Not binding | Same issue |
| 8000 | 127.0.0.1 | ❌ Local only | Can't reach from Android |
| 8888 | 0.0.0.0 | ⏳ Testing | Current: Changed port to avoid conflicts |

## API Endpoint Status
**Endpoint**: `POST /api/addUser`
**Status**: ✅ Working (tested on localhost)
**Response**: Creates user in database and returns HTTP 200

## Database
**Host**: 127.0.0.1:3306
**Database**: chatter
**Table**: users
**Status**: ✅ Connected

## File Changes This Session
1. `chatter_flutter/chatter/lib/utilities/const.dart` - Updated baseURL to port 8888
2. `.env` - Updated APP_URL
3. `start_server.bat` - Created batch file for easy server startup

## Next Steps
1. Ensure both machine and phone are on same WiFi network
2. Start the server using the batch file
3. Rebuild Flutter app
4. Test sign-in from Android device
5. If successful, we can switch to a production setup (Apache + PHP or Docker)

---

**Server Status**: Ready at `http://192.168.100.4:8888/`  
**Last Updated**: 2025-12-11 20:58  
**Issue**: Network binding on Windows - workaround in progress

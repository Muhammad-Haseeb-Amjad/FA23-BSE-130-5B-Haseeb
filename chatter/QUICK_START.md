# BACKEND SETUP - QUICK START GUIDE

## Current Status
- ✅ Laravel Backend: Ready
- ✅ API Endpoints: Working  
- ✅ Database: Connected
- ⚠️ Network Binding: Issue on Windows (workaround applied)

## TO FIX SIGN-IN ERROR

### 1️⃣ Start the Backend Server

**Easy Way** (Recommended):
- Double-click: `C:\Users\Atif\Desktop\chatter\chatter_backend\start_server.bat`
- A command window will appear showing the server is running
- **Leave this window open** while testing the app

**Manual Way**:
```bash
cd C:\Users\Atif\Desktop\chatter\chatter_backend
php artisan serve --host=0.0.0.0 --port=8888
```

### 2️⃣ Rebuild the Flutter App
The backend URL has been automatically updated to `http://192.168.100.4:8888/`

```bash
cd C:\Users\Atif\Desktop\chatter\chatter_flutter\chatter
flutter clean
flutter pub get
flutter run
```

Or use VS Code:
- Open the project
- Run > Start Debugging (F5)

### 3️⃣ Test Sign-In on Your Android Device
1. Open the Chatter app
2. Tap **"Sign In With Email"**
3. Enter your email and password
4. Tap **"Continue"**
5. App should authenticate and show Interests selection screen

## ✅ If It Works
Great! The app is now connected to the backend. You can continue with feature development.

## ❌ If It Still Shows "Backend not responding"

### Verify the Server is Running
In a separate PowerShell window:
```powershell
# Test if server is listening
netstat -ano | Select-String "8888"

# Test API directly from Windows PC
Invoke-WebRequest -Uri "http://localhost:8888/api/addUser" `
  -Method POST `
  -Headers @{"apikey"="123"} `
  -Body @{"identity"="test@test.com";"full_name"="Test";"login_type"="0";"device_type"="0";"device_token"="token"}
```

### Check Network Connection
On your Android device:
1. Open web browser
2. Go to: `http://192.168.100.4:8888`
3. Should see Laravel app or an error page
4. If page doesn't load, network/firewall is blocking it

### Fix Windows Firewall
**If on domain network**:
1. Settings > Firewall & network protection > Advanced settings
2. Inbound Rules > New Rule...
3. Rule Type: Port
4. TCP, Port 8888
5. Action: Allow
6. Apply to: All profiles

**If antivirus is blocking**:
- Temporarily disable antivirus software to test
- Check antivirus firewall settings separately

### Try Different Port
If 8888 is already in use:
1. Edit: `lib/utilities/const.dart` (line 7)
2. Change port: `http://192.168.100.4:9000/`
3. Start server on same port: `php artisan serve --host=0.0.0.0 --port=9000`
4. Rebuild app and test

##  Files Modified
| File | Change |
|------|--------|
| `lib/utilities/const.dart` | Updated baseURL to `192.168.100.4:8888` |
| `.env` | Updated APP_URL |
| Created `start_server.bat` | Easy server startup |

## Troubleshooting Checklist
- [ ] Backend server started (command window showing "Server running")
- [ ] Flutter app rebuilt with `flutter clean` && `flutter pub get`
- [ ] Android device on same WiFi as PC (both 192.168.x.x)
- [ ] Windows Firewall allows port 8888
- [ ] No antivirus/security software blocking PHP
- [ ] Tried accessing `http://192.168.100.4:8888` from phone browser

## API Details
- **Base URL**: `http://192.168.100.4:8888/api/`
- **Sign-In Endpoint**: `/addUser` (POST)
- **Required Header**: `apikey: 123`
- **Response**: HTTP 200 + User data (JSON)

## Server Log
The server window will show requests as you test. Look for entries like:
```
[11/Dec/2025 21:00:00] "POST /api/addUser HTTP/1.1" 200 -
```

## When Signing In
The flow is:
1. Email + Password entered in app
2. Firebase authentication (cloud)
3. Backend creates user record
4. App stores session locally
5. Navigate to interests screen

If it fails at step 3, the "Backend not responding" error appears.

---

**Need Help?** Check BACKEND_TROUBLESHOOTING.md for advanced debugging steps.

## Mobile Sign-In API Testing - Quick Reference

### ✅ Current Status
- **Backend**: Running at `http://0.0.0.0:8000`
- **API Endpoint**: `POST /api/addUser` - **WORKING**
- **Test Result**: HTTP 200 - User successfully created
- **Database**: Users table receiving new records

### Quick Test (PowerShell)

```powershell
# Test the addUser API endpoint
$response = Invoke-WebRequest -Uri "http://127.0.0.1:8000/api/addUser" `
  -Method POST `
  -Headers @{"apikey"="123"} `
  -Body @{
    "identity"="test@example.com"
    "full_name"="Test User"
    "login_type"="0"
    "device_type"="0"
    "device_token"="test_device_token"
  }

# Check status
Write-Host "Status Code: $($response.StatusCode)"

# Parse and display response
$json = $response.Content | ConvertFrom-Json
Write-Host "Success: $($json.status)"
Write-Host "Message: $($json.message)"
Write-Host "User ID: $($json.data.id)"
Write-Host "Email: $($json.data.identity)"
```

### Expected Response
```json
{
  "status": true,
  "message": "User Added succesfully",
  "data": {
    "id": 4,
    "identity": "test@example.com",
    "full_name": "Test User",
    "login_type": 0,
    "device_type": 0,
    "device_token": "test_device_token",
    "created_at": "2025-12-11T15:37:56.000000Z",
    ...
  }
}
```

### What This Means for Mobile App

When user signs in with email:
1. ✅ Firebase authenticates the email/password
2. ✅ App calls `/api/addUser` endpoint
3. ✅ Backend creates user record in database
4. ✅ App stores user session locally
5. ✅ User navigates to interests/profile setup

### If Testing on Actual Device

If the app is on a physical Android device:

1. **Ensure device is on same WiFi** as backend machine
2. **Update Flutter baseURL if needed**:
   - File: `lib/utilities/const.dart`
   - Line 7: Change IP from `192.168.100.4` to your actual machine IP
3. **Check Windows Firewall**:
   - Settings > Firewall & network protection
   - Advanced settings > Inbound Rules
   - Allow PHP port 8000 for private networks
4. **Verify connectivity**:
   ```powershell
   # From device (ping might not work if blocked, but HTTP should)
   # Try accessing from browser: http://192.168.100.4:8000
   ```

### All Created Test Users
- test.user@example.com (ID: 3)
- test.user2@example.com (ID: 4)  
- test.user3@example.com (ID: 5)
- test@test.com (ID: 6)
- final.test@example.com (ID: 7)

All successfully registered in the `users` table!

### Command to Keep Backend Running (Persistent)

Create a batch file for easy startup:

**File: `start_backend.bat`**
```batch
@echo off
cd /d "C:\Users\Atif\Desktop\chatter\chatter_backend"
php artisan serve --host=0.0.0.0 --port=8000
pause
```

Double-click to start. Backend will run until you press a key or close the window.

---

**Session**: Mobile Sign-In API Fix
**Date**: 2025-12-11
**Status**: ✅ RESOLVED

# Google Drive Backup - Setup Guide

## مسئلہ
جب آپ "Backup to Google Drive" پر کلک کرتے ہیں تو **"Backup failed - Sign in to Google required"** error آتا ہے۔

## حل (Step by Step)

### ⚠️ اہم: یہ error اس لیے آ رہا ہے کیونکہ:
1. Firebase/Google Console میں OAuth client ID ٹھیک سے configure نہیں ہے
2. SHA-1 fingerprint add نہیں ہے
3. Google Sign-In properly setup نہیں ہے

---

## 🔧 Solution Steps

### Step 1: SHA-1 Fingerprint نکالیں

#### **Debug SHA-1** (Testing کے لیے):
```powershell
cd android
.\gradlew signingReport
```

**یا directly:**
```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

#### **Release SHA-1** (Production کے لیے):
```powershell
keytool -list -v -keystore "path\to\your\release.keystore" -alias your_alias
```

**Output میں آپ کو یہ ملے گا:**
```
SHA1: AA:BB:CC:DD:EE:FF:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE
```

---

### Step 2: Firebase Console میں SHA-1 Add کریں

1. **Firebase Console** کھولیں: https://console.firebase.google.com/
2. اپنا project select کریں
3. **Project Settings** (⚙️ gear icon) > **General** tab
4. نیچے scroll کریں "Your apps" section میں
5. اپنے Android app پر کلک کریں
6. **"Add fingerprint"** button پر کلک کریں
7. SHA-1 fingerprint paste کریں
8. **Save** کریں

**ضروری:** Debug اور Release دونوں SHA-1 add کریں!

---

### Step 3: OAuth 2.0 Client ID Create کریں

1. **Google Cloud Console** میں جائیں: https://console.cloud.google.com/
2. اپنا Firebase project select کریں
3. Left menu میں **"APIs & Services"** > **"Credentials"** پر کلک کریں
4. **"+ CREATE CREDENTIALS"** > **"OAuth client ID"** select کریں
5. Application type: **"Android"** select کریں
6. Name: `Bread Box Android` (کوئی بھی نام)
7. **Package name:** `com.example.pos_backers` (یہ آپ کی app کا package name ہے)
8. **SHA-1 certificate fingerprint:** آپ کا SHA-1 paste کریں
9. **Create** button دبائیں

---

### Step 4: google-services.json Update کریں

1. Firebase Console میں واپس جائیں
2. **Project Settings** > **General** > **Your apps**
3. Android app میں **"google-services.json"** download کریں
4. نئی downloaded file کو یہاں replace کریں:
   ```
   android/app/google-services.json
   ```

---

### Step 5: Google Drive API Enable کریں

1. Google Cloud Console میں جائیں
2. **"APIs & Services"** > **"Library"**
3. **"Google Drive API"** search کریں
4. **ENABLE** کریں

---

### Step 6: App Clean Build کریں

Terminal میں یہ commands چلائیں:

```powershell
# Clean کریں
flutter clean

# Dependencies install کریں
flutter pub get

# Build کریں (debug)
flutter build apk --debug

# یا run کریں
flutter run
```

---

## ✅ Testing

1. App کھولیں
2. Settings > Backup & Restore
3. **"Backup Now"** button دبائیں
4. Google Sign-In dialog آنی چاہیے
5. Account select کریں
6. "Allow" permissions کریں
7. Backup successfully complete ہونا چاہیے!

---

## 🚨 Common Issues & Solutions

### Issue 1: "DEVELOPER_ERROR" یا "Error 10"
**حل:** SHA-1 fingerprint غلط ہے یا Firebase/Google Console میں ٹھیک سے add نہیں ہے۔
- دوبارہ SHA-1 نکالیں
- Firebase Console میں correctly add کریں
- google-services.json update کریں
- App rebuild کریں

### Issue 2: "Sign in failed" یا "Network error"
**حل:**
- Internet connection check کریں
- Google Play Services updated ہے check کریں
- Device date/time correct ہے check کریں

### Issue 3: Sign-In dialog نہیں آتی
**حل:**
- App permissions check کریں (Settings > Apps > Bread Box)
- Google Play Services clear cache کریں
- Device restart کریں

---

## 📱 Package Name Check کریں

آپ کی app کا package name یہ ہونا چاہیے:

**File:** `android/app/build.gradle.kts`
```kotlin
namespace = "com.example.pos_backers"
```

**یا** `android/app/src/main/AndroidManifest.xml` میں:
```xml
package="com.example.pos_backers"
```

⚠️ **یہ package name Google Cloud Console میں OAuth client بناتے وقت use کریں!**

---

## 🔍 Debug Logging

اگر problem solve نہیں ہو رہی، تو terminal میں detailed logs دیکھیں:

```powershell
flutter run --verbose
```

جب backup button دبائیں تو errors console میں آئیں گی۔

---

## 📞 Support

اگر پھر بھی issue ہے تو:
1. Terminal کی error logs share کریں
2. Firebase Console settings screenshot
3. Google Cloud Console OAuth settings screenshot

---

**Last Updated:** 2 January 2026

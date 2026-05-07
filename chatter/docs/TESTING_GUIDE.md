# CUICHAT — Testing Guide

## Overview

This guide provides a comprehensive testing checklist for the CUICHAT platform. Each test case includes the expected result and a pass/fail column for manual testing sessions.

---

## 1. Admin Panel Tests

| # | Test Case | Steps | Expected Result | Pass/Fail |
|---|-----------|-------|-----------------|-----------|
| AP-01 | Admin login with valid credentials | Navigate to `/`, enter correct username and password | Redirected to `/dashboard` | |
| AP-02 | Admin login with invalid credentials | Enter wrong password | Error message "Wrong credentials." shown | |
| AP-03 | Admin session persistence | Login, close browser tab, reopen `/dashboard` | Redirected to login (session expired) | |
| AP-04 | Admin logout | Click logout button | Session cleared, redirected to `/` | |
| AP-05 | View all users | Navigate to `/users` | DataTable loads with user list, search works | |
| AP-06 | Block a user | Click Block button on a user | User's `is_block` set to 1, button changes to Unblock | |
| AP-07 | Unblock a user | Click Unblock on a blocked user | User's `is_block` set to 0 | |
| AP-08 | Toggle moderator status | Click moderator toggle on a user | `is_moderator` toggled, change persists on refresh | |
| AP-09 | View registration requests | Navigate to `/registrationRequests` | 4 tabs shown with correct counts | |
| AP-10 | Approve a pending registration | Click Approve on a pending request | Status changes to approved, approval email sent | |
| AP-11 | Reject a registration with reason | Click Reject, enter reason, confirm | Status changes to rejected, rejection email sent | |
| AP-12 | Reject without reason | Click Reject, leave reason empty | Validation error shown, rejection not processed | |
| AP-13 | Cancel a registration | Click Cancel on a pending request | Status changes to cancelled | |
| AP-14 | View registration details | Click View on any registration | Modal shows all user details (name, email, phone, department, etc.) | |
| AP-15 | Search registration requests | Type in search box on registrationRequests | Table filters by name, email, phone, or registration number | |
| AP-16 | Delete a post | Navigate to `/viewPosts`, click Delete | Post removed from database and feed | |
| AP-17 | Add an interest | Navigate to `/interests`, add new interest with image | Interest appears in list and in app | |
| AP-18 | Send platform notification | Navigate to `/notification`, compose and send | All users receive push notification | |
| AP-19 | Update app settings | Navigate to `/setting`, change app name | New name reflected in API response | |
| AP-20 | Forgot password reset | Use forgot password form with correct DB credentials | Admin password updated successfully | |

---

## 2. Flutter App Tests

| # | Test Case | Steps | Expected Result | Pass/Fail |
|---|-----------|-------|-----------------|-----------|
| FA-01 | App launch (not logged in) | Fresh install, open app | Splash screen → OnBoardingScreen | |
| FA-02 | App launch (logged in) | Login, close app, reopen | Splash screen → TabBarScreen (skips login) | |
| FA-03 | Google Sign-In | Tap Google button on login screen | Google account picker opens, login completes | |
| FA-04 | Apple Sign-In (iOS only) | Tap Apple button | Apple auth sheet opens, login completes | |
| FA-05 | CUI Registration — Student | Fill all student fields correctly, tap Register | OTP screen shown | |
| FA-06 | CUI Registration — invalid reg number | Enter "abc123" as registration number | Validation error shown, Register button disabled | |
| FA-07 | CUI Registration — invalid phone | Enter "12345" as phone | Validation error shown | |
| FA-08 | OTP verification — correct OTP | Enter correct 6-digit OTP | Registration submitted, RegistrationPendingScreen shown | |
| FA-09 | OTP verification — wrong OTP | Enter incorrect OTP | Error "Invalid OTP" shown | |
| FA-10 | OTP resend | Wait 45 seconds, tap Resend | New OTP sent, timer resets | |
| FA-11 | CUI Login — approved user | Enter correct email + password | Login succeeds, user enters app | |
| FA-12 | CUI Login — pending user | Login with pending account | Error "Your account is pending admin approval." | |
| FA-13 | CUI Login — rejected user | Login with rejected account | Error "Your registration request was rejected." | |
| FA-14 | Blocked user login | Login with blocked account | BlockedByAdminScreen shown | |
| FA-15 | Create a post | Tap add post, select image, add caption, post | Post appears in feed | |
| FA-16 | Like a post | Tap like button on a post | Like count increments, button state changes | |
| FA-17 | Comment on a post | Tap comment, type text, submit | Comment appears in comment list | |
| FA-18 | Follow a user | Visit profile, tap Follow | Following count increments, button changes to Following | |
| FA-19 | Create a room | Tap create room, fill details | Room created, user enters as host | |
| FA-20 | Join a public room | Tap Join on a public room | User joins room, member count increments | |
| FA-21 | Upload a reel | Record/select video, add description, upload | Reel appears in reels feed | |
| FA-22 | Create a story | Tap story camera, capture/select media | Story appears in story row | |
| FA-23 | Edit profile | Navigate to edit profile, change bio, save | Updated bio shown on profile | |
| FA-24 | Block a user | Visit profile, tap block | User removed from feed, block list updated | |
| FA-25 | Report a post | Long press post, tap report, select reason | Report submitted, confirmation shown | |
| FA-26 | Logout | Settings → Logout | Session cleared, OnBoardingScreen shown | |
| FA-27 | Delete account | Settings → Delete Account | Account deleted, redirected to login | |
| FA-28 | Push notification received | Trigger a notification from admin panel | Notification appears in device notification tray | |
| FA-29 | Interest selection | Select 5 interests | All 5 saved, cannot select 6th | |
| FA-30 | Username availability check | Type username in username screen | Real-time availability feedback shown | |

---

## 3. API Endpoint Tests

Use a tool like Postman or curl. All requests require header `apikey: 123`.

| # | Endpoint | Test | Expected Response | Pass/Fail |
|---|----------|------|-------------------|-----------|
| API-01 | POST /api/addUser | Valid social login payload | `{ status: true, data: { ...user } }` | |
| API-02 | POST /api/addUser | Missing apikey header | `401 Unauthorized` | |
| API-03 | POST /api/sendRegisterOtp | Valid phone number | `{ status: true, message: "OTP..." }` | |
| API-04 | POST /api/sendRegisterOtp | Already registered phone | `{ status: false, message: "Phone number is already registered." }` | |
| API-05 | POST /api/sendRegisterOtp | Invalid phone format | `{ status: false, message: validation error }` | |
| API-06 | POST /api/verifyRegisterOtp | Correct OTP | `{ status: true, message: "Phone number verified" }` | |
| API-07 | POST /api/verifyRegisterOtp | Wrong OTP | `{ status: false, message: "Invalid OTP..." }` | |
| API-08 | POST /api/register | Valid student payload after OTP | `{ status: true, data: { approval_status: "pending" } }` | |
| API-09 | POST /api/register | Missing registration_number for student | `{ status: false, message: validation error }` | |
| API-10 | POST /api/cuiLogin | Approved user credentials | `{ status: true, data: { approval_status: "approved" } }` | |
| API-11 | POST /api/cuiLogin | Pending user credentials | `{ status: false, message: "pending admin approval" }` | |
| API-12 | POST /api/fetchPosts | Valid user ID | `{ status: true, data: [ ...posts ] }` | |
| API-13 | POST /api/generateAgoraToken | Valid channel name | `{ status: true, data: "agora_token" }` | |
| API-14 | POST /api/fetchSetting | Any user ID | `{ status: true, data: { interests, report_reasons, ... } }` | |
| API-15 | POST /api/uploadFile | Image file | `{ status: true, data: "uploads/filename.jpg" }` | |

---

## 4. Database Verification Tests

| # | Test | Query | Expected Result | Pass/Fail |
|---|------|-------|-----------------|-----------|
| DB-01 | Users table has CUI columns | `DESCRIBE users;` | Columns: role_type, approval_status, registration_number, department, batch_duration, phone_number, gender, campus, phone_verified_at, approved_at, approved_by, rejected_reason | |
| DB-02 | registration_otps table exists | `SHOW TABLES LIKE 'registration_otps';` | Table found | |
| DB-03 | OTP is hashed | `SELECT otp_code FROM registration_otps LIMIT 1;` | 64-character hex string (SHA-256 hash), not plain text | |
| DB-04 | Pending user cannot login | `SELECT approval_status FROM users WHERE email='test@test.com';` | 'pending' for newly registered CUI user | |
| DB-05 | Approved user has timestamp | `SELECT approved_at, approved_by FROM users WHERE approval_status='approved';` | Non-null timestamps for approved users | |

---

## 5. Security Tests

| # | Test | Method | Expected Result | Pass/Fail |
|---|------|--------|-----------------|-----------|
| SEC-01 | API without apikey header | Send request without header | 401 response | |
| SEC-02 | Admin panel without session | Access `/dashboard` directly | Redirect to `/` | |
| SEC-03 | OTP brute force | Submit wrong OTP multiple times | Each attempt returns "Invalid OTP" (no lockout currently — known limitation) | |
| SEC-04 | Password in API response | Call `/api/fetchProfile` | `password` field not present in response | |
| SEC-05 | OTP in production response | Call `/api/sendRegisterOtp` with `APP_DEBUG=false` | OTP not returned in response body | |
| SEC-06 | Phone/gender privacy | Call `/api/fetchProfile` for another user | `phone_number` and `gender` not in response | |

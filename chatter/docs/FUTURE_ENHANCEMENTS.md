# CUICHAT — Future Enhancements

## Overview

This document outlines planned and proposed enhancements for the CUICHAT platform, organized by priority and estimated implementation effort.

---

## Enhancement Roadmap

| # | Enhancement | Description | Priority | Effort | Category |
|---|-------------|-------------|----------|--------|----------|
| FE-01 | Per-user API authentication (JWT/Sanctum) | Replace the static `apikey: 123` header with per-user JWT tokens using Laravel Sanctum. Each login generates a unique token stored server-side. | High | Medium | Security |
| FE-02 | OTP brute force protection | Add attempt counter to `registration_otps` table. Lock the phone number after 5 failed attempts for 30 minutes. | High | Low | Security |
| FE-03 | SMS provider integration (production) | Configure and test Twilio or Vonage for production OTP delivery. Add fallback between providers. | High | Low | Feature |
| FE-04 | Email notification system | Configure SMTP and implement email templates for: registration approval, rejection, welcome email, password reset. | High | Medium | Feature |
| FE-05 | Admin password migration to bcrypt | Migrate admin passwords from `Crypt::encrypt()` to `Hash::make()` (bcrypt). Add a migration script for existing passwords. | High | Low | Security |
| FE-06 | Flutter package rename | Rename the Flutter package from `untitled` to `com.cuichat.app` for Play Store and App Store submission. | High | Low | Maintenance |
| FE-07 | Video calling | Add one-on-one and group video calling using Agora Video SDK. Integrate with the existing chat and rooms system. | High | High | Feature |
| FE-08 | Chat moderation in admin panel | Allow admins to view and moderate Firestore chat messages. Add reporting for chat messages. | High | High | Feature |
| FE-09 | Automated database backups | Configure daily automated MySQL backups via Hostinger or a custom cron job. Store backups in cloud storage. | High | Low | Infrastructure |
| FE-10 | Queue worker for async jobs | Move email sending and push notifications to a background queue. Configure `QUEUE_CONNECTION=database` with a cron-based worker. | Medium | Medium | Performance |
| FE-11 | Offline mode for feed | Cache the last 20 feed posts locally using SQLite or Hive. Show cached content when offline with a "You're offline" banner. | Medium | High | Feature |
| FE-12 | Junction tables for IDs | Replace comma-separated `interest_ids`, `block_user_ids`, `saved_music_ids`, `saved_reel_ids` with proper junction tables for better query performance. | Medium | High | Database |
| FE-13 | Soft deletes | Add `SoftDeletes` trait to User, Post, Reel, Room, and Story models. Allow admins to restore accidentally deleted content. | Medium | Medium | Feature |
| FE-14 | Academic department groups | Create department-specific groups or channels where students from the same department can share resources and announcements. | Medium | High | Feature |
| FE-15 | Campus-specific feeds | Allow users to filter the feed by campus. Show campus-specific announcements and events. | Medium | Medium | Feature |
| FE-16 | Event system | Allow faculty and admins to create campus events. Students can RSVP and receive reminders. | Medium | High | Feature |
| FE-17 | Academic resource sharing | Dedicated section for sharing lecture notes, past papers, and study materials. Organized by department and course. | Medium | High | Feature |
| FE-18 | Polls and surveys | Allow users to create polls in posts and rooms. Useful for faculty to gather student feedback. | Medium | Medium | Feature |
| FE-19 | Advanced search | Full-text search across posts, reels, users, and rooms. Add filters for campus, department, and date range. | Medium | Medium | Feature |
| FE-20 | Analytics dashboard improvements | Add more detailed analytics to the admin panel: daily active users, registration trends by campus/department, content engagement metrics. | Low | Medium | Admin |
| FE-21 | Multi-language support expansion | The app has localization infrastructure. Add Urdu language support for Pakistani users. | Low | Medium | Feature |
| FE-22 | Dark mode | Add a dark mode theme option. The app currently uses a light theme only. | Low | Medium | UI/UX |
| FE-23 | Web version | Build a web version of the app using Flutter Web or a separate React/Vue frontend. | Low | High | Feature |
| FE-24 | Content recommendation algorithm | Implement a recommendation engine that suggests posts, reels, and rooms based on user interests and engagement history. | Low | High | Feature |
| FE-25 | Verified faculty badge | Add a distinct badge for verified faculty members, separate from the general verification badge. | Low | Low | Feature |

---

## Priority Definitions

- **High:** Should be implemented before or shortly after the initial public launch. Addresses security, critical functionality, or user experience issues.
- **Medium:** Important for a complete product but not blocking launch. Enhances the platform significantly.
- **Low:** Nice-to-have features that improve the platform over time.

## Effort Definitions

- **Low:** 1-3 days of development work
- **Medium:** 1-2 weeks of development work
- **High:** 2-4+ weeks of development work, may require architectural changes

---

## Immediate Post-Launch Priorities

Based on the current state of the project, these enhancements should be addressed immediately after the initial launch:

1. **FE-01** — JWT authentication (security critical)
2. **FE-02** — OTP brute force protection (security critical)
3. **FE-03** — SMS provider for production OTP delivery
4. **FE-04** — Email notifications (approval/rejection emails)
5. **FE-06** — Flutter package rename (required for app store submission)
6. **FE-09** — Automated database backups (data safety)

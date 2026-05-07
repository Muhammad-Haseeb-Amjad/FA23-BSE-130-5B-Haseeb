# CUICHAT — Project Overview

## 1. Introduction

CUICHAT is a university-specific social networking platform developed as a Final Year Project for COMSATS University Islamabad (CUI). The platform is purpose-built for the COMSATS community, providing students and faculty with a dedicated digital space to connect, share content, collaborate, and engage in real-time communication. Unlike general-purpose social media platforms, CUICHAT is restricted to verified members of the COMSATS community, ensuring a trusted and academically relevant environment.

The system consists of two primary components: a Laravel 9 REST API backend hosted on Hostinger, and a cross-platform Flutter mobile application targeting Android and iOS. A web-based admin panel is integrated into the backend for content moderation and user management.

---

## 2. Problem Statement

University students and faculty at COMSATS University Islamabad currently rely on fragmented communication channels — WhatsApp groups, Facebook pages, and email threads — to share academic updates, campus news, and social content. These platforms lack:

- **Identity verification**: Anyone can join, leading to misinformation and spam.
- **Academic context**: General platforms do not understand department, batch, or campus distinctions.
- **Centralized moderation**: There is no single authority to moderate content within the university community.
- **Structured discovery**: Students cannot easily find peers from the same department, batch, or campus.
- **Real-time collaboration**: Existing tools do not support live audio discussions or structured group rooms.

The absence of a dedicated, verified platform creates communication gaps and reduces the sense of community among COMSATS students and faculty.

---

## 3. Proposed Solution

CUICHAT addresses these gaps by providing a closed, verified social platform exclusively for COMSATS University Islamabad. The solution includes:

- A **phone OTP-based registration system** that verifies users before they can apply for an account.
- An **admin approval workflow** that ensures only genuine COMSATS students and faculty gain access.
- A **rich social feed** supporting text posts, images, videos, and audio content.
- **Live audio rooms** powered by Agora RTC for real-time group discussions.
- **Direct messaging** via Firebase Firestore for private conversations.
- **Interest-based content discovery** to connect users with relevant academic and social content.
- A **comprehensive admin panel** for content moderation, user management, and platform analytics.

---

## 4. Objectives

1. Design and implement a secure, verified registration system for COMSATS students and faculty.
2. Build a RESTful API backend using Laravel 9 that serves the mobile application.
3. Develop a cross-platform Flutter mobile application for Android and iOS.
4. Implement an admin approval workflow to control platform access.
5. Provide a social feed with support for posts, reels, stories, and comments.
6. Integrate live audio rooms using Agora RTC Engine.
7. Enable real-time direct messaging using Firebase Firestore.
8. Support multi-campus operations across all 7 COMSATS campuses.
9. Implement push notifications via Firebase Cloud Messaging (FCM).
10. Build a web-based admin panel for content moderation and user management.
11. Deploy the backend on Hostinger shared hosting with MySQL database.
12. Ensure the platform is scalable and maintainable for future development.

---

## 5. Scope

**In Scope:**
- Mobile application for Android and iOS (Flutter)
- Laravel REST API backend
- Admin web panel
- CUI-specific registration with OTP and admin approval
- Social feed (posts, reels, stories)
- Live audio rooms
- Direct messaging (Firebase Firestore)
- Push notifications
- Music integration
- Interest-based content discovery
- Multi-campus support (Islamabad, Lahore, Abbottabad, Wah, Attock, Sahiwal, Vehari)
- Content moderation tools

**Out of Scope:**
- Web version of the mobile app
- Video calling
- Academic management features (grades, attendance)
- Integration with COMSATS official systems (LMS, ERP)

---

## 6. Target Users

### Students
Undergraduate and postgraduate students enrolled at any COMSATS University campus. Students register with their registration number (e.g., FA23-BSE-130), batch duration (e.g., FA23-SP27), department, and campus. They must pass phone OTP verification and receive admin approval before accessing the platform.

### Faculty
Teaching and non-teaching staff at COMSATS University. Faculty members register with their department, campus, and institutional email. They do not require a registration number or batch duration. Faculty accounts also require admin approval.

### Administrators
Platform administrators who manage the system through the web-based admin panel. Admins can approve or reject registration requests, moderate content, manage interests, send platform notifications, and configure app settings.

---

## 7. Key Features

| Feature | Status | Description |
|---------|--------|-------------|
| CUI Registration | ✅ Implemented | Phone OTP + admin approval for students and faculty |
| Social Login | ✅ Implemented | Google, Apple, and email-based login via Firebase |
| Social Feed | ✅ Implemented | Posts with images, videos, audio, and text |
| Reels | ✅ Implemented | Short-form video content with likes, comments, and music |
| Stories | ✅ Implemented | 24-hour ephemeral content |
| Live Audio Rooms | ✅ Implemented | Agora RTC-powered group audio spaces |
| Direct Messaging | ✅ Implemented | Firebase Firestore real-time chat |
| Music Integration | ✅ Implemented | Background music for reels, categorized library |
| Interest Discovery | ✅ Implemented | Up to 5 interests per user, content filtered by interest |
| Push Notifications | ✅ Implemented | Firebase FCM for in-app and background notifications |
| Admin Panel | ✅ Implemented | Full web-based moderation and management panel |
| Profile Verification | ✅ Implemented | Document-based verification with admin review |
| AdMob Integration | ✅ Implemented | Banner and interstitial ads |
| Multi-campus Support | ✅ Implemented | 7 COMSATS campuses supported |
| Moderator System | ✅ Implemented | Trusted users with content moderation privileges |
| Block/Report System | ✅ Implemented | User-level blocking and content reporting |

---

## 8. System Modules

### 8.1 Authentication Module
Handles both social login (Google/Apple/Email via Firebase) and CUI-specific login (email + password). Includes OTP verification, admin approval workflow, and session management via GetStorage.

### 8.2 Registration Module
Three-step CUI registration: form submission → phone OTP verification → admin approval. Separate flows for students (with registration number and batch) and faculty.

### 8.3 Feed Module
Social feed displaying posts from followed users and suggested content. Supports images, videos, audio posts, hashtags, and interest-based filtering.

### 8.4 Reels Module
Short-form video content with background music, likes, comments, view counts, and hashtag discovery.

### 8.5 Rooms Module
Live audio rooms powered by Agora RTC. Supports public and private rooms, join requests, invitations, co-admins, and room notifications.

### 8.6 Chat Module
Real-time direct messaging using Firebase Firestore. Supports individual and group conversations.

### 8.7 Stories Module
24-hour ephemeral content visible to followers. Supports images and videos with quick emoji reactions.

### 8.8 Music Module
Categorized music library for use in reels. Users can save favorite tracks.

### 8.9 Admin Panel Module
Web-based management interface for admins. Covers user management, registration approvals, content moderation, analytics, notifications, and settings.

### 8.10 Notification Module
Firebase FCM-based push notifications for likes, comments, follows, room invitations, and admin announcements.

---

## 9. Why CUICHAT is Useful for COMSATS/CUI

CUICHAT fills a genuine gap in the COMSATS University ecosystem. By restricting access to verified community members, it creates a trusted environment where students can share academic resources, discuss coursework, and build professional networks within their university. Faculty can engage with students beyond the classroom, share announcements, and participate in academic discussions.

The multi-campus architecture means students from Islamabad, Lahore, Abbottabad, Wah, Attock, Sahiwal, and Vehari can all connect on a single platform while maintaining campus-specific identity. The interest-based discovery system helps students find peers working in the same academic domains, fostering collaboration on projects and research.

The admin approval system ensures the platform remains free from external interference, maintaining the academic integrity of the community. The live audio rooms provide a modern alternative to traditional study groups, enabling real-time collaboration regardless of physical location.

📘 Task Manager – Documentation
1. Overview

Task Manager ek Flutter-based productivity app hai jo “Today” tasks, repeating schedules, task notifications, subtasks, export/import, aur bottom sheet quick-entry par focus karti hai.
UI dark theme follow karta hai aur tasks ko categories (All, Work, Personal) ke through filter karta hai.
Android par advanced screen-on reminder system bhi implement hai.

2. Tech Stack & Architecture
Frontend

Flutter (Material Design)

Provider (State Management)

Intl (Date & Time formatting)

State Providers

TaskProvider

ThemeProvider

ExportOptionsProvider

Persistence

SQLite (DatabaseHelper)

Tasks + Subtasks tables (with cascade delete logic)

Notifications

flutter_local_notifications

Custom Android broadcast receivers for screen-on reminders

Android Platform Code

UnlockReceiver

TaskManagerApp

PendingTasksResolver

Routing / Screens

Today Screen

Completed Archive

Repeating Tasks

Settings

Onboarding

Task Edit Bottom Sheet

3. Layered Architecture
Model Layer

Includes models such as:

Task

Subtask

ExportOptions

Database Layer

DatabaseHelper responsible for CRUD operations, migrations, subtasks cascade delete, and repeat task rollover.

Provider Layer

Handles:

Fetching tasks

Applying filters

Scheduling notifications

Updating repeat tasks

Theme & settings management

Service Layer

NotificationService

ExportService

RestoreService

Onboarding helpers

UI Layer

All Material widgets

Screens and bottom sheets that consume provider data

Reusable custom components

4. Core Features
Today Screen

Shows greeting, current date, search bar, filter chips, and pending task count

Displays:

Today’s due tasks

Overdue tasks

Undated tasks

Swipe gestures:

Mark as complete

Delete task

FAB opens the Task Edit Bottom Sheet

Task Edit Bottom Sheet

Includes:

Title

Description

Category

Due date

Repeat settings

Notification time

Priority selection

Subtasks

Save button
Manages repeat toggles and schedules notifications automatically.

Repeating Tasks Screen

Shows all tasks with repeat enabled

Search toggle for filtering

Each card includes:

Task title

Recurrence

Next run date

Priority color

Enable/disable switch

Completed Archive

Shows all completed non-repeating tasks

Also displays completed instances of repeating tasks

Settings Screen

Includes:

Accent color picker

Light/Dark theme toggle

Notification sound picker

Export/Import (CSV & PDF)

Restore backup

Completed archive shortcut

WhatsApp contact shortcut

Toggle for “Today Task Screen-On Reminders”

5. Notification System
Task Reminders

Reminders support:

5 min, 15 min, 30 min, 1 hr, 1 day before

Custom minute duration

Manual custom time

NotificationService ensures:

Permission handling

Timezone initialization

Custom sound loading

Exact scheduling with fallback safety

Screen-On / Unlock Reminders (Android)

This system triggers a special notification whenever:

The device screen turns on

User unlocks the phone

It works like this:

UnlockReceiver catches SCREEN_ON and USER_PRESENT

PendingTasksResolver directly reads the tasks database

Builds a multi-line big notification listing up to 20 pending today tasks

Triggered only when “Today notifications” toggle is ON

A 20-second rate-limiter prevents notification spam

Works even when app is backgrounded

After reboot or force-stop, app must be opened once to re-register receivers

6. Database Schema (Description Form)
Tasks Table Contains:

ID

Title

Description

Due date in milliseconds

Repeat rule

Priority value

Completion status

Repeating enabled flag

Notification enabled flag

Notification time

Notification sound

Created & updated timestamps

Category (Work, Personal, etc.)

Subtasks Table Contains:

ID

Parent task ID

Title

Completion status

Repeating Tasks Logic

When a repeating task is completed:

Its current occurrence is closed

A new future-dated occurrence is generated

Subtasks are reset for the new repetition

7. Export & Restore
Export Features

Export to CSV or PDF

Select which fields to export

“Export All Data” produces both formats together

Restore Process

Uses file_picker to import CSV

Reconstructs tasks and subtasks

Reschedules notifications for restored tasks

8. Themes & Settings

Dark and light themes switchable

Accent color fully customizable

Notification sounds selectable with preview

All preferences stored using shared_preferences

9. Build & Release Process

Steps:

flutter clean

flutter pub get

flutter build apk --release

(Optional) flutter build apk --release --split-per-abi

Keystore must be configured in:

android/app/build.gradle

key.properties

10. Testing Guide
Manual Testing

Create tasks with due dates and without

Test repeat enable/disable

Verify next-occurrence rollover

Test screen-on notifications:

With app open

In background

After device reboot

Test export → delete → import → verify data restored

Automated Testing Suggestions

Test provider logic

Test notification scheduling

Test repeat generation logic

Test database CRUD operations

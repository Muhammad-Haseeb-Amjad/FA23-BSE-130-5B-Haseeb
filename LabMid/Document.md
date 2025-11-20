Overview
Task Manager is a Flutter-based productivity app that focuses on “Today” tasks, repeating schedules, notifications, and quick entry via a bottom sheet. The UI follows a dark-themed design with categorized filters (“All / Work / Personal”) and advanced notification behavior, including screen-on reminders.
Tech Stack & Architecture
Frontend: Flutter (Material, Provider for state, Intl for dates)
State Management: TaskProvider, ThemeProvider, ExportOptionsProvider
Persistence: SQLite via DatabaseHelper (tasks + subtasks tables)
Notifications: flutter_local_notifications + custom Android broadcast receiver
Platform-Specific Code: Android Kotlin classes (UnlockReceiver, TaskManagerApp, PendingTasksResolver)
Routing: Screen widgets inside lib/screens (Today, Completed Archive, Repeating Tasks, Settings, Onboarding, etc.)
Layering
Models: Task, Subtask, ExportOptions
Database: DatabaseHelper handles CRUD, migration, and Subtask cascades.
Providers: Business logic & state (fetching tasks, toggling filters, scheduling notifications).
Services: NotificationService, export/restore, onboarding helpers.
UI: Screens (e.g., today_tasks_screen.dart, task_edit_sheet.dart) inflate provider data into Material widgets.
Core Features
Today Screen
Shows greeting, date, search, filter chips, pending count, and list of incomplete tasks due today or overdue (undated tasks remain visible).
Swipe actions: mark complete (with repeat rollover) or delete.
Floating Action Button opens TaskEditSheet.
Task Editing
Bottom sheet includes title, description, category toggles, due date picker, repeat settings, notification timing, priority chips, subtasks, and Save.
Handles repeating task enable/disable toggle and notification scheduling via provider.
Repeating Tasks
RepeatedTasksListScreen lists tasks where repeat is set and provides a search bar toggled in the AppBar.
Cards show title, recurrence, next run date, priority color strip, and an on/off switch for enabling/disabling the repeat schedule.
Completed Archive
Allows viewing and managing completed tasks (non-repeating or archived copies of repeat tasks).
Settings
Accent color picker, theme toggle, notification sound selection, export/import (CSV/PDF), restore, completed archive, info/about, WhatsApp contact shortcut.
Includes a switch “Today task notifications” to enable screen-on reminders.
Integration with export services and shared preferences for defaults.
Notification System
Task Reminders
Each task can schedule a notification relative to due time (5 min, 15 min, 30 min, 1 hr, 1 day, custom duration, or manual clock time).
NotificationService ensures permission checks, timezone setup, custom sound resolution, and exact scheduling with fallback.
Screen-On / Unlock Reminders
Android-specific implementation:
UnlockReceiver listens to USER_PRESENT and SCREEN_ON.
PendingTasksResolver reads tasks.db directly to build a real-time snapshot of Today’s pending tasks (up to 20 lines, BigText style).
TaskManagerApp registers the receiver at application level to catch broadcasts even when the Flutter activity is backgrounded.
Shared Preferences store toggle state (today_unlock_reminders_enabled) and rate-limit timestamp.
Behavior:
When the screen turns on or the device unlocks, and the toggle is enabled, the receiver fetches pending Today tasks (ignoring task reminder times) and displays a multi-line notification with bullets for each task title.
A 20-second rate limiter prevents spamming on rapid screen toggles.
Works while app is in background; after force-stopping or reboot, open the app once to re-register.
Database Schema
tasks table:
Columns: id, title, description, due_date (ms), repeat, priority, is_completed, is_repeating_enabled, is_notification_enabled, notification_time, notification_sound, created_at, updated_at, category.
subtasks table: id, taskId, title, isCompleted (with cascade delete).
For repeating tasks, toggleTaskCompletion closes current occurrence and creates the next scheduled instance with reset subtasks.
Export & Restore
Export to CSV or PDF with customizable field sets (ExportService).
Direct “Export All Data” writes both formats to storage.
Restore reads CSV to reconstruct Task and Subtask models via RestoreService.
Uses file_picker for import; ensures notifications are rescheduled post-restore.
Settings & Themes
ThemeProvider controls light/dark and accent color; stored via shared preferences.
Notification sounds customizable via dedicated picker screen (plays preview audio, stored in shared prefs, used by NotificationService).
Build/Release Process
flutter clean && flutter pub get
flutter build apk --release (or --split-per-abi)
Ensure keystore configured in android/app/build.gradle and key.properties.
Testing Tips
Manual scenarios:
Create tasks with and without due dates, toggle repeat on/off, verify rollover.
Test screen-on notifications after enabling toggle, in background and after closing app (re-open once post-reboot).
Export/import roundtrip to confirm data integrity.
Automated tests: test/widget_test.dart exists but you may extend coverage for providers/services.

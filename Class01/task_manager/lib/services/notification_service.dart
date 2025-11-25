import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import '../models/task.dart';

const int accentGreenValue = 0xFF38B28F;
const String _soundKey = 'selectedNotificationSound';
// ✅ NEW: App-wide notification sound key (settings screen se save hoga)
const String _appSoundKey = 'notification_sound';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  static tz.Location? _localTimeZone;

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initTimezone(String timeZoneName) {
    tzdata.initializeTimeZones();
    try {
      final location = tz.getLocation(timeZoneName);
      tz.setLocalLocation(location);
      _localTimeZone = location;
      debugPrint('Timezone set to: $timeZoneName');
    } catch (e) {
      debugPrint('Error setting local timezone to $timeZoneName: $e');
      _localTimeZone = null;
    }
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
      >();

      Future<bool> refreshStatus({Duration delay = Duration.zero}) async {
        if (delay > Duration.zero) {
          await Future.delayed(delay);
        }

        if (androidImplementation != null) {
          try {
            final enabled =
            await androidImplementation.areNotificationsEnabled();
            if (enabled == true) {
              debugPrint('areNotificationsEnabled => true');
              return true;
            } else if (enabled == false) {
              debugPrint('areNotificationsEnabled => false');
            }
          } catch (e) {
            debugPrint('Error checking areNotificationsEnabled: $e');
          }
        }

        final status = await Permission.notification.status;
        debugPrint('Permission.notification.status => $status');
        return _isStatusGranted(status);
      }

      if (await refreshStatus()) {
        debugPrint('Notification permission already granted');
        return true;
      }

      var permissionGranted = false;
      if (androidImplementation != null) {
        try {
          final granted = await androidImplementation
              .requestNotificationsPermission();
          debugPrint('flutter_local_notifications request => $granted');
          if (granted == true) {
            permissionGranted = true;
          }
        } catch (e) {
          debugPrint(
            'Error requesting permission via flutter_local_notifications: $e',
          );
        }
      }

      if (!permissionGranted) {
        try {
          final status = await Permission.notification.request();
          debugPrint('permission_handler request => $status');

          if (_isStatusGranted(status)) {
            permissionGranted = true;
          } else if (status.isPermanentlyDenied) {
            debugPrint('Notification permission permanently denied');
            return false;
          }
        } catch (e) {
          debugPrint('Error requesting permission via permission_handler: $e');
        }
      }

      if (permissionGranted || await refreshStatus()) {
        return true;
      }

      if (await refreshStatus(delay: const Duration(milliseconds: 400))) {
        return true;
      }

      return await refreshStatus(delay: const Duration(milliseconds: 800));
    }
    return true;
  }

  Future<bool> openNotificationSettings() async {
    return await openAppSettings();
  }

  Future<Map<Permission, PermissionStatus>> requestMediaPermissions() async {
    if (!Platform.isAndroid) return {};

    final permissionsToRequest = <Permission>[
      Permission.storage,
      Permission.photos,
      Permission.audio,
      Permission.videos,
      Permission.mediaLibrary,
    ];

    final results = await permissionsToRequest.request();

    results.forEach((permission, status) {
      debugPrint('Permission $permission => $status');
    });

    return results;
  }

  Future<bool> requestIgnoreBatteryOptimization() async {
    if (Platform.isAndroid) {
      try {
        final status = await Permission.ignoreBatteryOptimizations.request();
        if (status.isGranted) {
          debugPrint(
            '✅ Battery optimization ignored - notifications will work better',
          );
          return true;
        } else {
          debugPrint('❌ Battery optimization permission denied');
          return false;
        }
      } catch (e) {
        debugPrint('Error requesting battery optimization: $e');
        return false;
      }
    }
    return true;
  }

  Future<bool> isBatteryOptimizationIgnored() async {
    if (Platform.isAndroid) {
      final status = await Permission.ignoreBatteryOptimizations.status;
      return status.isGranted;
    }
    return true;
  }

  Future<bool> openBatteryOptimizationSettings() async {
    if (Platform.isAndroid) {
      return await openAppSettings();
    }
    return false;
  }

  Future<bool> isPermissionPermanentlyDenied() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return status.isPermanentlyDenied;
    }
    return false;
  }

  Future<bool> isNotificationPermissionGranted() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return _isStatusGranted(status);
    }
    return true;
  }

  bool _isStatusGranted(PermissionStatus status) {
    return status.isGranted ||
        status.isLimited ||
        status == PermissionStatus.provisional ||
        status == PermissionStatus.restricted;
  }

  Future<PermissionStatus> getNotificationPermissionStatus({
    Duration delay = Duration.zero,
  }) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    return Permission.notification.status;
  }

  bool isPermissionStatusGranted(PermissionStatus status) {
    return _isStatusGranted(status);
  }

  // ✅ UPDATED: Priority-based sound selection
  // 1. Task-specific sound (if set)
  // 2. App-wide sound (from settings)
  // 3. Default system sound
  Future<String?> _getNotificationSound() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check both keys: 'notification_sound' and 'selectedNotificationSound'
    String? appSound = prefs.getString(_appSoundKey);
    if (appSound == null || appSound.isEmpty) {
      // Fallback to the other key
      final soundName = prefs.getString(_soundKey);
      if (soundName != null && soundName.isNotEmpty) {
        appSound = soundName;
      } else {
        appSound = 'default';
      }
    }

    if (appSound.toLowerCase() != 'default' && 
        appSound.toLowerCase() != 'default system sound') {
      return appSound;
    }

    return null; // Use system default
  }

  Future<String?> _getSelectedSoundPath() async {
    final prefs = await SharedPreferences.getInstance();
    final soundPath = prefs.getString(_soundKey) ?? 'default';

    return soundPath.toLowerCase() != 'default'
        ? soundPath.split('.').first
        : null;
  }

  String? _resolveSoundResource(String? storedSound) {
    if (storedSound == null || storedSound.isEmpty) return null;
    final lower = storedSound.toLowerCase();
    if (lower == 'default' || lower == 'default system sound') {
      return null;
    }

    // Map of sound names (as saved in settings) to file names
    const Map<String, String> labelToFile = {
      'alert chime': 'chime',
      'bell ring': 'bell',
      'magic wand': 'magic_wand',
      'echo pulse': 'echo_pulse',
      'chime': 'chime',
      'bell': 'bell',
      'alert': 'alert',
      'gentle': 'gentle',
    };

    // First check if it's a known label (sound name)
    if (labelToFile.containsKey(lower)) {
      final file = labelToFile[lower];
      return file; // Return without extension (Android needs resource name without extension)
    }

    // If it's already a file path with extension, remove extension
    if (storedSound.endsWith('.mp3') || storedSound.endsWith('.wav')) {
      return storedSound.split('.').first;
    }

    // Otherwise return as is (might be a resource name already)
    return storedSound;
  }

  // ✅ UPDATED: Notification details with app-wide sound support
  Future<NotificationDetails> _notificationDetails(Task task) async {
    // Priority order:
    // 1. Task-specific sound
    // 2. App-wide sound (from settings)
    // 3. Default system sound
    final taskSound = _resolveSoundResource(task.notificationSound);
    final appSound = await _getNotificationSound();
    final resolvedAppSound = _resolveSoundResource(appSound);

    final finalSound = taskSound ?? resolvedAppSound;

    debugPrint('🔊 Notification sound resolution:');
    debugPrint('   Task sound: ${task.notificationSound} -> $taskSound');
    debugPrint('   App sound: $appSound -> $resolvedAppSound');
    debugPrint('   Final sound: $finalSound');

    final sound = finalSound != null
        ? RawResourceAndroidNotificationSound(finalSound)
        : null;

    if (sound != null) {
      debugPrint('   ✅ Using custom sound: $finalSound');
    } else {
      debugPrint('   ℹ️ Using system default sound');
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel_id',
        'Task Reminders',
        channelDescription: 'Notifications for task due dates',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        color: const Color(accentGreenValue),
        sound: sound,
        enableVibration: true,
        playSound: true,
      ),
    );
  }

  Future<void> scheduleNotification(Task task) async {
    debugPrint('=== Scheduling notification for task: ${task.title} ===');

    final hasPermission = await isNotificationPermissionGranted();
    if (!hasPermission) {
      debugPrint(
        '❌ Notification permission not granted. Cannot schedule notification for task: ${task.title}',
      );
      return;
    }
    debugPrint('✅ Permission granted');

    if (task.dueDate == null) {
      debugPrint('❌ Task has no due date. Cannot schedule notification.');
      return;
    }
    debugPrint('✅ Task has due date: ${task.dueDate}');

    final notificationId =
        task.id ?? DateTime.now().millisecondsSinceEpoch % 100000;
    debugPrint('📌 Notification ID: $notificationId');

    final dueDateTime = tz.TZDateTime.from(task.dueDate!, tz.local);

    final notificationTimeBefore =
        task.notificationTime ?? const Duration(minutes: 15);
    final scheduledTime = dueDateTime.subtract(notificationTimeBefore);

    final now = tz.TZDateTime.now(tz.local);
    debugPrint('⏰ Due date: $dueDateTime');
    debugPrint(
      '⏰ Notification time before: ${notificationTimeBefore.inMinutes} minutes',
    );
    debugPrint('⏰ Scheduled notification time: $scheduledTime');
    debugPrint('⏰ Current time: $now');

    if (scheduledTime.isBefore(now.add(const Duration(seconds: 5)))) {
      debugPrint(
        '❌ Notification time is in the past or too near. Skipping scheduling.',
      );
      debugPrint(
        '   Scheduled: $scheduledTime, Now: $now, Difference: ${scheduledTime.difference(now).inSeconds} seconds',
      );
      return;
    }

    final details = await _notificationDetails(task);
    debugPrint('📋 Notification details prepared');

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'REMINDER: ${task.title}',
        'Your task is due!',
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint('✅ Notification scheduled successfully with exact mode!');
      debugPrint(
        '   ID: $notificationId, Time: $scheduledTime, Title: ${task.title}',
      );
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('exact_alarms_not_permitted')) {
        debugPrint(
          '⚠️ Exact alarm permission not available. Using inexact mode...',
        );
        try {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            'REMINDER: ${task.title}',
            'Your task is due!',
            scheduledTime,
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
          );
          debugPrint(
            '✅ Notification scheduled successfully with inexact mode!',
          );
          debugPrint(
            '   Note: Notification may arrive slightly before or after scheduled time.',
          );
        } catch (e2) {
          debugPrint('❌ Error scheduling notification with inexact mode: $e2');
        }
      } else {
        debugPrint('❌ Error scheduling notification: $e');
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> showTodaySummaryNotification(List<Task> tasks) async {
    if (tasks.isEmpty) return;

    var hasPermission = await isNotificationPermissionGranted();
    if (!hasPermission) {
      hasPermission = await requestNotificationPermission();
      if (!hasPermission) return;
    }

    final lines = tasks.take(5).map((task) => '• ${task.title}').toList();
    final remaining = tasks.length - lines.length;

    final style = InboxStyleInformation(
      lines,
      contentTitle: 'Today\'s pending tasks',
      summaryText: remaining > 0 ? '+$remaining more tasks' : null,
    );

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'today_unlock_channel',
        'Today Unlock Reminders',
        channelDescription:
            'Reminders shown when you unlock your phone with pending tasks.',
        importance: Importance.max,
        priority: Priority.high,
        color: const Color(accentGreenValue),
        styleInformation: style,
        category: AndroidNotificationCategory.reminder,
        enableVibration: true,
        playSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      9001,
      'You have ${tasks.length} pending today',
      lines.isNotEmpty ? lines.first : 'Open Task Manager to review.',
      details,
    );
  }
}
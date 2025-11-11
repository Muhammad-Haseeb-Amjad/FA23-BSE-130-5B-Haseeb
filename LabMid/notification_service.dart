// lib/services/notification_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

// Assuming accentGreen = 0xFF38B28F
const int accentGreenValue = 0xFF38B28F;
// NEW: Sound key jo humne NotificationSoundPicker mein use kiya tha
const String _soundKey = 'selectedNotificationSound';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  // ✅ FIX 1. Time Zone ko globally store karne ki zaroorat nahi hai agar hum tz.local use karein.
  // Lekin initialization ke liye zaroori hai. Static variable rakhenge.
  static tz.Location? _localTimeZone;

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // ✅ NEW STATIC METHOD: main.dart se call kiya jayega time zone setup ke liye
  static void initTimezone(String timeZoneName) {
    // 1. Timezone data ko initialize karein
    tzdata.initializeTimeZones();
    // 2. Local time zone ko set karein
    try {
      final location = tz.getLocation(timeZoneName);
      tz.setLocalLocation(location); // CRITICAL: tz.local set ho jayega
      _localTimeZone = location;
      debugPrint('Timezone set to: $timeZoneName');
    } catch (e) {
      debugPrint('Error setting local timezone to $timeZoneName: $e');
      _localTimeZone = null;
    }
  }


  // Initialization (App launch par call hoga)
  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initial check (permission prompt aane ke liye zaroori)
    // Android 13+ ke liye permissions yahan prompt ho jati hain
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: (details) { ... }
    );
  }

  // NEW: Helper function to get the custom sound path
  Future<String?> _getSelectedSoundPath() async {
    final prefs = await SharedPreferences.getInstance();
    final soundPath = prefs.getString(_soundKey) ?? 'default';

    return soundPath.toLowerCase() != 'default' ? soundPath.split('.').first : null;
  }

  // Notification details (kaisa dikhega)
  Future<NotificationDetails> _notificationDetails() async {
    final selectedSound = await _getSelectedSoundPath();

    final sound = selectedSound != null
        ? RawResourceAndroidNotificationSound(selectedSound)
        : null;

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
      ),
    );
  }

  // --- Zaroori Functions ---

  // 1. Notification Schedule Karna
  Future<void> scheduleNotification(Task task) async {
    // 💡 FIX 2: Agar due date nahi hai, ya Timezone initialize nahi hua (jo ab main.dart se ho raha hai) toh return karo.
    // NOTE: Agar initTimezone fail hua toh tz.local default location utha lega (jo theek nahi hai, but app crash nahi hogi).
    if (task.dueDate == null) return;

    // Task ID ko use karein, ya agar null ho toh fallback use karein
    final notificationId = task.id ?? DateTime.now().millisecondsSinceEpoch % 100000;

    // DueDate ko local time zone mein convert karein
    final scheduledTime = tz.TZDateTime.from(task.dueDate!, tz.local);

    // ✅ CRITICAL FIX: isBefore check mein TZDateTime.now() use karein
    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)))) {
      debugPrint('Notification time is in the past or too near. Skipping scheduling.');
      return;
    }

    final details = await _notificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'REMINDER: ${task.title}',
      'Your task is due!',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents: DateTimeComponents.time, // Yeh theek hai ki yeh removed hai
    );
  }

  // 2. Notification Cancel Karna
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
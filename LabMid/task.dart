// lib/models/task.dart

import 'subtask.dart'; // Subtask model ko zaroor import karein

class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String priority; // e.g., 'Low', 'Medium', 'High'
  final String? repeat; // e.g., 'Daily', 'Weekly'
  final bool isCompleted;

  // --- NEW FIELD 1: Repeating Task status save karne ke liye ---
  final bool isRepeatingEnabled;
  // -------------------------------------------------------------

  // ✅ FIX: 1/7 - Notification fields add kiye
  final bool isNotificationEnabled; // Notification on/off
  final Duration? notificationTime;   // Kitni der pehle (Duration stored as milliseconds)
  final String? notificationSound;    // Sound name (e.g., 'Default', 'chime.mp3')
  // ----------------------------------------------------------

  final List<Subtask>? subtasks; // List of associated subtasks

  // --- FIX 1: New fields for Activity Log ---
  final DateTime createdAt;
  final DateTime updatedAt;
  // ------------------------------------------

  const Task({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    this.repeat,
    this.isCompleted = false,

    // --- NEW FIELD 2: Constructor mein add karein (Default true rakhein) ---
    this.isRepeatingEnabled = true,
    // ----------------------------------------------------------------------

    // ✅ FIX: 2/7 - Notification fields constructor mein shamil kiye
    this.isNotificationEnabled = true, // Default: ON
    this.notificationTime = const Duration(minutes: 15), // Default: 15 minutes
    this.notificationSound = 'Default', // Default: System Default
    // ------------------------------------------------------------

    this.subtasks,
    // FIX 2: Constructor mein require karein
    required this.createdAt,
    required this.updatedAt,
  });

  // --- 1. Database Conversion (Task object to Map) ---
  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'description': description,
      // FIX 3: DateTime ko Integer (millisecondsSinceEpoch) mein convert karein.
      'due_date': dueDate?.millisecondsSinceEpoch,
      'repeat': repeat,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,

      // --- NEW FIELD 3: Map mein shamil karein (Boolean to Integer) ---
      'is_repeating_enabled': isRepeatingEnabled ? 1 : 0,
      // ------------------------------------------------------------------

      // ✅ FIX: 3/7 - Notification fields ko Map mein shamil kiya
      'is_notification_enabled': isNotificationEnabled ? 1 : 0,
      'notification_time': notificationTime?.inMilliseconds, // Duration ko milliseconds mein store karein
      'notification_sound': notificationSound,
      // ----------------------------------------------------------

      // --- FIX 4: New fields ko Map mein shamil karein ---
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      // --------------------------------------------------
    };

    // FIX: Naye task (id == null) ke liye, ID ko Map se hata dein taaki database auto-increment ho sake.
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  // --- 2. Database Conversion (Map to Task object) ---
  factory Task.fromMap(Map<String, dynamic> map) {
    // Helper function for converting integer to DateTime
    DateTime? _getDateTimeFromMap(String key) {
      final value = map[key];
      return (value != null && value is int)
          ? DateTime.fromMillisecondsSinceEpoch(value)
          : null;
    }

    // Helper function for converting integer (ms) to Duration
    Duration? _getDurationFromMap(String key) {
      final value = map[key];
      return (value != null && value is int)
          ? Duration(milliseconds: value)
          : null;
    }


    // Default value for DateTime (agar database mein koi value nahi hai)
    final defaultDate = DateTime.now();

    // FIX 5: DateTime.fromMillisecondsSinceEpoch ko use karke values wapas lein
    final createdAt = _getDateTimeFromMap('created_at') ?? defaultDate;
    final updatedAt = _getDateTimeFromMap('updated_at') ?? defaultDate;

    // NEW FIELD 4: Check if column exists, else default to true
    final isRepeatingEnabledValue = map['is_repeating_enabled'] as int?;

    // ✅ FIX: 4/7 - Notification fields ki values lein
    final isNotificationEnabledValue = map['is_notification_enabled'] as int?;
    final notificationTimeDuration = _getDurationFromMap('notification_time');
    final notificationSoundName = map['notification_sound'] as String?;
    // ------------------------------------------------------------


    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,

      // FIX 6: Integer (milliseconds) ko wapas DateTime mein convert karein.
      dueDate: _getDateTimeFromMap('due_date'),

      priority: map['priority'] as String,
      repeat: map['repeat'] as String?,

      // FIX 7: Integer (0 ya 1) ko wapas boolean mein convert karein.
      isCompleted: (map['is_completed'] as int) == 1,

      // --- NEW FIELD 5: Integer (0 ya 1) ko wapas boolean mein convert karein ---
      isRepeatingEnabled: isRepeatingEnabledValue == 1,
      // --------------------------------------------------------------------------

      // ✅ FIX: 5/7 - Notification fields ko Task constructor mein pass karein
      isNotificationEnabled: isNotificationEnabledValue == 1,
      notificationTime: notificationTimeDuration,
      notificationSound: notificationSoundName,
      // --------------------------------------------------------------------

      subtasks: const [],

      // --- FIX 8: New fields ko Task constructor mein pass karein ---
      createdAt: createdAt,
      updatedAt: updatedAt,
      // ------------------------------------------------------------
    );
  }

  // --- 3. copyWith method (Used for updating objects in DatabaseHelper) ---
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? repeat,
    bool? isCompleted,

    // --- NEW FIELD 6: copyWith mein bhi shamil karein ---
    bool? isRepeatingEnabled,
    // ----------------------------------------------------

    // ✅ FIX: 6/7 - Notification fields ko copyWith mein shamil kiya
    bool? isNotificationEnabled,
    Duration? notificationTime,
    String? notificationSound,
    // ------------------------------------------------------------

    List<Subtask>? subtasks,
    // FIX 9: copyWith mein bhi shamil karein
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      repeat: repeat ?? this.repeat,
      isCompleted: isCompleted ?? this.isCompleted,

      // --- NEW FIELD 7: copyWith logic ---
      isRepeatingEnabled: isRepeatingEnabled ?? this.isRepeatingEnabled,
      // -----------------------------------

      // ✅ FIX: 7/7 - Notification fields ki copyWith logic
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      notificationSound: notificationSound ?? this.notificationSound,
      // ---------------------------------------------------

      subtasks: subtasks ?? this.subtasks,

      // --- FIX 10: copyWith logic ---
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // -----------------------------
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  String _currentFilter = 'All';
  bool _todayUnlockRemindersEnabled = false;

  final NotificationService _notificationService = NotificationService();
  static const String _unlockReminderPrefKey = 'today_unlock_reminders_enabled';
  static const String _pendingCountPrefKey = 'pending_today_count';
  static const String _pendingTitlesPrefKey = 'pending_today_titles';
  static const String _pendingPreviewPrefKey = 'pending_today_preview';

  List<Task> get allTasks => _tasks;

  // Completed list shows all completed tasks
  // For repeating tasks, completed copies are created and shown here
  List<Task> get completedTasks {
    return _tasks.where((task) {
      // Only show tasks that are completed
      if (!task.isCompleted) return false;
      
      // Exclude active repeating tasks (they are rolled forward, not completed)
      // Completed copies of repeating tasks have isRepeatingEnabled=false, so they will show here
      final isRepeating = _isTaskRepeating(task);
      if (isRepeating) return false;
      
      // Task is completed and not actively repeating - show in completed list
      return true;
    }).toList();
  }

  // Active (incomplete) tasks filtered by category (repeat tasks stay active as we roll them forward)
  List<Task> get tasks {
    final activeTasks = _tasks.where((task) => !task.isCompleted).toList();

    if (_currentFilter == 'All') return activeTasks;

    final normalizedFilter = _currentFilter.toLowerCase();
    return activeTasks
        .where((task) => task.category.toLowerCase() == normalizedFilter)
        .toList();
  }

  String get currentFilter => _currentFilter;
  bool get todayUnlockRemindersEnabled => _todayUnlockRemindersEnabled;
  List<Task> get pendingTodayTasks => _computePendingTodayTasks(_tasks);

  TaskProvider() {
    fetchTasks();
    _loadUnlockReminderPreference();
  }

  Future<void> _loadUnlockReminderPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _todayUnlockRemindersEnabled =
        prefs.getBool(_unlockReminderPrefKey) ?? false;
    notifyListeners();
  }

  Future<void> setTodayUnlockRemindersEnabled(bool value) async {
    _todayUnlockRemindersEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_unlockReminderPrefKey, value);
    await _syncPendingSummaryForNative();
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    _tasks = await DatabaseHelper.instance.readAllTasks();

    _tasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    await _syncPendingSummaryForNative();
    // Explicitly notify listeners to update UI
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final createdTask = await DatabaseHelper.instance.create(task);
    await fetchTasks();

    if (createdTask.dueDate != null && createdTask.isNotificationEnabled) {
      _notificationService.scheduleNotification(createdTask);
    }
  }

  Future<void> toggleRepeatingTaskStatus(Task task) async {
    final updatedTask = task.copyWith(
      isRepeatingEnabled: !task.isRepeatingEnabled,
      updatedAt: DateTime.now(),
    );
    await updateTask(updatedTask);
  }

  Future<void> updateTask(Task task) async {
    if (task.id != null) {
      await _notificationService.cancelNotification(task.id!);
    }

    await DatabaseHelper.instance.update(task);

    // Update local list immediately
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = task;
    }

    if (task.dueDate != null &&
        !task.isCompleted &&
        task.isNotificationEnabled) {
      _notificationService.scheduleNotification(task);
    }

    // Refresh from database to ensure consistency
    await fetchTasks();
    // Explicitly notify listeners to update UI
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    await _notificationService.cancelNotification(id);
    _tasks.removeWhere((task) => task.id == id);
    await _syncPendingSummaryForNative();
    notifyListeners();
  }

  // Old direct complete (kept for backward compatibility)
  Future<void> completeTask(Task task) async {
    await toggleTaskCompletion(task);
  }

  // NEW: Toggle completion with repeat rollover
  Future<void> toggleTaskCompletion(Task task) async {
    // If marking incomplete manually
    if (task.isCompleted) {
      final reopened = task.copyWith(
        isCompleted: false,
        updatedAt: DateTime.now(),
      );
      await updateTask(reopened);
      return;
    }

    // If repeating, mark this occurrence as completed and create a fresh one for the next schedule
    if (_isTaskRepeating(task) && task.dueDate != null) {
      final now = DateTime.now();
      final todayDate = DateTime(now.year, now.month, now.day);

      // 1) Mark this occurrence as completed (so it moves to archive)
      final completedTask = task.copyWith(
        isCompleted: true,
        isRepeatingEnabled: false,
        dueDate: todayDate,
        updatedAt: now,
      );
      await updateTask(completedTask);

      // 2) Create a fresh task for the next schedule
      final nextDue = _computeNextDueDate(task.dueDate!, task.repeat!);
      final clonedSubtasks = task.subtasks?.map((subtask) {
        return Subtask(
          id: null,
          taskId: 0,
          title: subtask.title,
          isCompleted: false,
        );
      }).toList();

      final nextTask = Task(
        title: task.title,
        description: task.description,
        dueDate: nextDue,
        priority: task.priority,
        repeat: task.repeat,
        isCompleted: false,
        isRepeatingEnabled: true,
        isNotificationEnabled: task.isNotificationEnabled,
        notificationTime: task.notificationTime,
        notificationSound: task.notificationSound,
        subtasks: clonedSubtasks,
        createdAt: now,
        updatedAt: now,
        category: task.category,
      );

      await addTask(nextTask);
      return;
    } else {
      // Non-repeating task: mark as completed with today's date
      final now = DateTime.now();
      final todayDate = DateTime(now.year, now.month, now.day);
      final completedTask = task.copyWith(
        isCompleted: true,
        dueDate: todayDate, // Set to today's date when completed
        updatedAt: now,
      );
      await updateTask(completedTask);
    }
  }

  bool _isTaskRepeating(Task task) {
    // Task is repeating if:
    // 1. Repeat field is set and not "Does not repeat"
    // 2. AND isRepeatingEnabled flag is true (repeating can be paused)
    final hasRepeatField = task.repeat != null &&
        task.repeat!.isNotEmpty &&
        task.repeat != 'Does not repeat';
    
    // Both conditions must be true: repeat field set AND enabled
    return hasRepeatField && (task.isRepeatingEnabled == true);
  }

  DateTime _computeNextDueDate(DateTime current, String repeatRule) {
    switch (repeatRule) {
      case 'Daily':
        return current.add(const Duration(days: 1));
      case 'Weekly':
        return current.add(const Duration(days: 7));
      case 'Monthly':
        return DateTime(
          current.year,
          current.month + 1,
          _safeDayInMonth(current.year, current.month + 1, current.day),
          current.hour,
          current.minute,
          current.second,
          current.millisecond,
          current.microsecond,
        );
      case 'Yearly':
        return DateTime(
          current.year + 1,
          current.month,
          _safeDayInMonth(current.year + 1, current.month, current.day),
          current.hour,
          current.minute,
          current.second,
          current.millisecond,
          current.microsecond,
        );
      default:
      // Fallback: just mark completed if unknown rule
        return current;
    }
  }

  int _safeDayInMonth(int year, int month, int desiredDay) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return desiredDay <= lastDay ? desiredDay : lastDay;
  }

  Future<void> restoreTasks(List<Task> importedTasks) async {
    for (final task in _tasks) {
      if (task.id != null) {
        await _notificationService.cancelNotification(task.id!);
      }
    }

    await DatabaseHelper.instance.deleteAllTasks();

    for (final task in importedTasks) {
      await DatabaseHelper.instance.create(task);
    }

    await fetchTasks();

    for (final task in _tasks) {
      if (task.dueDate != null &&
          !task.isCompleted &&
          task.isNotificationEnabled) {
        _notificationService.scheduleNotification(task);
      }
    }

    await _syncPendingSummaryForNative();
  }

  Future<List<Task>> getAllTasksForExport() async {
    return await DatabaseHelper.instance.getAllTasks();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  List<Task> _computePendingTodayTasks(List<Task> taskList) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return taskList.where((task) {
      if (task.isCompleted) return false;
      final dueDate = task.dueDate;
      if (dueDate == null) {
        return true;
      }
      return dueDate.isBefore(todayEnd);
    }).toList();
  }

  Future<void> showTodayUnlockReminder(List<Task> pendingTasks) async {
    if (pendingTasks.isEmpty || !_todayUnlockRemindersEnabled) return;
    await _syncPendingSummaryForNative();
    await _notificationService.showTodaySummaryNotification(pendingTasks);
  }

  Future<void> _syncPendingSummaryForNative() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pending = _computePendingTodayTasks(_tasks);
      await prefs.setInt(_pendingCountPrefKey, pending.length);

      if (pending.isEmpty) {
        await prefs.setString(_pendingTitlesPrefKey, '');
        await prefs.setString(_pendingPreviewPrefKey, '');
        return;
      }

      final sanitizedTitles = pending
          .take(5)
          .map((task) => task.title.replaceAll('|', ' ').trim())
          .where((title) => title.isNotEmpty)
          .toList();

      await prefs.setString(
        _pendingTitlesPrefKey,
        sanitizedTitles.join('|'),
      );
      await prefs.setString(
        _pendingPreviewPrefKey,
        sanitizedTitles.isNotEmpty ? sanitizedTitles.first : pending.first.title,
      );
    } catch (_) {
      // Ignore sync errors silently
    }
  }
}
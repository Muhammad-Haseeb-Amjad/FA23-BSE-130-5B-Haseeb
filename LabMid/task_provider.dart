// lib/providers/task_provider.dart (Persistence Logic Added)

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
// FIX 1: Notification Service import karein
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  String _currentFilter = 'All';

  // FIX 2: Notification Service ka instance
  final NotificationService _notificationService = NotificationService();

  // --- NEW GETTER 1: Calendar View ke liye zaroori (Sare tasks dega) ---
  List<Task> get allTasks {
    return _tasks;
  }

  // --- NEW GETTER 2: Completed Tasks Archive ke liye zaroori ---
  List<Task> get completedTasks {
    return _tasks.where((task) => task.isCompleted).toList();
  }
  // -------------------------------------------------------------

  List<Task> get tasks {
    // Filter logic: Only return tasks that are NOT completed
    if (_currentFilter == 'All') {
      return _tasks.where((task) => !task.isCompleted).toList();
    }
    // Note: Category filtering ke liye Task model mein 'category' field chahiye.
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  String get currentFilter => _currentFilter;

  TaskProvider() {
    fetchTasks();
  }

  // Load tasks from database
  Future<void> fetchTasks() async {
    _tasks = await DatabaseHelper.instance.readAllTasks();

    // --- FIX: Sorting logic added to resolve "The operator '>'" error ---
    _tasks.sort((a, b) {
      // Null due dates ko list ke aakhir mein bhejte hain
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      // Date objects ko compare karte hain
      return a.dueDate!.compareTo(b.dueDate!);
    });
    // -------------------------------------------------------------------

    notifyListeners();
  }

  // --- NEW: addTask method implemented to save new tasks ---
  Future<void> addTask(Task task) async {
    // 1. Database mein task daalen aur naya ID obtain karein
    final createdTask = await DatabaseHelper.instance.create(task);

    // 2. Poori list ko refresh karein jisse naya task list mein aa jaye aur sorting/filtering ho jaye
    await fetchTasks();

    // ✅ FIX 3: Notification schedule karein + isNotificationEnabled check kiya
    if (createdTask.dueDate != null && createdTask.isNotificationEnabled) {
      _notificationService.scheduleNotification(createdTask);
    }
    // notifyListeners() is inside fetchTasks()
  }
  // --------------------------------------------------------

  // --- NEW FUNCTION: Repeated task status toggle karne ke liye ---
  Future<void> toggleRepeatingTaskStatus(Task task) async {
    // 1. Task ki copy banayein aur status toggle karein
    final updatedTask = task.copyWith(
      isRepeatingEnabled: !task.isRepeatingEnabled,
      updatedAt: DateTime.now(),
    );

    // 2. updatedTask ko database mein update karein.
    await updateTask(updatedTask);
  }
  // -------------------------------------------------------------

  // --- FIX 1: Missing updateTask method added (Already in your code) ---
  Future<void> updateTask(Task task) async {
    // FIX 4: Update par purani notification cancel karein (Naye ID ki zaroorat nahi)
    if (task.id != null) {
      await _notificationService.cancelNotification(task.id!);
    }

    // Task ko database mein update karein
    await DatabaseHelper.instance.update(task);

    // Local list mein task ki position dhoondhein aur usse update karein
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);

    if (taskIndex != -1) {
      _tasks[taskIndex] = task;
    }

    // ✅ FIX 5: Agar task complete nahi hua, due date hai, AUR notification enabled hai, toh naya notification schedule karein
    if (task.dueDate != null && !task.isCompleted && task.isNotificationEnabled) {
      _notificationService.scheduleNotification(task);
    }

    // FetchTasks() automatic sorting aur filtering ko handle karega.
    await fetchTasks();
  }
  // ----------------------------------------------------

  // Delete Task
  Future<void> deleteTask(int id) async {
    // FIX 1: Database delete operation ko enable karein
    await DatabaseHelper.instance.delete(id);

    // FIX 6: Notification cancel karein
    await _notificationService.cancelNotification(id);

    // List se remove karein
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  // Mark Task as Complete (Swipe Right Action)
  Future<void> completeTask(Task task) async {
    // Task model mein copyWith use karein
    final completedTask = task.copyWith(isCompleted: true, updatedAt: DateTime.now());

    // FIX 2: Database update operation ko enable karein (updateTask method ko call karein)
    await updateTask(completedTask);

    // FIX 7: Task complete hone par notification cancel ho jayega kyunki updateTask call hua hai.
  }

  // --- NEW FUNCTION: Task Restoration/Replacement (Renamed to fix error) ---
  Future<void> restoreTasks(List<Task> importedTasks) async {
    // 1. Purani saari notifications cancel karein
    for (final task in _tasks) {
      if (task.id != null) {
        await _notificationService.cancelNotification(task.id!);
      }
    }

    // 2. Database mein maujood saare tasks ko delete karein
    await DatabaseHelper.instance.deleteAllTasks();

    // 3. Naye tasks ko database mein insert karein aur naye IDs obtain karein
    for (final task in importedTasks) {
      await DatabaseHelper.instance.create(task);
    }

    // 4. Data ko fetch karein aur notifications schedule karein
    await fetchTasks();

    // 5. Naye schedule kiye gaye tasks ke liye notifications schedule karein
    for (final task in _tasks) {
      if (task.dueDate != null && !task.isCompleted && task.isNotificationEnabled) {
        _notificationService.scheduleNotification(task);
      }
    }

    // notifyListeners() is inside fetchTasks()
  }
  // -------------------------------------------------

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }
}

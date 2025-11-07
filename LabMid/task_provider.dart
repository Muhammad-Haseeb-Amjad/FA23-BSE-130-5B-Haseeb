import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  String _currentFilter = 'All'; // 'All', 'Work', 'Personal'

  List<Task> get tasks {
    // Filter logic
    if (_currentFilter == 'All') {
      return _tasks.where((task) => !task.isCompleted).toList();
    }
    // Note: For 'Work' and 'Personal', you'd need a category field
    // in your Task model and database schema.
    // For now, we'll just filter by completion status.
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  // Getter for filters (for the chip UI)
  String get currentFilter => _currentFilter;

  TaskProvider() {
    fetchTasks();
  }

  // Load tasks from database
  Future<void> fetchTasks() async {
    _tasks = await DatabaseHelper.instance.readAllTasks();
    notifyListeners();
  }

  // Delete Task
  Future<void> deleteTask(int id) async {
    // Assuming you add a delete method in DatabaseHelper
    // await DatabaseHelper.instance.delete(id);

    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  // Mark Task as Complete (Swipe Right Action)
  Future<void> completeTask(Task task) async {
    final completedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      repeat: task.repeat,
      priority: task.priority,
      isCompleted: true, // Mark as complete
    );

    // Assuming you add an update method in DatabaseHelper
    // await DatabaseHelper.instance.update(completedTask);

    // Remove from the current list (since 'tasks' getter filters incomplete ones)
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }
}
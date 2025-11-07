// lib/models/task.dart

import 'subtask.dart'; // Assuming you have a Subtask model

class Task {
  int? id; // Database ID (Nullable for new tasks)
  String title;
  String? description;
  DateTime? dueDate;
  String priority; // e.g., 'Low', 'Medium', 'High'
  bool isCompleted;
  String? repeat; // e.g., 'Daily', 'Weekly', 'Does not repeat'
  // String? category; // You can add this if needed, based on TodayTasksScreen filtering
  List<Subtask>? subtasks;

  Task({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
    this.repeat,
    this.subtasks,
  });

  // -----------------------------------------------------------------
  // ADDED: copyWith method to solve the "The method 'copyWith' isn't defined" error.
  // This allows the DatabaseHelper to assign the generated ID to the Task object.
  // -----------------------------------------------------------------
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
    String? repeat,
    List<Subtask>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      repeat: repeat ?? this.repeat,
      subtasks: subtasks ?? this.subtasks,
    );
  }
  // -----------------------------------------------------------------

  // --- Database Helper Methods (Optional but Recommended) ---

  // Converts a Task object into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // Store DateTime as integer (milliseconds since epoch)
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'priority': priority,
      // Store boolean as integer (0 or 1)
      'isCompleted': isCompleted ? 1 : 0,
      'repeat': repeat,
    };
  }

  // Creates a Task object from a Map (database retrieval)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : null,
      priority: map['priority'] as String? ?? 'Medium',
      isCompleted: map['isCompleted'] == 1,
      repeat: map['repeat'] as String?,
      // Subtasks need to be loaded separately using another query
      subtasks: [],
    );
  }
}
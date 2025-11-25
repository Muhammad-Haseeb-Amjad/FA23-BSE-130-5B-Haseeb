// lib/models/subtask.dart

class Subtask {
  int? id; // Database ID (Nullable for new subtasks)
  int taskId; // Foreign key linking it to the main Task
  String title;
  bool isCompleted;

  Subtask({
    this.id,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
  });

  // --- Database Helper Methods ---

  // Converts a Subtask object into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      // Store boolean as integer (0 or 1)
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Creates a Subtask object from a Map (database retrieval)
  factory Subtask.fromMap(Map<String, dynamic> map) {
    // Note: We cast map values to their expected types
    return Subtask(
      id: map['id'] as int?,
      taskId: map['taskId'] as int,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

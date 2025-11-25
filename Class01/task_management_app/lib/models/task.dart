import 'dart:convert';


class Task {
  int? id;
  String title;
  String description;
  DateTime? dueDate;
  bool completed;
  String? repeat; // e.g. "none", "daily", "weekly"
  List<int>? repeatWeekdays; // 1..7 for Mon..Sun
  int? notificationId;


  Task({
    this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.completed = false,
    this.repeat = 'none',
    this.repeatWeekdays,
    this.notificationId,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed ? 1 : 0,
      'repeat': repeat,
      'repeatWeekdays': repeatWeekdays != null ? jsonEncode(repeatWeekdays) : null,
      'notificationId': notificationId,
    };
  }


  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      completed: (map['completed'] ?? 0) == 1,
      repeat: map['repeat'] ?? 'none',
      repeatWeekdays: map['repeatWeekdays'] != null ? List<int>.from(jsonDecode(map['repeatWeekdays'])) : null,
      notificationId: map['notificationId'] as int?,
    );
  }
}
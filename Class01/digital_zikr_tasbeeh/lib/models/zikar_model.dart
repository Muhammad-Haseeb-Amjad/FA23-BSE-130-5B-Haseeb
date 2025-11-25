// lib/models/zikar_model.dart

class ZikarModel {
  int? id;
  String name;
  String? arabicText;
  int count;
  int? targetCount;
  String? reminderTime; // e.g., "12:00"
  String? reminderDays; // e.g., "Mon,Tue,Fri"

  ZikarModel({
    this.id,
    required this.name,
    this.arabicText,
    this.count = 0,
    this.targetCount,
    this.reminderTime,
    this.reminderDays,
  });

  // Convert Zikar object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'arabic_text': arabicText,
      'count': count,
      'target_count': targetCount,
      'reminder_time': reminderTime,
      'reminder_days': reminderDays,
    };
  }

  // Convert a Map to a Zikar object
  factory ZikarModel.fromMap(Map<String, dynamic> map) {
    return ZikarModel(
      id: map['id'],
      name: map['name'],
      arabicText: map['arabic_text'],
      count: map['count'],
      targetCount: map['target_count'],
      reminderTime: map['reminder_time'],
      reminderDays: map['reminder_days'],
    );
  }
}
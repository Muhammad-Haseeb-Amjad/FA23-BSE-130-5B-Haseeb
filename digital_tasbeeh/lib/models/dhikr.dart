class Dhikr {
  final String id;
  String name;
  String description;
  int currentCount;
  int? targetCount;
  bool hasTarget;
  String icon;
  bool isCompleted;

  Dhikr({
    required this.id,
    required this.name,
    this.description = '',
    this.currentCount = 0,
    this.targetCount,
    this.hasTarget = false,
    this.icon = '🌿',
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'currentCount': currentCount,
      'targetCount': targetCount,
      'hasTarget': hasTarget,
      'icon': icon,
      'isCompleted': isCompleted,
    };
  }

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      currentCount: json['currentCount'] ?? 0,
      targetCount: json['targetCount'],
      hasTarget: json['hasTarget'] ?? false,
      icon: json['icon'] ?? '🌿',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Dhikr copyWith({
    String? name,
    String? description,
    int? currentCount,
    int? targetCount,
    bool? hasTarget,
    String? icon,
    bool? isCompleted,
  }) {
    return Dhikr(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      currentCount: currentCount ?? this.currentCount,
      targetCount: targetCount ?? this.targetCount,
      hasTarget: hasTarget ?? this.hasTarget,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

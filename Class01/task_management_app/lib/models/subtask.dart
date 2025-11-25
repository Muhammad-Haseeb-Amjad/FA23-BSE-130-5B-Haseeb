class Subtask {
  int? id;
  int taskId;
  String title;
  bool done;


  Subtask({this.id, required this.taskId, required this.title, this.done = false});


  Map<String, dynamic> toMap() => {
    'id': id,
    'taskId': taskId,
    'title': title,
    'done': done ? 1 : 0,
  };


  factory Subtask.fromMap(Map<String, dynamic> m) => Subtask(
    id: m['id'] as int?,
    taskId: m['taskId'] as int,
    title: m['title'] as String,
    done: (m['done'] ?? 0) == 1,
  );
}
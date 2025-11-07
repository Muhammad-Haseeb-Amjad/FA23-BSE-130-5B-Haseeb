import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// FIX 1: Task model ko copyWith method ki zaroorat hai.
// Aur yahan Task model available hona chahiye.
import '../models/task.dart';
//import '../models/subtask.dart';
// Subtask model ko bhi import karein (optional, but good practice)

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL'; // FIX 2: SQLite BOOLEAN ko INTEGER (0/1) mein store karta hai.
    const nullableTextType = 'TEXT';
    const integerType = 'INTEGER'; // DUE DATE ko milliseconds mein store karne ke liye

    // --- 1. Tasks Table ---
    await db.execute('''
CREATE TABLE tasks ( 
  id $idType, 
  title $textType,
  description $nullableTextType,
  due_date $integerType, // FIX 3: Due Date ko Integer (Timestamp) ke roop mein store karein.
  repeat $nullableTextType,
  priority $textType,
  is_completed $boolType
  )
''');

    // --- 2. Subtasks Table (Recommended for structure) ---
    await db.execute('''
CREATE TABLE subtasks (
  id $idType,
  taskId INTEGER NOT NULL,
  title $textType,
  isCompleted $boolType,
  FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
)
''');
  }

  // Task
  Future<Task> create(Task task) async {
    final db = await instance.database;

    // Task insertion
    final id = await db.insert('tasks', task.toMap());

    // NOTE: Agar aap Task model mein copyWith method use kar rahe hain, toh woh Task model mein define hona chahiye.
    // Agar nahi hai, toh aapko naya Task object banana padega.

    // Assuming 'copyWith' is defined in Task model:
    final createdTask = task.copyWith(id: id);

    // Subtasks insertion (agar hain toh)
    if (task.subtasks != null && task.subtasks!.isNotEmpty) {
      for (var subtask in task.subtasks!) {
        final subtaskId = await db.insert('subtasks', subtask.toMap()..['taskId'] = id);
        subtask.id = subtaskId; // Update ID in the object
      }
    }

    return createdTask;
  }

  // सभी Tasks पढ़ें
  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    const orderBy = 'priority ASC'; // Example ordering
    final result = await db.query('tasks', orderBy: orderBy);

    // FIX 4: Yeh method abhi Subtasks ko load nahi kar raha hai,
    // lekin core error solving ke liye yeh code structure theek hai.
    // Subtask loading ke liye alag logic lagana padega.
    return result.map((json) => Task.fromMap(json)).toList();
  }


}
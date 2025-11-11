import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// Task and Subtask models ko import karein
import '../models/task.dart';
import '../models/subtask.dart'; // Assuming this file exists and contains the Subtask model

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
      // NOTE: Agar aap pehle se version 1 par hain, to ab aapko version 2 use karna chahiye
      // taaki database update ho sake aur nayi columns add ho sakein.
      // Agar aapne pehle kabhi database version nahi badla, to ab isko 2 kar dein.
      version: 1, // Agar aapne migration code add nahi kiya hai to isko 1 hi rehne dein,
      // lekin yaad rahe, agar app pehle se installed hai to nayi columns add nahi hongi.
      // Agar aap fresh install/reinstall kar rahe hain to 1 theek hai.
      onCreate: _createDB,
      // FIX 1: ON DELETE CASCADE ko enable karne ke liye onConfigure use karein
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const nullableTextType = 'TEXT';
    const integerType = 'INTEGER';

    // --- 1. Tasks Table ---
    await db.execute('''
CREATE TABLE tasks ( 
  id $idType, 
  title $textType,
  description $nullableTextType,
  due_date $integerType, 
  repeat $nullableTextType,
  priority $textType,
  is_completed $boolType,
  
  -- NEW COLUMN: Repeating status save karne ke liye
  is_repeating_enabled $boolType DEFAULT 1, 
  
  -- ✅ NEW NOTIFICATION COLUMNS ADDED
  is_notification_enabled $boolType DEFAULT 1, 
  notification_time $integerType, 
  notification_sound $nullableTextType, 
  -- --------------------------------
  
  -- FIX: Naye REQUIRED fields yahan add karein
  created_at $integerType NOT NULL, 
  updated_at $integerType NOT NULL
  )
''');

    // --- 2. Subtasks Table (Recommended for structure) ---
    await db.execute('''
CREATE TABLE subtasks (
  id $idType,
  taskId INTEGER NOT NULL,
  title $textType,
  isCompleted $boolType,
  -- Foreign Key jo task ke delete hone par subtask ko bhi delete karega
  FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
)
''');
  }

  // ------------------------------------
  // Task CREATE Method (UNCHANGED)
  // ------------------------------------
  Future<Task> create(Task task) async {
    final db = await instance.database;

    // 1. Task insertion
    final id = await db.insert('tasks', task.toMap());

    // Assuming 'copyWith' is defined in Task model:
    final createdTask = task.copyWith(id: id);

    // 2. Subtasks insertion (agar hain toh)
    if (createdTask.subtasks != null && createdTask.subtasks!.isNotEmpty) {
      for (var subtask in createdTask.subtasks!) {
        // Subtask mein naya taskId set karein
        // subtask.taskId = id; // Agar Subtask model mein taskId mutable hai
        try {
          // Assuming subtask has a setter for taskId or is mutable
          subtask.taskId = id;
        } catch (e) {
          // Agar subtask.taskId final hai, toh yahan Subtask.copyWith ka logic aayega.
        }

        // Subtask ko insert karein
        await db.insert('subtasks', subtask.toMap());
        // Subtask ka ID update karna optional hai, lekin object consistency ke liye theek hai
      }
    }

    return createdTask;
  }

  // ------------------------------------
  // FIX 2: Task UPDATE Method (UNCHANGED)
  // ------------------------------------
  Future<int> update(Task task) async {
    final db = await database;

    // 1. Task table update
    int result = await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

    // 2. Subtasks manage karein
    if (task.id != null) {
      // Purane subtasks delete karein
      await db.delete(
        'subtasks',
        where: 'taskId = ?',
        whereArgs: [task.id],
      );

      // Naye ya modified subtasks ko insert karein
      if (task.subtasks != null) {
        for (var subtask in task.subtasks!) {
          // Task ID ensure karein
          // subtask.taskId = task.id!; // Agar final hai toh problem dega
          try {
            // Assuming subtask has a setter for taskId or is mutable
            subtask.taskId = task.id!;
          } catch (e) {
            // Agar subtask.taskId final hai, toh yahan Subtask.copyWith ka logic aayega.
          }

          // Subtask insert
          await db.insert('subtasks', subtask.toMap());
        }
      }
    }

    return result;
  }


  // ------------------------------------
  // FIX 3: Read method mein Subtask loading add karein (UNCHANGED)
  // ------------------------------------
  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    const orderBy = 'priority ASC';
    final taskResults = await db.query('tasks', orderBy: orderBy);

    if (taskResults.isEmpty) {
      return [];
    }

    // Tasks ko hydrate karein aur saath mein Subtasks load karein
    final List<Task> tasks = [];
    for (final taskJson in taskResults) {
      // 1. Task object banayein
      final task = Task.fromMap(taskJson);

      // 2. Subtasks load karein
      final subtaskResults = await db.query(
        'subtasks',
        where: 'taskId = ?',
        whereArgs: [task.id],
      );

      // 3. Subtask list banayein
      final List<Subtask> subtasks = subtaskResults.map((json) => Subtask.fromMap(json)).toList();

      // 4. Task object mein subtasks add karein (assuming Task model mein 'subtasks' property hai)
      tasks.add(task.copyWith(subtasks: subtasks));
    }

    return tasks;
  }

  // Optionally, Task read by ID method
  // Future<Task> readTask(int id) async { ... }

  // Task delete method
  Future<int> delete(int id) async {
    final db = await instance.database;
    // Task delete hone par 'ON DELETE CASCADE' ki wajah se subtasks automatically delete ho jayenge.
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- NEW FUNCTION: Delete All Tasks (Restore Support) ---
  // Restore se pehle saare tasks ko hamesha ke liye delete karta hai
  Future<void> deleteAllTasks() async {
    final db = await instance.database;
    // DELETE FROM tasks; query chala kar saare rows hata diye jate hain
    // ON DELETE CASCADE ki wajah se subtasks table bhi clean ho jayega.
    await db.delete('tasks');
  }
}

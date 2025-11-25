import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/subtask.dart';

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
      version: 2,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const nullableTextType = 'TEXT';
    const integerType = 'INTEGER';

    await db.execute('''
CREATE TABLE tasks ( 
  id $idType, 
  title $textType,
  description $nullableTextType,
  due_date $integerType, 
  repeat $nullableTextType,
  priority $textType,
  is_completed $boolType,
  is_repeating_enabled $boolType DEFAULT 1, 
  is_notification_enabled $boolType DEFAULT 1, 
  notification_time $integerType, 
  notification_sound $nullableTextType, 
  created_at $integerType NOT NULL, 
  updated_at $integerType NOT NULL,
  category $textType DEFAULT 'Personal'
  )
''');

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

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE tasks ADD COLUMN category TEXT DEFAULT 'Personal'",
      );
    }
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;

    final id = await db.insert('tasks', task.toMap());
    final createdTask = task.copyWith(id: id);

    if (createdTask.subtasks != null && createdTask.subtasks!.isNotEmpty) {
      for (var subtask in createdTask.subtasks!) {
        try {
          subtask.taskId = id;
        } catch (e) {
          // Handle if taskId is final
        }
        await db.insert('subtasks', subtask.toMap());
      }
    }

    return createdTask;
  }

  Future<int> update(Task task) async {
    final db = await database;

    int result = await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

    if (task.id != null) {
      await db.delete('subtasks', where: 'taskId = ?', whereArgs: [task.id]);

      if (task.subtasks != null) {
        for (var subtask in task.subtasks!) {
          try {
            subtask.taskId = task.id!;
          } catch (e) {
            // Handle if taskId is final
          }
          await db.insert('subtasks', subtask.toMap());
        }
      }

      // ✅ REMOVED: _scheduleNextRepetition logic removed because TaskProvider
      // already handles repeating task rollover in toggleTaskCompletion().
      // This was causing duplicate tasks to be created.
    }

    return result;
  }

  // ✅ REMOVED: _scheduleNextRepetition function removed because TaskProvider
  // already handles repeating task rollover in toggleTaskCompletion().
  // This prevents duplicate task creation.

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    const orderBy = 'priority ASC';
    final taskResults = await db.query('tasks', orderBy: orderBy);

    if (taskResults.isEmpty) {
      return [];
    }

    final List<Task> tasks = [];
    for (final taskJson in taskResults) {
      final task = Task.fromMap(taskJson);

      final subtaskResults = await db.query(
        'subtasks',
        where: 'taskId = ?',
        whereArgs: [task.id],
      );

      final List<Subtask> subtasks = subtaskResults
          .map((json) => Subtask.fromMap(json))
          .toList();

      tasks.add(task.copyWith(subtasks: subtasks));
    }

    return tasks;
  }

  Future<Task?> readTask(int id) async {
    final db = await database;
    final taskResults = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (taskResults.isEmpty) return null;

    final task = Task.fromMap(taskResults.first);

    final subtaskResults = await db.query(
      'subtasks',
      where: 'taskId = ?',
      whereArgs: [task.id],
    );

    final List<Subtask> subtasks = subtaskResults
        .map((json) => Subtask.fromMap(json))
        .toList();

    return task.copyWith(subtasks: subtasks);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllTasks() async {
    final db = await instance.database;
    await db.delete('tasks');
  }

  Future<List<Task>> getAllTasks() async {
    return await readAllTasks();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
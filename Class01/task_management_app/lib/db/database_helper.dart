import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/task.dart';
import '../models/subtask.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'tasks.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        completed INTEGER,
        repeat TEXT,
        repeatWeekdays TEXT,
        notificationId INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE subtasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER,
        title TEXT,
        done INTEGER
      )
    ''');
  }

  // Task CRUD
  Future<int> insertTask(Task task) async {
    final database = await db;
    return await database.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final database = await db;
    return await database.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final database = await db;
    await database.delete('subtasks', where: 'taskId = ?', whereArgs: [id]);
    return await database.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getAllTasks() async {
    final database = await db;
    final maps = await database.query('tasks', orderBy: 'dueDate ASC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<Task?> getTask(int id) async {
    final database = await db;
    final maps = await database.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Task.fromMap(maps.first);
  }

  // Subtasks
  Future<int> insertSubtask(Subtask s) async {
    final database = await db;
    return await database.insert('subtasks', s.toMap());
  }

  Future<int> updateSubtask(Subtask s) async {
    final database = await db;
    return await database.update('subtasks', s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  }

  Future<int> deleteSubtask(int id) async {
    final database = await db;
    return await database.delete('subtasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Subtask>> getSubtasksForTask(int taskId) async {
    final database = await db;
    final maps = await database.query('subtasks', where: 'taskId = ?', whereArgs: [taskId]);
    return maps.map((m) => Subtask.fromMap(m)).toList();
  }
}
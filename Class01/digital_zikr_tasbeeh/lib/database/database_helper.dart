// lib/database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/zikar_model.dart';

class DatabaseHelper {
  static const _databaseName = "ZikrTasbeeh.db";
  static const _databaseVersion = 1;
  static const zikarTable = 'zikar_table';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create the table
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $zikarTable (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            arabic_text TEXT,
            count INTEGER NOT NULL,
            target_count INTEGER,
            reminder_time TEXT,
            reminder_days TEXT
          )
          ''');
  }

  // --- CRUD Operations ---

  // Insert Zikar (Used when saving a new zikar)
  Future<int> insertZikar(ZikarModel zikar) async {
    Database db = await instance.database;
    return await db.insert(zikarTable, zikar.toMap());
  }

  // Get all Zikar (Used for Zikar List Screen)
  Future<List<ZikarModel>> getAllZikar() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(zikarTable);
    return List.generate(maps.length, (i) {
      return ZikarModel.fromMap(maps[i]);
    });
  }

  // Update Zikar (Used for editing or saving current count)
  Future<int> updateZikar(ZikarModel zikar) async {
    Database db = await instance.database;
    return await db.update(
      zikarTable,
      zikar.toMap(),
      where: 'id = ?',
      whereArgs: [zikar.id],
    );
  }

  // Delete Zikar (Used in Zikar List Screen)
  Future<int> deleteZikar(int id) async {
    Database db = await instance.database;
    return await db.delete(
      zikarTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
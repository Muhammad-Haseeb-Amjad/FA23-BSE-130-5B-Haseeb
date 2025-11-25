import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../models/patient_model.dart';
import '../models/visit_model.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dr_assistant.db');
    return _database!;
  }

  Future<String> get _dbPath async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'dr_assistant.db');
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

  // Tables banane ka function
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';
    const integerType = 'INTEGER NOT NULL';

    // Patients Table
    await db.execute('''
      CREATE TABLE patients (
        id $idType,
        name $textType,
        phone $textType,
        email $textNullable,
        age $integerType,
        gender $textType,
        address $textType,
        notes $textNullable,
        creationDate $textType   // ✅ 'creationDate' column
      )
    ''');

    // Visits Table
    await db.execute('''
      CREATE TABLE visits (
        id $idType,
        patient_id $integerType,
        visit_date $textType,
        diagnosis $textNullable,
        treatment $textNullable,
        notes $textNullable,
        prescription_image_path $textNullable,
        FOREIGN KEY(patient_id) REFERENCES patients(id)
      )
    ''');
  }

  // --- PATIENT CRUD OPERATIONS ---

  Future<int> insertPatient(Patient patient) async {
    final db = await database;
    // Patient object ke toMap() mein creationDate add karke save kiya
    return await db.insert('patients', patient.toMap()..['creationDate'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
  }

  Future<List<Patient>> getAllPatients() async {
    final db = await database;
    final result = await db.query('patients', orderBy: 'id DESC');
    return result.map((json) => Patient.fromMap(json)).toList();
  }

  Future<List<Patient>> getRecentPatients(int limit) async {
    final db = await database;
    final result = await db.query('patients', orderBy: 'id DESC', limit: limit);
    return result.map((json) => Patient.fromMap(json)).toList();
  }

  Future<List<Patient>> searchPatients(String query) async {
    final db = await database;
    final result = await db.query(
      'patients',
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return result.map((json) => Patient.fromMap(json)).toList();
  }

  Future<int> updatePatient(Patient patient) async {
    final db = await database;
    return await db.update(
      'patients',
      patient.toMap(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  Future<int> deletePatient(int id) async {
    final db = await database;
    return await db.delete(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // --- END PATIENT CRUD OPERATIONS ---


  // --- VISIT CRUD OPERATIONS ---

  Future<int> insertVisit(Visit visit) async {
    final db = await database;
    return await db.insert('visits', visit.toMap());
  }

  Future<List<Visit>> getVisitsByPatientId(int patientId) async {
    final db = await database;
    final result = await db.query(
      'visits',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'id DESC',
    );
    return result.map((json) => Visit.fromMap(json)).toList();
  }

  // --- END VISIT CRUD OPERATIONS ---


  // --- DATA MANAGEMENT FUNCTIONS ---

  // EXPORT/BACKUP FUNCTION
  Future<String> exportDatabase(String exportPath) async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }

    final originalPath = await _dbPath;
    final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');
    final exportedFile = File(join(exportPath, 'dr_assistant_backup_$timestamp.db'));

    try {
      if (await exportedFile.exists()) {
        await exportedFile.delete();
      }
      await File(originalPath).copy(exportedFile.path);
      _database = await _initDB('dr_assistant.db');
      return exportedFile.path;
    } catch (e) {
      _database = await _initDB('dr_assistant.db');
      rethrow;
    }
  }

  // IMPORT/RESTORE FUNCTION
  Future<void> importDatabase(String importedPath) async {
    final originalPath = await _dbPath;
    final originalDBFile = File(originalPath);
    final importedDBFile = File(importedPath);

    if (!await importedDBFile.exists()) {
      throw Exception('Imported file not found. Aborting restore.');
    }

    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }

    try {
      if (await originalDBFile.exists()) {
        await originalDBFile.delete();
      }
      await importedDBFile.copy(originalPath);
      _database = await _initDB('dr_assistant.db');
    } catch (e) {
      _database = await _initDB('dr_assistant.db');
      rethrow;
    }
  }

  // CLEAR ALL DATA FUNCTION
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('visits');
    await db.delete('patients');
  }

  Future<int> getNewPatientsCount(String date) async {
    final db = await database;

    final countResult = await db.rawQuery(
        'SELECT COUNT(id) FROM patients WHERE date(creationDate) = date(?)', [date]
    );

    return Sqflite.firstIntValue(countResult) ?? 0;
  }
}
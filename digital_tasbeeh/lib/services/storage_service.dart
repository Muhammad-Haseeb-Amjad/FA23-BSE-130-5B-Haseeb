import 'dart:io' show Platform;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/dhikr.dart';

class StorageService {
  static const String _dbName = 'digital_tasbeeh.db';
  static const int _dbVersion = 1;

  static const String _tableDhikrs = 'dhikrs';
  static const String _tableSettings = 'app_settings';
  static const String _tableState = 'app_state';

  static bool _ffiInitialized = false;
  static Database? _database;
  static bool _useInMemoryBackend = false;

  static List<Dhikr> _memoryDhikrs = [];
  static Map<String, dynamic> _memorySettings = {};
  static int _memoryTasbeehCount = 0;
  static String? _memoryCurrentDhikrId;

  static const Map<String, dynamic> _defaultSettings = {
    'vibration': true,
    'mute': false,
    'language': 'eng',
    'theme': 'dark',
  };

  Future<Database> get _db async {
    if (_useInMemoryBackend) {
      throw StateError('In-memory backend does not use a SQLite database.');
    }

    if (_database != null) {
      return _database!;
    }

    _ensureFfiForDesktopAndTests();

    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, _dbName);

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onOpen: (db) async {
        await _seedDefaultsIfNeeded(db);
      },
    );

    return _database!;
  }

  static void enableInMemoryBackendForTests() {
    _useInMemoryBackend = true;
    _memoryDhikrs = _defaultDhikrsStatic().map((dhikr) => dhikr.copyWith()).toList();
    _memorySettings = Map<String, dynamic>.from(_defaultSettings);
    _memoryTasbeehCount = 0;
    _memoryCurrentDhikrId = null;
  }

  void _ensureFfiForDesktopAndTests() {
    if (_ffiInitialized) {
      return;
    }

    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _ffiInitialized = true;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableDhikrs (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        current_count INTEGER NOT NULL DEFAULT 0,
        target_count INTEGER,
        has_target INTEGER NOT NULL DEFAULT 0,
        icon TEXT NOT NULL DEFAULT '🌿',
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableSettings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        vibration INTEGER NOT NULL DEFAULT 1,
        mute INTEGER NOT NULL DEFAULT 0,
        language TEXT NOT NULL DEFAULT 'eng',
        theme TEXT NOT NULL DEFAULT 'dark'
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableState (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        tasbeeh_count INTEGER NOT NULL DEFAULT 0,
        current_dhikr TEXT
      )
    ''');

    await db.insert(_tableSettings, _defaultSettingsRow());
    await db.insert(_tableState, _defaultStateRow());
    for (final dhikr in _getDefaultDhikrs()) {
      await db.insert(_tableDhikrs, _dhikrToRow(dhikr));
    }
  }

  Future<void> _seedDefaultsIfNeeded(Database db) async {
    final settingsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableSettings'),
    );
    if ((settingsCount ?? 0) == 0) {
      await db.insert(_tableSettings, _defaultSettingsRow());
    }

    final stateCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableState'),
    );
    if ((stateCount ?? 0) == 0) {
      await db.insert(_tableState, _defaultStateRow());
    }

    final dhikrCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableDhikrs'),
    );
    if ((dhikrCount ?? 0) == 0) {
      for (final dhikr in _getDefaultDhikrs()) {
        await db.insert(_tableDhikrs, _dhikrToRow(dhikr));
      }
    }
  }

  Map<String, Object?> _defaultSettingsRow() {
    return {
      'id': 1,
      'vibration': 1,
      'mute': 0,
      'language': 'eng',
      'theme': 'dark',
    };
  }

  Map<String, Object?> _defaultStateRow() {
    return {
      'id': 1,
      'tasbeeh_count': 0,
      'current_dhikr': null,
    };
  }

  Map<String, Object?> _dhikrToRow(Dhikr dhikr) {
    return {
      'id': dhikr.id,
      'name': dhikr.name,
      'description': dhikr.description,
      'current_count': dhikr.currentCount,
      'target_count': dhikr.targetCount,
      'has_target': dhikr.hasTarget ? 1 : 0,
      'icon': dhikr.icon,
      'is_completed': dhikr.isCompleted ? 1 : 0,
    };
  }

  Dhikr _rowToDhikr(Map<String, Object?> row) {
    return Dhikr(
      id: row['id'] as String,
      name: row['name'] as String,
      description: row['description'] as String? ?? '',
      currentCount: (row['current_count'] as int?) ?? 0,
      targetCount: row['target_count'] as int?,
      hasTarget: ((row['has_target'] as int?) ?? 0) == 1,
      icon: row['icon'] as String? ?? '🌿',
      isCompleted: ((row['is_completed'] as int?) ?? 0) == 1,
    );
  }

  Future<List<Dhikr>> loadDhikrs() async {
    if (_useInMemoryBackend) {
      if (_memoryDhikrs.isEmpty) {
        _memoryDhikrs = _defaultDhikrsStatic().map((dhikr) => dhikr.copyWith()).toList();
      }
      return _memoryDhikrs.map((dhikr) => dhikr.copyWith()).toList();
    }

    final db = await _db;
    final rows = await db.query(_tableDhikrs, orderBy: 'name COLLATE NOCASE ASC');
    return rows.map(_rowToDhikr).toList();
  }

  Future<void> saveDhikrs(List<Dhikr> dhikrs) async {
    if (_useInMemoryBackend) {
      _memoryDhikrs = dhikrs.map((dhikr) => dhikr.copyWith()).toList();
      return;
    }

    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete(_tableDhikrs);
      for (final dhikr in dhikrs) {
        await txn.insert(_tableDhikrs, _dhikrToRow(dhikr), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> saveDhikr(Dhikr dhikr) async {
    if (_useInMemoryBackend) {
      final index = _memoryDhikrs.indexWhere((d) => d.id == dhikr.id);
      if (index >= 0) {
        _memoryDhikrs[index] = dhikr.copyWith();
      } else {
        _memoryDhikrs.add(dhikr.copyWith());
      }
      return;
    }

    final db = await _db;
    await db.insert(
      _tableDhikrs,
      _dhikrToRow(dhikr),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteDhikr(String id) async {
    if (_useInMemoryBackend) {
      _memoryDhikrs.removeWhere((d) => d.id == id);
      if (_memoryCurrentDhikrId == id) {
        _memoryCurrentDhikrId = null;
      }
      return;
    }

    final db = await _db;
    await db.delete(_tableDhikrs, where: 'id = ?', whereArgs: [id]);

    final currentId = await getCurrentDhikrId();
    if (currentId == id) {
      await setCurrentDhikrId('');
    }
  }

  Future<Map<String, dynamic>> loadSettings() async {
    if (_useInMemoryBackend) {
      if (_memorySettings.isEmpty) {
        _memorySettings = Map<String, dynamic>.from(_defaultSettings);
      }
      return Map<String, dynamic>.from(_memorySettings);
    }

    final db = await _db;
    final rows = await db.query(_tableSettings, where: 'id = 1', limit: 1);
    if (rows.isEmpty) {
      return Map<String, dynamic>.from(_defaultSettings);
    }

    final row = rows.first;
    return {
      'vibration': (row['vibration'] as int?) == 1,
      'mute': (row['mute'] as int?) == 1,
      'language': row['language'] as String? ?? 'eng',
      'theme': row['theme'] as String? ?? 'dark',
    };
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    if (_useInMemoryBackend) {
      _memorySettings = Map<String, dynamic>.from(settings);
      return;
    }

    final db = await _db;
    await db.insert(
      _tableSettings,
      {
        'id': 1,
        'vibration': (settings['vibration'] == true) ? 1 : 0,
        'mute': (settings['mute'] == true) ? 1 : 0,
        'language': settings['language']?.toString() ?? 'eng',
        'theme': settings['theme']?.toString() ?? 'dark',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getTasbeehCount() async {
    if (_useInMemoryBackend) {
      return _memoryTasbeehCount;
    }

    final db = await _db;
    final rows = await db.query(_tableState, columns: ['tasbeeh_count'], where: 'id = 1', limit: 1);
    if (rows.isEmpty) {
      await db.insert(_tableState, _defaultStateRow());
      return 0;
    }
    return (rows.first['tasbeeh_count'] as int?) ?? 0;
  }

  Future<void> setTasbeehCount(int count) async {
    if (_useInMemoryBackend) {
      _memoryTasbeehCount = count;
      return;
    }

    final db = await _db;
    await db.insert(
      _tableState,
      {
        'id': 1,
        'tasbeeh_count': count,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getCurrentDhikrId() async {
    if (_useInMemoryBackend) {
      return _memoryCurrentDhikrId;
    }

    final db = await _db;
    final rows = await db.query(_tableState, columns: ['current_dhikr'], where: 'id = 1', limit: 1);
    if (rows.isEmpty) {
      await db.insert(_tableState, _defaultStateRow());
      return null;
    }

    final value = rows.first['current_dhikr'] as String?;
    return value?.isEmpty == true ? null : value;
  }

  Future<void> setCurrentDhikrId(String id) async {
    if (_useInMemoryBackend) {
      _memoryCurrentDhikrId = id.isEmpty ? null : id;
      return;
    }

    final db = await _db;
    await db.insert(
      _tableState,
      {
        'id': 1,
        'current_dhikr': id.isEmpty ? null : id,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> resetForTests() async {
    if (_useInMemoryBackend) {
      enableInMemoryBackendForTests();
      return;
    }

    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  List<Dhikr> _getDefaultDhikrs() {
    return _defaultDhikrsStatic();
  }

  static List<Dhikr> _defaultDhikrsStatic() {
    return [
      Dhikr(
        id: '1',
        name: 'SubhanAllah',
        description: 'Glory be to Allah',
        currentCount: 0,
        targetCount: 33,
        hasTarget: true,
        icon: '🌿',
      ),
      Dhikr(
        id: '2',
        name: 'Alhamdulillah',
        description: 'All praise is due to Allah',
        currentCount: 0,
        targetCount: 33,
        hasTarget: true,
        icon: '💚',
      ),
      Dhikr(
        id: '3',
        name: 'Allahu Akbar',
        description: 'Allah is the Greatest',
        currentCount: 0,
        targetCount: 34,
        hasTarget: true,
        icon: '⭐',
      ),
    ];
  }
}

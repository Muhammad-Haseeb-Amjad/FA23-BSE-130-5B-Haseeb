import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseService {
  LocalDatabaseService._();
  static final LocalDatabaseService instance = LocalDatabaseService._();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'breadbox_pos.db');

    return openDatabase(
      path,
      version: 4,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add image_path column if it doesn't exist
      try {
        await db.execute('ALTER TABLE products ADD COLUMN image_path TEXT');
      } catch (e) {
        print('Column might already exist: $e');
      }
    }

    // Add address to customers table if upgrading from older schema
    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE customers ADD COLUMN address TEXT');
      } catch (e) {
        print('Address column might already exist: $e');
      }
    }

    // Add profile table on upgrade
    if (oldVersion < 4) {
      try {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS profile (
            id TEXT PRIMARY KEY,
            name TEXT,
            address TEXT,
            phone TEXT,
            email TEXT,
            image_path TEXT,
            updated_at TEXT
          )
        ''');
      } catch (e) {
        print('Profile table creation error: $e');
      }
    }
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT,
        barcode TEXT,
        price REAL DEFAULT 0,
        cost_price REAL DEFAULT 0,
        quantity INTEGER DEFAULT 0,
        batch_date TEXT,
        expiry_date TEXT,
        low_stock_alert INTEGER DEFAULT 1,
        expiry_alert INTEGER DEFAULT 1,
        image_path TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS profile (
        id TEXT PRIMARY KEY,
        name TEXT,
        address TEXT,
        phone TEXT,
        email TEXT,
        image_path TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        address TEXT,
        loyalty_points INTEGER DEFAULT 0,
        total_spent REAL DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sales (
        id TEXT PRIMARY KEY,
        subtotal REAL DEFAULT 0,
        tax REAL DEFAULT 0,
        discount REAL DEFAULT 0,
        total REAL NOT NULL,
        items TEXT,
        method TEXT,
        currency_symbol TEXT DEFAULT '\$',
        currency_code TEXT DEFAULT 'USD',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS wastage_logs (
        id TEXT PRIMARY KEY,
        product_id TEXT REFERENCES products(id),
        quantity INTEGER,
        reason TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS stock_operations (
        id TEXT PRIMARY KEY,
        product_id TEXT REFERENCES products(id),
        operation_type TEXT,
        quantity INTEGER,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        synced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> insert(String table, Map<String, dynamic> data, {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace}) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: conflictAlgorithm);
  }

  Future<void> update(
    String table,
    Map<String, dynamic> data,
    String id,
  ) async {
    final db = await database;
    await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(String table, String id) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await database;
    return db.query(table);
  }

  Future<Map<String, dynamic>?> queryOne(String table, String id) async {
    final db = await database;
    final results = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getUnsynced(String table) async {
    final db = await database;
    return db.query(table, where: 'synced = 0');
  }

  Future<void> markSynced(String table, List<String> ids) async {
    final db = await database;
    for (final id in ids) {
      await db.update(table, {'synced': 1}, where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return db.query(table);
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    await insert('products', product);
  }

  Future<void> insertCustomer(Map<String, dynamic> customer) async {
    await insert('customers', customer);
  }

  Future<void> insertSale(Map<String, dynamic> sale) async {
    await insert('sales', sale);
  }

  Future<void> insertWastageLog(Map<String, dynamic> log) async {
    await insert('wastage_logs', log);
  }

  Future<void> insertStockOperation(Map<String, dynamic> operation) async {
    await insert('stock_operations', operation);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('sales');
    await db.delete('stock_operations');
    await db.delete('wastage_logs');
    await db.delete('customers');
    await db.delete('products');
  }

  Future<void> close() async {
    await _db?.close();
  }

  /// Fully reset the singleton database handle so fresh queries reopen a clean connection.
  Future<void> reset() async {
    await _db?.close();
    _db = null;
  }
}

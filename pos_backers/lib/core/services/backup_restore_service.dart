import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'local_database_service.dart';
import 'google_drive_service.dart';

class RestoreResult {
  final bool success;
  final int inserted;
  final int total;
  final String? error;
  final Map<String, int>? dbCounts;

  const RestoreResult({required this.success, required this.inserted, required this.total, this.error, this.dbCounts});
}

class BackupRestoreService {
  BackupRestoreService._();
  static final BackupRestoreService instance = BackupRestoreService._();

  /// Restore from JSON backup (from file or Drive)
  Future<RestoreResult> restoreFromJson(String jsonContent) async {
    try {
      print('🔄 Starting restore from JSON...');

      late final Map<String, dynamic> backup;
      try {
        backup = jsonDecode(jsonContent) as Map<String, dynamic>;
      } catch (e) {
        print('❌ JSON decode failed: $e');
        return RestoreResult(success: false, inserted: 0, total: 0, error: 'Invalid JSON: $e');
      }

      final db = LocalDatabaseService.instance;
      final uuid = const Uuid();
      final errors = <String>[];

      // Snapshot counts before restore
      final beforeCounts = <String, int>{
        'products': (await db.queryAll('products')).length,
        'customers': (await db.queryAll('customers')).length,
        'sales': (await db.queryAll('sales')).length,
        'wastage_logs': (await db.queryAll('wastage_logs')).length,
        'stock_operations': (await db.queryAll('stock_operations')).length,
      };
      print('📊 DB counts before restore: $beforeCounts');

      // Validate backup structure
      if (backup.isEmpty) {
        print('❌ Backup is empty');
        return const RestoreResult(success: false, inserted: 0, total: 0, error: 'Backup file is empty');
      }

      print('📦 Backup contains: ${backup.keys.join(", ")}');

      int inserted = 0;

      // Clear all tables
      print('🗑️ Clearing existing data...');
      await db.clearAll();

      // Insert products
      final products = backup['products'] as List<dynamic>? ?? [];
      print('📦 Restoring ${products.length} products...');
      for (final p in products) {
        try {
          final raw = Map<String, dynamic>.from(p as Map);
          final product = <String, dynamic>{};

          // Required/known fields with safe casting
          product['id'] = (raw['id'] ?? uuid.v4()).toString();
          product['name'] = raw['name']?.toString();
          product['category'] = raw['category']?.toString();
          product['barcode'] = raw['barcode']?.toString();

          // Numeric conversions
          product['price'] = _toDouble(raw['price']);
          product['cost_price'] = _toDouble(raw['cost_price']);
          product['quantity'] = _toInt(raw['quantity']);

          // Dates and misc
          product['batch_date'] = raw['batch_date']?.toString();
          product['expiry_date'] = raw['expiry_date']?.toString();
          product['image_path'] = raw['image_path']?.toString();
          product['created_at'] = raw['created_at']?.toString();

          // Booleans stored as INTEGER (0/1) in SQLite
          product['low_stock_alert'] = _toBoolInt(raw['low_stock_alert']);
          product['expiry_alert'] = _toBoolInt(raw['expiry_alert']);

          product['synced'] = 0; // Mark as unsynced for next sync push
          await db.insertProduct(product);
          inserted++;
        } catch (e) {
          print('⚠️ Failed to restore product: $e');
          errors.add('product: $e');
        }
      }
      print('✅ Products restored: ${products.length}');

      // Insert customers
      final customers = backup['customers'] as List<dynamic>? ?? [];
      print('👥 Restoring ${customers.length} customers...');
      for (final c in customers) {
        try {
          final raw = Map<String, dynamic>.from(c as Map);
          final customer = <String, dynamic>{};
          
          customer['id'] = (raw['id'] ?? uuid.v4()).toString();
          customer['name'] = raw['name']?.toString();
          customer['phone'] = raw['phone']?.toString();
          customer['email'] = raw['email']?.toString();
          customer['address'] = raw['address']?.toString();
          customer['loyalty_points'] = _toInt(raw['loyalty_points'] ?? raw['points']);
          customer['total_spent'] = _toDouble(raw['total_spent']);
          customer['created_at'] = raw['created_at']?.toString();
          customer['synced'] = 0;
          
          await db.insertCustomer(customer);
          inserted++;
        } catch (e) {
          print('⚠️ Failed to restore customer: $e');
          errors.add('customer: $e');
        }
      }
      print('✅ Customers restored: ${customers.length}');

      // Insert sales
      final sales = backup['sales'] as List<dynamic>? ?? [];
      print('💰 Restoring ${sales.length} sales...');
      for (final s in sales) {
        try {
          final raw = Map<String, dynamic>.from(s as Map);
          final sale = <String, dynamic>{};
          
          sale['id'] = (raw['id'] ?? uuid.v4()).toString();
          sale['subtotal'] = _toDouble(raw['subtotal']);
          sale['tax'] = _toDouble(raw['tax']);
          sale['discount'] = _toDouble(raw['discount']);
          sale['total'] = _toDouble(raw['total']);
          sale['items'] = raw['items']?.toString();
          sale['method'] = raw['method']?.toString();
          sale['currency_symbol'] = raw['currency_symbol']?.toString() ?? r'$';
          sale['currency_code'] = raw['currency_code']?.toString() ?? 'USD';
          sale['created_at'] = raw['created_at']?.toString();
          sale['synced'] = 0;
          
          await db.insertSale(sale);
          inserted++;
        } catch (e) {
          print('⚠️ Failed to restore sale: $e');
          errors.add('sale: $e');
        }
      }
      print('✅ Sales restored: ${sales.length}');

      // Insert wastage logs
      final wastage = backup['wastage_logs'] as List<dynamic>? ?? [];
      print('🚮 Restoring ${wastage.length} wastage logs...');
      for (final w in wastage) {
        try {
          final raw = Map<String, dynamic>.from(w as Map);
          final log = <String, dynamic>{};
          
          log['id'] = (raw['id'] ?? uuid.v4()).toString();
          log['product_id'] = raw['product_id']?.toString();
          log['quantity'] = _toInt(raw['quantity']);
          log['reason'] = raw['reason']?.toString();
          log['created_at'] = raw['created_at']?.toString();
          log['synced'] = 0;
          
          await db.insertWastageLog(log);
          inserted++;
        } catch (e) {
          print('⚠️ Failed to restore wastage log: $e');
          errors.add('wastage: $e');
        }
      }
      print('✅ Wastage logs restored: ${wastage.length}');

      // Insert stock operations
      final ops = backup['stock_operations'] as List<dynamic>? ?? [];
      print('📊 Restoring ${ops.length} stock operations...');
      for (final op in ops) {
        try {
          final raw = Map<String, dynamic>.from(op as Map);
          final operation = <String, dynamic>{};
          
          operation['id'] = (raw['id'] ?? uuid.v4()).toString();
          operation['product_id'] = raw['product_id']?.toString();
          operation['operation_type'] = raw['operation_type']?.toString();
          operation['quantity'] = _toInt(raw['quantity']);
          operation['notes'] = raw['notes']?.toString();
          operation['created_at'] = raw['created_at']?.toString();
          operation['synced'] = 0;
          
          await db.insertStockOperation(operation);
          inserted++;
        } catch (e) {
          print('⚠️ Failed to restore stock operation: $e');
          errors.add('stock_operation: $e');
        }
      }
      print('✅ Stock operations restored: ${ops.length}');

      final totalItems = products.length + customers.length + sales.length + wastage.length + ops.length;
      // Get actual DB counts after restore for debugging
      final dbCounts = <String, int>{
        'products': (await db.queryAll('products')).length,
        'customers': (await db.queryAll('customers')).length,
        'sales': (await db.queryAll('sales')).length,
        'wastage_logs': (await db.queryAll('wastage_logs')).length,
        'stock_operations': (await db.queryAll('stock_operations')).length,
      };

      final success = totalItems > 0 && inserted > 0;
      final errMsg = success
          ? null
          : (errors.isNotEmpty
              ? errors.join('; ')
              : (totalItems == 0 ? 'Backup is empty' : 'No rows inserted'));

      print('✅ Restore completed. Inserted $inserted / $totalItems records. DB counts: $dbCounts');
      // Reset DB handle so subsequent screens reopen and see fresh data
      await db.reset();
      return RestoreResult(success: success, inserted: inserted, total: totalItems, error: errMsg, dbCounts: dbCounts);
    } catch (e) {
      print('❌ Restore from JSON failed: $e');
      return RestoreResult(success: false, inserted: 0, total: 0, error: e.toString());
    }
  }

  // Helpers to normalize types coming from JSON backups
  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  int _toBoolInt(dynamic v) {
    if (v == null) return 1; // default true
    if (v is bool) return v ? 1 : 0;
    if (v is int) return v == 0 ? 0 : 1;
    if (v is String) {
      final s = v.toLowerCase();
      if (s == 'true' || s == '1') return 1;
      if (s == 'false' || s == '0') return 0;
    }
    return 1;
  }

  /// Restore from Google Drive backup
  Future<RestoreResult> restoreFromGoogleDrive(String fileId) async {
    try {
      final jsonContent = await GoogleDriveService.instance.downloadBackup(fileId);
      if (jsonContent == null) return const RestoreResult(success: false, inserted: 0, total: 0, error: 'Download failed');
      return await restoreFromJson(jsonContent);
    } catch (e) {
      print('Restore from Google Drive failed: $e');
      return RestoreResult(success: false, inserted: 0, total: 0, error: e.toString());
    }
  }

  /// Create local JSON backup (for manual export)
  Future<String> createLocalBackup() async {
    final db = LocalDatabaseService.instance;

    final products = await db.queryAll('products');
    final customers = await db.queryAll('customers');
    final sales = await db.queryAll('sales');
    final wastageLogs = await db.queryAll('wastage_logs');
    final stockOps = await db.queryAll('stock_operations');

    final backup = {
      'timestamp': DateTime.now().toIso8601String(),
      'products': products,
      'customers': customers,
      'sales': sales,
      'wastage_logs': wastageLogs,
      'stock_operations': stockOps,
    };

    // If everything is empty, signal failure so user doesn’t export a blank file
    final total = products.length + customers.length + sales.length + wastageLogs.length + stockOps.length;
    if (total == 0) {
      throw Exception('No data to export');
    }

    return jsonEncode(backup);
  }
}

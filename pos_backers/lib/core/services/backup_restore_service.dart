import 'dart:convert';
import 'local_database_service.dart';
import 'google_drive_service.dart';

class BackupRestoreService {
  BackupRestoreService._();
  static final BackupRestoreService instance = BackupRestoreService._();

  /// Restore from JSON backup (from file or Drive)
  Future<bool> restoreFromJson(String jsonContent) async {
    try {
      final backup = jsonDecode(jsonContent) as Map<String, dynamic>;
      final db = LocalDatabaseService.instance;

      // Clear all tables
      await db.clearAll();

      // Insert products
      final products = backup['products'] as List<dynamic>? ?? [];
      for (final p in products) {
        final product = Map<String, dynamic>.from(p as Map);
        product['synced'] = 0; // Mark as unsynced for next sync push
        await db.insertProduct(product);
      }

      // Insert customers
      final customers = backup['customers'] as List<dynamic>? ?? [];
      for (final c in customers) {
        final customer = Map<String, dynamic>.from(c as Map);
        customer['synced'] = 0;
        await db.insertCustomer(customer);
      }

      // Insert sales
      final sales = backup['sales'] as List<dynamic>? ?? [];
      for (final s in sales) {
        final sale = Map<String, dynamic>.from(s as Map);
        sale['synced'] = 0;
        await db.insertSale(sale);
      }

      // Insert wastage logs
      final wastage = backup['wastage_logs'] as List<dynamic>? ?? [];
      for (final w in wastage) {
        final log = Map<String, dynamic>.from(w as Map);
        log['synced'] = 0;
        await db.insertWastageLog(log);
      }

      // Insert stock operations
      final ops = backup['stock_operations'] as List<dynamic>? ?? [];
      for (final op in ops) {
        final operation = Map<String, dynamic>.from(op as Map);
        operation['synced'] = 0;
        await db.insertStockOperation(operation);
      }

      return true;
    } catch (e) {
      print('Restore from JSON failed: $e');
      return false;
    }
  }

  /// Restore from Google Drive backup
  Future<bool> restoreFromGoogleDrive(String fileId) async {
    try {
      final jsonContent = await GoogleDriveService.instance.downloadBackup(fileId);
      if (jsonContent == null) return false;
      return await restoreFromJson(jsonContent);
    } catch (e) {
      print('Restore from Google Drive failed: $e');
      return false;
    }
  }

  /// Create local JSON backup (for manual export)
  Future<String> createLocalBackup() async {
    try {
      final db = LocalDatabaseService.instance;

      final backup = {
        'timestamp': DateTime.now().toIso8601String(),
        'products': await db.queryAll('products'),
        'customers': await db.queryAll('customers'),
        'sales': await db.queryAll('sales'),
        'wastage_logs': await db.queryAll('wastage_logs'),
        'stock_operations': await db.queryAll('stock_operations'),
      };

      return jsonEncode(backup);
    } catch (e) {
      print('Create local backup failed: $e');
      return '';
    }
  }
}

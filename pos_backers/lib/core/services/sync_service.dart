import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_database_service.dart';
import 'supabase_service.dart';
import 'connectivity_service.dart';

class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  Timer? _syncTimer;
  StreamSubscription? _connectivitySubscription;
  final ValueNotifier<bool> isSyncing = ValueNotifier(false);
  final ValueNotifier<String> lastSyncTime = ValueNotifier('Never');

  void startAutoSync({int intervalSeconds = 60}) {
    // Ensure previous timers/subscriptions are cleared before starting
    stopAutoSync();
    // Sync when online status changes
    _connectivitySubscription = ConnectivityService.instance.connectivityStream
        .listen((online) async {
          if (online) {
            // Only auto-sync if automatic sync is enabled
            final prefs = await SharedPreferences.getInstance();
            final autoSyncEnabled = prefs.getBool('auto_sync') ?? true;
            if (autoSyncEnabled) {
              syncAllData();
            }
          }
        });

    // Periodic sync timer
    _syncTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      // Only auto-sync if automatic sync is enabled
      final prefs = await SharedPreferences.getInstance();
      final autoSyncEnabled = prefs.getBool('auto_sync') ?? true;
      if (autoSyncEnabled) {
        syncAllData();
      }
    });
  }

  Future<void> syncAllData() async {
    if (isSyncing.value) return;
    isSyncing.value = true;

    int successCount = 0;
    int failureCount = 0;

    try {
      await SupabaseService.instance.ensureInitialized();
      final db = LocalDatabaseService.instance;

      // Sync products
      final unSyncedProducts = await db.getUnsynced('products');
      print('Found ${unSyncedProducts.length} unsynced products');

      for (final product in unSyncedProducts) {
        try {
          // Remove synced field before sending to Supabase
          final productData = Map<String, dynamic>.from(product);
          productData.remove('synced');

          await SupabaseService.instance.client
              .from('products')
              .upsert(productData);
          await db.markSynced('products', [product['id'].toString()]);
          successCount++;
          print('Synced product: ${product['id']}');
        } catch (e) {
          failureCount++;
          print('Failed to sync product ${product['id']}: $e');
        }
      }

      // Sync customers
      final unSyncedCustomers = await db.getUnsynced('customers');
      print('Found ${unSyncedCustomers.length} unsynced customers');

      for (final customer in unSyncedCustomers) {
        try {
          final customerData = Map<String, dynamic>.from(customer);
          customerData.remove('synced');

          await SupabaseService.instance.client
              .from('customers')
              .upsert(customerData);
          await db.markSynced('customers', [customer['id'].toString()]);
          successCount++;
          print('Synced customer: ${customer['id']}');
        } catch (e) {
          failureCount++;
          print('Failed to sync customer ${customer['id']}: $e');
        }
      }

      // Sync sales
      final unSyncedSales = await db.getUnsynced('sales');
      print('Found ${unSyncedSales.length} unsynced sales');

      for (final sale in unSyncedSales) {
        try {
          final saleData = Map<String, dynamic>.from(sale);
          saleData.remove('synced');

          await SupabaseService.instance.client.from('sales').insert(saleData);
          await db.markSynced('sales', [sale['id'].toString()]);
          successCount++;
          print('Synced sale: ${sale['id']}');
        } catch (e) {
          failureCount++;
          print('Failed to sync sale ${sale['id']}: $e');
        }
      }

      // Sync wastage logs
      final unSyncedWastage = await db.getUnsynced('wastage_logs');
      print('Found ${unSyncedWastage.length} unsynced wastage logs');

      for (final log in unSyncedWastage) {
        try {
          final logData = Map<String, dynamic>.from(log);
          logData.remove('synced');

          await SupabaseService.instance.client
              .from('wastage_logs')
              .insert(logData);
          await db.markSynced('wastage_logs', [log['id'].toString()]);
          successCount++;
          print('Synced wastage log: ${log['id']}');
        } catch (e) {
          failureCount++;
          print('Failed to sync wastage ${log['id']}: $e');
        }
      }

      // Sync stock operations
      final unSyncedOps = await db.getUnsynced('stock_operations');
      print('Found ${unSyncedOps.length} unsynced stock operations');

      for (final op in unSyncedOps) {
        try {
          final opData = Map<String, dynamic>.from(op);
          opData.remove('synced');

          await SupabaseService.instance.client
              .from('stock_operations')
              .insert(opData);
          await db.markSynced('stock_operations', [op['id'].toString()]);
          successCount++;
          print('Synced stock operation: ${op['id']}');
        } catch (e) {
          failureCount++;
          print('Failed to sync operation ${op['id']}: $e');
        }
      }

      lastSyncTime.value = DateTime.now().toString();
      print('Sync completed: $successCount succeeded, $failureCount failed');
    } catch (e) {
      print('Sync failed: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  void stopAutoSync() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}

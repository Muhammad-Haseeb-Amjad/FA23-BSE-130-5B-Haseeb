import 'dart:async';
import 'package:flutter/foundation.dart';
import 'local_database_service.dart';
import 'offline_queue_service.dart';
import 'supabase_service.dart';
import 'connectivity_service.dart';

class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  Timer? _syncTimer;
  StreamSubscription? _connectivitySubscription;
  final ValueNotifier<bool> isSyncing = ValueNotifier(false);
  final ValueNotifier<String> lastSyncTime = ValueNotifier('Never');
  bool _initialSyncDone = false;  // Track if initial sync has been completed

  void startAutoSync({int intervalSeconds = 60}) {
    // Ensure we don't start multiple timers/subscriptions
    stopAutoSync();

    // Sync when online status changes
    _connectivitySubscription = ConnectivityService.instance.connectivityStream.listen((online) {
      if (online) {
        if (!_initialSyncDone) {
          // First time coming online - do full sync
          syncAllData(isInitial: true);
        } else {
          syncAllData();
        }
      }
    });

    // Periodic sync timer
    _syncTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) {
      syncAllData();
    });
  }

  Future<void> syncAllData({bool isInitial = false}) async {
    if (isSyncing.value) return;
    isSyncing.value = true;

    try {
      // Skip sync when offline to avoid unnecessary failures
      final online = await ConnectivityService.instance.isOnline;
      if (!online) {
        return;
      }

      await SupabaseService.instance.ensureInitialized();
      final db = LocalDatabaseService.instance;

      // On initial sync, download all data from Supabase
      if (isInitial) {
        await _downloadAllData(db);
        _initialSyncDone = true;
      }

      // First, process offline queue (priority)
      await OfflineQueueService.instance.syncPendingProducts(SupabaseService.instance.client);
      await OfflineQueueService.instance.syncPendingCustomers(SupabaseService.instance.client);
      await OfflineQueueService.instance.syncPendingSales(SupabaseService.instance.client);

      // Sync unsynced products from local DB
      final unSyncedProducts = await db.getUnsynced('products');
      for (final product in unSyncedProducts) {
        try {
          await SupabaseService.instance.client.from('products').upsert(product);
          await db.markSynced('products', [product['id']]);
        } catch (e) {
          print('Failed to sync product ${product['id']}: $e');
        }
      }

      // Sync unsynced customers from local DB
      final unSyncedCustomers = await db.getUnsynced('customers');
      for (final customer in unSyncedCustomers) {
        try {
          await SupabaseService.instance.client.from('customers').upsert(customer);
          await db.markSynced('customers', [customer['id']]);
        } catch (e) {
          print('Failed to sync customer ${customer['id']}: $e');
        }
      }

      // Sync unsynced sales from local DB
      final unSyncedSales = await db.getUnsynced('sales');
      for (final sale in unSyncedSales) {
        try {
          await SupabaseService.instance.client.from('sales').insert(sale);
          await db.markSynced('sales', [sale['id']]);
        } catch (e) {
          print('Failed to sync sale ${sale['id']}: $e');
        }
      }

      // Sync unsynced wastage logs
      final unSyncedWastage = await db.getUnsynced('wastage_logs');
      for (final log in unSyncedWastage) {
        try {
          await SupabaseService.instance.client.from('wastage_logs').insert(log);
          await db.markSynced('wastage_logs', [log['id']]);
        } catch (e) {
          print('Failed to sync wastage ${log['id']}: $e');
        }
      }

      // Sync unsynced stock operations
      final unSyncedOps = await db.getUnsynced('stock_operations');
      for (final op in unSyncedOps) {
        try {
          await SupabaseService.instance.client.from('stock_operations').insert(op);
          await db.markSynced('stock_operations', [op['id']]);
        } catch (e) {
          print('Failed to sync operation ${op['id']}: $e');
        }
      }


      lastSyncTime.value = DateTime.now().toString();
    } catch (e) {
      print('Sync failed: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _downloadAllData(LocalDatabaseService db) async {
    try {
      print('Starting initial full sync...');
      final client = SupabaseService.instance.client;

      // Download and cache all products
      try {
        final products = await client.from('products').select();
        for (final product in products) {
          await db.insertProduct({...product, 'synced': 1});
        }
        print('Cached ${products.length} products');
      } catch (e) {
        print('Failed to sync products: $e');
      }

      // Download and cache all customers
      try {
        final customers = await client.from('customers').select();
        for (final customer in customers) {
          await db.insertCustomer({...customer, 'synced': 1});
        }
        print('Cached ${customers.length} customers');
      } catch (e) {
        print('Failed to sync customers: $e');
      }

      // Download and cache all sales
      try {
        final sales = await client.from('sales').select();
        for (final sale in sales) {
          await db.insertSale({...sale, 'synced': 1});
        }
        print('Cached ${sales.length} sales');
      } catch (e) {
        print('Failed to sync sales: $e');
      }

      // Download and cache all wastage logs
      try {
        final logs = await client.from('wastage_logs').select();
        for (final log in logs) {
          await db.insertWastageLog({...log, 'synced': 1});
        }
        print('Cached ${logs.length} wastage logs');
      } catch (e) {
        print('Failed to sync wastage logs: $e');
      }

      // Download and cache all stock operations
      try {
        final ops = await client.from('stock_operations').select();
        for (final op in ops) {
          await db.insertStockOperation({...op, 'synced': 1});
        }
        print('Cached ${ops.length} stock operations');
      } catch (e) {
        print('Failed to sync stock operations: $e');
      }

      print('Initial full sync completed');
    } catch (e) {
      print('Error downloading all data: $e');
    }
  }

  void stopAutoSync() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}

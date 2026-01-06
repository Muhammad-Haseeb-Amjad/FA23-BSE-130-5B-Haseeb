import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_database_service.dart';

class OfflineQueueService {
  OfflineQueueService._();
  static final OfflineQueueService instance = OfflineQueueService._();

  static const _boxName = 'offline_queue';
  static const _keySales = 'pending_sales';
  static const _keyProducts = 'pending_products';
  static const _keyCustomers = 'pending_customers';
  Box? _box;

  Future<void> init() async {
    _box ??= await Hive.openBox(_boxName);
  }

  // ===== SALES =====
  Future<void> enqueueSale(Map<String, dynamic> sale) async {
    await init();
    try {
      final data = _box?.get(_keySales, defaultValue: <dynamic>[]);
      final list = data is List ? List<Map<String, dynamic>>.from(
        (data).map((item) => item is Map ? Map<String, dynamic>.from(item as Map) : {})
      ) : <Map<String, dynamic>>[];
      list.add(sale);
      await _box?.put(_keySales, list);
      print('Sale queued for sync (total: ${list.length})');
    } catch (e) {
      print('Error enqueueing sale: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingSales() async {
    await init();
    try {
      final data = _box?.get(_keySales, defaultValue: <dynamic>[]);
      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((item) => item is Map ? Map<String, dynamic>.from(item as Map) : {})
        );
      }
      return [];
    } catch (e) {
      print('Error getting pending sales: $e');
      return [];
    }
  }

  Future<void> clearPendingSales() async {
    await init();
    await _box?.put(_keySales, []);
  }

  Future<void> overwritePendingSales(List<Map<String, dynamic>> sales) async {
    await init();
    await _box?.put(_keySales, sales);
  }

  // ===== PRODUCTS =====
  Future<void> enqueueProduct(Map<String, dynamic> product) async {
    await init();
    try {
      final data = _box?.get(_keyProducts, defaultValue: <dynamic>[]);
      final list = data is List ? List<Map<String, dynamic>>.from(
        (data).map((item) => item is Map ? Map<String, dynamic>.from(item as Map) : {})
      ) : <Map<String, dynamic>>[];
      
      // Remove existing product with same id if editing
      list.removeWhere((p) => p['id'] == product['id']);
      list.add(product);
      await _box?.put(_keyProducts, list);
      print('Product ${product['id']} queued for sync (total: ${list.length})');
    } catch (e) {
      print('Error enqueueing product: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingProducts() async {
    await init();
    try {
      final data = _box?.get(_keyProducts, defaultValue: <dynamic>[]);
      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((item) => item is Map ? Map<String, dynamic>.from(item as Map) : {})
        );
      }
      return [];
    } catch (e) {
      print('Error getting pending products: $e');
      return [];
    }
  }

  Future<void> clearPendingProducts() async {
    await init();
    await _box?.put(_keyProducts, []);
  }

  // ===== CUSTOMERS =====
  Future<void> enqueueCustomer(Map<String, dynamic> customer) async {
    await init();
    try {
      final data = _box?.get(_keyCustomers, defaultValue: <dynamic>[]);
      final list = data is List ? List<Map<String, dynamic>>.from(
        (data).map((item) => item is Map ? Map<String, dynamic>.from(item as Map) : {})
      ) : <Map<String, dynamic>>[];
      
      // Remove existing customer with same id if editing
      list.removeWhere((c) => c['id'] == customer['id']);
      list.add(customer);
      await _box?.put(_keyCustomers, list);
      print('Customer ${customer['id']} queued for sync (total: ${list.length})');
    } catch (e) {
      print('Error enqueueing customer: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingCustomers() async {
    await init();
    try {
      final data = _box?.get(_keyCustomers, defaultValue: <dynamic>[]);
      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((item) => item is Map ? Map<String, dynamic>.from(item as Map) : {})
        );
      }
      return [];
    } catch (e) {
      print('Error getting pending customers: $e');
      return [];
    }
  }

  Future<void> clearPendingCustomers() async {
    await init();
    await _box?.put(_keyCustomers, []);
  }

  // ===== SYNC =====
  Future<int> syncPendingSales(SupabaseClient client) async {
    await init();
    final pending = await getPendingSales();
    int success = 0;
    for (final sale in pending) {
      try {
        await client.from('sales').insert(sale);
        success++;
      } catch (_) {
        // keep remaining
      }
    }
    if (success == pending.length) {
      await clearPendingSales();
    } else {
      final remaining = pending.skip(success).toList();
      await _box?.put(_keySales, remaining);
    }
    return success;
  }

  Future<int> syncPendingProducts(SupabaseClient client) async {
    await init();
    final pending = await getPendingProducts();
    int success = 0;
    for (final product in pending) {
      try {
        final id = product['id'];
        final data = Map<String, dynamic>.from(product)..remove('id');
        // Try upsert in case product exists
        await client.from('products').upsert({'id': id, ...data});
        success++;
        print('Synced product $id');
      } catch (e) {
        print('Failed to sync product: $e');
      }
    }
    if (success == pending.length) {
      await clearPendingProducts();
    } else {
      final remaining = pending.skip(success).toList();
      await _box?.put(_keyProducts, remaining);
    }
    return success;
  }

  Future<int> syncPendingCustomers(SupabaseClient client) async {
    await init();
    final pending = await getPendingCustomers();
    print('🔄 Starting customer sync. Pending: ${pending.length}');
    
    if (pending.isEmpty) {
      print('✓ No customers to sync');
      return 0;
    }
    
    int success = 0;
    final List<Map<String, dynamic>> failedCustomers = [];
    
    for (final customer in pending) {
      try {
        var id = customer['id'];
        print('Syncing customer: $id');
        
        // Remove fields not in Supabase schema (address, synced)
        final data = Map<String, dynamic>.from(customer)
          ..remove('id')
          ..remove('synced')
          ..remove('address'); // Supabase customers table doesn't have address column
        
        try {
          // First try upsert with id
          await client.from('customers').upsert({'id': id, ...data});
          success++;
          print('✓ Synced customer $id');
        } catch (e) {
          // Fallback: insert without id (for integer PK tables)
          print('⚠ Upsert with id failed for customer $id, retrying without id. Error: $e');
          try {
            final res = await client.from('customers').insert(data).select('id').single();
            if (res != null && res['id'] != null) {
              final newId = res['id'];
              // Update local DB to new id so future edits point to the same record
              final db = LocalDatabaseService.instance;
              final updated = Map<String, dynamic>.from(customer);
              updated['id'] = newId.toString();
              updated['synced'] = 1;
              await db.update('customers', updated, id.toString());
              id = newId;
              success++;
              print('✓ Inserted customer with new id $newId and updated local mapping');
            }
          } catch (e2) {
            print('❌ Failed to sync customer $id (both attempts): $e2');
            failedCustomers.add(customer);
          }
        }
      } catch (e) {
        print('❌ Failed to sync customer: $e');
        failedCustomers.add(customer);
      }
    }
    
    // Update queue: remove successful, keep failed
    if (failedCustomers.isEmpty) {
      await clearPendingCustomers();
      print('✓ All customers synced successfully');
    } else {
      await _box?.put(_keyCustomers, failedCustomers);
      print('⚠ ${failedCustomers.length} customers failed to sync and remain in queue');
    }
    
    print('📊 Customer sync complete: $success synced, ${failedCustomers.length} failed');
    return success;
  }

  Future<void> setSyncIntervalMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sync_interval', minutes);
  }

  Future<int> getSyncIntervalMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('sync_interval') ?? 15;
  }
}
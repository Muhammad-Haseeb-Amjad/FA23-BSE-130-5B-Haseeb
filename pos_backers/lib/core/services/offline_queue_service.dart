import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfflineQueueService {
  OfflineQueueService._();
  static final OfflineQueueService instance = OfflineQueueService._();

  static const _boxName = 'offline_queue';
  static const _keySales = 'pending_sales';
  Box? _box;

  Future<void> init() async {
    _box ??= await Hive.openBox(_boxName);
  }

  Future<void> enqueueSale(Map<String, dynamic> sale) async {
    await init();
    final list = List<Map<String, dynamic>>.from(_box?.get(_keySales, defaultValue: [])?.cast<Map>() ?? []);
    list.add(sale);
    await _box?.put(_keySales, list);
  }

  Future<List<Map<String, dynamic>>> getPendingSales() async {
    await init();
    final list = List<Map<String, dynamic>>.from(_box?.get(_keySales, defaultValue: [])?.cast<Map>() ?? []);
    return list;
  }

  Future<void> clearPendingSales() async {
    await init();
    await _box?.put(_keySales, []);
  }

  Future<void> overwritePendingSales(List<Map<String, dynamic>> sales) async {
    await init();
    await _box?.put(_keySales, sales);
  }

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

  Future<void> setSyncIntervalMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sync_interval', minutes);
  }

  Future<int> getSyncIntervalMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('sync_interval') ?? 15;
  }
}

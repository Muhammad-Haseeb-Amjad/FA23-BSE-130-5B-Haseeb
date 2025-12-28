import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/offline_queue_service.dart';
import '../core/services/supabase_service.dart';
import '../core/services/sync_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';

class SyncPreferencesScreen extends StatefulWidget {
  const SyncPreferencesScreen({super.key});

  @override
  State<SyncPreferencesScreen> createState() => _SyncPreferencesScreenState();
}

class _SyncPreferencesScreenState extends State<SyncPreferencesScreen> {
  bool _offline = false;
  String _status = 'Idle';
  DateTime? _lastSync;
  bool _auto = true;
  bool _wifiOnly = false;
  int _interval = 15;
  List<Map<String, dynamic>> _pending = [];
  late final _connSub = ConnectivityService.instance.connectivityStream.listen(
    (online) => setState(() => _offline = !online),
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSync = DateTime.tryParse(prefs.getString('last_sync') ?? '');
      _auto = prefs.getBool('auto_sync') ?? true;
      _wifiOnly = prefs.getBool('wifi_only') ?? false;
      _interval = prefs.getInt('sync_interval') ?? 15;
    });

    // Get pending items count from all tables
    try {
      final db = LocalDatabaseService.instance;
      final products = await db.getUnsynced('products');
      final customers = await db.getUnsynced('customers');
      final sales = await db.getUnsynced('sales');
      final total = products.length + customers.length + sales.length;

      _pending = [
        {'type': 'Products', 'count': products.length},
        {'type': 'Customers', 'count': customers.length},
        {'type': 'Sales', 'count': sales.length},
      ];
    } catch (e) {
      print('Error loading pending items: $e');
    }

    if (mounted) setState(() {});
  }

  Future<void> _syncNow() async {
    setState(() => _status = 'Syncing...');

    try {
      // Use SyncService to sync all data
      await SyncService.instance.syncAllData();

      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      await prefs.setString('last_sync', now.toIso8601String());

      // Reload pending items
      await _load();

      setState(() {
        _lastSync = now;
        _status = 'Idle';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync completed successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _status = 'Sync failed');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
      }
    }
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_sync', _auto);
    await prefs.setBool('wifi_only', _wifiOnly);
    await prefs.setInt('sync_interval', _interval);
    // Apply sync behavior immediately
    if (_auto) {
      // Convert minutes to seconds
      SyncService.instance.startAutoSync(intervalSeconds: _interval * 60);
    } else {
      SyncService.instance.stopAutoSync();
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Preferences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OfflineBanner(isOffline: _offline),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Sync Status'),
              subtitle: Text(
                'Last synced: ${_lastSync == null ? 'Never' : _lastSync!.toLocal()}',
              ),
              trailing: Text(
                _status,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Pending Offline Sales'),
              subtitle: Text(
                '${_pending.fold<int>(0, (sum, item) => sum + (item['count'] as int? ?? 0))} queued',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.list_alt),
                onPressed: _pending.isEmpty
                    ? null
                    : () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => ListView(
                            padding: const EdgeInsets.all(12),
                            children: _pending
                                .map(
                                  (item) => ListTile(
                                    title: Text('${item['type']}'),
                                    trailing: Text(
                                      '${item['count']} pending',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _syncNow,
            icon: const Icon(Icons.sync),
            label: const Text('Sync Now'),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            value: _auto,
            title: const Text('Automatic Sync'),
            onChanged: (v) => setState(() => _auto = v),
          ),
          SwitchListTile(
            value: _wifiOnly,
            title: const Text('Sync only over Wi‑Fi'),
            onChanged: (v) => setState(() => _wifiOnly = v),
          ),
          ListTile(
            title: const Text('Sync Interval'),
            trailing: DropdownButton<int>(
              value: _interval,
              items: const [5, 10, 15, 30, 60]
                  .map(
                    (m) => DropdownMenuItem(value: m, child: Text('$m mins')),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _interval = v ?? 15),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _savePrefs,
            child: const Text('Save Preferences'),
          ),
        ],
      ),
    );
  }
}

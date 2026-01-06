import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/offline_queue_service.dart';
import '../core/services/supabase_service.dart';
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
  List<Map<String, dynamic>> _pendingSales = [];
  List<Map<String, dynamic>> _pendingProducts = [];
  List<Map<String, dynamic>> _pendingCustomers = [];
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) => setState(() => _offline = !online));

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
    
    // Load all pending items
    _pendingSales = await OfflineQueueService.instance.getPendingSales();
    _pendingProducts = await OfflineQueueService.instance.getPendingProducts();
    _pendingCustomers = await OfflineQueueService.instance.getPendingCustomers();
    setState(() {});
  }

  Future<void> _syncNow() async {
    setState(() => _status = 'Syncing...');
    
    try {
      // Ensure Supabase is initialized
      await SupabaseService.instance.ensureInitialized();
      
      int totalCount = 0;
      
      // Sync products, customers, then sales
      totalCount += await OfflineQueueService.instance.syncPendingProducts(SupabaseService.instance.client);
      totalCount += await OfflineQueueService.instance.syncPendingCustomers(SupabaseService.instance.client);
      totalCount += await OfflineQueueService.instance.syncPendingSales(SupabaseService.instance.client);
      
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      await prefs.setString('last_sync', now.toIso8601String());
      
      // Reload pending items
      _pendingSales = await OfflineQueueService.instance.getPendingSales();
      _pendingProducts = await OfflineQueueService.instance.getPendingProducts();
      _pendingCustomers = await OfflineQueueService.instance.getPendingCustomers();
      
      setState(() {
        _lastSync = now;
        _status = 'Sync complete ($totalCount pushed)';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Synced $totalCount items to cloud'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Sync error: $e');
      setState(() => _status = 'Sync failed: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_sync', _auto);
    await prefs.setBool('wifi_only', _wifiOnly);
    await prefs.setInt('sync_interval', _interval);
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
              subtitle: Text('Last synced: ${_lastSync == null ? 'Never' : _lastSync!.toLocal()}'),
              trailing: Text(_status, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Pending Offline Products'),
              subtitle: Text('${_pendingProducts.length} queued'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.list_alt),
                    onPressed: _pendingProducts.isEmpty
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ListView(
                                padding: const EdgeInsets.all(12),
                                children: _pendingProducts
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => ListTile(
                                        title: Text('${e.value['name']} • ${e.value['price']}'),
                                        subtitle: Text('Qty: ${e.value['quantity']}'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: () async {
                                            _pendingProducts.removeAt(e.key);
                                            // Manually update the queue
                                            await OfflineQueueService.instance.init();
                                            if (mounted) setState(() {});
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: _pendingProducts.isEmpty
                        ? null
                        : () async {
                            await OfflineQueueService.instance.clearPendingProducts();
                            _pendingProducts = [];
                            if (mounted) setState(() {});
                          },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Pending Offline Customers'),
              subtitle: Text('${_pendingCustomers.length} queued'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.list_alt),
                    onPressed: _pendingCustomers.isEmpty
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ListView(
                                padding: const EdgeInsets.all(12),
                                children: _pendingCustomers
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e.value['name'] ?? 'Unknown'),
                                        subtitle: Text(e.value['phone'] ?? e.value['email'] ?? ''),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: () async {
                                            _pendingCustomers.removeAt(e.key);
                                            if (mounted) setState(() {});
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: _pendingCustomers.isEmpty
                        ? null
                        : () async {
                            await OfflineQueueService.instance.clearPendingCustomers();
                            _pendingCustomers = [];
                            if (mounted) setState(() {});
                          },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Pending Offline Sales'),
              subtitle: Text('${_pendingSales.length} queued'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.list_alt),
                    onPressed: _pendingSales.isEmpty
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ListView(
                                padding: const EdgeInsets.all(12),
                                children: _pendingSales
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => ListTile(
                                        title: Text('Sale ${e.key + 1} • ${e.value['total']}'),
                                        subtitle: Text(e.value['created_at'] ?? ''),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: () async {
                                            _pendingSales.removeAt(e.key);
                                            await OfflineQueueService.instance.overwritePendingSales(_pendingSales);
                                            if (mounted) setState(() {});
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: _pendingSales.isEmpty
                        ? null
                        : () async {
                            await OfflineQueueService.instance.clearPendingSales();
                            _pendingSales = [];
                            if (mounted) setState(() {});
                          },
                  ),
                ],
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
              items: const [5, 10, 15, 30, 60].map((m) => DropdownMenuItem(value: m, child: Text('$m mins'))).toList(),
              onChanged: (v) => setState(() => _interval = v ?? 15),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _savePrefs, child: const Text('Save Preferences')),
        ],
      ),
    );
  }
}

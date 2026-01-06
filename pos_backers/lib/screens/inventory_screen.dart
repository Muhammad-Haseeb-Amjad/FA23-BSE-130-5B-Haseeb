import 'package:flutter/material.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import 'stock_operations_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _offline = false;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) => setState(() => _offline = !online));
  String _filter = '';

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    try {
      // Load local first so restored backups are visible while online
      var products = await LocalDatabaseService.instance.query('products');

      if (!_offline) {
        try {
          final res = await SupabaseService.instance.client.from('products').select('id, name, category, quantity');
          final remote = List<Map<String, dynamic>>.from(res);

          if (remote.isNotEmpty) {
            for (final product in remote) {
              await LocalDatabaseService.instance.insertProduct({...product, 'synced': 1});
            }
            products = remote;
          }
        } catch (e) {
          print('Supabase fetch failed, keeping local cache: $e');
        }
      }

      return products;
    } catch (e) {
      print('Error loading inventory: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Overview')),
      body: Column(
        children: [
          OfflineBanner(isOffline: _offline),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search or filter'),
              onChanged: (v) => setState(() => _filter = v.toLowerCase()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download_done_rounded),
                    label: const Text('Stock In'),
                    onPressed: () async {
                      final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StockOperationsScreen(stockIn: true)));
                      if (res == true && mounted) setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Stock Out'),
                    onPressed: () async {
                      final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StockOperationsScreen(stockIn: false)));
                      if (res == true && mounted) setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _load(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                  final items = snapshot.data ?? [];
                  final filtered = items.where((i) => i['name'].toString().toLowerCase().contains(_filter)).toList();
                  if (filtered.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text('No inventory items.')),
                      ],
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      final low = (p['quantity'] ?? 0) <= 5;
                      return ListTile(
                        title: Text(p['name'] ?? ''),
                        subtitle: Text(p['category'] ?? ''),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${p['quantity'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w800)),
                            if (low) const Text('Low', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

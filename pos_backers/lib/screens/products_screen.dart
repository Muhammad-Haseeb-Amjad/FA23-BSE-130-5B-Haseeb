import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import 'add_edit_product_screen.dart';
import '../core/services/connectivity_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _query = '';
  bool _offline = false;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) {
    setState(() => _offline = !online);
  });

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final client = SupabaseService.instance.client;
    final res = await client.from('products').select('id, name, category, quantity, price');
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> _delete(int id) async {
    await SupabaseService.instance.client.from('products').delete().eq('id', id);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final added = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddEditProductScreen()));
          if (added == true && mounted) setState(() {});
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            OfflineBanner(isOffline: _offline),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search name or barcode'),
                onChanged: (value) => setState(() => _query = value.toLowerCase()),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _loadProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final items = snapshot.data ?? [];
                  final filtered = items.where((p) => p['name'].toString().toLowerCase().contains(_query)).toList();
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      return Dismissible(
                        key: ValueKey(p['id']),
                        background: Container(color: Colors.redAccent, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _delete(p['id'] as int),
                        child: ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          leading: CircleAvatar(backgroundColor: Colors.orange.shade50, child: const Icon(Icons.bakery_dining, color: AppColors.primary)),
                          title: Text(p['name'] ?? ''),
                          subtitle: Text(p['category'] ?? ''),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Qty: ${p['quantity'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text('\$${p['price'] ?? 0}', style: const TextStyle(color: AppColors.muted)),
                            ],
                          ),
                          onTap: () async {
                            final updated = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddEditProductScreen(product: p)));
                            if (updated == true && mounted) setState(() {});
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/supabase_service.dart';
import '../core/services/settings_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import 'add_edit_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _query = '';
  bool _offline = false;
  String _currencySymbol = r'$';
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) {
    setState(() => _offline = !online);
  });

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final symbol = await SettingsService.instance.currencySymbol();
    if (mounted) setState(() => _currencySymbol = symbol);
  }

  Future<void> _checkConnectivity() async {
    final online = await ConnectivityService.instance.isOnline;
    if (mounted) {
      setState(() => _offline = !online);
    }
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    try {
      // Prefer local cache/restored data so import works while online
      var products = await LocalDatabaseService.instance.query('products');

      // If online, try to fetch from Supabase and override only when it has rows
      if (!_offline) {
        try {
          final client = SupabaseService.instance.client;
          final res = await client.from('products').select('id, name, category, quantity, price, cost_price, barcode, batch_date, expiry_date, low_stock_alert, expiry_alert, image_path');
          final remote = List<Map<String, dynamic>>.from(res);

          if (remote.isNotEmpty) {
            for (final product in remote) {
              await LocalDatabaseService.instance.insertProduct({
                ...product,
                'synced': 1,
              });
            }
            products = remote;
          }
        } catch (e) {
          // If online but Supabase fails, fall back to local database
          print('Supabase fetch failed, keeping local DB: $e');
        }
      }
      
      // Load from local database (offline, Supabase failed, or remote empty)
      return products;
    } catch (e) {
      print('Error loading products: $e');
      return [];
    }
  }

  Future<void> _delete(String id) async {
    try {
      if (!_offline) {
        await SupabaseService.instance.client.from('products').delete().eq('id', id);
      }
      // Also delete from local database
      await LocalDatabaseService.instance.delete('products', id);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
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
              child: RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _loadProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    final items = snapshot.data ?? [];
                    final filtered = items.where((p) => p['name'].toString().toLowerCase().contains(_query)).toList();
                    
                    if (filtered.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 80),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  'No products found.',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _offline ? 'Add products online first or tap + to add offline' : 'Tap + to add your first product',
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        final imagePath = p['image_path'] as String?;
                        
                        // Debug: Check if file exists
                        bool fileExists = false;
                        if (imagePath != null && !imagePath.startsWith('http')) {
                          fileExists = File(imagePath).existsSync();
                          print('Image path: $imagePath, exists: $fileExists');
                        }
                        
                        return Dismissible(
                          key: ValueKey(p['id'].toString()),
                          background: Container(color: Colors.redAccent, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            return await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete product?'),
                                    content: Text('This will remove "${p['name'] ?? 'product'}".'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                      ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete')),
                                    ],
                                  ),
                                ) ??
                                false;
                          },
                          onDismissed: (_) => _delete(p['id'].toString()),
                          child: ListTile(
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.orange.shade50,
                              child: imagePath == null || imagePath.isEmpty || (!fileExists && !imagePath.startsWith('http'))
                                  ? const Icon(Icons.bakery_dining, color: AppColors.primary, size: 30)
                                  : ClipOval(
                                      child: imagePath.startsWith('http')
                                          ? Image.network(
                                              imagePath,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Icon(Icons.bakery_dining, color: AppColors.primary, size: 30),
                                            )
                                          : Image.file(
                                              File(imagePath),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Icon(Icons.bakery_dining, color: AppColors.primary, size: 30),
                                            ),
                                    ),
                            ),
                            title: Text(p['name'] ?? ''),
                            subtitle: Text(p['category'] ?? ''),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Qty: ${p['quantity'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                Text('$_currencySymbol${p['price'] ?? 0}', style: const TextStyle(color: AppColors.muted)),
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
            ),
          ],
        ),
      ),
    );
  }
}

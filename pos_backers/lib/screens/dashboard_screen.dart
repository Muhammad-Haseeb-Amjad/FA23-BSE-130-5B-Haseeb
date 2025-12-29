import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import 'profile_screen.dart';

class DashboardData {
  final double todaySales;
  final int lowStock;
  final List<Map<String, dynamic>> bestSellers;
  final int totalProducts;
  final int expiryAlerts;
  final int bakedToday;
  DashboardData({
    required this.todaySales,
    required this.lowStock,
    required this.bestSellers,
    required this.totalProducts,
    required this.expiryAlerts,
    required this.bakedToday,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _offline = false;
  String? _avatarPath;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) {
    setState(() => _offline = !online);
  });

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('profile_avatar_path');
    if (!mounted) return;
    setState(() => _avatarPath = saved);
  }

  void _openProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  Future<DashboardData> _load() async {
    final todayStart = DateTime.now();
    final start = DateTime(todayStart.year, todayStart.month, todayStart.day).toIso8601String();

    double todaySales = 0;
    int lowStock = 0;
    int totalProducts = 0;
    int expiryAlerts = 0;
    int baked = 0;
    List<Map<String, dynamic>> best = [];

    try {
      if (!_offline) {
        try {
          final client = SupabaseService.instance.client;
          final sales = await client.from('sales').select('total').gte('created_at', start);
          todaySales = sales.fold<double>(0, (sum, row) => sum + (row['total'] as num).toDouble());
        } catch (e) {
          // Fall back to local database
          final localSales = await LocalDatabaseService.instance.query('sales');
          final todaySalesData = localSales.where((s) => (s['created_at'] as String).compareTo(start) >= 0);
          todaySales = todaySalesData.fold<double>(0, (sum, row) => sum + (row['total'] as num).toDouble());
        }
      } else {
        // Load from local database when offline
        final localSales = await LocalDatabaseService.instance.query('sales');
        final todaySalesData = localSales.where((s) => (s['created_at'] as String).compareTo(start) >= 0);
        todaySales = todaySalesData.fold<double>(0, (sum, row) => sum + (row['total'] as num).toDouble());
      }
    } catch (e) {
      print('Error loading sales: $e');
    }

    try {
      if (!_offline) {
        try {
          final client = SupabaseService.instance.client;
          final items = await client.from('products').select('quantity, name, category, price').order('quantity', ascending: true).limit(5);
          totalProducts = items.length;
          lowStock = items.where((p) => (p['quantity'] ?? 0) <= 5).length;
          best = items.take(3).map<Map<String, dynamic>>((p) => {
                'name': p['name'],
                'sold': p['quantity'] ?? 0,
                'price': p['price'] ?? 0,
              }).toList();
        } catch (e) {
          // Fall back to local database
          final items = await LocalDatabaseService.instance.query('products');
          totalProducts = items.length;
          lowStock = items.where((p) => (p['quantity'] ?? 0) <= 5).length;
          best = items.take(3).map<Map<String, dynamic>>((p) => {
                'name': p['name'],
                'sold': p['quantity'] ?? 0,
                'price': p['price'] ?? 0,
              }).toList();
        }
      } else {
        final items = await LocalDatabaseService.instance.query('products');
        totalProducts = items.length;
        lowStock = items.where((p) => (p['quantity'] ?? 0) <= 5).length;
        best = items.take(3).map<Map<String, dynamic>>((p) => {
              'name': p['name'],
              'sold': p['quantity'] ?? 0,
              'price': p['price'] ?? 0,
            }).toList();
      }
    } catch (e) {
      print('Error loading products: $e');
    }

    // Skip inventory_batches and production_logs as they don't have local tables yet
    try {
      if (!_offline) {
        final client = SupabaseService.instance.client;
        final expiring = await client.from('inventory_batches').select('expiry_date').lte('expiry_date', DateTime.now().add(const Duration(days: 3)).toIso8601String());
        expiryAlerts = expiring.length;
      }
    } catch (_) {}

    try {
      if (!_offline) {
        final client = SupabaseService.instance.client;
        final prod = await client.from('production_logs').select('quantity').gte('created_at', start);
        baked = prod.fold<int>(0, (sum, row) => sum + (row['quantity'] as int));
      }
    } catch (_) {}

    return DashboardData(
      todaySales: todaySales,
      lowStock: lowStock,
      bestSellers: best,
      totalProducts: totalProducts,
      expiryAlerts: expiryAlerts,
      bakedToday: baked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: FutureBuilder<DashboardData>(
            future: _load(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              return ListView(
                padding: const EdgeInsets.only(bottom: 18),
                children: [
                  OfflineBanner(isOffline: _offline),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _openProfile,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                backgroundImage: _avatarPath != null && File(_avatarPath!).existsSync() ? FileImage(File(_avatarPath!)) : null,
                                child: (_avatarPath == null || !File(_avatarPath!).existsSync())
                                    ? const Icon(Icons.person, color: AppColors.primary, size: 28)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<String?>(
                                  future: SupabaseService.instance.getCurrentUserEmail(),
                                  builder: (ctx, snap) {
                                    final email = snap.data ?? 'baker@example.com';
                                    final name = email.split('@')[0];
                                    final displayName = name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : 'Admin';
                                    return Text('Hi, $displayName!', style: Theme.of(context).textTheme.headlineMedium);
                                  },
                                ),
                                const SizedBox(height: 4),
                                Row(children: const [
                                  Icon(Icons.circle, color: AppColors.success, size: 10),
                                  SizedBox(width: 6),
                                  Text('Store Open · 8:45 AM', style: TextStyle(color: AppColors.muted)),
                                ]),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_none_rounded, size: 28),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, size: 26),
                              onPressed: () => context.push('/settings'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Sales', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 6),
                          Text(
                            data == null ? '—' : NumberFormat.simpleCurrency().format(data.todaySales),
                            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.trending_up, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text('vs yesterday', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Daily Production', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                                  child: const Text('On Track', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text('${data?.bakedToday ?? '—'} items baked today', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: ((data?.bakedToday ?? 0) / 1000).clamp(0, 1).toDouble(),
                                minHeight: 10,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _statRow('Low Stock Alerts', data?.lowStock ?? 0, icon: Icons.inventory_2_outlined, color: AppColors.danger),
                        _statRow('Total Products', data?.totalProducts ?? 0, icon: Icons.list_alt, color: AppColors.primary),
                        _statRow('Expiry Alerts', data?.expiryAlerts ?? 0, icon: Icons.warning_amber, color: Colors.redAccent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Best Sellers', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 12),
                            if (data == null || data.bestSellers.isEmpty)
                              const Text('No data yet. Add sales to see best sellers.', style: TextStyle(color: AppColors.muted))
                            else
                              ...data.bestSellers.map((item) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.bakery_dining, color: AppColors.primary)),
                                    title: Text(item['name'] ?? ''),
                                    subtitle: Text('Sold: ${item['sold']}'),
                                    trailing: Text(NumberFormat.simpleCurrency().format((item['price'] ?? 0) * (item['sold'] ?? 0))),
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _statRow(String title, int value, {required IconData icon, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

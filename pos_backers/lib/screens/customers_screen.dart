import 'package:flutter/material.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import 'add_edit_customer_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _query = '';
  bool _offline = false;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) => setState(() => _offline = !online));

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    try {
      // Prefer local cache/restored data
      var customers = await LocalDatabaseService.instance.query('customers');

      if (!_offline) {
        try {
          final res = await SupabaseService.instance.client.from('customers').select('id,name,phone,email');
          final remote = List<Map<String, dynamic>>.from(res);
          
          if (remote.isNotEmpty) {
            // Cache to local database
            for (final customer in remote) {
              await LocalDatabaseService.instance.insertCustomer({...customer, 'synced': 1});
            }
            customers = remote;
          }
        } catch (e) {
          print('Supabase fetch failed, keeping local DB: $e');
        }
      }
      
      // Load from local database (or remote when not empty)
      return customers;
    } catch (e) {
      print('Error loading customers: $e');
      return [];
    }
  }

  Future<void> _delete(dynamic id) async {
    try {
      if (!_offline) {
        await SupabaseService.instance.client.from('customers').delete().eq('id', id);
      }
      // Also delete from local database
      await LocalDatabaseService.instance.delete('customers', id.toString());
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
      appBar: AppBar(title: const Text('Customers')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final added = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()));
          if (added == true && mounted) setState(() {});
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          OfflineBanner(isOffline: _offline),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search customers'),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _load(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                final items = snapshot.data ?? [];
                final filtered = items.where((c) => c['name'].toString().toLowerCase().contains(_query) || (c['phone'] ?? '').toString().toLowerCase().contains(_query)).toList();
                if (filtered.isEmpty) return const Center(child: Text('No customers found'));
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final c = filtered[index];
                    return Dismissible(
                      key: ValueKey(c['id']),
                      direction: DismissDirection.endToStart,
                      background: Container(color: Colors.redAccent, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Customer?'),
                                content: Text('This will remove "${c['name'] ?? 'customer'}" permanently.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                  ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete')),
                                ],
                              ),
                            ) ??
                            false;
                      },
                      onDismissed: (_) => _delete(c['id']),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        title: Text(c['name'] ?? ''),
                        subtitle: Text(c['phone'] ?? c['email'] ?? ''),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final updated = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddEditCustomerScreen(customer: c)));
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
    );
  }
}

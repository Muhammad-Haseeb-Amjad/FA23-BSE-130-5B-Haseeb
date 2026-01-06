import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/offline_queue_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Map<String, dynamic>? customer;
  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.customer?['name'] ?? '');
  late final TextEditingController _phone = TextEditingController(text: widget.customer?['phone'] ?? '');
  late final TextEditingController _email = TextEditingController(text: widget.customer?['email'] ?? '');
  late final TextEditingController _address = TextEditingController(text: widget.customer?['address'] ?? '');
  late final TextEditingController _points = TextEditingController(text: widget.customer?['points']?.toString() ?? '0');
  bool _saving = false;
  bool _online = true;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) {
    setState(() => _online = online);
  });

  @override
  void dispose() {
    _connSub.cancel();
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _points.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final id = widget.customer?['id'] ?? const Uuid().v4();
    final data = {
      'id': id.toString(),
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'email': _email.text.trim(),
      'address': _address.text.trim(),
      'loyalty_points': int.tryParse(_points.text) ?? 0,
      'created_at': widget.customer?['created_at'] ?? DateTime.now().toIso8601String(),
    };
    
    try {
      bool savedToSupabase = false;
      
      // Try to save to Supabase when online
      if (_online) {
        try {
          final client = SupabaseService.instance.client;
          if (widget.customer == null) {
            await client.from('customers').insert(data);
          } else {
            final updateData = Map<String, dynamic>.from(data)..remove('id')..remove('created_at');
            await client.from('customers').update(updateData).eq('id', id);
          }
          savedToSupabase = true;
        } catch (e) {
          // Supabase failed, queue for later sync
          print('Supabase save failed: $e');
          await OfflineQueueService.instance.enqueueCustomer(data);
        }
      } else {
        // Offline - queue the customer for sync
        await OfflineQueueService.instance.enqueueCustomer(data);
      }
      
      // Always save to local database
      final localData = {
        ...data,
        'synced': savedToSupabase ? 1 : 0,
      };
      
      if (widget.customer == null) {
        await LocalDatabaseService.instance.insertCustomer(localData);
      } else {
        await LocalDatabaseService.instance.update('customers', localData, id.toString());
      }
      
      if (!mounted) return;
      
      if (!_online || !savedToSupabase) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer saved locally. Will sync when online.'), duration: Duration(seconds: 2)),
        );
      }
      
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _points,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Loyalty Points'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Save'),
                ),
              ),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel', style: TextStyle(color: AppColors.muted))),
            ],
          ),
        ),
      ),
    );
  }
}

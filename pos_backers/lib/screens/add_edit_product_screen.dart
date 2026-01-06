import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:uuid/uuid.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/offline_queue_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';

class AddEditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _category;
  late TextEditingController _barcode;
  late TextEditingController _cost;
  late TextEditingController _price;
  late TextEditingController _qty;
  late TextEditingController _batchDate;
  late TextEditingController _expiryDate;
  late bool _lowStockAlert;
  late bool _expiryAlert;
  String? _imagePath;
  bool _saving = false;
  bool _online = true;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) {
    setState(() => _online = online);
  });

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product?['name'] ?? '');
    _category = TextEditingController(text: widget.product?['category'] ?? '');
    _barcode = TextEditingController(text: widget.product?['barcode'] ?? '');
    _cost = TextEditingController(text: widget.product?['cost_price']?.toString() ?? '');
    _price = TextEditingController(text: widget.product?['price']?.toString() ?? '');
    _qty = TextEditingController(text: widget.product?['quantity']?.toString() ?? '');
    _batchDate = TextEditingController(text: widget.product?['batch_date'] ?? '');
    _expiryDate = TextEditingController(text: widget.product?['expiry_date'] ?? '');
    _lowStockAlert = widget.product?['low_stock_alert'] ?? true;
    _expiryAlert = widget.product?['expiry_alert'] ?? true;
    _imagePath = widget.product?['image_path'];
  }

  @override
  void dispose() {
    _connSub.cancel();
    _name.dispose();
    _category.dispose();
    _barcode.dispose();
    _cost.dispose();
    _price.dispose();
    _qty.dispose();
    _batchDate.dispose();
    _expiryDate.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final id = (widget.product?['id'] ?? const Uuid().v4()).toString();
    final data = {
      'id': id,
      'name': _name.text.trim(),
      'category': _category.text.trim(),
      'barcode': _barcode.text.trim().isEmpty ? null : _barcode.text.trim(),
      'cost_price': double.tryParse(_cost.text) ?? 0,
      'price': double.tryParse(_price.text) ?? 0,
      'quantity': int.tryParse(_qty.text) ?? 0,
      'batch_date': _batchDate.text.isEmpty ? null : _batchDate.text,
      'expiry_date': _expiryDate.text.isEmpty ? null : _expiryDate.text,
      'low_stock_alert': _lowStockAlert,
      'expiry_alert': _expiryAlert,
      'created_at': widget.product?['created_at'] ?? DateTime.now().toIso8601String(),
    };
    
    try {
      bool savedToSupabase = false;
      
      // Try to save to Supabase when online
      if (_online) {
        try {
          final client = SupabaseService.instance.client;
          if (widget.product == null) {
            await client.from('products').insert(data);
          } else {
            final updateData = Map<String, dynamic>.from(data)..remove('id')..remove('created_at');
            await client.from('products').update(updateData).eq('id', id);
          }
          savedToSupabase = true;
          print('Product saved to Supabase: $id');
        } catch (e) {
          // Supabase failed, queue for later sync
          print('Supabase save failed, queuing product: $e');
          await OfflineQueueService.instance.enqueueProduct(data);
        }
      } else {
        // Offline - queue the product for sync
        print('Offline mode - queuing product: $id');
        await OfflineQueueService.instance.enqueueProduct(data);
      }
      
      // Always save to local database with image_path
      final localData = {
        ...data,
        'synced': savedToSupabase ? 1 : 0,
        if (_imagePath != null) 'image_path': _imagePath,
      };
      
      if (widget.product == null) {
        await LocalDatabaseService.instance.insertProduct(localData);
      } else {
        await LocalDatabaseService.instance.update('products', localData, id);
      }
      
      if (!mounted) return;
      
      // Show appropriate message
      if (!_online || !savedToSupabase) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product saved locally. Will sync when online.'), duration: Duration(seconds: 2)),
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

  Future<void> _pickDate(TextEditingController controller) async {
    final initial = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: initial, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() => _imagePath = result.files.single.path);
    }
  }

  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan(options: const ScanOptions(useCamera: -1));
      final code = result.rawContent;
      if (code.isNotEmpty) {
        setState(() => _barcode.text = code);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scan failed: $e')));
    }
  }

  Future<void> _confirmAndDelete() async {
    final product = widget.product;
    if (product == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('This will remove "${product['name'] ?? 'product'}" from your list.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteProduct(product['id'].toString());
    }
  }

  Future<void> _deleteProduct(String id) async {
    setState(() => _saving = true);
    try {
      if (_online) {
        try {
          await SupabaseService.instance.client.from('products').delete().eq('id', id);
        } catch (e) {
          // If Supabase delete fails, still remove locally
          print('Supabase delete failed: $e');
        }
      }

      await LocalDatabaseService.instance.delete('products', id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          if (widget.product != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete product',
              onPressed: _saving ? null : _confirmAndDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                          image: _imagePath != null ? DecorationImage(image: FileImage(File(_imagePath!)), fit: BoxFit.cover) : null,
                        ),
                        child: _imagePath == null ? const Icon(Icons.add_a_photo, color: AppColors.primary) : null,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add product photo', style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('Tap to choose image', style: TextStyle(color: AppColors.muted)),
                          ],
                        ),
                      ),
                      if (_imagePath != null)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _imagePath = null),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(labelText: 'Category (Bread, Cake, etc.)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _barcode,
                decoration: InputDecoration(
                  labelText: 'Barcode (optional)',
                  suffixIcon: IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: _scanBarcode),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cost,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Cost Price'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Selling Price'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _qty,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity / Units'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _batchDate,
                      readOnly: true,
                      onTap: () => _pickDate(_batchDate),
                      decoration: const InputDecoration(labelText: 'Batch / Baking Date'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDate,
                      readOnly: true,
                      onTap: () => _pickDate(_expiryDate),
                      decoration: const InputDecoration(labelText: 'Expiry Date'),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                value: _lowStockAlert,
                title: const Text('Low stock alerts'),
                onChanged: (v) => setState(() => _lowStockAlert = v),
              ),
              SwitchListTile(
                value: _expiryAlert,
                title: const Text('Expiry alerts'),
                onChanged: (v) => setState(() => _expiryAlert = v),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(widget.product == null ? 'Save Product' : 'Update Product'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel', style: TextStyle(color: AppColors.muted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

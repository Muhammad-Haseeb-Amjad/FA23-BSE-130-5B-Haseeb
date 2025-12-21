import 'package:flutter/material.dart';
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
  bool _saving = false;

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
  }

  @override
  void dispose() {
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
    final data = {
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
    };
    try {
      final client = SupabaseService.instance.client;
      if (widget.product == null) {
        await client.from('products').insert(data);
      } else {
        await client.from('products').update(data).eq('id', widget.product!['id']);
      }
      if (!mounted) return;
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
      controller.text = picked.toIso8601String();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                decoration: const InputDecoration(labelText: 'Barcode (optional)'),
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

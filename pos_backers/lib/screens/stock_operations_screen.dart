import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';

class StockOperationsScreen extends StatefulWidget {
  final bool stockIn;
  const StockOperationsScreen({super.key, required this.stockIn});

  @override
  State<StockOperationsScreen> createState() => _StockOperationsScreenState();
}

class _StockOperationsScreenState extends State<StockOperationsScreen> {
  Map<String, dynamic>? _selectedProduct;
  final _qtyController = TextEditingController();
  final _reasonController = TextEditingController();
  final _dateController = TextEditingController();
  final _expiryController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final res = await SupabaseService.instance.client.from('products').select('id, name');
    setState(() => _products = List<Map<String, dynamic>>.from(res));
  }

  Future<void> _save() async {
    if (_selectedProduct == null || _qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select product and quantity')));
      return;
    }
    setState(() => _saving = true);
    final qty = int.tryParse(_qtyController.text) ?? 0;
    try {
      final client = SupabaseService.instance.client;
      final productRes = await client.from('products').select('quantity').eq('id', _selectedProduct!['id']).single();
      final currentQty = (productRes['quantity'] ?? 0) as int;
      final newQty = widget.stockIn ? currentQty + qty : (currentQty - qty).clamp(0, 1000000);

      await client.from('products').update({'quantity': newQty}).eq('id', _selectedProduct!['id']);

      if (widget.stockIn) {
        await client.from('inventory_batches').insert({
          'product_id': _selectedProduct!['id'],
          'quantity': qty,
          'expiry_date': _expiryController.text.isEmpty ? null : _expiryController.text,
          'batch_date': _dateController.text.isEmpty ? null : _dateController.text,
        });
      } else {
        await client.from('wastage_logs').insert({
          'product_id': _selectedProduct!['id'],
          'quantity': qty,
          'reason': _reasonController.text,
        });
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pick(TextEditingController controller) async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (picked != null) controller.text = picked.toIso8601String();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.stockIn ? 'Stock In' : 'Stock Out')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: const InputDecoration(labelText: 'Product'),
              items: _products
                  .map((p) => DropdownMenuItem(value: p, child: Text(p['name'])))
                  .toList(),
              onChanged: (v) => setState(() => _selectedProduct = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: widget.stockIn ? 'Quantity to add' : 'Quantity to deduct'),
            ),
            const SizedBox(height: 12),
            if (widget.stockIn)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _pick(_dateController),
                      decoration: const InputDecoration(labelText: 'Batch / Baking Date'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      readOnly: true,
                      onTap: () => _pick(_expiryController),
                      decoration: const InputDecoration(labelText: 'Expiry Date (optional)'),
                    ),
                  ),
                ],
              ),
            if (!widget.stockIn)
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason for wastage/deduction'),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const CircularProgressIndicator(color: Colors.white) : Text(widget.stockIn ? 'Confirm Stock In' : 'Confirm Stock Out'),
              ),
            ),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel', style: TextStyle(color: AppColors.muted))),
          ],
        ),
      ),
    );
  }
}

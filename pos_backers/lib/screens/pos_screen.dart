import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/settings_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import 'pos_payment_screen.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _cart = [];
  String _query = '';
  bool _offline = false;
  String _currencySymbol = r'$';
  String _currencyCode = 'USD';
  bool _taxEnabled = true;
  bool _taxExclusive = true;
  List<Map<String, dynamic>> _taxRules = [];
  double _discountAmount = 0;
  bool _settingsLoaded = false;
  double _discount = 0;
  bool _percentDiscount = true;
  double _taxAmount = 0;
  double _total = 0;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((online) => setState(() => _offline = !online));

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _load();
    _recalculate();
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      List<Map<String, dynamic>> products;
      
      if (!_offline) {
        try {
          final res = await SupabaseService.instance.client.from('products').select('id, name, price, quantity, barcode');
          products = List<Map<String, dynamic>>.from(res);
          
          // Cache to local database
          for (final product in products) {
            await LocalDatabaseService.instance.insertProduct({...product, 'synced': 1});
          }
        } catch (e) {
          // Fall back to local database
          products = await LocalDatabaseService.instance.query('products');
        }
      } else {
        // Load from local database when offline
        products = await LocalDatabaseService.instance.query('products');
      }
      
      setState(() => _products = products);
      _recalculate();
    } catch (e) {
      if (!mounted) return;
      print('Error loading products: $e');
    }
  }

  Future<void> _loadSettings() async {
    final symbol = await SettingsService.instance.currencySymbol();
    final code = await SettingsService.instance.currencyCode();
    final enabled = await SettingsService.instance.taxEnabled();
    final exclusive = await SettingsService.instance.taxExclusive();
    final rules = await SettingsService.instance.taxRules();
    if (mounted) {
      setState(() {
        _currencySymbol = symbol;
        _currencyCode = code;
        _taxEnabled = enabled;
        _taxExclusive = exclusive;
        _taxRules = rules;
        _settingsLoaded = true;
      });
    }
  }

  Future<void> _recalculate() async {
    if (!_settingsLoaded) {
      await _loadSettings();
    }
    double base = subtotal;
    double tax = 0;
    if (_taxEnabled && _taxRules.isNotEmpty) {
      for (final r in _taxRules) {
        if ((r['active'] ?? true) == true) {
          final rate = (r['rate'] as num).toDouble();
          if (_taxExclusive) {
            tax += base * (rate / 100);
          } else {
            tax += base - base / (1 + rate / 100);
          }
        }
      }
    }
    var baseTotal = base + tax;
    double discountAmount = 0;
    if (_discount > 0) {
      discountAmount = _percentDiscount ? baseTotal * (_discount / 100) : _discount;
      baseTotal -= discountAmount;
    }
    if (mounted) {
      setState(() {
        _taxAmount = tax;
        _discountAmount = discountAmount;
        _total = baseTotal;
      });
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    final existingIndex = _cart.indexWhere((c) => c['id'] == product['id']);
    if (existingIndex >= 0) {
      _cart[existingIndex]['qty'] = (_cart[existingIndex]['qty'] as int) + 1;
    } else {
      _cart.add({...product, 'qty': 1});
    }
    setState(() {});
    _recalculate();
  }

  void _updateQty(int index, int delta) {
    final newQty = (_cart[index]['qty'] as int) + delta;
    if (newQty <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index]['qty'] = newQty;
    }
    setState(() {});
    _recalculate();
  }

  double get subtotal => _cart.fold(0, (sum, item) => sum + (item['qty'] as int) * (item['price'] as num));

  Future<void> _scanAndAdd() async {
    try {
      final result = await BarcodeScanner.scan(options: const ScanOptions(useCamera: -1));
      final code = result.rawContent;
      if (code.isEmpty) return;
      final match = _products.firstWhere(
        (p) => (p['barcode']?.toString() == code) || p['id'].toString() == code || p['name'].toString().toLowerCase().contains(code.toLowerCase()),
        orElse: () => {},
      );
      if (match.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No product found for "$code"')));
      } else {
        _addToCart(match);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scan failed: $e')));
    }
  }

  void _showDiscountDialog() {
    final controller = TextEditingController(text: _discount.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Apply discount'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Value'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    value: true,
                    groupValue: _percentDiscount,
                    onChanged: (v) => setState(() => _percentDiscount = v ?? true),
                    title: const Text('%'),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    value: false,
                    groupValue: _percentDiscount,
                    onChanged: (v) => setState(() => _percentDiscount = v ?? false),
                    title: const Text('Fixed'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              _discount = double.tryParse(controller.text) ?? 0;
              setState(() {});
              _recalculate();
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _products.where((p) => p['name'].toString().toLowerCase().contains(_query)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('POS Billing')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'scan',
        onPressed: _scanAndAdd,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadSettings();
          await _load();
        },
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  OfflineBanner(isOffline: _offline),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search products'),
                      onChanged: (v) => setState(() => _query = v.toLowerCase()),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight - 140,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final p = filtered[index];
                              return ListTile(
                                title: Text(p['name'] ?? ''),
                                subtitle: Text('$_currencySymbol${p['price']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                                  onPressed: () => _addToCart(p),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(width: 1, color: Colors.grey.shade200),
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _cart.length,
                                  itemBuilder: (context, index) {
                                    final item = _cart[index];
                                    return ListTile(
                                      title: Text(item['name']),
                                      subtitle: Text('Qty ${item['qty']} x $_currencySymbol${item['price']}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => _updateQty(index, -1)),
                                          Text(item['qty'].toString()),
                                          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _updateQty(index, 1)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('$_currencySymbol${subtotal.toStringAsFixed(2)}')]),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tax'), Text('$_currencySymbol${_taxAmount.toStringAsFixed(2)}')]),
                                    if (_discount > 0)
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Discount ${_percentDiscount ? '(%)' : ''}'), Text('-$_currencySymbol${_discountAmount.toStringAsFixed(2)}')]),
                                    const Divider(),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w800)), Text('$_currencySymbol${_total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800))]),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            icon: const Icon(Icons.percent),
                                            label: const Text('Discount'),
                                            onPressed: _showDiscountDialog,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _cart.isEmpty
                                                ? null
                                                : () async {
                                                    final result = await Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (_) => PosPaymentScreen(
                                                        cart: _cart,
                                                        subtotal: subtotal,
                                                        tax: _taxAmount,
                                                        total: _total,
                                                        currencySymbol: _currencySymbol,
                                                        currencyCode: _currencyCode,
                                                      ),
                                                    ));
                                                    if (result == true) {
                                                      setState(() => _cart.clear());
                                                    }
                                                  },
                                            child: const Text('Checkout'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

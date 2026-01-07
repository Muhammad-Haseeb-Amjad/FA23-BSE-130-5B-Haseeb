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
  // Per-sale tax application state
  bool _applyTax = true;
  List<int> _selectedTaxRuleIndices = [];
  // Customer selection state
  List<Map<String, dynamic>> _customers = [];
  String? _customerId;
  String? _customerName;
  bool _walkInCustomer = true;
  double _discountAmount = 0;
  bool _settingsLoaded = false;
  double _discount = 0;
  bool _percentDiscount = true;
  double _taxAmount = 0;
  double _total = 0;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen(
    (online) => setState(() => _offline = !online),
  );

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _load();
    _loadCustomers();
    _recalculate();
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      // Always read local first so restored backups show even when online
      var products = await LocalDatabaseService.instance.query('products');

      if (!_offline) {
        try {
          final res = await SupabaseService.instance.client
              .from('products')
              .select('id, name, price, quantity, barcode');
          final remote = List<Map<String, dynamic>>.from(res);

          if (remote.isNotEmpty) {
            // Cache to local database and use remote as source of truth
            for (final product in remote) {
              await LocalDatabaseService.instance.insertProduct({
                ...product,
                'synced': 1,
              });
            }
            products = remote;
          }
        } catch (e) {
          // Ignore and keep local snapshot
          print('Supabase fetch failed, using local cache: $e');
        }
      }

      setState(() => _products = products);
      _recalculate();
    } catch (e) {
      if (!mounted) return;
      print('Error loading products: $e');
    }
  }

  Future<void> _loadCustomers() async {
    try {
      final rows = await LocalDatabaseService.instance.query('customers');
      setState(() => _customers = rows);
    } catch (e) {
      print('Error loading customers: $e');
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
        // Initialize per-sale tax state based on settings
        _applyTax = _taxEnabled;
        _selectedTaxRuleIndices = List.generate(
          _taxRules.length,
          (i) => i,
        ).where((i) => (_taxRules[i]['active'] ?? true) == true).toList();
      });
    }
  }

  Future<void> _recalculate() async {
    if (!_settingsLoaded) {
      await _loadSettings();
    }
    double base = subtotal;
    double tax = 0;
    if (_applyTax && _selectedTaxRuleIndices.isNotEmpty) {
      for (final idx in _selectedTaxRuleIndices) {
        final r = _taxRules[idx];
        final rate = (r['rate'] as num).toDouble();
        if (_taxExclusive) {
          tax += base * (rate / 100);
        } else {
          tax += base - base / (1 + rate / 100);
        }
      }
    }
    var baseTotal = base + tax;
    double discountAmount = 0;
    if (_discount > 0) {
      discountAmount = _percentDiscount
          ? baseTotal * (_discount / 100)
          : _discount;
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

  double get subtotal => _cart.fold(
    0,
    (sum, item) => sum + (item['qty'] as int) * (item['price'] as num),
  );

  Future<void> _scanAndAdd() async {
    try {
      final result = await BarcodeScanner.scan(
        options: const ScanOptions(useCamera: -1),
      );
      final code = result.rawContent;
      if (code.isEmpty) return;
      final match = _products.firstWhere(
        (p) =>
            (p['barcode']?.toString() == code) ||
            p['id'].toString() == code ||
            p['name'].toString().toLowerCase().contains(code.toLowerCase()),
        orElse: () => {},
      );
      if (match.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No product found for "$code"')));
      } else {
        _addToCart(match);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Scan failed: $e')));
    }
  }

  void _showDiscountDialog() {
    final controller = TextEditingController(text: _discount.toString());
    // Local copies for tax controls inside discount dialog
    bool applyTax = _applyTax;
    final selected = Set<int>.from(_selectedTaxRuleIndices);
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Discount & Tax'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Discount controls
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Discount value',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: _percentDiscount,
                        onChanged: (v) =>
                            setLocal(() => _percentDiscount = v ?? true),
                        title: const Text('%'),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: _percentDiscount,
                        onChanged: (v) =>
                            setLocal(() => _percentDiscount = v ?? false),
                        title: const Text('Fixed'),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                // Tax controls (moved inside discount dialog)
                SwitchListTile(
                  title: const Text('Apply tax to this sale'),
                  value: applyTax,
                  onChanged: (v) => setLocal(() => applyTax = v),
                ),
                ..._taxRules.asMap().entries.map((entry) {
                  final i = entry.key;
                  final r = entry.value;
                  final active = (r['active'] ?? true) == true;
                  return CheckboxListTile(
                    title: Text('${r['name']} (${r['rate']}%)'),
                    subtitle: active
                        ? null
                        : const Text(
                            'Inactive in settings',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                    value: selected.contains(i),
                    onChanged: (v) => setLocal(() {
                      if (v == true) {
                        selected.add(i);
                      } else {
                        selected.remove(i);
                      }
                    }),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _discount = double.tryParse(controller.text) ?? 0;
                setState(() {
                  _applyTax = applyTax;
                  _selectedTaxRuleIndices = selected.toList()..sort();
                });
                _recalculate();
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerDialog() {
    String query = '';
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setLocal) {
          final filtered = _customers
              .where(
                (c) =>
                    (c['name'] ?? '').toString().toLowerCase().contains(query),
              )
              .toList();
          return AlertDialog(
            title: const Text('Select Customer'),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Walk-in customer'),
                    value: _walkInCustomer,
                    onChanged: (v) => setLocal(() => _walkInCustomer = v),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search regular customers',
                    ),
                    onChanged: (v) => setLocal(() => query = v.toLowerCase()),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _loadCustomers();
                        setLocal(() {});
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final c = filtered[index];
                          final selected =
                              _customerId == c['id'] && !_walkInCustomer;
                          return ListTile(
                            title: Text(c['name'] ?? ''),
                            subtitle: Text(
                              (c['phone'] ?? c['email'] ?? '').toString(),
                            ),
                            trailing: selected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  )
                                : null,
                            onTap: () => setLocal(() {
                              _walkInCustomer = false;
                              _customerId = c['id']?.toString();
                              _customerName = c['name']?.toString();
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_walkInCustomer) {
                    setState(() {
                      _customerId = null;
                      _customerName = null;
                    });
                  } else {
                    setState(() {});
                  }
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTaxDialog() {
    // Local mutable copies for dialog
    bool applyTax = _applyTax;
    final selected = Set<int>.from(_selectedTaxRuleIndices);
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setLocal) {
          return AlertDialog(
            title: const Text('Apply Taxes'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: const Text('Apply tax to this sale'),
                      value: applyTax,
                      onChanged: (v) => setLocal(() => applyTax = v),
                    ),
                    const Divider(),
                    ..._taxRules.asMap().entries.map((entry) {
                      final i = entry.key;
                      final r = entry.value;
                      final active = (r['active'] ?? true) == true;
                      return CheckboxListTile(
                        title: Text('${r['name']} (${r['rate']}%)'),
                        subtitle: active
                            ? null
                            : const Text(
                                'Inactive in settings',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                        value: selected.contains(i),
                        onChanged: (v) => setLocal(() {
                          if (v == true) {
                            selected.add(i);
                          } else {
                            selected.remove(i);
                          }
                        }),
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _applyTax = applyTax;
                    _selectedTaxRuleIndices = selected.toList()..sort();
                  });
                  _recalculate();
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _products
        .where((p) => p['name'].toString().toLowerCase().contains(_query))
        .toList();
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
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search products',
                      ),
                      onChanged: (v) =>
                          setState(() => _query = v.toLowerCase()),
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
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: AppColors.primary,
                                  ),
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
                                      subtitle: Text(
                                        'Qty ${item['qty']} x $_currencySymbol${item['price']}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                            onPressed: () =>
                                                _updateQty(index, -1),
                                          ),
                                          Text(item['qty'].toString()),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                            ),
                                            onPressed: () =>
                                                _updateQty(index, 1),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Customer selection above subtotal
                                    InkWell(
                                      onTap: _showCustomerDialog,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.person_outline,
                                                size: 18,
                                              ),
                                              SizedBox(width: 6),
                                              Text('Customer'),
                                            ],
                                          ),
                                          Text(
                                            _walkInCustomer
                                                ? 'Walk-in'
                                                : (_customerName ?? 'Select'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Subtotal'),
                                        Text(
                                          '$_currencySymbol${subtotal.toStringAsFixed(2)}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Tax'),
                                        Text(
                                          '$_currencySymbol${_taxAmount.toStringAsFixed(2)}',
                                        ),
                                      ],
                                    ),
                                    if (_discount > 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Discount ${_percentDiscount ? '(%)' : ''}',
                                          ),
                                          Text(
                                            '-$_currencySymbol${_discountAmount.toStringAsFixed(2)}',
                                          ),
                                        ],
                                      ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '$_currencySymbol${_total.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        OutlinedButton.icon(
                                          icon: const Icon(Icons.percent),
                                          label: const Text('Discount'),
                                          onPressed: _showDiscountDialog,
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: _cart.isEmpty
                                              ? null
                                              : () async {
                                                  final result =
                                                      await Navigator.of(
                                                        context,
                                                      ).push(
                                                        MaterialPageRoute(
                                                          builder: (_) => PosPaymentScreen(
                                                            cart: _cart,
                                                            subtotal: subtotal,
                                                            tax: _taxAmount,
                                                            total: _total,
                                                            currencySymbol:
                                                                _currencySymbol,
                                                            currencyCode:
                                                                _currencyCode,
                                                            customerName:
                                                                _walkInCustomer
                                                                ? 'Walk-in'
                                                                : (_customerName ??
                                                                      'Regular'),
                                                          ),
                                                        ),
                                                      );
                                                  if (result == true) {
                                                    setState(
                                                      () => _cart.clear(),
                                                    );
                                                  }
                                                },
                                          child: const Text('Checkout'),
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

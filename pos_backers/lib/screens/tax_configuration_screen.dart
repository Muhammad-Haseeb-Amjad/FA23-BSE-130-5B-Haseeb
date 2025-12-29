import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';

class TaxRule {
  String name;
  double rate;
  bool active;
  TaxRule({required this.name, required this.rate, this.active = true});

  Map<String, dynamic> toJson() => {'name': name, 'rate': rate, 'active': active};
  static TaxRule fromJson(Map<String, dynamic> json) => TaxRule(name: json['name'], rate: (json['rate'] as num).toDouble(), active: json['active'] ?? true);
}

class TaxConfigurationScreen extends StatefulWidget {
  const TaxConfigurationScreen({super.key});

  @override
  State<TaxConfigurationScreen> createState() => _TaxConfigurationScreenState();
}

class _TaxConfigurationScreenState extends State<TaxConfigurationScreen> {
  bool _enabled = true;
  bool _exclusive = true;
  List<TaxRule> _rules = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('tax_enabled') ?? true;
    _exclusive = prefs.getBool('tax_exclusive') ?? true;
    final stored = prefs.getString('tax_rules');
    if (stored != null) {
      final decoded = (jsonDecode(stored) as List).map((e) => TaxRule.fromJson(Map<String, dynamic>.from(e))).toList();
      _rules = decoded;
    } else {
      _rules = [TaxRule(name: 'VAT', rate: 15), TaxRule(name: 'Service Charge', rate: 10), TaxRule(name: 'Eco Levy', rate: 2.5)];
    }
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tax_enabled', _enabled);
    await prefs.setBool('tax_exclusive', _exclusive);
    await prefs.setString('tax_rules', jsonEncode(_rules.map((e) => e.toJson()).toList()));
    if (mounted) Navigator.of(context).pop();
  }

  void _addRule() {
    final nameCtrl = TextEditingController();
    final rateCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Tax Rule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: rateCtrl, decoration: const InputDecoration(labelText: 'Rate %'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final rate = double.tryParse(rateCtrl.text) ?? 0;
              setState(() => _rules.add(TaxRule(name: nameCtrl.text, rate: rate)));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tax Configuration')),
      floatingActionButton: FloatingActionButton(backgroundColor: AppColors.primary, onPressed: _addRule, child: const Icon(Icons.add, color: Colors.white)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable Tax Calculation'),
            subtitle: const Text('Apply taxes automatically'),
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('Tax Exclusive'),
                  selected: _exclusive,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  onSelected: (_) => setState(() => _exclusive = true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ChoiceChip(
                  label: const Text('Tax Inclusive'),
                  selected: !_exclusive,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  onSelected: (_) => setState(() => _exclusive = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('${_rules.where((r) => r.active).length} Active', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ..._rules.map((r) => Card(
                child: ListTile(
                  title: Text(r.name),
                  subtitle: Text('Rate: ${r.rate}%'),
                  trailing: Switch(value: r.active, onChanged: (v) => setState(() => r.active = v)),
                ),
              )),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _save, child: const Text('Save Configuration')),
        ],
      ),
    );
  }
}

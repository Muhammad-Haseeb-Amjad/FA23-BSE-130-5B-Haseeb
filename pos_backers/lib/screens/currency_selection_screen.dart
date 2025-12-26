import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  State<CurrencySelectionScreen> createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  String? _current;
  final _currencies = const [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': r'$'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥'},
    {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': r'$'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': r'$'},
    {'code': 'SGD', 'name': 'Singapore Dollar', 'symbol': r'$'},
    {'code': 'HKD', 'name': 'Hong Kong Dollar', 'symbol': r'$'},
    {'code': 'NZD', 'name': 'New Zealand Dollar', 'symbol': r'$'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'CHF'},
    {'code': 'SEK', 'name': 'Swedish Krona', 'symbol': 'kr'},
    {'code': 'NOK', 'name': 'Norwegian Krone', 'symbol': 'kr'},
    {'code': 'DKK', 'name': 'Danish Krone', 'symbol': 'kr'},
    {'code': 'PKR', 'name': 'Pakistani Rupee', 'symbol': '₨'},
    {'code': 'BDT', 'name': 'Bangladeshi Taka', 'symbol': '৳'},
    {'code': 'LKR', 'name': 'Sri Lankan Rupee', 'symbol': 'Rs'},
    {'code': 'BRL', 'name': 'Brazilian Real', 'symbol': 'R\$'},
    {'code': 'MXN', 'name': 'Mexican Peso', 'symbol': r'$'},
    {'code': 'ZAR', 'name': 'South African Rand', 'symbol': 'R'},
    {'code': 'EGP', 'name': 'Egyptian Pound', 'symbol': 'E£'},
    {'code': 'AED', 'name': 'UAE Dirham', 'symbol': 'د.إ'},
    {'code': 'SAR', 'name': 'Saudi Riyal', 'symbol': 'ر.ع'},
    {'code': 'KWD', 'name': 'Kuwaiti Dinar', 'symbol': 'د.ك'},
    {'code': 'QAR', 'name': 'Qatari Riyal', 'symbol': 'ر.ق'},
    {'code': 'THB', 'name': 'Thai Baht', 'symbol': '฿'},
    {'code': 'IDR', 'name': 'Indonesian Rupiah', 'symbol': 'Rp'},
    {'code': 'MYR', 'name': 'Malaysian Ringgit', 'symbol': 'RM'},
    {'code': 'PHP', 'name': 'Philippine Peso', 'symbol': '₱'},
    {'code': 'VND', 'name': 'Vietnamese Dong', 'symbol': '₫'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _current = prefs.getString('currency_code') ?? 'USD');
  }

  Future<void> _select(String code, String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', code);
    await prefs.setString('currency_symbol', symbol);
    setState(() => _current = code);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Currency')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _currencies
            .map((c) => Card(
                  child: ListTile(
                    title: Text('${c['code']}'),
                    subtitle: Text('${c['name']} (${c['symbol']})'),
                    trailing: Radio<String>(
                      value: c['code']!,
                      groupValue: _current,
                      onChanged: (_) => _select(c['code']!, c['symbol']!),
                      activeColor: AppColors.primary,
                    ),
                    onTap: () => _select(c['code']!, c['symbol']!),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

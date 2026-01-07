import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/offline_queue_service.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offline_banner.dart';

class PosPaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double subtotal;
  final double tax;
  final double total;
  final String currencySymbol;
  final String currencyCode;
  final String? customerName; // Walk-in or regular customer name
  const PosPaymentScreen({
    super.key,
    required this.cart,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.currencySymbol,
    required this.currencyCode,
    this.customerName,
  });

  @override
  State<PosPaymentScreen> createState() => _PosPaymentScreenState();
}

class _PosPaymentScreenState extends State<PosPaymentScreen> {
  String _method = 'cash';
  bool _processing = false;
  bool _offline = false;
  late final _connSub = ConnectivityService.instance.connectivityStream.listen(
    (online) => setState(() => _offline = !online),
  );

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _complete() async {
    setState(() => _processing = true);
    final discount = (widget.subtotal + widget.tax) - widget.total;
    final id = const Uuid().v4();
    final sale = {
      'id': id,
      'total': widget.total,
      'subtotal': widget.subtotal,
      'tax': widget.tax,
      'discount': discount,
      'items': widget.cart.toString(),
      'method': _method,
      'currency_symbol': widget.currencySymbol,
      'currency_code': widget.currencyCode,
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      bool savedToSupabase = false;

      // Try to save to Supabase when online
      if (!_offline) {
        try {
          await SupabaseService.instance.client.from('sales').insert(sale);
          savedToSupabase = true;
          print('Sale saved to Supabase: $id');
        } catch (e) {
          // Supabase failed, queue for later sync
          print('Supabase save failed, queuing sale: $e');
          await OfflineQueueService.instance.enqueueSale(sale);
        }
      } else {
        // Offline - queue the sale for sync
        print('Offline mode - queuing sale: $id');
        await OfflineQueueService.instance.enqueueSale(sale);
      }

      // Always save to local database
      await LocalDatabaseService.instance.insertSale({
        ...sale,
        'synced': savedToSupabase ? 1 : 0,
      });

      await _updateStockQuantities(canSyncOnline: !_offline);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            savedToSupabase
                ? 'Sale recorded successfully'
                : 'Saved offline. Will sync when online.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save sale: $e')));
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _updateStockQuantities({required bool canSyncOnline}) async {
    for (final item in widget.cart) {
      final id = item['id'].toString();
      final currentQty = (item['quantity'] ?? 0) as num;
      final soldQty = (item['qty'] ?? 0) as num;
      final newQty = (currentQty - soldQty).clamp(0, double.infinity).toInt();

      try {
        // Update Supabase when allowed
        bool synced = false;
        if (canSyncOnline) {
          try {
            await SupabaseService.instance.client
                .from('products')
                .update({'quantity': newQty})
                .eq('id', id);
            synced = true;
          } catch (e) {
            print('Supabase stock update failed for $id: $e');
          }
        }

        await LocalDatabaseService.instance.update('products', {
          'quantity': newQty,
          'synced': synced ? 1 : 0,
        }, id);
      } catch (e) {
        print('Local stock update failed for $id: $e');
      }
    }
  }

  Future<void> _shareReceipt(Map<String, dynamic> sale) async {
    final buffer = StringBuffer();
    buffer.writeln('BreadBox POS Receipt');
    buffer.writeln('Date: ${sale['created_at']}');
    if (widget.customerName != null)
      buffer.writeln('Customer: ${widget.customerName}');
    buffer.writeln('Payment: ${_method.toUpperCase()}');
    buffer.writeln('');
    for (final item in widget.cart) {
      final lineTotal = (item['qty'] as num) * (item['price'] as num);
      buffer.writeln(
        '${item['qty']} x ${item['name']} @ ${widget.currencySymbol}${(item['price'] as num).toStringAsFixed(2)} = ${widget.currencySymbol}${lineTotal.toStringAsFixed(2)}',
      );
    }
    buffer.writeln('');
    buffer.writeln(
      'Subtotal: ${widget.currencySymbol}${widget.subtotal.toStringAsFixed(2)}',
    );
    buffer.writeln(
      'Tax: ${widget.currencySymbol}${widget.tax.toStringAsFixed(2)}',
    );
    if (sale['discount'] != null && (sale['discount'] as num) > 0) {
      buffer.writeln(
        'Discount: -${widget.currencySymbol}${(sale['discount'] as num).toStringAsFixed(2)}',
      );
    }
    buffer.writeln(
      'Total: ${widget.currencySymbol}${widget.total.toStringAsFixed(2)} ${widget.currencyCode}',
    );
    buffer.writeln('Thank you for shopping with us!');
    try {
      await Share.share(
        buffer.toString(),
        subject: 'Receipt ${sale['created_at']}',
      );
    } catch (_) {
      // Ignore sharing errors; proceed silently.
    }
  }

  Future<void> _printReceipt(Map<String, dynamic> sale) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'BreadBox POS Receipt',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text('Date: ${sale['created_at']}'),
            if (widget.customerName != null)
              pw.Text('Customer: ${widget.customerName}'),
            pw.Text('Payment: ${_method.toUpperCase()}'),
            pw.SizedBox(height: 10),
            pw.Divider(),
            ...widget.cart.map((item) {
              final lineTotal = (item['qty'] as num) * (item['price'] as num);
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${item['qty']} x ${item['name']}'),
                    pw.Text(
                      '${widget.currencySymbol}${lineTotal.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              );
            }),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal'),
                pw.Text(
                  '${widget.currencySymbol}${widget.subtotal.toStringAsFixed(2)}',
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Tax'),
                pw.Text(
                  '${widget.currencySymbol}${widget.tax.toStringAsFixed(2)}',
                ),
              ],
            ),
            if (sale['discount'] != null && (sale['discount'] as num) > 0)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Discount'),
                  pw.Text(
                    '-${widget.currencySymbol}${(sale['discount'] as num).toStringAsFixed(2)}',
                  ),
                ],
              ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  '${widget.currencySymbol}${widget.total.toStringAsFixed(2)} ${widget.currencyCode}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Text('Thank you for shopping with us!'),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment & Receipt')),
      body: Column(
        children: [
          OfflineBanner(isOffline: _offline),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amount Due',
                  style: TextStyle(fontSize: 14, color: AppColors.muted),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.currencySymbol}${widget.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Select payment method'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: [
                    _chip('cash', Icons.payments_outlined),
                    _chip('card', Icons.credit_card),
                    _chip('online', Icons.wifi_tethering),
                  ],
                ),
                const SizedBox(height: 18),
                const Text('Items'),
                const SizedBox(height: 10),
                ...widget.cart.map(
                  (item) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(item['name']),
                    subtitle: Text(
                      'Qty ${item['qty']} x ${widget.currencySymbol}${item['price']}',
                    ),
                    trailing: Text(
                      '${widget.currencySymbol}${(item['qty'] * item['price']).toStringAsFixed(2)}',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text(
                      '${widget.currencySymbol}${widget.subtotal.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tax'),
                    Text(
                      '${widget.currencySymbol}${widget.tax.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                if ((widget.subtotal + widget.tax) - widget.total > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount'),
                      Text(
                        '-${widget.currencySymbol}${((widget.subtotal + widget.tax) - widget.total).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${widget.currencySymbol}${widget.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _processing ? null : _complete,
                    child: _processing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Complete Sale'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _processing
                        ? null
                        : () {
                            final discount =
                                (widget.subtotal + widget.tax) - widget.total;
                            final sale = {
                              'subtotal': widget.subtotal,
                              'tax': widget.tax,
                              'discount': discount,
                              'total': widget.total,
                              'created_at': DateTime.now().toIso8601String(),
                            };
                            _printReceipt(sale);
                          },
                    icon: const Icon(Icons.print),
                    label: const Text('Print / Export PDF'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _processing
                        ? null
                        : () {
                            final discount =
                                (widget.subtotal + widget.tax) - widget.total;
                            final sale = {
                              'subtotal': widget.subtotal,
                              'tax': widget.tax,
                              'discount': discount,
                              'total': widget.total,
                              'created_at': DateTime.now().toIso8601String(),
                            };
                            _shareReceipt(sale);
                          },
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share receipt'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String value, IconData icon) {
    final selected = _method == value;
    return ChoiceChip(
      label: Text(value.toUpperCase()),
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? Colors.white : AppColors.muted,
      ),
      selected: selected,
      selectedColor: AppColors.primary,
      onSelected: (_) => setState(() => _method = value),
    );
  }
}

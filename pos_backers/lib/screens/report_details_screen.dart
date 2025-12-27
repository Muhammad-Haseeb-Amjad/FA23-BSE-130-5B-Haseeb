import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/local_database_service.dart';
import '../core/services/supabase_service.dart';

class ReportDetailsScreen extends StatefulWidget {
  final String type;
  const ReportDetailsScreen({super.key, required this.type});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  DateTimeRange? _range;
  bool _loading = false;
  bool _offline = false;
  List<Map<String, dynamic>> _rows = [];
  late final _connSub = ConnectivityService.instance.connectivityStream.listen((
    online,
  ) {
    setState(() => _offline = !online);
  });

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      if (widget.type == 'Daily Sales' || widget.type == 'Monthly Sales') {
        List<Map<String, dynamic>> sales;

        if (!_offline) {
          try {
            final client = SupabaseService.instance.client;
            final res = await client
                .from('sales')
                .select('id, total, method, created_at')
                .order('created_at', ascending: false);
            sales = List<Map<String, dynamic>>.from(res);

            // Cache to local database for offline access
            print('Caching ${sales.length} sales records to local database');
            final db = LocalDatabaseService.instance;
            for (final sale in sales) {
              try {
                await db.insert('sales', {...sale, 'synced': 1});
              } catch (e) {
                print('Error caching sale ${sale['id']}: $e');
              }
            }
          } catch (e) {
            print('Supabase fetch failed, loading from local DB: $e');
            sales = await LocalDatabaseService.instance.query('sales');
          }
        } else {
          print('Loading sales from local database (offline mode)');
          sales = await LocalDatabaseService.instance.query('sales');
          print('Found ${sales.length} sales records in local database');
        }

        _rows = sales;
        if (_range != null) {
          _rows = _rows.where((r) {
            final date = DateTime.tryParse(r['created_at'] ?? '');
            if (date == null) return false;
            return !date.isBefore(_range!.start) && !date.isAfter(_range!.end);
          }).toList();
        }
      } else if (widget.type == 'Profit') {
        List<Map<String, dynamic>> sales;
        List<Map<String, dynamic>> products;

        if (!_offline) {
          try {
            final client = SupabaseService.instance.client;
            final res = await client
                .from('sales')
                .select('id, total, created_at');
            sales = List<Map<String, dynamic>>.from(res);
            final prodRes = await client
                .from('products')
                .select('id, cost_price, quantity');
            products = List<Map<String, dynamic>>.from(prodRes);

            // Cache to local database
            print(
              'Caching ${sales.length} sales and ${products.length} products for profit report',
            );
            final db = LocalDatabaseService.instance;
            for (final sale in sales) {
              try {
                await db.insert('sales', {...sale, 'synced': 1});
              } catch (e) {
                print('Error caching sale: $e');
              }
            }
            for (final product in products) {
              try {
                await db.insert('products', {...product, 'synced': 1});
              } catch (e) {
                print('Error caching product: $e');
              }
            }
          } catch (e) {
            print('Supabase fetch failed, loading from local DB: $e');
            sales = await LocalDatabaseService.instance.query('sales');
            products = await LocalDatabaseService.instance.query('products');
          }
        } else {
          print('Loading profit data from local database (offline mode)');
          sales = await LocalDatabaseService.instance.query('sales');
          products = await LocalDatabaseService.instance.query('products');
          print('Found ${sales.length} sales and ${products.length} products');
        }

        // Calculate profit per sale (simplified: total - (avg cost * items))
        final Map<String, double> costMap = {};
        for (final p in products) {
          costMap[p['id']] = (p['cost_price'] as num?)?.toDouble() ?? 0;
        }

        _rows = sales.map((sale) {
          final total = (sale['total'] as num?)?.toDouble() ?? 0;
          // Approximate cost (in real scenario, items would be stored in JSONB)
          final estimatedCost = total * 0.4; // Assume 40% cost ratio
          return {
            'id': sale['id'],
            'total': total.toStringAsFixed(2),
            'cost': estimatedCost.toStringAsFixed(2),
            'profit': (total - estimatedCost).toStringAsFixed(2),
            'created_at': sale['created_at'],
          };
        }).toList();

        if (_range != null) {
          _rows = _rows.where((r) {
            final date = DateTime.tryParse(r['created_at'] ?? '');
            if (date == null) return false;
            return !date.isBefore(_range!.start) && !date.isAfter(_range!.end);
          }).toList();
        }
      } else if (widget.type == 'Stock') {
        if (!_offline) {
          try {
            final client = SupabaseService.instance.client;
            final res = await client
                .from('products')
                .select('name, quantity, category')
                .order('quantity', ascending: true);
            _rows = List<Map<String, dynamic>>.from(res);

            // Cache to local database
            final db = LocalDatabaseService.instance;
            for (final product in _rows) {
              await db.insert('products', {...product, 'synced': 1});
            }
          } catch (e) {
            print('Supabase fetch failed, loading from local DB: $e');
            _rows = await LocalDatabaseService.instance.query('products');
          }
        } else {
          _rows = await LocalDatabaseService.instance.query('products');
        }
      } else if (widget.type == 'Wastage') {
        if (!_offline) {
          try {
            final client = SupabaseService.instance.client;
            final res = await client
                .from('wastage_logs')
                .select('reason, quantity, created_at')
                .order('created_at', ascending: false);
            _rows = List<Map<String, dynamic>>.from(res);

            // Cache to local database
            final db = LocalDatabaseService.instance;
            for (final log in _rows) {
              await db.insert('wastage_logs', {...log, 'synced': 1});
            }
          } catch (e) {
            print('No wastage logs available');
            _rows = [];
          }
        } else {
          try {
            _rows = await LocalDatabaseService.instance.query('wastage_logs');
          } catch (e) {
            _rows = [];
          }
        }

        if (_range != null) {
          _rows = _rows.where((r) {
            final date = DateTime.tryParse(r['created_at'] ?? '');
            if (date == null) return false;
            return !date.isBefore(_range!.start) && !date.isAfter(_range!.end);
          }).toList();
        }
      }
    } catch (e) {
      print('Report load error: $e');
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _export('pdf'),
          ),
          IconButton(
            icon: const Icon(Icons.grid_on),
            onPressed: () => _export('csv'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _range == null
                          ? 'Select Date Range'
                          : '${_range!.start.toString().split(' ').first} - ${_range!.end.toString().split(' ').first}',
                    ),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(now.year + 1),
                      );
                      if (picked != null) {
                        setState(() => _range = picked);
                        _load();
                      }
                    },
                  ),
                ),
                IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _rows.isEmpty
                ? const Center(child: Text('No data available'))
                : ListView.separated(
                    itemCount: _rows.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final row = _rows[index];
                      return ListTile(
                        title: Text(
                          _getDisplayTitle(row),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          _getDisplaySubtitle(row),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: _getDisplayTrailing(row),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getDisplayTitle(Map<String, dynamic> row) {
    if (widget.type.contains('Sales')) {
      return '\$${row['total'] ?? '0'} · ${row['method']?.toUpperCase() ?? 'UNKNOWN'}';
    } else if (widget.type == 'Profit') {
      return 'Profit: \$${row['profit']} (Sale: \$${row['total']})';
    } else if (widget.type == 'Stock') {
      return row['name'] ?? 'Unknown';
    } else if (widget.type == 'Wastage') {
      return '${row['quantity'] ?? 0} units · ${row['reason'] ?? 'Unknown'}';
    }
    return row.values.first.toString();
  }

  String _getDisplaySubtitle(Map<String, dynamic> row) {
    if (widget.type.contains('Sales')) {
      final date = DateTime.tryParse(row['created_at'] ?? '');
      return date?.toString().split('.').first ?? 'Unknown date';
    } else if (widget.type == 'Profit') {
      return 'Cost: \$${row['cost']}';
    } else if (widget.type == 'Stock') {
      return 'In stock: ${row['quantity']} · Category: ${row['category'] ?? 'N/A'}';
    } else if (widget.type == 'Wastage') {
      final date = DateTime.tryParse(row['created_at'] ?? '');
      return date?.toString().split('.').first ?? 'Unknown date';
    }
    return '';
  }

  Widget? _getDisplayTrailing(Map<String, dynamic> row) {
    if (widget.type == 'Profit') {
      final profit = double.tryParse(row['profit']?.toString() ?? '0') ?? 0;
      return Text(
        '\$${profit.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: profit >= 0 ? Colors.green : Colors.red,
        ),
      );
    }
    return null;
  }

  void _export(String type) {
    if (_rows.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }
    if (type == 'csv') {
      _exportCsv();
    } else {
      _exportPdf();
    }
  }

  Future<void> _exportCsv() async {
    final headers = _rows.first.keys.toList();
    final data = [
      headers,
      ..._rows.map((r) => headers.map((h) => r[h] ?? '').toList()),
    ];
    final csvData = const ListToCsvConverter().convert(data);
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/${widget.type.replaceAll(' ', '_').toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csvData);
    await Share.shareXFiles([XFile(file.path)], subject: '${widget.type} CSV');
  }

  Future<void> _exportPdf() async {
    try {
      final doc = pw.Document();
      final headers = _rows.isNotEmpty ? _rows.first.keys.toList() : [];

      if (headers.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No data to export')));
        return;
      }

      doc.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Text(
              widget.type,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              'Generated: ${DateTime.now().toString().split('.').first}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
            pw.SizedBox(height: 12),
            if (_rows.isNotEmpty)
              pw.Table.fromTextArray(
                headers: headers,
                data: _rows
                    .map(
                      (r) => headers.map((h) {
                        final val = r[h];
                        if (val is double) return val.toStringAsFixed(2);
                        return val?.toString() ?? '';
                      }).toList(),
                    )
                    .toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9),
              )
            else
              pw.Text(
                'No data available',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
          ],
        ),
      );

      final bytes = await doc.save();
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/${widget.type.replaceAll(' ', '_').toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(bytes, flush: true);
      await Share.shareXFiles([
        XFile(file.path),
      ], subject: '${widget.type} PDF');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDF export failed: $e')));
      }
    }
  }
}

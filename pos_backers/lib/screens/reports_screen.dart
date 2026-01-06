import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'report_details_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final reports = [
      'Daily Sales',
      'Monthly Sales',
      'Profit',
      'Wastage',
      'Stock',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Reports Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          // Small delay to show refresh indicator
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final name = reports[index];
            return ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.insert_chart_outlined, color: AppColors.primary),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReportDetailsScreen(type: name))),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import '../../models/export_options.dart';
import '../../models/task.dart';
import '../../services/export_service.dart';

// ❌ OLD: import '../../services/export_preview_screen.dart'; // <--- Path galat hai

// ✅ FIX 1: ExportPreviewScreen ka sahi import path (assuming woh 'screens' folder mein hai)
import '../../services/export_preview_screen.dart';

import '../../providers/task_provider.dart';

class ExportConfirmationScreen extends StatelessWidget {
  final ExportOptions options;
  const ExportConfirmationScreen({super.key, required this.options});

  void _startExport(BuildContext context) async {
    // 1. Tasks data fetch karein
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // ❌ OLD: final List<Task> tasksToExport = taskProvider.tasks;
    // ✅ FIX 2: Export ke liye TaskProvider.allTasks use karein
    final List<Task> tasksToExport = taskProvider.allTasks; // <--- FIX applied

    // ✅ Debugging ke liye check karein ki tasks list khaali to nahi hai
    if (tasksToExport.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error: No tasks available to export. Check TaskProvider.',
            ),
          ),
        );
      }
      return; // Agar tasks khaali hain, to aage mat badho
    }
    // --------------------------------------------------------------------------

    // 2. Data Generation
    String csvContent = '';
    Uint8List? pdfBytes;

    // Agar PDF format select hua hai, to PDF generate karein
    if (options.format == 'PDF') {
      try {
        pdfBytes = await ExportService().generatePdf(
          tasksToExport,
          options.selectedFields,
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
        }
        return;
      }
    }
    // Agar CSV/Email format select hua hai, to CSV generate karein
    else if (options.format == 'CSV' || options.format == 'Email') {
      csvContent = ExportService().generateCsv(
        tasksToExport,
        options.selectedFields,
      );
    }

    // 3. Navigate to Preview Screen
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExportPreviewScreen(
            format: options.format,
            csvContent: csvContent,
            tasksCount: tasksToExport.length,
            pdfData: pdfBytes,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    final accent = theme.colorScheme.secondary;
    final chipColor = theme.colorScheme.surfaceTint.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(title: const Text('3. Confirm & Export')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review your export settings before generating the file.',
              style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 16),
            ),
            const SizedBox(height: 30),

            // --- Export Summary ---
            _buildSummaryTile(context, 'Format', options.format),
            _buildSummaryTile(context, 'Tasks Included', 'All tasks'),

            const SizedBox(height: 20),
            Text(
              'Selected Fields:',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: options.selectedFields
                  .map(
                    (field) => Chip(
                      label: Text(field, style: TextStyle(color: accent)),
                      backgroundColor: chipColor,
                    ),
                  )
                  .toList(),
            ),

            const Spacer(),

            // --- Export Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startExport(context),
                child: Text('Generate & Export as ${options.format}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

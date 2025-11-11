import 'package:flutter/material.dart';
// FIX 1: XFile class use karne ke liye share_plus se XFile ko import karein
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data'; // PDF binary data ke liye
import '../theme.dart';
import '../services/export_service.dart';
import 'export_success_screen.dart';

class ExportPreviewScreen extends StatelessWidget {
  final String format;
  final String csvContent;
  final int tasksCount;
  final Uint8List? pdfData;

  const ExportPreviewScreen({
    super.key,
    required this.format,
    required this.csvContent,
    required this.tasksCount,
    this.pdfData,
  });

  void _handleExport(BuildContext context) async {
    String? filePath;

    if (format == 'CSV' || format == 'Email') {
      // 1. Save CSV file locally
      filePath = await ExportService().saveCsvFile(csvContent);

    } else if (format == 'PDF' && pdfData != null && pdfData!.isNotEmpty) {
      // 1. Save PDF file locally
      // Check for empty Uint8List (jo crash ya "No Preview" deta hai)
      filePath = await ExportService().savePdfFile(pdfData!);
    } else {
      // Agar format PDF hai lekin data missing/empty hai
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: PDF data is missing or invalid/empty.')),
        );
      }
      return;
    }

    if (filePath != null) {
      // 2. Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Task Manager Export',
        subject: 'Your Task Export - ${DateTime.now().toString().split(' ')[0]} ($format)',
      );

      // 3. Navigate to success screen
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ExportSuccessScreen()),
              (Route<dynamic> route) => route.isFirst, // Go back to Home
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color surfaceColor = theme.colorScheme.surface;

    // --- Preview Text Logic ---
    final String previewText;
    final String fileName = 'tasks-export.${format.toLowerCase()}';
    final bool isPdfAvailable = format == 'PDF' && pdfData != null && pdfData!.isNotEmpty;

    if (format == 'CSV' || format == 'Email') {
      // Show only the first few lines for CSV preview
      previewText = csvContent.split('\n').take(4).join('\n');
    } else if (isPdfAvailable) {
      // Show PDF file size as preview
      previewText = 'PDF data generated successfully.\nFile size: ${(pdfData!.length / 1024).toStringAsFixed(2)} KB.\nReady to share.';
    } else {
      previewText = 'No preview available for this format.';
    }
    // -------------------------

    return Scaffold(
      appBar: AppBar(
        title: Text('$format Export Preview'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (format == 'Email') ...[
                  Text('Email Subject', style: TextStyle(color: textColor.withOpacity(0.7))),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      // Placeholder text
                      hintText: 'Your Task Export (Date)',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                Text('Data Preview ($fileName)', style: TextStyle(color: textColor.withOpacity(0.7))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    previewText,
                    style: TextStyle(fontFamily: 'monospace', color: textColor),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  format == 'CSV'
                      ? 'Previewing ${csvContent.split('\n').length -1} of $tasksCount tasks to be exported.'
                      : 'Previewing $tasksCount tasks to be exported in $format format.',
                  style: TextStyle(color: textColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          const Spacer(),
          // --- Export Button ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Button sirf tab enable hoga jab CSV/Email ho ya PDF ho aur data available ho
                onPressed: isPdfAvailable || (format != 'PDF')
                    ? () => _handleExport(context)
                    : null,
                child: Text(format == 'Email' ? 'Send Email' : 'Export and Share ($format)'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
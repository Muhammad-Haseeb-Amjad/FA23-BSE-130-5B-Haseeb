import 'package:flutter/material.dart';
// FIX 1: XFile class use karne ke liye share_plus se XFile ko import karein
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data'; // PDF binary data ke liye
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
    // 1. Pehle file picker dikhao jo PDF aur CSV files ko prioritize kare (sirf desktop par)
    String? selectedPath;
    
    // Desktop platforms par hi file picker show karo
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        // File picker show karo with PDF and CSV extensions
        // saveFile() directly String? (path) return karta hai, FilePickerResult nahi
        String? result = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Export File',
          fileName: 'tasks_export_${DateTime.now().millisecondsSinceEpoch}.${format.toLowerCase()}',
          type: FileType.custom,
          allowedExtensions: format == 'PDF' 
              ? ['pdf'] 
              : ['csv'],
          lockParentWindow: true,
        );

        if (result != null && result.isNotEmpty) {
          selectedPath = result;
        } else {
          // User ne cancel kar diya
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Export cancelled.'),
              ),
            );
          }
          return;
        }
      } catch (e) {
        // File picker error - fallback to default save location
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File picker error: $e. Using default location.'),
            ),
          );
        }
      }
    }

    String? filePath;

    // 2. Ab file save karo
    if (format == 'CSV' || format == 'Email') {
      // CSV file save karo
      if (selectedPath != null) {
        // User ne path select kiya hai
        final file = File(selectedPath!);
        await file.writeAsString(csvContent);
        filePath = selectedPath;
      } else {
        // Default location use karo
        filePath = await ExportService().saveCsvFile(csvContent);
      }
    } else if (format == 'PDF' && pdfData != null && pdfData!.isNotEmpty) {
      // PDF file save karo
      if (selectedPath != null) {
        // User ne path select kiya hai
        final file = File(selectedPath!);
        await file.writeAsBytes(pdfData!);
        filePath = selectedPath;
      } else {
        // Default location use karo
        filePath = await ExportService().savePdfFile(pdfData!);
      }
    } else {
      // Agar format PDF hai lekin data missing/empty hai
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: PDF data is missing or invalid/empty.'),
          ),
        );
      }
      return;
    }

    if (filePath != null) {
      // 3. Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Task Manager Export',
        subject:
            'Your Task Export - ${DateTime.now().toString().split(' ')[0]} ($format)',
      );

      // 4. Navigate to success screen
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
    final bool isPdfAvailable =
        format == 'PDF' && pdfData != null && pdfData!.isNotEmpty;

    if (format == 'CSV' || format == 'Email') {
      // Show only the first few lines for CSV preview
      previewText = csvContent.split('\n').take(4).join('\n');
    } else if (isPdfAvailable) {
      // Show PDF file size and details as preview
      final fileSizeKB = (pdfData!.length / 1024).toStringAsFixed(2);
      previewText =
          '✅ PDF generated successfully!\n\n'
          '📄 File: $fileName\n'
          '📊 Tasks: $tasksCount\n'
          '💾 Size: $fileSizeKB KB\n\n'
          'Ready to export and share.';
    } else {
      // Debug info agar PDF data missing hai
      previewText = format == 'PDF' 
          ? '⚠️ PDF data is being generated...\nPlease wait or try again.'
          : 'No preview available for this format.';
    }
    // -------------------------

    return Scaffold(
      appBar: AppBar(title: Text('$format Export Preview')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (format == 'Email') ...[
                  Text(
                    'Email Subject',
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      // Placeholder text
                      hintText: 'Your Task Export (Date)',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                Text(
                  'Data Preview ($fileName)',
                  style: TextStyle(color: textColor.withOpacity(0.7)),
                ),
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
                      ? 'Previewing ${csvContent.split('\n').length - 1} of $tasksCount tasks to be exported.'
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
                child: Text(
                  format == 'Email'
                      ? 'Send Email'
                      : 'Export and Share ($format)',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

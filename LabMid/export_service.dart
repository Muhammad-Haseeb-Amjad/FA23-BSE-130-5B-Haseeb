import 'dart:io';
import 'dart:typed_data'; // PDF ke liye zaroori
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
// NEW IMPORTS for PDF generation
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// Permission handling ke liye
import 'package:permission_handler/permission_handler.dart';

import '../models/task.dart';

class ExportService {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  // 1. Public Downloads path nikalne ke liye
  Future<String> _getPublicDownloadPath() async {
    // 1. Permission Check
    var status = await Permission.storage.request();

    if (!status.isGranted) {
      final internalDir = await getApplicationDocumentsDirectory();
      return internalDir.path;
    }

    // Android: Downloads directory (Public storage)
    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          // Path ko manipulate karke Downloads tak pahunche
          List<String> parts = directory.path.split('/');
          int dataIndex = parts.indexOf('Android');

          if (dataIndex != -1 && dataIndex > 0) {
            String basePath = parts.sublist(0, dataIndex).join('/');
            String downloadPath = '$basePath/Download';

            if (await Directory(downloadPath).exists()) {
              return downloadPath;
            }
          }
        }
      } catch (e) {
        // Error aane par fallback use karein
      }
    }

    // Final Fallback: Internal app documents
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 2. CSV Data Generation
  String generateCsv(List<Task> tasks, List<String> fields) {
    List<List<dynamic>> rows = [];
    rows.add(fields); // Header row

    for (var task in tasks) {
      List<dynamic> row = [];
      for (String field in fields) {
        switch (field) {
          case 'Title':
            row.add(task.title);
            break;
          case 'Description':
            row.add(task.description ?? '');
            break;
          case 'Status':
            row.add(task.isCompleted ? 'Completed' : 'To Do');
            break;
          case 'Due Date':
            row.add(task.dueDate != null ? _dateFormat.format(task.dueDate!) : '');
            break;
          case 'Priority':
            row.add(task.priority ?? '');
            break;
          case 'Subtasks':
            final subtasksTitles = task.subtasks?.map((s) => s.title ?? 'N/A').join('; ') ?? '';
            row.add(subtasksTitles);
            break;
          case 'Created At':
            row.add(_dateFormat.format(task.createdAt));
            break;
          default:
            row.add('');
        }
      }
      rows.add(row);
    }
    return const ListToCsvConverter().convert(rows);
  }

  // 3. Local File Saving (CSV ke liye)
  Future<String> saveCsvFile(String csvContent) async {
    final directoryPath = await _getPublicDownloadPath();
    final fileName = 'tasks_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final path = '$directoryPath/$fileName';
    final file = File(path);

    if (!await Directory(directoryPath).exists()) {
      await Directory(directoryPath).create(recursive: true);
    }

    await file.writeAsString(csvContent);
    return path;
  }

  // 4. Save PDF File Locally
  Future<String> savePdfFile(Uint8List pdfBytes) async {
    final directoryPath = await _getPublicDownloadPath();
    final fileName = 'tasks_export_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final path = '$directoryPath/$fileName';
    final file = File(path);

    if (!await Directory(directoryPath).exists()) {
      await Directory(directoryPath).create(recursive: true);
    }

    await file.writeAsBytes(pdfBytes);
    return path;
  }

  // 5. File Share/Open Functionality
  Future<void> shareFile(String filePath) async {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile], text: 'Task Manager Data Export');
  }

  // 6. Generate PDF (Fixes Applied)
  Future<Uint8List> generatePdf(List<Task> tasks, List<String> fieldsToInclude) async {
    final pdf = pw.Document();

    if (tasks.isEmpty) {
      return Uint8List(0);
    }

    // Headers (pw.Text widgets)
    final headers = fieldsToInclude.map((field) =>
        pw.Text(field, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))
    ).toList();

    // Data rows (List<pw.Widget>)
    final data = tasks.map((task) {
      final List<pw.Widget> row = [];

      for (var field in fieldsToInclude) {
        String value;
        switch (field) {
          case 'Title':
            value = task.title;
            break;
          case 'Description':
            value = task.description ?? '';
            break;
          case 'Status':
            value = task.isCompleted ? 'Completed' : 'To Do';
            break;
          case 'Due Date':
            value = task.dueDate != null ? _dateFormat.format(task.dueDate!) : '';
            break;
          case 'Created At':
            value = _dateFormat.format(task.createdAt);
            break;
          case 'Priority':
            value = task.priority ?? '';
            break;
          case 'Subtasks':
            final subtasksTitles = task.subtasks?.map((s) => s.title ?? 'N/A').join(', ') ?? '';
            value = subtasksTitles;
            break;
          default:
            value = '';
            break;
        }
        row.add(pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            child: pw.Text(value, maxLines: 3, style: const pw.TextStyle(fontSize: 9))
        ));
      }
      return row;
    }).toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          // ✅ FIX: Column Widths ko headers ki count ke mutabik dynamic banaya.
          final Map<int, pw.TableColumnWidth> dynamicColumnWidths =
          Map.fromEntries(List.generate(headers.length, (index) =>
              MapEntry(index, const pw.FlexColumnWidth(1)))
          );

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Task Manager Export', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              // Tasks Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                // FIX: Dynamic widths use kiye taake 7 columns support ho saken
                columnWidths: dynamicColumnWidths,
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: headers,
                  ),
                  // Data Rows
                  ...data.map((row) => pw.TableRow(children: row)),
                ],
              ),
            ],
          );
        },
      ),
    );

    // FIX: Error handling add kiya
    try {
      return pdf.save();
    } catch (e) {
      print("PDF Generation/Save Error: $e");
      return Uint8List(0);
    }
  }

  // 7. Main Export Method (Sample)
  Future<void> exportData(List<Task> tasks) async {
    const fields = ['Title', 'Description', 'Status', 'Priority', 'Due Date', 'Created At', 'Subtasks'];

    final csvContent = generateCsv(tasks, fields);
    final filePath = await saveCsvFile(csvContent);

    await shareFile(filePath);
  }
}
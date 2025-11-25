// lib/services/restore_service.dart

import 'dart:io';
import 'package:csv/csv.dart';
import '../models/task.dart';
import 'dart:convert'; // NEW: UTF-8 decoding ke liye zaroori

class RestoreService {
  // NOTE: Yeh assume karta hai ki CSV export file mein yeh order hai:
  // Title, Description, IsCompleted, DueDate, Category, Priority, ColorValue
  static const List<String> csvHeaders = [
    'Title',
    'Description',
    'IsCompleted',
    'DueDate',
    'Category',
    'Priority',
    'ColorValue',
  ];

  // Function to read CSV file and convert rows to Task objects
  Future<List<Task>> importTasksFromCSV(String filePath) async {
    final file = File(filePath);
    final input = file.openRead();

    // CSV parser
    final fields = await input
        .transform(
          utf8.decoder,
        ) // FIX: Byte stream ko String stream mein decode kiya
        .transform(const CsvToListConverter())
        .toList();

    if (fields.isEmpty) {
      throw Exception("The selected file is empty or unreadable.");
    }

    // Header row skip karein
    final dataRows = fields.sublist(1);

    final List<Task> importedTasks = [];
    final now = DateTime.now(); // Required for createdAt and updatedAt

    for (final row in dataRows) {
      if (row.length < csvHeaders.length) {
        // Skip incomplete rows
        print("Skipping incomplete row: $row");
        continue;
      }

      try {
        // Data extraction and type conversion
        final String title = row[0].toString();
        final String description = row[1].toString();
        final bool isCompleted = row[2].toString().toLowerCase() == 'true';
        final DateTime? dueDate = row[3].toString().isNotEmpty
            ? DateTime.tryParse(row[3].toString())
            : null;

        // Although 'category' is extracted, it cannot be passed to Task constructor
        final String category = row[4].toString();

        final int priorityInt = int.tryParse(row[5].toString()) ?? 0;

        // Task object create karein (ID null hoga, naya database insert karega)
        final task = Task(
          id: null, // Let database assign new ID
          title: title,
          description: description,
          isCompleted: isCompleted,
          dueDate: dueDate,

          // FIX 1: Missing Required Parameters
          createdAt: now,
          updatedAt: now,

          // FIX 2: Priority ko String mein convert kiya
          priority: priorityInt.toString(),

          // NEW: Category ko preserve karein
          category: category.isNotEmpty ? category : 'Personal',

          // FIX 4: Default value set kiya gaya
          isRepeatingEnabled: false,

          // FIX 5: 'colorValue' parameter is REMOVED (since it's not defined)
          // colorValue: colorValueInt,

          // NOTE: Agar aapke Task model mein 'repeat' field hai toh yahan add karein (assuming null)
          repeat: null,

          // NOTE: Subtasks list default empty
          subtasks: [],
        );

        importedTasks.add(task);
      } catch (e) {
        print("Error parsing task row: $row. Error: $e");
        continue; // Error wali row skip kar dein
      }
    }

    if (importedTasks.isEmpty) {
      throw Exception("No valid tasks could be parsed from the file.");
    }

    return importedTasks;
  }
}

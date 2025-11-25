import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../models/task.dart';
import '../services/export_service.dart';
import '../database/database_helper.dart';
// FIX 1: ExportOptionsProvider ka import karein (Corrected Path)
import '../providers/export_options_provider.dart';
import 'export_preview_screen.dart';

class ExportOptionsScreen extends StatefulWidget {
  final String format;
  const ExportOptionsScreen({super.key, required this.format});

  @override
  State<ExportOptionsScreen> createState() => _ExportOptionsScreenState();
}

class _ExportOptionsScreenState extends State<ExportOptionsScreen> {
  // Mock Date Range
  TextEditingController startDateController = TextEditingController(
    text: 'YYYY-MM-DD',
  );
  TextEditingController endDateController = TextEditingController(
    text: 'YYYY-MM-DD',
  );

  // Available Fields ki list
  final List<String> availableFields = const [
    'Title',
    'Description',
    'Status', // IsCompleted
    'Due Date',
    'Subtasks',
    'Creation Date', // CreatedAt
    'Priority',
    'Category',
  ];

  void _showDatePicker(TextEditingController controller) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toString().split(
          ' ',
        )[0]; // Format to YYYY-MM-DD
      });
    }
  }

  void _navigateToPreview(
    List<Task> allTasks,
    ExportOptionsProvider provider,
  ) async {
    // 1. Date range filter (Abhi sirf UI se date string lena hai, actual filtering nahi)
    List<Task> tasksToExport = allTasks;

    // 2. Filter fields: Provider se selected fields lein
    List<String> fieldsToInclude = provider.options.selectedFields;

    // Safety check: Agar koi field selected nahi hai
    if (fieldsToInclude.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one field to export.'),
        ),
      );
      return;
    }

    // NOTE: Date filtering logic ko yahan implement karna chahiye

    // 3. Generate data based on format
    String csvContent = '';
    Uint8List? pdfBytes;

    if (widget.format == 'PDF') {
      // PDF format ke liye PDF generate karo
      try {
        pdfBytes = await ExportService().generatePdf(
          tasksToExport,
          fieldsToInclude,
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error generating PDF: $e'),
            ),
          );
        }
        return;
      }
    } else {
      // CSV format ke liye CSV generate karo
      csvContent = ExportService().generateCsv(
        tasksToExport,
        fieldsToInclude,
      );
    }

    // 4. Navigate to Preview
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExportPreviewScreen(
            format: widget.format,
            csvContent: csvContent,
            tasksCount: allTasks.length,
            pdfData: pdfBytes, // PDF data pass karo
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 1: Theme colors ko context se lein
    final theme = Theme.of(context);
    final Color accentColor = theme.colorScheme.secondary;
    final Color textColor = theme.colorScheme.onBackground;
    final Color surfaceColor = theme.colorScheme.surface;

    // FIX 3: Provider ko watch karein
    final exportProvider = context.watch<ExportOptionsProvider>();
    final selectedFields = exportProvider
        .options
        .selectedFields; // Provider se current selected fields

    // In a real app, you would fetch tasks using Provider/Bloc
    Future<List<Task>> futureTasks = DatabaseHelper.instance.readAllTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Options'), // Title change kiya
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          // Simplified error/loading handling
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Task> allTasks = snapshot.data ?? [];

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Date Range Section ---
                      // ✅ FIX 1: Hardcoded color ki jagah textColor use kiya gaya
                      Text(
                        'Select Date Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDateField(
                        'Start Date',
                        startDateController,
                        accentColor,
                        textColor,
                      ),
                      const SizedBox(height: 12),
                      _buildDateField(
                        'End Date',
                        endDateController,
                        accentColor,
                        textColor,
                      ),
                      // Divider color ko surface se alag rakha gaya
                      Divider(height: 30, color: textColor.withOpacity(0.2)),

                      // --- Fields Selection Section (Updated to use Provider) ---
                      // ✅ FIX 1: Hardcoded color ki jagah textColor use kiya gaya
                      Text(
                        'Include Fields in Export',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      ...availableFields.map((key) {
                        final isSelected = selectedFields.contains(key);
                        return CheckboxListTile(
                          title: Text(key, style: TextStyle(color: textColor)),
                          value: isSelected,
                          onChanged: (bool? value) {
                            // FIX 6: Toggle logic ko Provider mein move kiya
                            exportProvider.toggleField(key);
                          },
                          // ✅ FIX 1 & 3: Color theme se liya gaya
                          checkColor: theme
                              .colorScheme
                              .onSecondary, // Usually black or white text on accent color
                          activeColor: accentColor, // ✅ ACCENT COLOR FIX
                          // ✅ FIX 3: Tile color ko surface color se set kiya gaya taake Light Mode theek se kaam kare
                          tileColor: surfaceColor,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }).toList(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              // --- Export Button ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                // ✅ FIX 2: Button ko SizedBox mein wrap kiya gaya for full width
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // FIX 8: Provider ko navigate function mein pass kiya
                    onPressed: () =>
                        _navigateToPreview(allTasks, exportProvider),
                    child: Text('Export as ${widget.format}'), // Format dikhaya
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ FIX 1: Colors as parameter pass kiye gaye
  Widget _buildDateField(
    String label,
    TextEditingController controller,
    Color accentColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor.withOpacity(0.7))),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _showDatePicker(controller),
          child: IgnorePointer(
            child: TextField(
              controller: controller,
              style: TextStyle(color: textColor), // Text color set kiya
              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: accentColor,
                ), // ✅ ACCENT COLOR FIX
              ),
            ),
          ),
        ),
      ],
    );
  }
}

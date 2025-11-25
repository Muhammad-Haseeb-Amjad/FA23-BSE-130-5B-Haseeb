import 'package:flutter/material.dart';
import '../../models/export_options.dart';
import 'export_confirmation_screen.dart';

class ExportFieldSelectionScreen extends StatefulWidget {
  final ExportOptions options;
  const ExportFieldSelectionScreen({super.key, required this.options});

  @override
  State<ExportFieldSelectionScreen> createState() =>
      _ExportFieldSelectionScreenState();
}

class _ExportFieldSelectionScreenState
    extends State<ExportFieldSelectionScreen> {
  // All possible fields to export
  final List<String> availableFields = [
    'Title',
    'Description',
    'Due Date',
    'Priority',
    'Status',
    'Repeat Pattern',
    'Creation Date',
    'Category',
  ];

  void _toggleField(String field) {
    setState(() {
      if (widget.options.selectedFields.contains(field)) {
        widget.options.selectedFields.remove(field);
      } else {
        widget.options.selectedFields.add(field);
      }
    });
  }

  void _navigateToNextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExportConfirmationScreen(options: widget.options),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    final accent = theme.colorScheme.secondary;
    final surface = theme.colorScheme.surface;

    return Scaffold(
      appBar: AppBar(title: const Text('2. Select Data Fields')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the task attributes you wish to include in your ${widget.options.format} file.',
              style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 16),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: availableFields.map((field) {
                  final isSelected = widget.options.selectedFields.contains(
                    field,
                  );
                  return CheckboxListTile(
                    title: Text(field, style: TextStyle(color: textColor)),
                    value: isSelected,
                    onChanged: (bool? value) => _toggleField(field),
                    checkColor: theme.colorScheme.onPrimary,
                    activeColor: accent,
                    tileColor: surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  );
                }).toList(),
              ),
            ),

            // --- Next Button ---
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.options.selectedFields.isNotEmpty
                    ? _navigateToNextStep
                    : null,
                child: const Text('Next: Confirm Export'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

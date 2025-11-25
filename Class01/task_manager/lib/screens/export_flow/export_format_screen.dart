import 'package:flutter/material.dart';
import '../../models/export_options.dart';
import 'export_field_selection_screen.dart';

class ExportFormatScreen extends StatefulWidget {
  const ExportFormatScreen({super.key});

  @override
  State<ExportFormatScreen> createState() => _ExportFormatScreenState();
}

class _ExportFormatScreenState extends State<ExportFormatScreen> {
  final ExportOptions _options = ExportOptions();

  void _navigateToNextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExportFieldSelectionScreen(options: _options),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('1. Select Export Format')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your desired file format for exporting tasks.',
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              _buildFormatTile(
                context,
                title: 'CSV (Comma Separated Values)',
                subtitle: 'Best for spreadsheets and data analysis.',
                format: 'CSV',
              ),
              const SizedBox(height: 15),
              _buildFormatTile(
                context,
                title: 'PDF (Portable Document Format)',
                subtitle: 'Best for printing and sharing a clean document.',
                format: 'PDF',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToNextStep,
                  child: const Text('Next: Choose Fields'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String format,
  }) {
    final isSelected = _options.format == format;
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final textColor = theme.colorScheme.onSurface;
    final surface = theme.colorScheme.surface;

    return GestureDetector(
      onTap: () {
        setState(() => _options.format = format);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? accent.withOpacity(0.15) : surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? accent : textColor.withOpacity(0.6),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

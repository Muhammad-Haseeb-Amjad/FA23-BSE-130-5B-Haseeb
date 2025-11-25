import 'package:flutter/material.dart';
import 'export_options_screen.dart'; // Next screen in flow
import '../theme.dart';

class ExportFormatScreen extends StatelessWidget {
  const ExportFormatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Choose a format to export your data.',
              style: TextStyle(color: textLight),
            ),
          ),
          _buildFormatOption(
            context,
            icon: Icons.description,
            title: 'Export as CSV',
            subtitle: 'Best for spreadsheets and data analysis.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExportOptionsScreen(format: 'CSV'),
                ),
              );
            },
          ),
          _buildFormatOption(
            context,
            icon: Icons.picture_as_pdf,
            title: 'Save as PDF',
            subtitle: 'Ideal for printing and sharing documents.',
            // onTap for PDF: (Implementation would require packages like pdf)
            onTap: () {},
          ),
          _buildFormatOption(
            context,
            icon: Icons.mail,
            title: 'Send via Email',
            subtitle: 'Sends a summary to your inbox.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExportOptionsScreen(format: 'Email'),
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () {
                // Should navigate to the selected format's options screen
              },
              child: const Text('Export'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: accentGreen),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: textLight.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.radio_button_off,
              color: textLight,
            ), // Mimic radio button
          ],
        ),
      ),
    );
  }
}

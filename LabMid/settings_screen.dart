import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// NEW IMPORT: WhatsApp link open karne ke liye
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../providers/theme_provider.dart';
// FIX 1: Import TaskProvider aur Export Service
import '../providers/task_provider.dart';
import '../services/export_service.dart';
import '../services/restore_service.dart'; // RestoreService import kiya gaya
import '../models/task.dart'; // Task model import kiya gaya
import './completed_tasks_archive.dart';
// NEW: NotificationSoundPicker screen ko import karna zaroori hai
import './notification_sound_picker.dart'; // Ensure this path is correct
// NEW: file_picker package import kiya gaya
import 'package:file_picker/file_picker.dart';
// NEW: ExportOptionsScreen import kiya gaya
import '../services/export_options_screen.dart'; // Assuming correct path


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _isRestoring = false;

  // --- NEW FUNCTION: Export All Data Directly (CSV & PDF) ---
  void _exportAllDataDirectly(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting data export...')),
    );

    try {
      final allTasks = Provider.of<TaskProvider>(context, listen: false).tasks;

      if (allTasks.isEmpty) {
        if (context.mounted) {
          _showInfoSnackbar(context, 'No tasks found to export.', success: false);
        }
        return;
      }

      final List<String> allFields = [
        'Title', 'Description', 'Status', 'Due Date', 'Subtasks', 'Creation Date', 'Priority'
      ];

      final exportService = ExportService();

      // --- A. CSV Export ---
      final csvContent = exportService.generateCsv(allTasks, allFields);
      final csvPath = await exportService.saveCsvFile(csvContent);

      // --- B. PDF Export ---
      final pdfData = await exportService.generatePdf(allTasks, allFields);
      final pdfPath = await exportService.savePdfFile(pdfData);

      // 3. Success Feedback
      if (context.mounted) {
        _showInfoSnackbar(context, 'Export Complete! Files saved in storage.', success: true);
      }

    } catch (e) {
      if (context.mounted) {
        _showInfoSnackbar(context, 'Export failed: ${e.toString()}', success: false);
      }
    }
  }
  // -----------------------------------------------------------


  // --- NEW FUNCTION: WhatsApp Launch (FIXED: canLaunchUrl and launchUrl now correctly use url_launcher) ---
  void _launchWhatsApp(String number) async {
    final String internationalNumber = '92$number'.replaceFirst('0', '');
    final Uri url = Uri.parse('whatsapp://send?phone=$internationalNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      final Uri webUrl = Uri.parse('https://wa.me/$internationalNumber');
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        _showInfoSnackbar(context, 'Could not open WhatsApp. Make sure the app is installed.', success: false);
      }
    }
  }
  // ------------------------------------


  // --- UPDATED: Restore Logic (Unchanged but uses fixed helpers) ---
  Future<void> _handleRestoreData(BuildContext context) async {
    if (_isRestoring) return;

    setState(() {
      _isRestoring = true;
    });

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final restoreService = RestoreService();

    try {
      // 1. File Picker ka istemaal karke backup file choose karein
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;

        _showInfoSnackbar(context, 'Backup file selected. Reading data...', success: false);

        // 2. CSV se tasks ko padhein
        final List<Task> importedTasks = await restoreService.importTasksFromCSV(filePath);

        // 3. TaskProvider mein restore method ko call karein
        await taskProvider.restoreTasks(importedTasks);

        // 4. Tasks ko reload karein
        await taskProvider.fetchTasks();

        _showInfoSnackbar(context, '${importedTasks.length} tasks restored successfully!', success: true);

      } else {
        _showInfoSnackbar(context, 'Data restoration cancelled.');
      }

    } catch (e) {
      _showInfoSnackbar(context, 'Data restoration failed: ${e.toString()}', success: false);
    } finally {
      setState(() {
        _isRestoring = false;
      });
    }
  }
  // ---------------------------------------------------------------------------------


  // --- NEW: Export Format Selector (FIXED: showDialog use kiya gaya) ---
  void _showExportFormatDialog(BuildContext context) {
    // ✅ FIX: Navigator.push ki bajaye showDialog use karein
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Choose Export Format'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('CSV File'),
                onTap: () {
                  Navigator.pop(ctx); // Dialog band karein
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ExportOptionsScreen ko new route par bhejein
                      builder: (routeCtx) => const ExportOptionsScreen(format: 'CSV'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('PDF Document'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ExportOptionsScreen ko new route par bhejein
                      builder: (routeCtx) => const ExportOptionsScreen(format: 'PDF'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;
    final textColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings & Customization', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Customization Section (Appearance & Notifications) ---
            _buildSectionHeader('Appearance'),
            _buildThemeSwitch(context),
            const SizedBox(height: 10),
            _buildAccentColorPicker(context),
            const SizedBox(height: 10),
            _buildNotificationSounds(context),

            // --- 2. Data Management Section ---
            _buildSectionHeader('Data Management'),

            // Export Tasks (Ab yeh Export Format Dialog kholega)
            _buildSettingsTile(
              icon: Icons.download,
              title: 'Export Tasks (Select Format)',
              subtitle: 'Select format and fields to save your task data.',
              onTap: () => _showExportFormatDialog(context),
            ),

            // Restore Data
            _buildSettingsTile(
              icon: Icons.restore_outlined,
              title: _isRestoring ? 'Restoring Data...' : 'Restore Data (CSV)',
              subtitle: 'Import tasks from a saved CSV file.',
              onTap: _isRestoring ? () {} : () => _handleRestoreData(context),
              trailing: _isRestoring ? SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: accentColor)
              ) : null,
            ),

            // ✅ Manage Export Options ko Export All Data se replace kiya
            _buildSettingsTile(
              icon: Icons.save_alt,
              title: 'Export All Data (CSV & PDF)',
              subtitle: 'Saves all task data directly to your device storage.',
              onTap: () => _exportAllDataDirectly(context),
            ),
            // ----------------------------------------------------


            // Completed Tasks Archive tile (Unchanged)
            _buildSettingsTile(
              icon: Icons.archive_outlined,
              title: 'Completed Tasks Archive',
              subtitle: 'Review and manage all finished tasks.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  CompletedTasksArchive()),
                );
              },
            ),


            // --- 3. Account & About Section (General) ---
            _buildSectionHeader('General'),

            // About Task Manager (Unchanged)
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About Task Manager',
              subtitle: 'Version, licenses, and privacy policy.',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Task Manager Pro',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2025 Haseeb',
                  children: [
                    const Text('A comprehensive task management app built with Flutter.'),
                  ],
                );
              },
            ),

            // --- NEW TILE: Designed By (Muhammad Haseeb Amjad) ---
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _buildSettingsTile(
                  icon: Icons.code,
                  title: 'Designed by:',
                  subtitle: 'Muhammad Haseeb Amjad',
                  onTap: () {},
                  trailing: IconButton(
                    icon: Icon(
                      Icons.chat,
                      color: themeProvider.accentColor,
                    ),
                    onPressed: () => _launchWhatsApp('03287623023'),
                  ),
                );
              },
            ),
            // ----------------------------------------------------
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (FIXES FOR UNDEFINED METHODS) ---

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.secondary),
        title: Text(title, style: TextStyle(color: theme.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7))),
        tileColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        return _buildSettingsTile(
          icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
          title: 'App Theme',
          subtitle: isDarkMode ? 'Dark Mode' : 'Light Mode',
          onTap: () {},
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            activeColor: themeProvider.accentColor,
          ),
        );
      },
    );
  }

  Widget _buildAccentColorPicker(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    const List<Color> colorPalette = [
      Color(0xFF81C784), // Placeholder for accentGreen
      Color(0xFF81C784),
      Color(0xFF64B5F6),
      Color(0xFFff8a65),
      Color(0xFFe57373),
      Color(0xFFba68c8),
    ];

    return _buildSettingsTile(
      icon: Icons.color_lens_outlined,
      title: 'Pick Accent Color',
      subtitle: 'Change the primary color of the app UI.',
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: theme.colorScheme.background,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: colorPalette.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final color = colorPalette[index];
                  final isSelected = color == themeProvider.accentColor;
                  return GestureDetector(
                    onTap: () {
                      themeProvider.setAccentColor(color);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: theme.colorScheme.onBackground, width: 3) : null,
                      ),
                      child: isSelected ? Icon(Icons.check, color: theme.colorScheme.onPrimary) : null,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationSounds(BuildContext context) {
    // NOTE: Settings screen mein hum hamesha 'Default' sound se shuru karte hain
    // kyunki yeh global setting nahi hai.
    const String defaultSoundName = 'Default System Sound';

    return _buildSettingsTile(
      icon: Icons.notifications_active_outlined,
      title: 'Choose Notification Sound',
      subtitle: 'Set a custom sound for task reminders.',
      onTap: () {
        Navigator.push(
          context,
          // ✅ FIX: Required parameter 'initialSound' add kiya
          MaterialPageRoute(builder: (_) => const NotificationSoundPicker(initialSound: defaultSoundName)),
        );
      },
    );
  }

  void _showInfoSnackbar(BuildContext context, String message, {bool success = false}) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;
    final errorColor = theme.colorScheme.error;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? accentColor : errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
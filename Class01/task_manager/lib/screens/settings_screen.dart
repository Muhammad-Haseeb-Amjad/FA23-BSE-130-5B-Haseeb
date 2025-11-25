import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import '../providers/task_provider.dart';
import '../services/export_service.dart';
import '../services/restore_service.dart';
import '../models/task.dart';
import './completed_tasks_archive.dart';
import './notification_sound_picker.dart'; // ✅ Original screen
import 'package:file_picker/file_picker.dart';
import '../services/export_options_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isRestoring = false;
  String _currentSound = 'Default System Sound'; // ✅ Default sound name

  @override
  void initState() {
    super.initState();
    _loadNotificationSound();
  }

  // ✅ Load saved sound from SharedPreferences
  Future<void> _loadNotificationSound() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentSound = prefs.getString('selectedNotificationSound') ?? 'Default System Sound';
    });
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Tasks'),
        content: const Text('Choose export format'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportTasks('csv');
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportTasks('pdf');
            },
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _exportTasks(String format) async {
    try {
      _showInfoSnackbar(context, 'Starting export...', success: false);

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final tasks = taskProvider.tasks;

      if (tasks.isEmpty) {
        if (mounted) {
          _showInfoSnackbar(
            context,
            'No tasks found to export.',
            success: false,
          );
        }
        return;
      }

      final exportService = ExportService();

      const fields = [
        'Title',
        'Description',
        'Status',
        'Due Date',
        'Priority',
        'Category',
        'Subtasks',
        'Created At',
      ];

      String? filePath;

      if (format == 'csv') {
        final csvContent = exportService.generateCsv(tasks, fields);
        filePath = await exportService.saveCsvFile(csvContent);
      } else if (format == 'pdf') {
        final pdfBytes = await exportService.generatePdf(tasks, fields);
        filePath = await exportService.savePdfFile(pdfBytes);
      }

      if (filePath != null && filePath.isNotEmpty && mounted) {
        _showInfoSnackbar(
          context,
          'Export successful!',
          success: true,
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Complete'),
            content: Text('File saved at:\n$filePath'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await exportService.shareFile(filePath!);
                },
                child: const Text('Share'),
              ),
            ],
          ),
        );
      } else if (mounted) {
        _showInfoSnackbar(
          context,
          'Export failed: Unable to save file',
          success: false,
        );
      }
    } catch (e) {
      if (mounted) {
        _showInfoSnackbar(
          context,
          'Export failed: $e',
          success: false,
        );
      }
    }
  }

  void _exportAllDataDirectly(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting data export...')),
    );

    try {
      final allTasks = Provider.of<TaskProvider>(context, listen: false).tasks;

      if (allTasks.isEmpty) {
        if (context.mounted) {
          _showInfoSnackbar(
            context,
            'No tasks found to export.',
            success: false,
          );
        }
        return;
      }

      final List<String> allFields = [
        'Title',
        'Description',
        'Status',
        'Due Date',
        'Subtasks',
        'Created At',
        'Priority',
        'Category',
      ];

      final exportService = ExportService();

      final csvContent = exportService.generateCsv(allTasks, allFields);
      final csvPath = await exportService.saveCsvFile(csvContent);

      final pdfData = await exportService.generatePdf(allTasks, allFields);
      final pdfPath = await exportService.savePdfFile(pdfData);

      if (context.mounted) {
        final csvMsg = csvPath.isNotEmpty ? 'CSV: $csvPath' : 'CSV failed';
        final pdfMsg = pdfPath.isNotEmpty ? 'PDF: $pdfPath' : 'PDF failed';

        _showInfoSnackbar(
          context,
          'Export Complete!\n$csvMsg\n$pdfMsg',
          success: true,
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showInfoSnackbar(
          context,
          'Export failed: ${e.toString()}',
          success: false,
        );
      }
    }
  }

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
        _showInfoSnackbar(
          context,
          'Could not open WhatsApp. Make sure the app is installed.',
          success: false,
        );
      }
    }
  }

  Future<void> _handleRestoreData(BuildContext context) async {
    if (_isRestoring) return;

    setState(() {
      _isRestoring = true;
    });

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final restoreService = RestoreService();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;

        _showInfoSnackbar(
          context,
          'Backup file selected. Reading data...',
          success: false,
        );

        final List<Task> importedTasks =
        await restoreService.importTasksFromCSV(filePath);

        await taskProvider.restoreTasks(importedTasks);
        await taskProvider.fetchTasks();

        _showInfoSnackbar(
          context,
          '${importedTasks.length} tasks restored successfully!',
          success: true,
        );
      } else {
        _showInfoSnackbar(context, 'Data restoration cancelled.');
      }
    } catch (e) {
      _showInfoSnackbar(
        context,
        'Data restoration failed: ${e.toString()}',
        success: false,
      );
    } finally {
      setState(() {
        _isRestoring = false;
      });
    }
  }

  void _showExportFormatDialog(BuildContext context) {
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
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (routeCtx) =>
                      const ExportOptionsScreen(format: 'CSV'),
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
                      builder: (routeCtx) =>
                      const ExportOptionsScreen(format: 'PDF'),
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
        title: Text(
          'Settings & Customization',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Appearance'),
            _buildThemeSwitch(context),
            const SizedBox(height: 10),
            _buildAccentColorPicker(context),
            const SizedBox(height: 10),

            // ✅ RESTORED: Original notification sound picker tile
            _buildNotificationSounds(context),
            Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final enabled = taskProvider.todayUnlockRemindersEnabled;
                return _buildSettingsTile(
                  icon: Icons.lock_open_outlined,
                  title: 'Today task notifications',
                  subtitle:
                      'Get pending Today tasks as soon as you unlock the phone.',
                  onTap: () =>
                      taskProvider.setTodayUnlockRemindersEnabled(!enabled),
                  trailing: Switch(
                    value: enabled,
                    onChanged: (value) =>
                        taskProvider.setTodayUnlockRemindersEnabled(value),
                    activeColor: accentColor,
                  ),
                );
              },
            ),

            _buildSectionHeader('Data Management'),

            _buildSettingsTile(
              icon: Icons.download,
              title: 'Export Tasks',
              subtitle: 'Export all tasks to CSV or PDF',
              onTap: () => _showExportFormatDialog(context),
            ),

            _buildSettingsTile(
              icon: Icons.restore_outlined,
              title: _isRestoring ? 'Restoring Data...' : 'Restore Data (CSV)',
              subtitle: 'Import tasks from a saved CSV file.',
              onTap: _isRestoring ? () {} : () => _handleRestoreData(context),
              trailing: _isRestoring
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: accentColor,
                ),
              )
                  : null,
            ),

            _buildSettingsTile(
              icon: Icons.save_alt,
              title: 'Export All Data (CSV & PDF)',
              subtitle: 'Saves all task data directly to your device storage.',
              onTap: () => _exportAllDataDirectly(context),
            ),

            _buildSettingsTile(
              icon: Icons.archive_outlined,
              title: 'Completed Tasks Archive',
              subtitle: 'Review and manage all finished tasks.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CompletedTasksArchive()),
                );
              },
            ),

            _buildSectionHeader('General'),

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
                    const Text(
                      'A comprehensive task management app built with Flutter.',
                    ),
                  ],
                );
              },
            ),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _buildSettingsTile(
                  icon: Icons.code,
                  title: 'Designed by:',
                  subtitle: 'Muhammad Haseeb Amjad',
                  onTap: () {},
                  trailing: IconButton(
                    icon: Icon(Icons.chat, color: themeProvider.accentColor),
                    onPressed: () => _launchWhatsApp('03287623023'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
        title: Text(
          title,
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
        ),
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
              themeProvider.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
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
      Color(0xFF81C784),
      Color(0xFF64B5F6),
      Color(0xFFff8a65),
      Color(0xFFe57373),
      Color(0xFFba68c8),
      Color(0xFFFFD54F),
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
                        border: isSelected
                            ? Border.all(
                          color: theme.colorScheme.onBackground,
                          width: 3,
                        )
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                        Icons.check,
                        color: theme.colorScheme.onPrimary,
                      )
                          : null,
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

  // ✅ RESTORED: Original notification sound picker function
  Widget _buildNotificationSounds(BuildContext context) {
    return _buildSettingsTile(
      icon: Icons.notifications_active_outlined,
      title: 'Choose Notification Sound',
      subtitle: 'Current: $_currentSound', // ✅ Shows selected sound
      onTap: () async {
        // Navigate to NotificationSoundPicker
        final selectedSound = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationSoundPicker(initialSound: _currentSound),
          ),
        );

        // ✅ Update UI when user returns
        if (selectedSound != null && mounted) {
          setState(() {
            _currentSound = selectedSound;
          });
        }
      },
    );
  }

  void _showInfoSnackbar(
      BuildContext context,
      String message, {
        bool success = false,
      }) {
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
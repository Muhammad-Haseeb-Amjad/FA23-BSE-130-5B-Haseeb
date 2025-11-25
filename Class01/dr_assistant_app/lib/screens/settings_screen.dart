import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// ZAROORI IMPORTS
import 'package:permission_handler/permission_handler.dart'; // Permissions ke liye
// import 'package:path_provider/path_provider.dart';           // Iski zaroorat abhi nahi hai, kyunki hum FilePicker use kar rahe hain

import '../database/database_helper.dart';
import 'login_screen.dart';
import 'splash_screen.dart';
import '../main.dart';

// SettingsScreen ko StatefulWidget mein badla gaya
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  // Data clear karne ka function (Wohi hai, koi change nahi)
  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Clear Data'),
        content: const Text('Are you sure you want to permanently delete ALL data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.clearAllData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All app data cleared successfully!')),
      );
    }
  }

  // WhatsApp support launch karne ka function (Wohi hai, koi change nahi)
  void _launchWhatsApp() async {
    const whatsappUrl = 'whatsapp://send?phone=+923160837813&text=I need support with Dr. Assistant App';
    final uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final webUrl = 'https://wa.me/923160837813?text=I need support with Dr. Assistant App';
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  // --- 1. DATA EXPORT FUNCTION (FIXED) ---
  Future<void> _exportData() async {
    // ✅ FIX 1: Pehle Storage Permission maangein.
    // Note: Android 13+ par yeh 'READ_MEDIA_IMAGES' ho sakta hai agar aapka targetSDK 33+ hai.
    // Lekin FilePicker use karne par bhi yeh permission check achhi practice hai.
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied. Cannot export data.')),
      );
      return;
    }

    try {
      // ✅ FIX 2: User se Directory choose karwayein.
      // Is se app ko system ki taraf se temporary, limited access mil jaata hai us folder ka,
      // aur PathAccessException ka masla hal ho jaata hai.
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Please select a folder to save the backup file',
      );

      if (selectedDirectory == null) return; // User cancelled

      // DatabaseHelper ko directory ka path dein
      // Assume: DatabaseHelper.instance.exportDatabase() is a function you've written
      // that copies the app's database to the selectedDirectory path.
      final exportedPath = await DatabaseHelper.instance.exportDatabase(selectedDirectory);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup successful! File saved at: $exportedPath')),
      );
    } catch (e) {
      // Show the actual error message on failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup failed: ${e.toString()}')),
      );
    }
  }

  // --- 2. DATA IMPORT FUNCTION (FIXED) ---
  Future<void> _importData() async {
    // ✅ FIX 1: Pehle Storage Permission maangein.
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied. Cannot import data.')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Data?'),
        content: const Text('Warning: Restoring data will overwrite all existing patients and visits. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Restore', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // ✅ FIX 2: File Picker ka istemaal.
      // User ko khud file select karne dein.
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'], // Sirf .db files ki ijazat dein
      );

      if (result == null || result.files.single.path == null) return;

      final importedPath = result.files.single.path!;

      await DatabaseHelper.instance.importDatabase(importedPath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data restored successfully! Restarting app...')),
      );

      // App ko Splash Screen par bhej dein, taake database dobara load ho
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
            (Route<dynamic> route) => false,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: ${e.toString()}')),
      );
    }
  }

  // List Tile item banane ke liye reusable function (Wohi hai, const added)
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    // Current theme check karein
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Icon(icon, color: iconColor ?? kPrimaryGreen),
        title: Text(
          title,
          style: TextStyle(
            color: iconColor ?? (isDarkMode ? Colors.white : Colors.black87),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // --- 3. DARK MODE TOGGLE WIDGET (Wohi hai, koi change nahi) ---
  Widget _buildDarkModeToggle() {
    final currentTheme = Theme.of(context).brightness;
    final isDarkMode = currentTheme == Brightness.dark;

    return _buildSettingsTile(
      icon: isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
      title: 'Dark Mode',
      subtitle: 'Switch between light and dark theme',
      trailing: Switch(
        value: isDarkMode,
        onChanged: (bool value) {
          final newMode = value ? ThemeMode.dark : ThemeMode.light;
          MyApp.of(context)?.setThemeMode(newMode);
          setState(() {});
        },
        activeColor: kPrimaryGreen,
      ),
      onTap: () {
        final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
        MyApp.of(context)?.setThemeMode(newMode);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Current theme ke hisaab se colors set karein
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Appearance Section ---
            Text(
                'Appearance',
                style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 5),
            _buildDarkModeToggle(),

            const SizedBox(height: 20),
            // --- Data Management Section ---
            Text(
                'Data Management',
                style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 5),
            _buildSettingsTile(
              icon: Icons.cloud_upload,
              title: 'Export Data (Backup)',
              subtitle: 'Export all data to a secure file',
              onTap: _exportData, // Export function attach kiya
            ),
            _buildSettingsTile(
              icon: Icons.cloud_download,
              title: 'Import Data (Restore)',
              subtitle: 'Restore data from a backup file (All data will be overwritten)',
              onTap: _importData, // Import function attach kiya
            ),
            _buildSettingsTile(
              icon: Icons.delete_forever,
              title: 'Clear All Data',
              subtitle: 'Permanently delete all data',
              iconColor: Colors.red,
              onTap: _clearData,
            ),

            const SizedBox(height: 20),
            // --- App Information Section ---
            Text(
                'App Information',
                style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 5),
            _buildSettingsTile(
              icon: Icons.info,
              title: 'Version',
              subtitle: '1.0.0',
              trailing: const SizedBox.shrink(),
              onTap: null,
            ),
            _buildSettingsTile(
              icon: Icons.design_services,
              title: 'Designed By',
              subtitle: 'Muhammad Haseeb Amjad',
              trailing: const SizedBox.shrink(),
              onTap: null,
            ),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Contact us on WhatsApp',
              onTap: _launchWhatsApp,
            ),

            const SizedBox(height: 20),
            // --- Account Section ---
            Text(
                'Account',
                style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 5),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              iconColor: Colors.red,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
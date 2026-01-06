import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/services/backup_restore_service.dart';
import '../core/services/google_drive_service.dart';
import '../core/services/local_database_service.dart';
import '../core/theme/app_theme.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  bool _isBackingUp = false;
  bool _isRestoring = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 6))]),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  height: 180,
                  color: Colors.orange.shade50,
                  child: const Center(child: Icon(Icons.cloud_done, size: 64, color: AppColors.primary)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Secure Backup & Restore', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      SizedBox(height: 8),
                      Text('Backup your POS data locally or to Google Drive for safe storage.', style: TextStyle(color: AppColors.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Google Drive Backup', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_upload, color: AppColors.primary),
              title: const Text('Backup to Google Drive'),
              subtitle: const Text('Auto-upload encrypted backup'),
              trailing: _isBackingUp
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : ElevatedButton(
                      onPressed: _backupToGoogleDrive,
                      child: const Text('Backup Now'),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_download, color: AppColors.primary),
              title: const Text('Restore from Google Drive'),
              subtitle: const Text('Load previous backup'),
              trailing: _isRestoring
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : ElevatedButton(
                      onPressed: _restoreFromGoogleDrive,
                      child: const Text('Restore'),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Local Backup', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.save, color: AppColors.primary),
              title: const Text('Export to File'),
              subtitle: const Text('Save JSON backup to device'),
              trailing: ElevatedButton(
                onPressed: _exportLocalBackup,
                child: const Text('Export'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restore, color: AppColors.primary),
              title: const Text('Import from File'),
              subtitle: const Text('Restore from saved JSON'),
              trailing: _isRestoring
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : ElevatedButton(
                      onPressed: _importLocalBackup,
                      child: const Text('Import'),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('What gets backed up?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 8),
          const ListTile(leading: Icon(Icons.inventory_2, color: AppColors.primary), title: Text('Products'), subtitle: Text('All inventory items with pricing and stock.')),
          const ListTile(leading: Icon(Icons.receipt_long, color: AppColors.primary), title: Text('Sales Transactions'), subtitle: Text('Complete sales history with items.')),
          const ListTile(leading: Icon(Icons.people, color: AppColors.primary), title: Text('Customers'), subtitle: Text('Customer records and loyalty points.')),
          const ListTile(leading: Icon(Icons.delete_outline, color: AppColors.primary), title: Text('Wastage Logs'), subtitle: Text('Waste tracking and adjustments.')),
        ],
      ),
    );
  }

  Future<void> _backupToGoogleDrive() async {
    setState(() => _isBackingUp = true);
    try {
      final fileId = await GoogleDriveService.instance.backupToGoogleDrive();
      if (fileId != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✓ Backup uploaded to Google Drive'), backgroundColor: Colors.green),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup failed. Please check Google Sign-In.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isBackingUp = false);
    }
  }

  Future<void> _restoreFromGoogleDrive() async {
    setState(() => _isRestoring = true);
    try {
      final backups = await GoogleDriveService.instance.listBackups();
      if (!mounted) return;

      if (backups.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No backups found in Google Drive')),
        );
        return;
      }

      // Show backup selection dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Select Backup'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: backups.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(backups[i].name ?? 'Unknown'),
                subtitle: Text(backups[i].modifiedTime?.toString() ?? ''),
                onTap: () {
                  Navigator.pop(ctx);
                  _performRestore(backups[i].id!);
                },
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  Future<void> _performRestore(String fileId) async {
    setState(() => _isRestoring = true);
    try {
      final success = await BackupRestoreService.instance.restoreFromGoogleDrive(fileId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✓ Restore complete. Data will sync next time you connect.'), backgroundColor: Colors.green),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  Future<void> _exportLocalBackup() async {
    try {
      final jsonContent = await BackupRestoreService.instance.createLocalBackup();
      Directory? dir;

      // On Android, try public Downloads so the user can see the file; request permission
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        if (status.isGranted) {
          final downloads = Directory('/storage/emulated/0/Download');
          if (await downloads.exists()) {
            dir = downloads;
          }
        }
      }

      // Fallback to app documents if permission denied or Downloads missing
      dir ??= await getApplicationDocumentsDirectory();
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final path = dir.path;
      final fileName = 'pos_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('$path/$fileName');
      await file.writeAsString(jsonContent);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to ${file.path}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _importLocalBackup() async {
    setState(() => _isRestoring = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonContent = await file.readAsString();
        final success = await BackupRestoreService.instance.restoreFromJson(jsonContent);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✓ Restore complete. Data will sync next time you connect.'), backgroundColor: Colors.green),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Restore failed'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }
}

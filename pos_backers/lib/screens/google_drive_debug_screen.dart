import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/services/google_drive_service.dart';
import '../core/theme/app_theme.dart';

class GoogleDriveDebugScreen extends StatefulWidget {
  const GoogleDriveDebugScreen({super.key});

  @override
  State<GoogleDriveDebugScreen> createState() => _GoogleDriveDebugScreenState();
}

class _GoogleDriveDebugScreenState extends State<GoogleDriveDebugScreen> {
  String _status = 'Not checked';
  bool _isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Drive Debug')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'App Configuration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow('Package Name', 'com.example.pos_backers'),
                  _buildInfoRow(
                    'Debug SHA-1',
                    'E1:B7:7E:24:E2:8A:A3:CE:CF:45:88:7D:54:59:68:2C:87:AB:04:24',
                    copyable: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.checklist, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Setup Checklist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildChecklistItem(
                    '1. Firebase میں SHA-1 add کریں',
                    'Firebase Console > Project Settings > Your apps > Add fingerprint',
                  ),
                  _buildChecklistItem(
                    '2. Google Cloud Console میں OAuth Client بنائیں',
                    'Application type: Android\nPackage: com.example.pos_backers\nSHA-1: وہی جو اوپر ہے',
                  ),
                  _buildChecklistItem(
                    '3. Google Drive API enable کریں',
                    'Google Cloud Console > APIs & Services > Library',
                  ),
                  _buildChecklistItem(
                    '4. google-services.json update کریں',
                    'Firebase سے latest file download کر کے android/app/ میں رکھیں',
                  ),
                  _buildChecklistItem(
                    '5. App rebuild کریں',
                    'flutter clean && flutter pub get && flutter run',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bug_report, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Test Connection',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text('Status: $_status'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isChecking ? null : _testGoogleSignIn,
                      icon: _isChecking
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.play_arrow),
                      label: Text(
                        _isChecking ? 'Testing...' : 'Test Google Sign-In',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Common Errors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '❌ "DEVELOPER_ERROR" یا "Error 10":\n'
                    '   → SHA-1 fingerprint غلط ہے یا Firebase میں add نہیں ہے\n\n'
                    '❌ "Sign in required":\n'
                    '   → OAuth Client ID properly configured نہیں ہے\n\n'
                    '❌ "Network error":\n'
                    '   → Internet connection check کریں\n'
                    '   → Google Play Services update کریں',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Quick Links'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('🔗 Firebase Console'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('🔗 Google Cloud Console'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('📄 Setup Guide'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.open_in_browser),
            label: const Text('Open Setup Links'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                if (copyable)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Future<void> _testGoogleSignIn() async {
    setState(() {
      _isChecking = true;
      _status = 'Testing...';
    });

    try {
      final account = await GoogleDriveService.instance.signIn();

      if (account != null) {
        setState(() {
          _status =
              '✅ SUCCESS!\n'
              'Signed in as: ${account.email}\n'
              'Display name: ${account.displayName ?? "N/A"}';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Google Sign-In کامیاب!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _status = '❌ Sign-In failed: User cancelled or error occurred';
        });
      }
    } catch (e) {
      String errorMessage = '❌ ERROR:\n';

      if (e.toString().contains('DEVELOPER_ERROR') ||
          e.toString().contains('10:')) {
        errorMessage +=
            'Configuration error!\n'
            '→ SHA-1 fingerprint Firebase میں add نہیں ہے\n'
            '→ OAuth Client ID properly configured نہیں ہے\n\n'
            'Steps:\n'
            '1. Firebase Console میں SHA-1 add کریں\n'
            '2. Google Cloud میں Android OAuth client بنائیں\n'
            '3. google-services.json update کریں\n'
            '4. App rebuild کریں (flutter clean && flutter run)';
      } else if (e.toString().contains('network') ||
          e.toString().contains('Network')) {
        errorMessage +=
            'Network error!\n'
            '→ Internet connection check کریں\n'
            '→ Google Play Services update کریں';
      } else {
        errorMessage += e.toString();
      }

      setState(() {
        _status = errorMessage;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-In failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() => _isChecking = false);
    }
  }
}

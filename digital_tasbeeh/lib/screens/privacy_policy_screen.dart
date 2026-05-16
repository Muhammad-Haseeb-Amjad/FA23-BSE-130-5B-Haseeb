import 'package:flutter/material.dart';
import '../widgets/premium_app_background.dart';
import '../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return PremiumAppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n.translate('privacy_policy')),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last updated: May 2026\n\n'
                      'Welcome to Digital Tasbeeh. Your privacy is important to us. This Privacy Policy explains how we handle information when you use our mobile application.\n\n'
                      '1. Information Collection\n'
                      'We do not collect, store, or share any personal data. All your dhikr records, sequences, and preferences are stored entirely locally on your device.\n\n'
                      '2. Device Permissions\n'
                      'We may request access to your device\'s vibration motor for haptic feedback. For advanced features, we might request camera access to scan text or microphone access for voice input. All processing is done securely.\n\n'
                      '3. Third-Party Services\n'
                      'Our app does not use third-party analytics, ad trackers, or data harvesting services.\n\n'
                      '4. Changes to This Policy\n'
                      'We may update our Privacy Policy from time to time. Any changes will be posted on this page.\n\n'
                      '5. Contact Us\n'
                      'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact the developer.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/premium_app_background.dart';
import '../l10n/app_localizations.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return PremiumAppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n.translate('terms_conditions')),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last updated: May 2026\n\n'
                      '1. Acceptance of Terms\n'
                      'By downloading or using the Digital Tasbeeh app, these terms will automatically apply to you. Please read them carefully before using the app.\n\n'
                      '2. Use of the App\n'
                      'You are responsible for your use of the app. The app is provided for personal, non-commercial use to assist with daily dhikr and prayers.\n\n'
                      '3. Intellectual Property\n'
                      'The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, belong to the developer.\n\n'
                      '4. Disclaimer of Warranties\n'
                      'The app is provided "as is" without any guarantees. We do not warrant that the app will always be available, accurate, or uninterrupted.\n\n'
                      '5. Changes to Terms\n'
                      'We reserve the right to modify these terms at any time. We will notify you of any changes by updating the terms in the app.\n\n'
                      '6. Contact Us\n'
                      'If you have any questions about these Terms and Conditions, please contact us via our Google Play Store developer profile.',
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

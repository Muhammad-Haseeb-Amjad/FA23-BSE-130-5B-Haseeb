import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../main.dart'; // For appSettingsProvider
import '../l10n/app_localizations.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import '../widgets/premium_app_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AudioPlayer? _audioPlayer;

  Future<void> _playClickSound() async {
    try {
      final player = _audioPlayer ??= AudioPlayer();
      await player.play(
        AssetSource('click.wav'),
        mode: PlayerMode.mediaPlayer,
        volume: 1.0,
      ).timeout(const Duration(seconds: 2));
    } catch (e) {
      // Ignore audio error
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettingsProvider,
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);
        final settings = appSettingsProvider; // global singleton

        return PremiumAppBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
            _buildHeader(l10n),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSectionHeader(l10n.translate('preferences')),
                  const SizedBox(height: 15),
                  _buildToggleSetting(
                    icon: settings.vibration ? Icons.vibration : Icons.do_not_disturb,
                    iconColor: const Color(0xFF4ADE80),
                    title: l10n.translate('vibration'),
                    value: settings.vibration,
                    onChanged: (value) async {
                      await settings.setVibration(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildToggleSetting(
                    icon: settings.mute ? Icons.volume_off : Icons.volume_up,
                    iconColor: settings.mute ? Colors.redAccent : const Color(0xFF4ADE80),
                    title: l10n.translate('mute'),
                    value: settings.mute,
                    onChanged: (value) async {
                      await settings.setMute(value);
                      if (value == false) {
                        await _playClickSound();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildLanguageSetting(settings, l10n),
                  const SizedBox(height: 30),
                  _buildSectionHeader(l10n.translate('appearance')),
                  const SizedBox(height: 15),
                  _buildNavigationSetting(
                    icon: Icons.dark_mode,
                    iconColor: Colors.purple,
                    title: l10n.translate('theme'),
                    value: l10n.translate(settings.theme),
                    onTap: () {
                      _showThemeDialog(context, settings, l10n);
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildSectionHeader(l10n.translate('support')),
                  const SizedBox(height: 15),
                  _buildNavigationSetting(
                    icon: Icons.star,
                    iconColor: Colors.amber,
                    title: l10n.translate('rate_app'),
                    onTap: () async {
                      final url = Uri.parse('market://details?id=com.haseebamjad.digitaltasbeeh');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        final webUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.haseebamjad.digitaltasbeeh');
                        if (await canLaunchUrl(webUrl)) {
                          await launchUrl(webUrl);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildNavigationSetting(
                    icon: Icons.share,
                    iconColor: Colors.blue,
                    title: l10n.translate('share_app'),
                    onTap: () {
                      Share.share('Check out Digital Tasbeeh App! https://play.google.com/store/apps/details?id=com.haseebamjad.digitaltasbeeh');
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildNavigationSetting(
                    icon: Icons.apps,
                    iconColor: Colors.pink,
                    title: l10n.translate('other_apps'),
                    onTap: () async {
                      final url = Uri.parse('https://play.google.com/store/apps/developer?id=Muhammad+Haseeb+Amjad');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildNavigationSetting(
                    icon: Icons.privacy_tip,
                    iconColor: Colors.teal,
                    title: l10n.translate('privacy_policy'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildNavigationSetting(
                    icon: Icons.gavel,
                    iconColor: Colors.indigo,
                    title: l10n.translate('terms_conditions'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen()));
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      l10n.translate('developed_by'),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.translate('settings'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Icon(
            title == AppLocalizations.of(context).translate('preferences')
                ? Icons.tune
                : title == AppLocalizations.of(context).translate('appearance')
                ? Icons.palette
                : Icons.favorite,
            color: const Color(0xFF4ADE80),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4ADE80),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF234141),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4ADE80),
            activeTrackColor: const Color(0xFF4ADE80).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSetting(dynamic settings, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF234141),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.language, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              l10n.translate('language'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              _buildLanguageButton('اردو', settings.language == 'urdu', () async {
                await settings.setLanguage('urdu');
              }),
              const SizedBox(width: 10),
              _buildLanguageButton('Eng', settings.language == 'eng', () async {
                await settings.setLanguage('eng');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ADE80) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4ADE80)
                : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1A2F2F) : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationSetting({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF234141),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, dynamic settings, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A2F2F),
          title: Text(l10n.translate('select_theme'), style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.translate('dark'), style: const TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'dark',
                  groupValue: settings.theme,
                  onChanged: (value) async {
                    await settings.setTheme(value!);
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFF4ADE80),
                ),
              ),
              ListTile(
                title: Text(l10n.translate('black'), style: const TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'black',
                  groupValue: settings.theme,
                  onChanged: (value) async {
                    await settings.setTheme(value!);
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFF4ADE80),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.translate('cancel'), style: const TextStyle(color: Color(0xFF4ADE80))),
            ),
          ],
        );
      },
    );
  }
}

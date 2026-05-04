import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();
  AudioPlayer? _audioPlayer;

  bool _vibration = true;
  bool _mute = false;
  String _language = 'eng';
  String _theme = 'dark';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storage.loadSettings();
    setState(() {
      _vibration = settings['vibration'] ?? true;
      _mute = settings['mute'] ?? false;
      _language = settings['language'] ?? 'eng';
      _theme = settings['theme'] ?? 'dark';
    });
  }

  Future<void> _saveSettings() async {
    await _storage.saveSettings({
      'vibration': _vibration,
      'mute': _mute,
      'language': _language,
      'theme': _theme,
    });
  }

  Future<void> _playClickSound() async {
    try {
      final player = _audioPlayer ??= AudioPlayer();
      await player.play(
        AssetSource('click.wav'),
        mode: PlayerMode.mediaPlayer,
        volume: 1.0,
      ).timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('Sound error: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSectionHeader('PREFERENCES'),
                  const SizedBox(height: 15),
                  _buildToggleSetting(
                    icon: _vibration ? Icons.vibration : Icons.do_not_disturb,
                    iconColor: const Color(0xFF4ADE80),
                    title: 'Vibration',
                    value: _vibration,
                    onChanged: (value) async {
                      setState(() {
                        _vibration = value;
                      });
                      await _saveSettings();
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildToggleSetting(
                    icon: _mute ? Icons.volume_off : Icons.volume_up,
                    iconColor: _mute ? Colors.redAccent : const Color(0xFF4ADE80),
                    title: 'Mute',
                    value: _mute,
                    onChanged: (value) async {
                      setState(() {
                        _mute = value;
                      });
                      await _saveSettings();
                      // Play sound if mute is turned OFF
                      if (value == false) {
                        await _playClickSound();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildLanguageSetting(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('APPEARANCE'),
                  const SizedBox(height: 15),
                  _buildNavigationSetting(
                    icon: Icons.dark_mode,
                    iconColor: Colors.purple,
                    title: 'Theme',
                    value: _theme == 'dark' ? 'Dark' : 'Light',
                    onTap: () {
                      // Theme selection dialog
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildSectionHeader('SUPPORT'),
                  const SizedBox(height: 15),
                  _buildNavigationSetting(
                    icon: Icons.star,
                    iconColor: Colors.amber,
                    title: 'Rate App',
                    onTap: () {
                      // Rate app logic
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildNavigationSetting(
                    icon: Icons.share,
                    iconColor: Colors.blue,
                    title: 'Share App',
                    onTap: () {
                      // Share app logic
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildNavigationSetting(
                    icon: Icons.apps,
                    iconColor: Colors.pink,
                    title: 'Other Apps',
                    onTap: () {
                      // Other apps logic
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Version 2.0.1 (Build 45)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          const Text(
            'Settings',
            style: TextStyle(
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
            title == 'PREFERENCES'
                ? Icons.tune
                : title == 'APPEARANCE'
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

  Widget _buildLanguageSetting() {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildLanguageButton('اردو', _language == 'urdu', () {
                setState(() {
                  _language = 'urdu';
                });
                _saveSettings();
              }),
              const SizedBox(width: 10),
              _buildLanguageButton('Eng', _language == 'eng', () {
                setState(() {
                  _language = 'eng';
                });
                _saveSettings();
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
}

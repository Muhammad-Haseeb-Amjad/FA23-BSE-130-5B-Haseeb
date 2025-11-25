// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart'; // For kPrimaryGreen
import 'theme_screen.dart'; // Theme Screen

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _touchIncrement = true;
  bool _volumeKeys = false;
  bool _dailyNotification = false;
  bool _reminderNotification = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _touchIncrement = prefs.getBool('touchIncrement') ?? true;
      _volumeKeys = prefs.getBool('volumeKeys') ?? false;
      _dailyNotification = prefs.getBool('dailyNotification') ?? false;
      _reminderNotification = prefs.getBool('reminderNotification') ?? false;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    // Note: Notification logic (scheduling/cancelling) would go here
  }

  Widget _buildToggleTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: kPrimaryGreen,
      ),
    );
  }

  void _rateApp() async {
    const url = 'https://play.google.com/store/apps/details?id=your.package.name';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Show error
    }
  }

  void _shareApp() async {
    // Implement sharing functionality
    const text = 'Check out this amazing Digital Zikr Tasbeeh App: [Link to App Store]';
    // Use Share.share() from share_plus package if added
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          _buildToggleTile('Touch Increment', _touchIncrement, (val) {
            setState(() {
              _touchIncrement = val;
            });
            _updateSetting('touchIncrement', val);
          }),
          _buildToggleTile('Counting with Volume Keys', _volumeKeys, (val) {
            setState(() {
              _volumeKeys = val;
            });
            _updateSetting('volumeKeys', val);
          }),
          _buildToggleTile('Daily Notification', _dailyNotification, (val) {
            setState(() {
              _dailyNotification = val;
            });
            _updateSetting('dailyNotification', val);
          }),
          _buildToggleTile('Reminder Notification', _reminderNotification, (val) {
            setState(() {
              _reminderNotification = val;
            });
            _updateSetting('reminderNotification', val);
          }),

          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate Our App!'),
            onTap: _rateApp,
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Application'),
            onTap: _shareApp,
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/settings_service.dart';
import '../core/theme/app_theme.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String _mode = 'light';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _mode = prefs.getString('theme_mode') ?? 'light');
  }

  Future<void> _set(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode);
    await SettingsService.instance.setThemeMode(
      mode == 'dark'
          ? ThemeMode.dark
          : mode == 'system'
              ? ThemeMode.system
              : ThemeMode.light,
    );
    setState(() => _mode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card('Fresh Morning', 'Light Mode', 'light'),
          _card('Night Shift', 'Dark Mode', 'dark'),
          _card('Automatic', 'Follow system', 'system'),
          const SizedBox(height: 20),
          const Text('Theme preference updates instantly across the app.', style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _card(String title, String subtitle, String value) {
    final selected = _mode == value;
    return Card(
      child: ListTile(
        leading: Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? AppColors.primary : AppColors.muted),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        onTap: () => _set(value),
      ),
    );
  }
}

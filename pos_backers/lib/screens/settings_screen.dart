import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/services/supabase_service.dart';
import '../core/services/settings_service.dart';
import 'currency_selection_screen.dart';
import 'tax_configuration_screen.dart';
import 'sync_preferences_screen.dart';
import 'backup_settings_screen.dart';
import 'data_source_screen.dart';
import 'appearance_screen.dart';
import 'about_screen.dart';
import 'customers_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = SettingsService.instance.role;
    return ValueListenableBuilder<String>(
      valueListenable: role,
      builder: (_, currentRole, __) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Settings'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.verified_user_outlined),
              tooltip: 'Role: $currentRole',
              initialValue: currentRole,
              onSelected: (val) => SettingsService.instance.setRole(val),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'admin', child: Text('Admin')),
                PopupMenuItem(value: 'manager', child: Text('Manager')),
                PopupMenuItem(value: 'cashier', child: Text('Cashier')),
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            _sectionTitle('General'),
            _tile(
              context,
              title: 'Customers',
              subtitle: 'Manage customer profiles',
              icon: Icons.people_alt_outlined,
              onTap: () => context.push('/customers'),
            ),
            _tile(
              context,
              title: 'Currency Selection',
              subtitle: 'Choose default currency',
              icon: Icons.currency_exchange,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CurrencySelectionScreen())),
            ),
            _tile(
              context,
              title: 'Tax Configuration',
              subtitle: 'Manage tax rules',
              icon: Icons.percent,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TaxConfigurationScreen())),
              enabled: currentRole != 'cashier',
            ),
            _sectionTitle('Data & Sync'),
            _tile(
              context,
              title: 'Sync Preferences',
              subtitle: 'Auto sync and status',
              icon: Icons.sync,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SyncPreferencesScreen())),
            ),
            _tile(
              context,
              title: 'Backup & Restore',
              subtitle: 'Cloud backups overview',
              icon: Icons.backup_outlined,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BackupSettingsScreen())),
              enabled: currentRole != 'cashier',
            ),
            _sectionTitle('Appearance'),
            _tile(
              context,
              title: 'Theme',
              subtitle: 'Light / Dark / Auto',
              icon: Icons.dark_mode_outlined,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AppearanceScreen())),
            ),
            _sectionTitle('Info'),
            _tile(
              context,
              title: 'About Us',
              subtitle: 'Terms, privacy, version',
              icon: Icons.info_outline,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen())),
            ),
            _logoutTile(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
        child: Text(text.toUpperCase(), style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, fontSize: 13)),
      );

  Widget _tile(BuildContext context, {required String title, required String subtitle, required IconData icon, VoidCallback? onTap, bool enabled = true}) {
    final muted = !enabled;
    return ListTile(
      enabled: enabled,
      leading: CircleAvatar(backgroundColor: Colors.orange.shade50, child: Icon(icon, color: muted ? Colors.grey : AppColors.primary)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: muted ? Colors.grey : null)),
      subtitle: Text(subtitle, style: TextStyle(color: muted ? Colors.grey : null)),
      trailing: const Icon(Icons.chevron_right),
      onTap: enabled ? onTap : null,
    );
  }

  Widget _logoutTile(BuildContext context) {
    return ListTile(
      title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
      leading: const Icon(Icons.logout, color: Colors.red),
      onTap: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Log Out?'),
            content: const Text('Are you sure you want to end your shift? Unsaved cart items will be cleared.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, Log Out')),
            ],
          ),
        );
        if (confirm == true) {
          await SupabaseService.instance.client.auth.signOut();
          if (context.mounted) context.go('/login');
        }
      },
    );
  }
}

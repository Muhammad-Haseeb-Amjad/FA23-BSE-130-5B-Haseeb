import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class DataSourceScreen extends StatelessWidget {
  const DataSourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Source')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(child: Text('Changing backend requires restart. Pending transactions should be synced first.')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _option(title: 'Supabase', description: 'Best for realtime sync & offline support.', selected: true),
          _option(title: 'Firebase', description: 'Disabled (Supabase only)', selected: false, disabled: true),
          _option(title: 'REST API + MySQL', description: 'Disabled (Supabase only)', selected: false, disabled: true),
          const SizedBox(height: 18),
          const Text('Endpoint Configuration', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 10),
          const Text('Supabase keys are loaded from .env. Edit .env to change.'),
          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.save), label: const Text('Save & Restart')),
        ],
      ),
    );
  }

  Widget _option({required String title, required String description, required bool selected, bool disabled = false}) {
    return Card(
      color: disabled ? Colors.grey.shade100 : Colors.white,
      child: ListTile(
        leading: Icon(Icons.storage, color: disabled ? Colors.grey : AppColors.primary),
        title: Text(title, style: TextStyle(color: disabled ? Colors.grey : null)),
        subtitle: Text(description, style: TextStyle(color: disabled ? Colors.grey : null)),
        trailing: Radio<bool>(value: true, groupValue: selected, onChanged: disabled ? null : (_) {}),
      ),
    );
  }
}

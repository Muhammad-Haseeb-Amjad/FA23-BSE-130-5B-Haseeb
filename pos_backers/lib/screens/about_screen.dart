import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 12),
          Center(child: Icon(Icons.bakery_dining, size: 72, color: AppColors.primary)),
          SizedBox(height: 12),
          Center(child: Text('BreadBox POS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
          SizedBox(height: 6),
          Center(child: Text('Smart Inventory & Sales')),
          SizedBox(height: 8),
          Center(child: Chip(label: Text('Version 1.0.4 (Build 203)'))),
          SizedBox(height: 20),
          ListTile(leading: Icon(Icons.description_outlined, color: AppColors.primary), title: Text('Terms of Service')), 
          ListTile(leading: Icon(Icons.privacy_tip_outlined, color: AppColors.primary), title: Text('Privacy Policy')),
          ListTile(leading: Icon(Icons.star_border, color: AppColors.primary), title: Text('Rate Us on App Store')),
          ListTile(leading: Icon(Icons.language, color: AppColors.primary), title: Text('Visit Website')),
          SizedBox(height: 20),
          Center(child: Text('Made with ❤️ in San Francisco')),
        ],
      ),
    );
  }
}

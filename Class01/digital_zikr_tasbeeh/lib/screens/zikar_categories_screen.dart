// lib/screens/zikar_categories_screen.dart

import 'package:flutter/material.dart';
import '../main.dart'; // To use kPrimaryGreen
import 'main_counter_screen.dart';
import 'zikar_list_screen.dart';
import 'asmaul_husna_screen.dart';
import 'settings_screen.dart';
import 'prayer_zikar_screen.dart'; // Abhi iski file nahi bani hai

class ZikarCategoriesScreen extends StatelessWidget {
  const ZikarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zikr Categories'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // Yahan se wapas jaane ka button hatana behtar hai kyunki yeh Splash ke baad aata hai.
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Note: Pehla card Main Counter Screen par jaana chahiye, jahan se Zikr List ka button oper hai.
            _buildCategoryCard(
              context,
              title: 'Main Zikr Counter',
              subtitle: 'Start or continue your Zikr',
              color: kPrimaryGreen,
              icon: Icons.numbers,
              onTap: () {
                // Main Counter Screen par jaana
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainCounterScreen()),
                );
              },
            ),

            // Dhikr List (Zikr List)
            _buildCategoryCard(
              context,
              title: 'Zikr List',
              subtitle: 'View and manage your saved Zikr',
              color: const Color(0xFF67B0A2), // Light Blue/Greenish shade
              icon: Icons.list_alt,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ZikarListScreen()),
                );
              },
            ),

            // Asmaul Husna
            _buildCategoryCard(
              context,
              title: 'Esmaul Husna',
              subtitle: '99 Names of Allah',
              color: kPrimaryGreen, // Green
              icon: Icons.star_border,
              onTap: () {
                // Aapko AsmaulHusnaScreen file banana padega.
                   Navigator.push(
                      context,
                     MaterialPageRoute(builder: (context) => const AsmaulHusnaScreen()),
                   );
              },
            ),

            // Prayer Dhikr
            _buildCategoryCard(
              context,
              title: 'Prayer Zikr',
              subtitle: 'Zikr after Salah',
              color: kPrimaryGreen.withOpacity(0.8), // Darker Green
              icon: Icons.self_improvement,
              onTap: () {
                // Aapko PrayerZikarScreen file banana padega.
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const PrayerZikarScreen()),
                   );
              },
            ),

            // Statistics (Orange/Accent Color)
            _buildCategoryCard(
              context,
              title: 'Statistics',
              subtitle: 'View your Zikr progress and achievements',
              color: Colors.deepOrange, // Orange shade
              icon: Icons.bar_chart,
              onTap: () {
                // Statistics Screen (Optional to create later)
              },
            ),

            // Settings (Aapke instructions ke mutabiq settings main counter par bhi hai, lekin yahan bhi ho sakta hai)
            _buildCategoryCard(
              context,
              title: 'Settings',
              subtitle: 'Manage app preferences and themes',
              color: Colors.grey,
              icon: Icons.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  // Custom function for category cards
  Widget _buildCategoryCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required Color color,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// lib/screens/theme_screen.dart

import 'package:flutter/material.dart';
import '../main.dart'; // To use kPrimaryGreen and kAccentPurple

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  // Placeholder for the currently selected theme
  Color _selectedTheme = kPrimaryGreen;

  // List of themes (Based on your image WhatsApp Image 2025-10-28 at 08.34.50_004cff1e.jpg)
  final List<Color> availableThemes = [
    kPrimaryGreen,
    Colors.grey.shade400,
    Colors.blue.shade700,
    Colors.deepPurple.shade900,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two themes per row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.7, // Adjust ratio for better display
          ),
          itemCount: availableThemes.length,
          itemBuilder: (context, index) {
            Color themeColor = availableThemes[index];
            bool isSelected = themeColor == _selectedTheme;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTheme = themeColor;
                  // TODO: Implement actual theme saving logic using shared_preferences
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 4)
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    // Placeholder for the Zikr Counter Image (like in your Theme image)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Icon(
                          Icons.circle, // Placeholder for the Tasbeeh Counter image
                          size: 100,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.check_circle, color: Colors.white, size: 30),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
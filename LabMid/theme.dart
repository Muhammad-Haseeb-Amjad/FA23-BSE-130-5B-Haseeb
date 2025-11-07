import 'package:flutter/material.dart';

// Custom Colors from the design
const Color primaryDark = Color(0xFF0F2625); // Deep green/black background
const Color accentGreen = Color(0xFF38B28F); // Main accent green (buttons/checks)
const Color textLight = Color(0xFFF0F2EE); // Light text color
const Color priorityHigh = Color(0xFFE57373); // Red/Orange for High Priority
const Color priorityMedium = Color(0xFFFFB74D); // Amber for Medium Priority
const Color priorityLow = Color(0xFF64B5F6); // Blue for Low Priority

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: primaryDark,
  colorScheme: const ColorScheme.dark(
    primary: accentGreen,
    secondary: accentGreen,
    surface: Color(0xFF1B3A39), // Card/Container background
    onSurface: textLight,
    background: primaryDark,
    onBackground: textLight,
  ),
  appBarTheme: const AppBarTheme(
    color: primaryDark,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: textLight,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1B3A39),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: textLight),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentGreen,
      foregroundColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
);
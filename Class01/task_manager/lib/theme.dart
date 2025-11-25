// lib/theme.dart

import 'package:flutter/material.dart';

// Custom Colors from the design (Constants)
const Color primaryDark = Color(0xFF0F2625); // Deep green/black background
const Color accentGreen = Color(
  0xFF38B28F,
); // Main accent green (buttons/checks)
const Color textLight = Color(0xFFF0F2EE); // Light text color

// FIX 1: Light Mode UI ke liye behtar base colors define kiye gaye
const Color primaryLightBg = Color(
  0xFFFFFFFF,
); // Pure white background for better contrast
const Color surfaceLight = Color(
  0xFFF0F0F0,
); // Light gray card/input background

const Color priorityHigh = Color(0xFFE57373); // Red/Orange for High Priority
const Color priorityMedium = Color(0xFFFFB74D); // Amber for Medium Priority
const Color priorityLow = Color(0xFF64B5F6); // Blue for Low Priority

// FIX: Static darkTheme ko dynamic function se replace kiya gaya
class AppTheme {
  // FIX 1: Naya dynamic function jo accent color aur brightness ko handle karega
  static ThemeData getTheme(Color accentColor, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Base colors for dark mode (can be adjusted for light mode if needed)
    // FIX 2: primaryBg aur textColor ko Light mode ke liye set kiya gaya
    final Color primaryBg = isDark
        ? primaryDark
        : primaryLightBg; // Background color
    final Color surfaceColor = isDark
        ? const Color(0xFF1B3A39)
        : surfaceLight; // Card/Input color
    final Color textColor = isDark
        ? textLight
        : primaryDark; // Main text color (Dark text on light background)
    final Color hintColor = isDark
        ? textLight.withOpacity(0.5)
        : primaryDark.withOpacity(0.5); // Hint text color

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: primaryBg,

      // FIX 2: ColorScheme ko dynamic accentColor use karne ke liye ColorScheme.fromSeed se banaya gaya
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor, // User selected accent color
        brightness: brightness,
        primary: accentColor,
        secondary: accentColor,
        surface: surfaceColor,
        onSurface: textColor,
        background: primaryBg,
        onBackground: textColor,
      ),

      appBarTheme: AppBarTheme(
        color: primaryBg, // AppBar color
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textColor), // Icons in AppBar
      ),

      // Floating Action Button (FAB) color change ke liye zaroori
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        // FIX 3: FAB foreground color ko Light mode ke liye primaryDark rakha
        foregroundColor: isDark ? primaryDark : primaryDark,
      ),

      // Bottom Navigation Bar ke colors ko theme ke mutabik set karein (optional, UI consistency ke liye)
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryBg,
        selectedItemColor: accentColor,
        unselectedItemColor: textColor.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
      ),

      // FIX 4: InputDecorationTheme ko Light Mode ke liye theek kiya gaya
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: hintColor),
        hintStyle: TextStyle(color: hintColor),
        prefixIconColor: hintColor,
        suffixIconColor: hintColor,
      ),

      // FIX 3: ElevatedButtonTheme mein bhi dynamic accentColor use karein
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          // FIX 3: Elevated button text color
          foregroundColor: isDark ? primaryDark : primaryLightBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // FIX 5: ListTile ki default appearance ko theme se control karein (Settings screen ke liye zaroori)
      listTileTheme: ListTileThemeData(
        tileColor: surfaceColor,
        textColor: textColor,
        iconColor: textColor,
      ),

      // FIX 6: TextButton color (jaise "Add Subtask" button)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accentColor),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: accentColor,
        contentTextStyle: TextStyle(
          color: isDark ? primaryDark : primaryLightBg,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

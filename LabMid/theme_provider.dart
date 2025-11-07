import 'package:flutter/material.dart';
import '../theme.dart'; // Contains accentGreen, primaryDark, etc.

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to Dark as per design
  Color _accentColor = accentGreen; // Default accent

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  // Change App Theme (Light/Dark/System)
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Change Accent Color (from a palette)
  void setAccentColor(Color color) {
    _accentColor = color;
    // We need to re-notify all widgets that depend on the theme/color
    notifyListeners();
  }

  // Helper to provide the correct ThemeData
  ThemeData get currentThemeData {
    // If the system theme is preferred, Flutter handles it.
    // Since our design is strictly dark, we'll only provide the dark theme
    // for now, but the switch UI remains for future light theme implementation.
    return darkTheme.copyWith(
      colorScheme: darkTheme.colorScheme.copyWith(
        primary: _accentColor,
        secondary: _accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: primaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
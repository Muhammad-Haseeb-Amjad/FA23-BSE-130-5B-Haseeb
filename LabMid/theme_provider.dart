import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart'; // Contains accentGreen, primaryDark, AppTheme.getTheme(), etc.

class ThemeProvider with ChangeNotifier {
  // SharedPreferences keys
  static const String _themeModeKey = 'themeMode';
  static const String _accentColorKey = 'accentColor';

  // ✅ NEW: Keys for Default Notification Settings
  static const String _defaultEnabledKey = 'defaultNotificationEnabled';
  static const String _defaultTimeKey = 'defaultNotificationTimeMinutes';
  static const String _defaultSoundKey = 'defaultNotificationSound';


  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = accentGreen;

  // ✅ NEW: Default Notification States
  bool _defaultNotificationEnabled = true;
  int _defaultNotificationTimeMinutes = 15; // 15 minutes before due date
  String _defaultNotificationSound = 'default'; // Default system sound


  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  // ✅ NEW: Default Notification Getters
  bool get defaultNotificationEnabled => _defaultNotificationEnabled;
  int get defaultNotificationTimeMinutes => _defaultNotificationTimeMinutes;
  String get defaultNotificationSound => _defaultNotificationSound;


  // FIX 1: Constructor mein settings ko load karein
  ThemeProvider() {
    _loadSettings();
  }

  // FIX 2: Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Load Theme Mode
    final savedMode = prefs.getString(_themeModeKey);
    if (savedMode != null) {
      if (savedMode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedMode == 'system') {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.dark;
      }
    }

    // 2. Load Accent Color
    final savedColorValue = prefs.getInt(_accentColorKey);
    if (savedColorValue != null) {
      _accentColor = Color(savedColorValue);
    }

    // ✅ NEW: 3. Load Default Notification Preferences
    // Agar value nahi milti, toh default values (true, 15, 'default') use honge
    _defaultNotificationEnabled = prefs.getBool(_defaultEnabledKey) ?? true;
    _defaultNotificationTimeMinutes = prefs.getInt(_defaultTimeKey) ?? 15;
    _defaultNotificationSound = prefs.getString(_defaultSoundKey) ?? 'default';

    // UI ko load ki hui settings se update karein
    notifyListeners();
  }

  // Change App Theme (Light/Dark/System)
  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();

    // FIX 3: Theme Mode ko save karein
    String modeString = 'dark';
    if (mode == ThemeMode.light) {
      modeString = 'light';
    } else if (mode == ThemeMode.system) {
      modeString = 'system';
    }
    await prefs.setString(_themeModeKey, modeString);

    notifyListeners();
  }

  // Change Accent Color (from a palette)
  void setAccentColor(Color color) async {
    _accentColor = color;
    final prefs = await SharedPreferences.getInstance();

    // FIX 4: Accent Color (integer value) ko save karein
    await prefs.setInt(_accentColorKey, color.value);

    notifyListeners();
  }

  // -------------------------------------------------------------------
  // ✅ NEW: Methods to Save Default Notification Settings
  // -------------------------------------------------------------------

  Future<void> setDefaultNotificationEnabled(bool isEnabled) async {
    _defaultNotificationEnabled = isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_defaultEnabledKey, isEnabled);
    notifyListeners();
  }

  Future<void> setDefaultNotificationTime(int minutesBefore) async {
    _defaultNotificationTimeMinutes = minutesBefore;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultTimeKey, minutesBefore);
    notifyListeners();
  }

  // soundName should be the filename (e.g., 'chime.mp3') or 'default'
  Future<void> setDefaultNotificationSound(String soundName) async {
    _defaultNotificationSound = soundName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultSoundKey, soundName);
    notifyListeners();
  }

  // Helper to provide the correct ThemeData
  ThemeData get currentThemeData {
    // FIX 5: Warning ko theek kiya. Context ke bahar hone ki wajah se,
    // humein yahan Brightness ko hardcode karna padega (ya Dark mode)
    // agar yeh getter use ho raha hai.
    final baseTheme = AppTheme.getTheme(_accentColor, Brightness.dark);

    return baseTheme.copyWith(
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

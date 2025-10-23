import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'database/database_helper.dart';

// Global Green Theme
const MaterialColor kPrimaryGreen = Colors.green;

void main() async {

  // 1. ZAROORI: Widgets binding ko initialize karein
  WidgetsFlutterBinding.ensureInitialized();

  // 2. ZAROORI: Database ko initialize karein
  try {
    await DatabaseHelper.instance.database;
    print('Database initialized successfully!');
  } catch (e) {
    print('Database initialization FAILED: $e');
  }

  // Phir app run karein
  runApp(const MyApp());
}

// -------------------------------------------------------------
// MyApp ko Stateful banaya gaya hai Theme management ke liye
// -------------------------------------------------------------

class MyApp extends StatefulWidget {
  // Static key to access state from SettingsScreen (zaroori hai Dark Mode toggle ke liye)
  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Default theme mode
  ThemeMode _themeMode = ThemeMode.system;

  // Public function to change theme state
  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr. Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode, // Theme mode applied here

      // --- LIGHT THEME ---
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: kPrimaryGreen,
        primaryColor: kPrimaryGreen,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: kPrimaryGreen)
            .copyWith(secondary: Colors.green.shade700),
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryGreen,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryGreen,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // FIX: CardTheme ki jagah CardThemeData use karein
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 1,
        ),
      ),

      // --- DARK THEME ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: kPrimaryGreen,
        primaryColor: kPrimaryGreen.shade700,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: kPrimaryGreen, brightness: Brightness.dark)
            .copyWith(secondary: Colors.teal.shade300, background: Colors.grey.shade900),
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryGreen.shade700,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryGreen.shade700,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryGreen.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        cardColor: Colors.grey.shade800,
        // FIX: CardTheme ki jagah CardThemeData use karein
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
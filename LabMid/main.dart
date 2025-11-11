// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // REQUIRED FOR ONBOARDING CHECK

// ✅ NEW IMPORTS FOR NOTIFICATIONS & TIME ZONE
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// NOTE: Humne TimezoneInfo object use karne ke liye, TimezoneInfo class ko access karne ki zaroorat nahi hai.
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io'; // Platform check ke liye
// ---------------------------------------------


// --- Local Imports ---
import 'theme.dart'; // Is file mein AppTheme class honi chahiye
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
// FIX 1: ExportOptionsProvider ko import karein
import 'providers/export_options_provider.dart';
import 'screens/today_tasks_screen.dart';
import 'screens/task_edit_sheet.dart'; // For FAB
import 'screens/onboarding/onboarding_flow.dart'; // For initial check
import 'screens/export_flow/export_format_screen.dart'; // For routing example
// ✅ NEW IMPORT: Notification Service
import 'services/notification_service.dart';


// IMPORTANT: Yeh imports ab aapki real screens ko point karne chahiye
import 'screens/repeated_tasks_list.dart'; // Real screen import
import 'screens/compact_calendar_view.dart'; // Real screen import
import 'screens/settings_screen.dart'; // Real screen import


// ✅ FIX 1: main() function ko async banaya aur Notification Initialization add kiya
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Zaroori Notification Setup ---
  // 1. Timezone set karna zaroori hai scheduled notifications ke liye
  try {
    // 💡 CRITICAL FIX: FlutterTimezone ka latest version TimezoneInfo object return karta hai.
    // Hum Timezone ID nikalne ke liye toString() method istemaal karenge.
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = timezoneInfo.toString();

    // Notification Service mein Timezone ko set karein
    NotificationService.initTimezone(currentTimeZone);
  } catch (e) {
    // Agar timezone set na ho paye toh error log karein
    debugPrint('Could not get local timezone: $e');
  }

  // 2. Local Notification Service ko initialize karein
  await NotificationService().initNotifications();
  // ----------------------------------

  runApp(const TaskManagerApp());
}
//
// ----------------------------------------------
// 1. Initial Loader (Checks Onboarding Status)
// ----------------------------------------------
class InitialLoader extends StatelessWidget {
// ... (Baaki code wahi rahega)
  const InitialLoader({super.key});

  Future<bool> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Returns true if 'has_seen_onboarding' is true, false otherwise (including null)
    return prefs.getBool('has_seen_onboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final hasSeenOnboarding = snapshot.data ?? false;

          if (hasSeenOnboarding) {
            // User has seen it, go straight to the main app shell
            return const TaskManagerShell();
          } else {
            // First time user, show onboarding
            return const OnboardingFlow();
          }
        }
        // Show a simple loading screen while checking status
        // NOTE: primaryDark aur accentGreen yahan use ho rahe hain.
        // Yeh variables 'theme.dart' mein define hone chahiye.
        return const Scaffold(
          // Assuming these variables are accessible via theme.dart
          // Agar AppTheme use karna hai toh context zaroori hai.
          backgroundColor: Colors.blueGrey,
          body: Center(child: CircularProgressIndicator(color: Colors.green)),
        );
      },
    );
  }
}


// ----------------------------------------------
// 2. Main App Configuration
// ----------------------------------------------
class TaskManagerApp extends StatelessWidget {
// ... (Baaki code wahi rahega)
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // FIX 2: ExportOptionsProvider ko yahan add kiya gaya hai
        ChangeNotifierProvider(create: (_) => ExportOptionsProvider()),
      ],
      // WRAP MaterialApp with Consumer to access ThemeProvider
      child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {

            // FIX: Dynamic theme logic ko AppTheme.getTheme function se replace kiya gaya
            // 💡 WARNING FIX: Maiñ ne yeh unused line delete kardi hai jisko aapne pichle message mein theek karne ko kaha tha.
            // final dynamicTheme = AppTheme.getTheme(
            //     themeProvider.accentColor,
            //     themeProvider.themeMode == ThemeMode.light ? Brightness.light : Brightness.dark
            // );


            return MaterialApp(
              title: 'Task Manager',
              debugShowCheckedModeBanner: false,

              // FIX: AppTheme.getTheme() ko use karein
              theme: AppTheme.getTheme(themeProvider.accentColor, Brightness.light),
              darkTheme: AppTheme.getTheme(themeProvider.accentColor, Brightness.dark),
              themeMode: themeProvider.themeMode,
              home: const InitialLoader(),

              // ✅ RESPONSIVE FIX: Builder function to override system font scale factor
              builder: (context, child) {
                // Device ki default font scaling factor ko 1.0 par set kar deta hai
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
              // routes...
            );
          }
      ),
    );
  }
}


// ----------------------------------------------
// 3. App Shell (Bottom Navigation Consistency)
// ----------------------------------------------
class TaskManagerShell extends StatefulWidget {
// ... (Baaki code wahi rahega)
  const TaskManagerShell({super.key});

  @override
  State<TaskManagerShell> createState() => _TaskManagerShellState();
}

class _TaskManagerShellState extends State<TaskManagerShell> {
  int _currentIndex = 0;

  // Placeholder screens for all four bottom navigation tabs
  final List<Widget> _screens = [
    const TodayTasksScreen(),           // Index 0: Today (Home)
    const RepeatedTasksListScreen(),    // Index 1: Tasks (Repeated Tasks)
    const CompactCalendarView(),        // Index 2: Calendar
    const SettingsScreen(),             // Index 3: Settings
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    // NOTE: accentColor ko themeProvider mein define kiya hua hona zaroori hai
    final accentColor = themeProvider.accentColor;

    // Theme.of(context).scaffoldBackgroundColor ab theme mode ke mutabik badlega
    final primaryBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        // Background color ab theme se aayega, lekin yahan bhi set kiya gaya hai
        backgroundColor: primaryBg,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open Task Add / Edit Sheet
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            // Background color ko theme se ya explicitly set karein
            backgroundColor: primaryBg,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const TaskEditSheet(),
          ).then((_) {
            // Task refresh call
            Provider.of<TaskProvider>(context, listen: false).fetchTasks();
          });
        },
        backgroundColor: accentColor,
        child:  Icon(Icons.add, color: primaryBg), // Icon color ko primaryBg se theek kiya
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

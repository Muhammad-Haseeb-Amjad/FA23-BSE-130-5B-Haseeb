// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // REQUIRED FOR ONBOARDING CHECK

// --- Local Imports ---
import 'theme.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart'; // <--- **FIX: Missing ThemeProvider Import**
import 'screens/today_tasks_screen.dart';
import 'screens/task_edit_sheet.dart'; // For FAB
import 'screens/onboarding/onboarding_flow.dart'; // For initial check
import 'screens/export_flow/export_format_screen.dart'; // For routing example
// We need to import the placeholder screens for the shell to work
import 'screens/repeated_tasks_list.dart'; // Placeholder for Tasks tab
import 'screens/compact_calendar_view.dart'; // Placeholder for Calendar tab
import 'screens/settings_screen.dart'; // Placeholder for Settings tab


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize DatabaseHelper here if needed: DatabaseHelper.instance.database;
  runApp(const TaskManagerApp());
}

// ----------------------------------------------
// 1. Initial Loader (Checks Onboarding Status)
// ----------------------------------------------
class InitialLoader extends StatelessWidget {
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
        return const Scaffold(
          backgroundColor: primaryDark,
          body: Center(child: CircularProgressIndicator(color: accentGreen)),
        );
      },
    );
  }
}


// ----------------------------------------------
// 2. Main App Configuration
// ----------------------------------------------
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // This line now works
      ],
      child: Consumer<ThemeProvider>( // WRAP MaterialApp with Consumer
          builder: (context, themeProvider, child) {
            return MaterialApp(
              title: 'Task Manager',
              debugShowCheckedModeBanner: false,
              // Use the dynamic theme data from the provider
              theme: themeProvider.currentThemeData,
              darkTheme: themeProvider.currentThemeData, // Use for consistency
              themeMode: themeProvider.themeMode, // Control Theme Mode
              home: const InitialLoader(),
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
    final primaryDark = Theme.of(context).scaffoldBackgroundColor;
    final accentGreen = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryDark,
        selectedItemColor: accentGreen,
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
            backgroundColor: primaryDark,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const TaskEditSheet(),
          ).then((_) {
            // Refresh tasks after modal closes (in case a new task was added)
            Provider.of<TaskProvider>(context, listen: false).fetchTasks();
          });
        },
        backgroundColor: accentGreen,
        child:  Icon(Icons.add, color: primaryDark),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ----------------------------------------------
// 4. Placeholder Screens (For Navigation)
// ----------------------------------------------
// NOTE: These are required to make the TaskManagerShell compile and run
class RepeatedTasksListScreen extends StatelessWidget {
  const RepeatedTasksListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repeated Tasks')),
      body: const Center(child: Text("Repeated Tasks Screen (Placeholder)", style: TextStyle(color: textLight))),
    );
  }
}

class CompactCalendarView extends StatelessWidget {
  const CompactCalendarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar View')),
      body: const Center(child: Text("Compact Calendar View (Placeholder)", style: TextStyle(color: textLight))),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text("Settings Screen (Placeholder)", style: TextStyle(color: textLight))),
    );
  }
}


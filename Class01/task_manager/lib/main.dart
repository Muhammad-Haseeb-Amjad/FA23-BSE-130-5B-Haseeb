// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // REQUIRED FOR ONBOARDING CHECK

// ✅ NEW IMPORTS FOR NOTIFICATIONS & TIME ZONE
// NOTE: Humne TimezoneInfo object use karne ke liye, TimezoneInfo class ko access karne ki zaroorat nahi hai.
import 'package:flutter_timezone/flutter_timezone.dart';
// ---------------------------------------------

// --- Local Imports ---
import 'theme.dart'; // Is file mein AppTheme class honi chahiye
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
// FIX 1: ExportOptionsProvider ko import karein
import 'providers/export_options_provider.dart';
import 'screens/today_tasks_screen.dart';
import 'screens/onboarding/onboarding_flow.dart'; // For initial check
// ✅ NEW IMPORT: Notification Service
import 'services/notification_service.dart';
import 'services/ad_service.dart';

// IMPORTANT: Yeh imports ab aapki real screens ko point karne chahiye
import 'screens/repeated_tasks_list.dart'; // Real screen import
import 'screens/compact_calendar_view.dart'; // Real screen import
import 'screens/completed_tasks_archive.dart'; // Completed tasks archive screen

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
  
  // 3. Initialize AdMob (test IDs in AdService)
  await AdService().initialize();

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
            return const TaskManagerShell();
          } else {
            return const OnboardingFlow();
          }
        }

        return const _BrandSplashScreen();
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
            theme: AppTheme.getTheme(
              themeProvider.accentColor,
              Brightness.light,
            ),
            darkTheme: AppTheme.getTheme(
              themeProvider.accentColor,
              Brightness.dark,
            ),
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
        },
      ),
    );
  }
}

class _BrandSplashScreen extends StatefulWidget {
  const _BrandSplashScreen();

  @override
  State<_BrandSplashScreen> createState() => _BrandSplashScreenState();
}

class _BrandSplashScreenState extends State<_BrandSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = Curves.easeOutBack.transform(_controller.value);
              final opacity = Curves.easeIn.transform(_controller.value.clamp(0, 1));
              return Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: 0.85 + (progress * 0.15),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: accentGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentGreen.withOpacity(0.2),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      'assets/branding/task_manager_logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.task_alt,
                          size: 68,
                          color: accentGreen,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Task Manager',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Plan • Focus • Achieve',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
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
  late final PageController _pageController;

  // Placeholder screens for all four bottom navigation tabs
  final List<Widget> _screens = [
    const TodayTasksScreen(), // Index 0: Today (Home)
    const RepeatedTasksListScreen(), // Index 1: Tasks (Repeated Tasks)
    const CompactCalendarView(), // Index 2: Calendar
    const CompletedTasksArchive(), // Index 3: Completed / Archive
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    // Show interstitial ad after 3 seconds of app open
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    // NOTE: accentColor ko themeProvider mein define kiya hua hona zaroori hai
    final accentColor = themeProvider.accentColor;

    // Theme.of(context).scaffoldBackgroundColor ab theme mode ke mutabik badlega
    final primaryBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity < -200) {
            _goToPage(_currentIndex + 1);
          } else if (velocity > 200) {
            _goToPage(_currentIndex - 1);
          }
        },
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            if (_currentIndex != index) {
              setState(() => _currentIndex = index);
            }
          },
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _goToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        // Background color ab theme se aayega, lekin yahan bhi set kiya gaya hai
        backgroundColor: primaryBg,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archive',
          ),
        ],
      ),
    );
  }

  void _goToPage(int index) {
    if (index < 0 || index >= _screens.length) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
}

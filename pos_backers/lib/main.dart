import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/connectivity_service.dart';
import 'core/services/offline_queue_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/supabase_service.dart';
import 'core/services/local_database_service.dart';
import 'core/services/sync_service.dart';
import 'core/services/google_drive_service.dart';
import 'core/theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/products_screen.dart';
import 'screens/pos_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/customers_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Explicitly load the .env asset for mobile builds
    await dotenv.load(fileName: '.env');
    await Hive.initFlutter();
    await SupabaseService.instance.init();
    await ConnectivityService.instance.init();
    await OfflineQueueService.instance.init();
    
    // Initialize offline database and sync
    await LocalDatabaseService.instance.database; // Initialize DB
    await GoogleDriveService.instance.initialize();
    SyncService.instance.startAutoSync(); // Start auto-sync on connectivity changes
  } catch (e) {
    print('Initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
    SettingsService.instance.loadRole().catchError((e) => print('Role load error: $e'));
  }

  Future<void> _loadTheme() async {
    await SettingsService.instance.loadThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/dashboard', builder: (context, state) => const MainShell()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        GoRoute(path: '/customers', builder: (context, state) => const CustomersScreen()),
      ],
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsService.instance.themeMode,
      builder: (_, mode, __) => MaterialApp.router(
        title: 'Bread Box',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        darkTheme: ThemeData.dark(useMaterial3: false),
        themeMode: mode,
        routerConfig: router,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    ProductsScreen(),
    PosScreen(),
    InventoryScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (value) => setState(() => _index = value),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: 'POS'),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Reports'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/counter_screen.dart';
import 'widgets/premium_app_background.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF071A17),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const DigitalTasbeehApp());
}

class DigitalTasbeehApp extends StatelessWidget {
  const DigitalTasbeehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Tasbeeh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4ADE80),
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'System',
      ),
      // Wrap every route with the premium background (gradient + glow + pattern)
      builder: (context, child) => PremiumAppBackground(child: child!),
      home: const SplashScreen(),
    );
  }
}

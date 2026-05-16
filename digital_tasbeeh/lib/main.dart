import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/counter_screen.dart';
import 'widgets/premium_app_background.dart';
import 'providers/app_settings_provider.dart';

// Global singleton instance
final AppSettingsProvider appSettingsProvider = AppSettingsProvider();

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
    return AnimatedBuilder(
      animation: appSettingsProvider,
      builder: (context, child) {
        // Build with localizations and theme directions (if we wanted RTL support, we'd add it here)
        // We will just use standard MaterialApp and apply the language to our custom loc class
        return MaterialApp(
          title: 'Digital Tasbeeh',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF4ADE80),
            scaffoldBackgroundColor: Colors.transparent,
            fontFamily: 'System',
          ),
          // Directionality for Urdu is RTL, but for a simple app we might just keep LTR
          // or properly apply Directionality depending on language
          builder: (context, child) => Directionality(
            textDirection: appSettingsProvider.language == 'urdu' ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

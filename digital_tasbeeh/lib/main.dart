import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/counter_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A2F2F),
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
        scaffoldBackgroundColor: const Color(0xFF1A2F2F),
        fontFamily: 'System',
      ),
      home: const CounterScreen(),
    );
  }
}

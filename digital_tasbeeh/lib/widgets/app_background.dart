import 'package:flutter/material.dart';

/// Wraps any widget with the app's premium dark green gradient background.
/// Used globally via MaterialApp.builder so every route gets it automatically.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF071A17), // deep dark green (top)
            Color(0xFF0B2E2A), // slightly lighter green (bottom)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

class ExportSuccessScreen extends StatelessWidget {
  const ExportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 1: Theme colors ko context se lein
    final theme = Theme.of(context);
    final Color accentColor = theme.colorScheme.secondary;
    final Color textColor = theme.colorScheme.onBackground;
    final Color surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      // FIX 2: Background color theme se set kiya gaya
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // Success screen par back button nahi hona chahiye
        automaticallyImplyLeading: false,
        title: const Text('Export Confirmation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // MainAxisAlignment.center ki jagah MainAxisAlignment.start use karein
            children: [
              // ✅ Success Icon
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor, // ✅ ACCENT COLOR FIX
                ),
                padding: const EdgeInsets.all(20),
                // FIX: Icon color ko theme.colorScheme.onSecondary (jo text color hai) se set kiya gaya
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Export Complete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ), // ✅ TEXT COLOR FIX
              ),
              const SizedBox(height: 10),
              Text(
                "Your task data has been successfully exported and is ready to share.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                ), // ✅ TEXT COLOR FIX
              ),
              const SizedBox(height: 40),

              // Filename and Size Block
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor, // ✅ SURFACE COLOR FIX
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filename',
                      style: TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ), // ✅ TEXT COLOR FIX
                    Text(
                      'tasks-export.csv',
                      style: TextStyle(color: accentColor),
                    ), // ✅ ACCENT COLOR FIX
                  ],
                ),
              ),
              const SizedBox(height: 30), // Spacing badhaya
              // --- Share Button (Width Fix) ---
              // ✅ FIX 3: Button ko SizedBox mein wrap kiya gaya for full width
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement actual sharing logic here.
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    ); // Go back to home
                  },
                  child: const Text('Share Data'),
                ),
              ),
              const SizedBox(height: 10),

              // --- Close Button ---
              TextButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  ); // Go back to home
                },
                child: Text(
                  'Close',
                  style: TextStyle(color: accentColor),
                ), // ✅ ACCENT COLOR FIX
              ),
            ],
          ),
        ),
      ),
    );
  }
}

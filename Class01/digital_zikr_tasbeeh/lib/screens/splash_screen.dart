// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import '../main.dart'; // For kPrimaryGreen
import 'zikar_categories_screen.dart'; // Next Screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: You need to add 'image/splash_image.png' (splash_image.png)
    // and include it in pubspec.yaml

    return Scaffold(
      body: Container(
        // Use an image as a background or centered large image here
        decoration: const BoxDecoration(
          // For simplicity, using a solid color matching the dark part of the image
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Placeholder for your image (unnamed (3).png)
            Center(
              child: Image.asset(
                'image/splash_image.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ZikarCategoriesScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen, // Use the app's green theme
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

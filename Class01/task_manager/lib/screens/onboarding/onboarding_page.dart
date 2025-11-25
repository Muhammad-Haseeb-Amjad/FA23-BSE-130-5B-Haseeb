import 'package:flutter/material.dart';
import '../../theme.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget illustration;
  final Widget?
  extraWidget; // For the notification permission button on the last screen
  final String buttonText;
  final VoidCallback onNext;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    required this.buttonText,
    required this.onNext,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          // Placeholder for Illustration (You can replace this with Lottie/SVG later)
          SizedBox(height: 200, child: illustration),
          const SizedBox(height: 40),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textLight,
            ),
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: textLight.withOpacity(0.8)),
          ),

          if (extraWidget != null) ...[
            const SizedBox(height: 30),
            extraWidget!,
          ],

          const Spacer(),

          // Next/Get Started Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: onNext, child: Text(buttonText)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

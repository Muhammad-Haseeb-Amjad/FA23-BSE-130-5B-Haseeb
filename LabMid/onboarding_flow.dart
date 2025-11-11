import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
// FIX 1: main.dart se TaskManagerShell ko import karein
import '../../main.dart'; // Is file mein TaskManagerShell class hai
import 'onboarding_page.dart';
import '../today_tasks_screen.dart';


class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Function to mark onboarding as complete and navigate to main app
  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (mounted) {
      // FIX 2: pushReplacement use karke seedha TaskManagerShell par navigate karein.
      Navigator.of(context).pushReplacement(
        // TaskManagerShell mein hi BottomNavigationBar define kiya gaya hai.
        MaterialPageRoute(builder: (_) => const TaskManagerShell()),
      );
    }
  }

  // Placeholder for requesting notification permission
  void _requestNotificationPermission() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification Permission Requested (Mock)'),
        backgroundColor: accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: 'primaryDark' and 'accentGreen' are assumed to be defined in '../../theme.dart'
    return Scaffold(
      backgroundColor: primaryDark,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // 1. Onboarding - Add Tasks
              OnboardingPage(
                title: 'Simple Task Management',
                description: 'Quickly add and manage your daily tasks. Use quick actions to stay productive.',
                illustration: const Icon(Icons.list_alt, size: 120, color: accentGreen),
                buttonText: 'Next',
                onNext: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                ),
              ),

              // 2. Onboarding - Repeating Tasks
              OnboardingPage(
                title: 'Never Miss a Habit',
                description: 'Set custom repeating schedules for your habits and recurring tasks (daily, weekly, custom).',
                illustration: const Icon(Icons.repeat, size: 120, color: priorityMedium),
                buttonText: 'Next',
                onNext: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                ),
              ),

              // 3. Onboarding - Progress & Export
              OnboardingPage(
                title: 'Track Progress & Share Data',
                description: 'Visualize your progress with subtasks and easily export your data in CSV or PDF format.',
                illustration: const Icon(Icons.bar_chart, size: 120, color: priorityHigh),
                buttonText: 'Get Started',
                extraWidget: ElevatedButton.icon(
                  onPressed: _requestNotificationPermission,
                  icon: const Icon(Icons.notifications_active_outlined, color: primaryDark),
                  label: const Text('Request Notifications'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Custom color for CTA
                    foregroundColor: primaryDark,
                  ),
                ),
                onNext: _finishOnboarding,
              ),
            ],
          ),

          // Dots Indicator
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0), // Adjust top padding as needed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => _buildDot(index)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? accentGreen : textLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
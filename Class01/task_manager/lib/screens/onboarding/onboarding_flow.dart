import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme.dart';
// FIX 1: main.dart se TaskManagerShell ko import karein
import '../../main.dart'; // Is file mein TaskManagerShell class hai
import '../../services/notification_service.dart';
import 'onboarding_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with WidgetsBindingObserver {
  void _showSnack(String message, {bool success = true}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success
            ? theme.colorScheme.secondary
            : theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ NEW: App lifecycle listener - settings se wapas aane par permission check karega
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAfterReturn();
    }
  }

  // ✅ NEW: Settings se wapas aane par permission check karega
  Future<void> _checkPermissionAfterReturn() async {
    final notificationService = NotificationService();
    final isGranted = await notificationService
        .isNotificationPermissionGranted();

    if (mounted && isGranted) {
      _showSnack(
        'Notification permission enabled! You will now receive task reminders.',
      );
    }
  }

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

  // ✅ FIX: Actual notification permission request - system dialog show karne ke liye
  Future<void> _requestNotificationPermission() async {
    final notificationService = NotificationService();

    // Pehle check karein ki permission already granted hai ya nahi
    final alreadyGranted = await notificationService
        .isNotificationPermissionGranted();
    if (alreadyGranted) {
      if (mounted) {
        _showSnack('Notification permission is already enabled!');
      }
      return;
    }

    // ✅ CRITICAL: Pehle permission status check karein
    final currentStatus = await Permission.notification.status;

    if (currentStatus.isPermanentlyDenied) {
      // Show dialog to open settings (user has permanently denied)
      if (mounted) {
        _showSettingsDialog(
          context: context,
          title: 'Enable Notifications',
          message:
              'Notification permission was previously denied. Please enable it in app settings.',
          onOpenSettings: () => notificationService.openNotificationSettings(),
        );
      }
      return;
    }

    final decision = await _showPermissionPrompt();
    if (decision != true) {
      if (mounted) {
        _showSnack('Permission request cancelled.', success: false);
      }
      return;
    }

    // ✅ Notification permission request karein (system dialog show hoga agar allowed ho)
    final isGranted =
        await notificationService.requestNotificationPermission();
    await Future.delayed(const Duration(milliseconds: 400));
    final statusAfter =
        await notificationService.getNotificationPermissionStatus(
      delay: const Duration(milliseconds: 200),
    );
    final finalGranted =
        await notificationService.isNotificationPermissionGranted();
    final confirmedGranted = isGranted ||
        notificationService.isPermissionStatusGranted(statusAfter) ||
        finalGranted;

    if (mounted) {
      if (confirmedGranted) {
        // ✅ Battery optimization bhi request karein (better notification delivery ke liye)
        final isBatteryOptimized = await notificationService
            .isBatteryOptimizationIgnored();
        if (!isBatteryOptimized) {
          // Show dialog for battery optimization
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Optimize for Notifications'),
              content: const Text(
                'For reliable task reminders, please disable battery optimization for this app. '
                'This ensures notifications work even when the app is in background.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final batteryGranted = await notificationService
                        .requestIgnoreBatteryOptimization();
                    if (mounted) {
                      if (batteryGranted) {
                        _showSnack(
                          'Battery optimization disabled! Notifications will work reliably.',
                        );
                      } else {
                        await notificationService
                            .openBatteryOptimizationSettings();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: const Text('Disable Optimization'),
                ),
              ],
            ),
          );
        }

        _showSnack(
          'Notification permission granted! You will receive reminders for your tasks.',
        );

        // ✅ Additional permissions (audio/photos/storage) for full experience
        await notificationService.requestMediaPermissions();
      } else {
        // Agar request ke baad bhi denied ho, toh check karein permanently denied hai ya nahi
        final isPermanentlyDeniedAfter =
            statusAfter.isPermanentlyDenied ||
                await notificationService.isPermissionPermanentlyDenied();

        if (isPermanentlyDeniedAfter) {
          _showSettingsDialog(
            context: context,
            title: 'Enable Notifications',
            message:
                'Notification permission is required to send task reminders. Please enable it in app settings.',
            onOpenSettings: () =>
                notificationService.openNotificationSettings(),
          );
        } else {
          _showSnack(
            'Permission denied. Please tap again and allow notifications when prompted.',
            success: false,
          );
        }
      }
    }
  }

  Future<bool?> _showPermissionPrompt() {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final textColor = theme.colorScheme.onSurface;

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Allow reminders & media access?',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.notifications_active, color: accent),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'To send timely reminders and let you pick custom sounds or attachments, we need access to the following permissions:',
                style: TextStyle(color: textColor.withOpacity(0.7)),
              ),
              const SizedBox(height: 12),
              _PermissionTile(
                icon: Icons.notifications_active_outlined,
                title: 'Notifications',
                subtitle: 'Send task reminders and updates.',
                accent: accent,
                textColor: textColor,
              ),
              _PermissionTile(
                icon: Icons.music_note_outlined,
                title: 'Audio',
                subtitle: 'Let you choose custom reminder sounds.',
                accent: accent,
                textColor: textColor,
              ),
              _PermissionTile(
                icon: Icons.photo_library_outlined,
                title: 'Photos & media',
                subtitle: 'Attach images to tasks and share exports.',
                accent: accent,
                textColor: textColor,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Not now',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: theme.brightness == Brightness.dark
                            ? primaryDark
                            : theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Allow'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Future<bool> Function() onOpenSettings,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final opened = await onOpenSettings();
              if (!opened && mounted) {
                _showSnack(
                  'Could not open settings. Please enable permissions manually.',
                  success: false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: const Text('Open Settings'),
          ),
        ],
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
                description:
                    'Quickly add and manage your daily tasks. Use quick actions to stay productive.',
                illustration: const Icon(
                  Icons.list_alt,
                  size: 120,
                  color: accentGreen,
                ),
                buttonText: 'Next',
                onNext: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                ),
              ),

              // 2. Onboarding - Repeating Tasks
              OnboardingPage(
                title: 'Never Miss a Habit',
                description:
                    'Set custom repeating schedules for your habits and recurring tasks (daily, weekly, custom).',
                illustration: const Icon(
                  Icons.repeat,
                  size: 120,
                  color: priorityMedium,
                ),
                buttonText: 'Next',
                onNext: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                ),
              ),

              // 3. Onboarding - Progress & Export
              OnboardingPage(
                title: 'Track Progress & Share Data',
                description:
                    'Visualize your progress with subtasks and easily export your data in CSV or PDF format.',
                illustration: const Icon(
                  Icons.bar_chart,
                  size: 120,
                  color: priorityHigh,
                ),
                buttonText: 'Get Started',
                extraWidget: ElevatedButton.icon(
                  onPressed: _requestNotificationPermission,
                  icon: const Icon(
                    Icons.notifications_active_outlined,
                    color: primaryDark,
                  ),
                  label: const Text('Permission Notifications'),
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
              padding: const EdgeInsets.only(
                top: 60.0,
              ), // Adjust top padding as needed
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

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Color textColor;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: accent.withOpacity(0.15),
        child: Icon(icon, color: accent),
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor.withOpacity(0.6)),
      ),
    );
  }
}

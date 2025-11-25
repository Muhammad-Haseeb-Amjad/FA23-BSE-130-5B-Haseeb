// lib/screens/main_counter_screen.dart

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../models/zikar_model.dart';
import 'zikar_list_screen.dart';
import 'settings_screen.dart';

class MainCounterScreen extends StatefulWidget {
  final ZikarModel? initialZikar;

  const MainCounterScreen({super.key, this.initialZikar});

  @override
  State<MainCounterScreen> createState() => _MainCounterScreenState();
}

class _MainCounterScreenState extends State<MainCounterScreen> {
  int _counter = 0;
  ZikarModel? _currentZikar;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundOn = true;
  bool _isVibrationOn = true;

  @override
  void initState() {
    super.initState();
    _currentZikar = widget.initialZikar ?? ZikarModel(name: 'General Zikr', count: 0);
    _loadSettingsAndCount();
  }

  // Load settings (sound, vibration) and current count
  Future<void> _loadSettingsAndCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundOn = prefs.getBool('isSoundOn') ?? true;
      _isVibrationOn = prefs.getBool('isVibrationOn') ?? true;
      // Load general zikar count if no specific zikar is loaded
      if (_currentZikar!.id == null) {
        _counter = prefs.getInt('generalCount') ?? 0;
        _currentZikar = _currentZikar!.copyWith(count: _counter);
      } else {
        _counter = _currentZikar!.count;
      }
    });
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    // Play sound and vibrate based on settings
    if (_isSoundOn) {
      // You need to add a short sound file (e.g., 'image/tap_sound.mp3')
      _audioPlayer.play(AssetSource('tap_sound.mp3'));
    }
    if (_isVibrationOn && await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 50);
    }

    // Save general count immediately for persistence (if not a saved zikar)
    if (_currentZikar!.id == null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('generalCount', _counter);
    }
  }

  void _resetCounter() async {
    setState(() {
      _counter = 0;
    });

    // Reset saved count as well
    if (_currentZikar!.id != null) {
      _currentZikar!.count = 0;
      // Update in database (implementation required)
      // await DatabaseHelper.instance.updateZikar(_currentZikar!);
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('generalCount', 0);
    }
  }

  void _toggleSound() async {
    setState(() {
      _isSoundOn = !_isSoundOn;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSoundOn', _isSoundOn);
  }

  void _toggleVibration() async {
    setState(() {
      _isVibrationOn = !_isVibrationOn;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isVibrationOn', _isVibrationOn);
  }

  void _rateApp() async {
    const url = 'https://play.google.com/store/apps/details?id=your.package.name';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open app store link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ZikarListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentPurple, // Purple/Accent Color for contrast
              ),
              child: const Text('Zikr List'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Zikar Name (Arabic) Display
            if (_currentZikar!.arabicText != null &&
                _currentZikar!.arabicText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  _currentZikar!.arabicText!,
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryGreen,
                      fontFamily: 'ArabicFont'), // Add an Arabic Font asset
                ),
              ),

            // Zikar Counter (The Digital Tasbeeh Image Area)
            Stack(
              alignment: Alignment.center,
              children: [
                // Placeholder for your tasbeeh image (unnamed (2).png)
                Image.asset(
                  'image/tasbeeh_dial.png', // Replace with your image path
                  width: 280,
                  color: Colors.black, // Color overlay to match the original image
                ),

                // Counter Display
                Positioned(
                  top: 50, // Adjust position to match the image
                  child: Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent.shade100, // Light blue color for the display
                    ),
                  ),
                ),

                // Tap Button (Large Central Circle)
                Positioned(
                  bottom: 55, // Adjust position
                  child: GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: kPrimaryGreen, // Primary Counter button in Green
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Center(
                        child: Text(
                          'TAP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),

                // Repeat/Reset Button
                Positioned(
                  right: 50, // Adjust position
                  bottom: 120,
                  child: IconButton(
                    onPressed: _resetCounter,
                    icon: const Icon(Icons.refresh, color: kPrimaryGreen, size: 30),
                  ),
                ),

                // Save Button (The other icon near reset in the image is for reset, we'll use a standard save icon)
                Positioned(
                  left: 50, // Adjust position
                  bottom: 120,
                  child: IconButton(
                    onPressed: () {
                      // Navigate to Save Screen
                      // Note: This needs to handle saving the CURRENT ZIKAR COUNT
                      // and then navigating to the Save Details screen if it's a new zikar.
                    },
                    icon: const Icon(Icons.save, color: kPrimaryGreen, size: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Star Button (Rate App)
            IconButton(
              onPressed: _rateApp,
              icon: const Icon(Icons.star, color: kAccentPurple),
            ),

            // Volume/Sound Toggle
            IconButton(
              onPressed: _toggleSound,
              icon: Icon(
                  _isSoundOn ? Icons.volume_up : Icons.volume_off,
                  color: _isSoundOn ? kAccentPurple : Colors.grey),
            ),

            // Vibration Toggle
            IconButton(
              onPressed: _toggleVibration,
              icon: Icon(
                  _isVibrationOn ? Icons.vibration : Icons.close,
                  color: _isVibrationOn ? kAccentPurple : Colors.grey),
            ),

            // Theme Button (Navigates to Theme Screen)
            IconButton(
              onPressed: () {
                // Navigate to Theme Screen
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemeScreen()));
              },
              icon: const Icon(Icons.palette, color: kAccentPurple),
            ),

            // Settings Button (Navigates to Settings Screen)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              icon: const Icon(Icons.settings, color: kAccentPurple),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple extension to help with ZikarModel updates
extension ZikarModelExtension on ZikarModel {
  ZikarModel copyWith({
    int? id,
    String? name,
    String? arabicText,
    int? count,
    int? targetCount,
    String? reminderTime,
    String? reminderDays,
  }) {
    return ZikarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicText: arabicText ?? this.arabicText,
      count: count ?? this.count,
      targetCount: targetCount ?? this.targetCount,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }
}
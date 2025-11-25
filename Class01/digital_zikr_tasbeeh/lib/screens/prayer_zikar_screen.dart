// lib/screens/prayer_zikar_screen.dart

import 'package:flutter/material.dart';
import '../main.dart';

// Data for Zikr after Salah (Fard prayers)
final List<Map<String, dynamic>> prayerZikarSteps = [
  {'name': 'SubhanAllah', 'arabic': 'سُبْحَانَ ٱللَّٰهِ', 'target': 33},
  {'name': 'Alhamdulillah', 'arabic': 'ٱلْحَمْدُ لِلَّٰهِ', 'target': 33},
  {'name': 'Allahu Akbar', 'arabic': 'ٱللَّٰهُ أَكْبَرُ', 'target': 34},
];

class PrayerZikarScreen extends StatefulWidget {
  const PrayerZikarScreen({super.key});

  @override
  State<PrayerZikarScreen> createState() => _PrayerZikarScreenState();
}

class _PrayerZikarScreenState extends State<PrayerZikarScreen> {
  int _currentStep = 0;
  int _currentCount = 0;

  void _incrementCounter() {
    if (_currentStep >= prayerZikarSteps.length) return; // Zikr complete

    setState(() {
      _currentCount++;
      // Agar target pura ho gaya to agle step par chale jayenge
      if (_currentCount >= prayerZikarSteps[_currentStep]['target']) {
        _nextStep();
      }
      // TODO: Sound and Vibration feedback yahan bhi add karein
    });
  }

  void _nextStep() {
    if (_currentStep < prayerZikarSteps.length) {
      _currentStep++;
      _currentCount = 0; // Reset count for the next Zikr
      if (_currentStep == prayerZikarSteps.length) {
        // Zikr complete message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alhamdulillah! All Zikr steps completed.')),
        );
      }
    }
  }

  void _resetZikar() {
    setState(() {
      _currentStep = 0;
      _currentCount = 0;
    });
  }

  void _completeCurrentZikar() {
    setState(() {
      _currentCount = prayerZikarSteps[_currentStep]['target']; // Force to target
      _nextStep();
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_currentStep >= prayerZikarSteps.length) {
      // Screen when Zikr is complete
      return Scaffold(
        appBar: AppBar(title: const Text('Prayer Zikr'), backgroundColor: kPrimaryGreen),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('All Prayer Zikr Complete!', style: TextStyle(fontSize: 22, color: kPrimaryGreen)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _resetZikar, child: const Text('Start Again')),
            ],
          ),
        ),
      );
    }

    final currentZikr = prayerZikarSteps[_currentStep];
    final target = currentZikr['target'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Zikr'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Step ${_currentStep + 1} of ${prayerZikarSteps.length}', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
            const SizedBox(height: 10),

            // Arabic Text
            Text(
              currentZikr['arabic'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: kPrimaryGreen),
            ),

            // Zikr Name
            Text(currentZikr['name'], style: TextStyle(fontSize: 24, color: Colors.grey.shade800)),
            const SizedBox(height: 40),

            // Counter Display
            Text(
              '$_currentCount / $target',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: kAccentPurple),
            ),
            const SizedBox(height: 40),

            // Main Tap Button
            GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: kPrimaryGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: kPrimaryGreen.withOpacity(0.5), blurRadius: 10),
                  ],
                ),
                child: Center(
                  child: Text(
                    'TAP',
                    style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Reset and Skip/Complete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _resetZikar,
                  icon: const Icon(Icons.refresh, color: Colors.red),
                  label: const Text('Reset All', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 30),
                TextButton.icon(
                  onPressed: _completeCurrentZikar,
                  icon: const Icon(Icons.check, color: kAccentPurple),
                  label: const Text('Complete Step', style: TextStyle(color: kAccentPurple)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
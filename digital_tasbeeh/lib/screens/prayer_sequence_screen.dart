import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/dhikr.dart';
import '../services/storage_service.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../widgets/premium_app_background.dart';

class PrayerSequenceScreen extends StatefulWidget {
  const PrayerSequenceScreen({super.key});

  @override
  State<PrayerSequenceScreen> createState() => _PrayerSequenceScreenState();
}

class _PrayerSequenceScreenState extends State<PrayerSequenceScreen> {
  final StorageService _storage = StorageService();
  AudioPlayer? _audioPlayer;
  List<Dhikr> _sequence = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSequence();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _loadSequence() async {
    // Create prayer sequence with fresh counts (independent from My Dhikrs)
    final sequenceDhikrs = [
      Dhikr(
        id: 's1',
        name: 'SubhanAllah',
        description: 'Glory be to Allah',
        currentCount: 0,
        targetCount: 33,
        hasTarget: true,
      ),
      Dhikr(
        id: 's2',
        name: 'Alhamdulillah',
        description: 'All praise is due to Allah',
        currentCount: 0,
        targetCount: 33,
        hasTarget: true,
      ),
      Dhikr(
        id: 's3',
        name: 'Allahu Akbar',
        description: 'Allah is the Greatest',
        currentCount: 0,
        targetCount: 34,
        hasTarget: true,
      ),
    ];

    setState(() {
      _sequence = sequenceDhikrs;
      _isLoading = false;
    });
  }

  void _incrementCount() async {
    if (_currentIndex >= _sequence.length) return;
    
    // Don't increment if already at target
    if (_sequence[_currentIndex].currentCount >= (_sequence[_currentIndex].targetCount ?? 0)) {
      return;
    }

    setState(() {
      _sequence[_currentIndex].currentCount++;
    });

    // Haptics and feedback
    if (appSettingsProvider.vibration) {
      Vibration.vibrate(duration: 50);
    }
    if (!appSettingsProvider.mute) {
      // Play sound when mute is OFF
      await _playClickSound();
    }

    // Check if current dhikr is complete
    if (_sequence[_currentIndex].currentCount >=
        (_sequence[_currentIndex].targetCount ?? 0)) {
      _sequence[_currentIndex].isCompleted = true;

      // Move to next if not last
      if (_currentIndex < _sequence.length - 1) {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _currentIndex++;
        });
      }
    }
  }

  void _nextDhikr() {
    if (_currentIndex < _sequence.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  Future<void> _playClickSound() async {
    try {
      final player = _audioPlayer ??= AudioPlayer();
      await player.play(
        AssetSource('click.wav'),
        mode: PlayerMode.mediaPlayer,
        volume: 1.0,
      ).timeout(const Duration(seconds: 2));
    } catch (e) {
      // Ignore audio error
    }
  }

  String _getArabicText(String name) {
    switch (name.toLowerCase()) {
      case 'subhanallah':
        return 'سُبْحَانَ اللّهِ';
      case 'alhamdulillah':
        return 'الْحَمْدُ لِلّهِ';
      case 'allahu akbar':
        return 'اللّهُ أَكْبَرُ';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const PremiumAppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF4ADE80)),
          ),
        ),
      );
    }

    if (_sequence.isEmpty) {
      return PremiumAppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppLocalizations.of(context).translate('prayer_sequence').toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Text(
            'No dhikrs with targets found',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        ),
      );
    }

    final currentDhikr = _sequence[_currentIndex];
    final progress =
        currentDhikr.currentCount / (currentDhikr.targetCount ?? 1);

    final l10n = AppLocalizations.of(context);

    return PremiumAppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(progress, l10n),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (() {
                      final arabic = _getArabicText(currentDhikr.name);
                      if (arabic.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        arabic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.rtl,
                      );
                    }()),
                    const SizedBox(height: 20),
                    Text(
                      currentDhikr.name,
                      style: const TextStyle(
                        color: Color(0xFF4ADE80),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentDhikr.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 60),
                    _buildCounter(currentDhikr, progress),
                  ],
                ),
              ),
            ),
            _buildBottomButton(l10n),
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(double progress, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  l10n.translate('prayer_sequence'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Step ${_currentIndex + 1} of ${_sequence.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}% ${l10n.translate('completed')}',
                style: const TextStyle(
                  color: Color(0xFF4ADE80),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4ADE80)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(Dhikr dhikr, double progress) {
    return GestureDetector(
      onTap: _incrementCount,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF2D4D4D),
              color: const Color(0xFF4ADE80),
              strokeWidth: 8,
            ),
          ),
          Column(
            children: [
              Text(
                dhikr.currentCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Target: ${dhikr.targetCount}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(AppLocalizations l10n) {
    final isLastStep = _currentIndex >= _sequence.length - 1;
    final isCompleted =
        _sequence[_currentIndex].currentCount >=
        (_sequence[_currentIndex].targetCount ?? 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isCompleted
              ? (isLastStep ? () => Navigator.pop(context) : _nextDhikr)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ADE80),
            foregroundColor: const Color(0xFF1A2F2F),
            disabledBackgroundColor: Colors.white.withOpacity(0.1),
            disabledForegroundColor: Colors.white.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCompleted) const Icon(Icons.check, size: 24),
              const SizedBox(width: 10),
              Text(
                isCompleted
                    ? (isLastStep
                          ? l10n.translate('finish')
                          : 'Next: ${_sequence[_currentIndex + 1].name}')
                    : l10n.translate('continue_text'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isCompleted && !isLastStep)
                const Icon(Icons.arrow_forward, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

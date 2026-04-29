import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import '../models/dhikr.dart';
import '../services/storage_service.dart';
import 'my_dhikrs_screen.dart';
import 'prayer_sequence_screen.dart';
import 'settings_screen.dart';

// Global flag to control test mode (suppress audio playback during tests)
bool isCounterScreenTestMode = false;

// For testing only — allows injecting a known _opaqueImageRect to expose coordinate-mapping bugs.
// Set this before pumping the widget in tests; clear it in tearDown.
Rect? counterScreenTestOpaqueRect;

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  static const bool _showDebugZones = false;
  static const Key _allahTapKey = Key('allah_tap_area');
  static const Key _saveTapKey = Key('save_tap_area');
  static const Key _replayTapKey = Key('replay_tap_area');
  static const Key _counterTextKey = Key('lcd_counter_text');

  static const String _primaryImageAsset = 'assets/images/tasbeeh.png';
  static const String _fallbackImageAsset = 'lib/assets/tasbeeh.png';

  static const double _saveCenterX = 0.313;
  static const double _saveCenterY = 0.496;
  static const double _replayCenterX = 0.684;
  static const double _replayCenterY = 0.496;
  static const double _saveReplayRadiusFactor = 0.066;
  static const double _allahCenterX = 0.511;
  static const double _allahCenterY = 0.754;
  static const double _allahRadiusFactor = 0.118;
  static const double _lcdCenterX = 0.506;
  static const double _lcdCenterY = 0.286;
  static const double _lcdWidthFactor = 0.43;
  static const double _lcdHeightFactor = 0.12;

  final StorageService _storage = StorageService();
  AudioPlayer? _audioPlayer;

  int _count = 0;
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;
  String _imageAssetPath = _primaryImageAsset;
  Rect _opaqueImageRect = const Rect.fromLTWH(0, 0, 1, 1);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedCount = await _storage.getTasbeehCount();
    final loadedSettings = await _storage.loadSettings();
    final resolvedAssetPath = await _resolveImageAssetPath();

    if (!mounted) return;
    setState(() {
      _count = loadedCount;
      _settings = loadedSettings;
      _imageAssetPath = resolvedAssetPath;
      _isLoading = false;
    });

    final computedRect = counterScreenTestOpaqueRect ?? await _computeOpaqueImageRect(resolvedAssetPath);

    if (!mounted) return;
    setState(() {
      _opaqueImageRect = computedRect;
    });
  }

  Future<String> _resolveImageAssetPath() async {
    try {
      await rootBundle.load(_primaryImageAsset);
      return _primaryImageAsset;
    } catch (_) {
      return _fallbackImageAsset;
    }
  }

  Future<Rect> _computeOpaqueImageRect(String assetPath) async {
    try {
      final bytes = await rootBundle.load(assetPath);
      final buffer = await ui.ImmutableBuffer.fromUint8List(
        bytes.buffer.asUint8List(),
      );
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final codec = await descriptor.instantiateCodec();
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (byteData == null) {
        return const Rect.fromLTWH(0, 0, 1, 1);
      }

      final data = byteData.buffer.asUint8List();
      final width = image.width;
      final height = image.height;

      int minX = width;
      int minY = height;
      int maxX = -1;
      int maxY = -1;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final alphaIndex = ((y * width) + x) * 4 + 3;
          if (data[alphaIndex] > 8) {
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
          }
        }
      }

      if (maxX < minX || maxY < minY) {
        return const Rect.fromLTWH(0, 0, 1, 1);
      }

      final left = minX / width;
      final top = minY / height;
      final right = (maxX + 1) / width;
      final bottom = (maxY + 1) / height;
      return Rect.fromLTRB(left, top, right, bottom);
    } catch (_) {
      return const Rect.fromLTWH(0, 0, 1, 1);
    }
  }

  double _mapContentX(double contentX) {
    return _opaqueImageRect.left + (_opaqueImageRect.width * contentX);
  }

  double _mapContentY(double contentY) {
    return _opaqueImageRect.top + (_opaqueImageRect.height * contentY);
  }

  double _mapContentWidth(double factor) {
    return _opaqueImageRect.width * factor;
  }

  double _mapContentHeight(double factor) {
    return _opaqueImageRect.height * factor;
  }

  Future<void> _saveCount() async {
    await _storage.setTasbeehCount(_count);
  }

  Future<void> _playClickSound() async {
    // Skip audio playback in test mode to avoid pending timers
    if (isCounterScreenTestMode) {
      return;
    }
    
    try {
      final player = _audioPlayer ??= AudioPlayer();
      await player.play(
        AssetSource('click.wav'),
        mode: PlayerMode.mediaPlayer,
        volume: 1.0,
      ).timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('Sound error: $e');
    }
  }

  Future<void> _incrementCount() async {
    setState(() {
      _count++;
    });

    if (_settings['vibration'] == true) {
      try {
        if (await Vibration.hasVibrator()) {
          await Vibration.vibrate(duration: 50);
        }
      } catch (e) {
        debugPrint('Vibration error: $e');
      }
    }

    if (_settings['mute'] != true) {
      await _playClickSound();
    }
  }

  Future<void> _resetCount() async {
    setState(() {
      _count = 0;
    });
    await _saveCount();
  }

  Future<void> _saveCurrentCount() async {
    await _saveCount();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Count saved'),
        backgroundColor: const Color(0xFF234141),
      ),
    );
  }

  Future<void> _confirmReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF234141),
        title: const Text(
          'Reset Count?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to reset the count to 0000?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset == true) {
      await _resetCount();
    }
  }

  Future<void> _openDhikrList() async {
    final result = await Navigator.push<Dhikr?>(
      context,
      MaterialPageRoute(builder: (context) => const MyDhikrsScreen()),
    );

    if (result == null || !mounted) return;

    setState(() {
      _count = result.currentCount;
    });
    await _storage.setCurrentDhikrId(result.id);
  }

  void _openPrayerDhikr() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrayerSequenceScreen()),
    );
  }

  void _navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
    if (!mounted) return;
    _settings = await _storage.loadSettings();
    setState(() {});
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A2F2F),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4ADE80)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A2F2F),
      drawer: _buildSideDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 20),
            _buildToggleButtons(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                    final widthBased = constraints.maxWidth * 0.92;
                    final heightBased = constraints.maxHeight * 0.92;
                  final imageSide = widthBased < heightBased
                      ? widthBased
                      : heightBased;

                  return Center(
                    child: SizedBox.square(
                      dimension: imageSide,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            _imageAssetPath,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            left: (imageSide * _mapContentX(_lcdCenterX)) -
                                (imageSide * _mapContentWidth(_lcdWidthFactor) / 2),
                            top: (imageSide * _mapContentY(_lcdCenterY)) -
                                (imageSide * _mapContentHeight(_lcdHeightFactor) / 2),
                            width: imageSide * _mapContentWidth(_lcdWidthFactor),
                            height: imageSide * _mapContentHeight(_lcdHeightFactor),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _formattedCount,
                                  key: _counterTextKey,
                                  style: TextStyle(
                                    color: Color(0xFF57FF7A),
                                    fontSize: imageSide * _mapContentWidth(0.075),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 5,
                                    fontFamily: 'monospace',
                                    shadows: const [
                                      Shadow(
                                        color: Color(0xAA1C7C39),
                                        blurRadius: 10,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _buildCenteredCircleTapZone(
                            key: _allahTapKey,
                            imageSide: imageSide,
                            centerX: _allahCenterX,
                            centerY: _allahCenterY,
                            radius: imageSide * _allahRadiusFactor,
                            onTap: _incrementCount,
                          ),
                          _buildCenteredCircleTapZone(
                            key: _saveTapKey,
                            imageSide: imageSide,
                            centerX: _saveCenterX,
                            centerY: _saveCenterY,
                            radius: imageSide * _saveReplayRadiusFactor,
                            onTap: _saveCurrentCount,
                          ),
                          _buildCenteredCircleTapZone(
                            key: _replayTapKey,
                            imageSide: imageSide,
                            centerX: _replayCenterX,
                            centerY: _replayCenterY,
                            radius: imageSide * _saveReplayRadiusFactor,
                            onTap: _confirmReset,
                          ),
                          if (_showDebugZones) ...[
                            _buildDebugCircle(
                              imageSide: imageSide,
                              centerX: _saveCenterX,
                              centerY: _saveCenterY,
                              radius: imageSide * _saveReplayRadiusFactor,
                              color: Colors.red,
                            ),
                            _buildDebugCircle(
                              imageSide: imageSide,
                              centerX: _replayCenterX,
                              centerY: _replayCenterY,
                              radius: imageSide * _saveReplayRadiusFactor,
                              color: Colors.blue,
                            ),
                            _buildDebugCircle(
                              imageSide: imageSide,
                              centerX: _allahCenterX,
                              centerY: _allahCenterY,
                              radius: imageSide * _allahRadiusFactor,
                              color: Colors.green,
                            ),
                            _buildDebugRect(
                              imageSide: imageSide,
                              centerX: _mapContentX(_lcdCenterX),
                              centerY: _mapContentY(_lcdCenterY),
                              width: imageSide * _mapContentWidth(_lcdWidthFactor),
                              height: imageSide * _mapContentHeight(_lcdHeightFactor),
                              color: Colors.yellow,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF8B7355).withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFF8B7355), width: 2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Colors.amber[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'No Ads',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1A2F2F),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.auto_awesome, color: Colors.white70),
              title: const Text('Prayer Dhikr', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _openPrayerDhikr();
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.white70),
              title: const Text('Dhikr List', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _openDhikrList();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white70),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _navigateToSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton(
          'Vibration',
          Icons.vibration,
          _settings['vibration'] == true,
        ),
        const SizedBox(width: 20),
        _buildToggleButton(
          'Mute',
          _settings['mute'] == true ? Icons.volume_off : Icons.volume_up,
          _settings['mute'] == true,
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () async {
        // Toggle behavior for vibration and mute buttons
        if (label.toLowerCase().contains('vibration')) {
          _settings['vibration'] = !(_settings['vibration'] == true);
        } else {
          // Mute toggle - consistent with vibration
          final newMuteState = !(_settings['mute'] == true);
          _settings['mute'] = newMuteState;
          // Play sound if mute is turned OFF
          if (newMuteState == false) {
            await _playClickSound();
          }
        }
        await _storage.saveSettings(_settings);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF4ADE80).withOpacity(0.20)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? const Color(0xFF4ADE80) : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? const Color(0xFF4ADE80) : Colors.white70, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF4ADE80) : Colors.white70,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredCircleTapZone({
    required Key key,
    required double imageSide,
    required double centerX,
    required double centerY,
    required double radius,
    required VoidCallback onTap,
  }) {
    final diameter = radius * 2;

    return Positioned(
      left: (imageSide * centerX) - radius,
      top: (imageSide * centerY) - radius,
      width: diameter,
      height: diameter,
      child: CircleTapTarget(
        key: key,
        onTap: onTap,
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildDebugCircle({
    required double imageSide,
    required double centerX,
    required double centerY,
    required double radius,
    required Color color,
  }) {
    final diameter = radius * 2;

    return Positioned(
      left: (imageSide * centerX) - radius,
      top: (imageSide * centerY) - radius,
      width: diameter,
      height: diameter,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.28),
            border: Border.all(color: color, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDebugRect({
    required double imageSide,
    required double centerX,
    required double centerY,
    required double width,
    required double height,
    required Color color,
  }) {
    return Positioned(
      left: (imageSide * centerX) - (width / 2),
      top: (imageSide * centerY) - (height / 2),
      width: width,
      height: height,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.22),
            border: Border.all(color: color, width: 2),
          ),
        ),
      ),
    );
  }

  String get _formattedCount => _count.toString().padLeft(4, '0');
}

class CircleTapTarget extends SingleChildRenderObjectWidget {
  final VoidCallback onTap;

  const CircleTapTarget({
    super.key,
    required this.onTap,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCircleTapTarget(onTap);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderObject renderObject,
  ) {
    (renderObject as _RenderCircleTapTarget).onTap = onTap;
  }
}

class _RenderCircleTapTarget extends RenderProxyBox {
  _RenderCircleTapTarget(this._onTap);

  VoidCallback _onTap;

  set onTap(VoidCallback value) {
    _onTap = value;
  }

  @override
  bool hitTestSelf(Offset position) {
    final radius = math.min(size.width, size.height) / 2;
    final center = size.center(Offset.zero);
    return (position - center).distance <= radius;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerUpEvent) {
      _onTap();
    }
  }
}

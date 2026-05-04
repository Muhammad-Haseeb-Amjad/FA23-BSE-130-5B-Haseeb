// Preservation Property Tests — Property 2
//
// These tests MUST PASS on both unfixed and fixed code.
// They establish that Save and Replay button positions are unchanged by the fix.
//
// Save/Replay buttons use raw (unmapped) constants — they are calibrated to the
// full imageSide coordinate space and must NOT be mapped through _mapContentX/Y.
//
// Validates: Requirements 3.1, 3.2, 3.3

import 'package:digital_tasbeeh/main.dart';
import 'package:digital_tasbeeh/screens/counter_screen.dart';
import 'package:digital_tasbeeh/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Same non-unit rect as in allah_tap_placement_test.dart
const _testOpaqueRect = Rect.fromLTRB(0.05, 0.03, 0.95, 0.97);

// Raw constants for Save and Replay (must NOT be mapped)
const double _saveCenterX = 0.313;
const double _saveCenterY = 0.496;
const double _replayCenterX = 0.684;
const double _replayCenterY = 0.496;
const double _saveReplayRadiusFactor = 0.066;

Future<void> _pumpAppWithSize(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const CounterScreen(),
    ),
  );
  for (int i = 0; i < 200; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    final menuReady = find.byIcon(Icons.menu).evaluate().isNotEmpty;
    final lcdReady = find.byKey(const Key('lcd_counter_text')).evaluate().isNotEmpty;
    if (menuReady && lcdReady) break;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    isCounterScreenTestMode = true;
    counterScreenTestOpaqueRect = _testOpaqueRect;
    StorageService.enableInMemoryBackendForTests();
    await StorageService().resetForTests();
  });

  tearDown(() {
    counterScreenTestOpaqueRect = null;
  });

  group('Preservation: Save and Replay button positions unchanged', () {
    // Representative screen sizes covering small phones to tablets
    final screenSizes = [
      const Size(360, 640),
      const Size(430, 932),
      const Size(540, 960),
      const Size(600, 1024),
      const Size(768, 1024),
      const Size(800, 1280),
    ];

    for (final screenSize in screenSizes) {
      testWidgets(
        'Save and Replay positions use raw constants on ${screenSize.width.toInt()}x${screenSize.height.toInt()}',
        (WidgetTester tester) async {
          await _pumpAppWithSize(tester, screenSize);

          final saveRect = tester.getRect(find.byKey(const Key('save_tap_area')));
          final replayRect = tester.getRect(find.byKey(const Key('replay_tap_area')));
          final stackRect = tester.getRect(find.byType(Stack).first);
          final imageSide = stackRect.width;

          // Save button — raw constants, no mapping
          final expectedSaveCX = imageSide * _saveCenterX;
          final expectedSaveCY = imageSide * _saveCenterY;
          final expectedSaveR = imageSide * _saveReplayRadiusFactor;

          final actualSaveCX = saveRect.center.dx - stackRect.left;
          final actualSaveCY = saveRect.center.dy - stackRect.top;
          final actualSaveR = saveRect.width / 2;

          expect(actualSaveCX, closeTo(expectedSaveCX, 1.0),
              reason: 'save_tap_area center X must equal imageSide * $_saveCenterX');
          expect(actualSaveCY, closeTo(expectedSaveCY, 1.0),
              reason: 'save_tap_area center Y must equal imageSide * $_saveCenterY');
          expect(actualSaveR, closeTo(expectedSaveR, 1.0),
              reason: 'save_tap_area radius must equal imageSide * $_saveReplayRadiusFactor');

          // Replay button — raw constants, no mapping
          final expectedReplayCX = imageSide * _replayCenterX;
          final expectedReplayCY = imageSide * _replayCenterY;
          final expectedReplayR = imageSide * _saveReplayRadiusFactor;

          final actualReplayCX = replayRect.center.dx - stackRect.left;
          final actualReplayCY = replayRect.center.dy - stackRect.top;
          final actualReplayR = replayRect.width / 2;

          expect(actualReplayCX, closeTo(expectedReplayCX, 1.0),
              reason: 'replay_tap_area center X must equal imageSide * $_replayCenterX');
          expect(actualReplayCY, closeTo(expectedReplayCY, 1.0),
              reason: 'replay_tap_area center Y must equal imageSide * $_replayCenterY');
          expect(actualReplayR, closeTo(expectedReplayR, 1.0),
              reason: 'replay_tap_area radius must equal imageSide * $_saveReplayRadiusFactor');
        },
      );
    }
  });
}

// Allah Tap Area Placement Tests
//
// These tests verify that the allah_tap_area transparent button is positioned
// at the correct location matching the visible Allah circle in the image.
//
// The constants _allahCenterX, _allahCenterY, _allahRadiusFactor are calibrated
// as fractions of imageSide (the full square container side), consistent with
// how Save and Replay button constants are calibrated.
//
// Validates: Requirements 2.1, 2.2, 2.3

import 'package:digital_tasbeeh/main.dart';
import 'package:digital_tasbeeh/screens/counter_screen.dart';
import 'package:digital_tasbeeh/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Expected constants for the Allah tap area (calibrated to full imageSide square)
const double _allahCenterX = 0.511;
const double _allahCenterY = 0.754;
const double _allahRadiusFactor = 0.118;

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
    final lcdReady =
        find.byKey(const Key('lcd_counter_text')).evaluate().isNotEmpty;
    if (menuReady && lcdReady) break;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    isCounterScreenTestMode = true;
    counterScreenTestOpaqueRect = const Rect.fromLTWH(0, 0, 1, 1); // unit rect — no-op mapping
    StorageService.enableInMemoryBackendForTests();
    await StorageService().resetForTests();
  });

  tearDown(() {
    counterScreenTestOpaqueRect = null;
  });

  group('allah_tap_area placement matches expected constants', () {
    for (final screenSize in [
      const Size(360, 640),
      const Size(430, 932),
      const Size(768, 1024),
    ]) {
      testWidgets(
        'allah_tap_area center and radius correct on '
        '${screenSize.width.toInt()}x${screenSize.height.toInt()}',
        (WidgetTester tester) async {
          await _pumpAppWithSize(tester, screenSize);

          final allahRect =
              tester.getRect(find.byKey(const Key('allah_tap_area')));
          final stackRect = tester.getRect(find.byType(Stack).first);
          final imageSide = stackRect.width;

          final expectedCenterX = imageSide * _allahCenterX;
          final expectedCenterY = imageSide * _allahCenterY;
          final expectedRadius = imageSide * _allahRadiusFactor;

          final actualCenterX = allahRect.center.dx - stackRect.left;
          final actualCenterY = allahRect.center.dy - stackRect.top;
          final actualRadius = allahRect.width / 2;

          expect(
            actualCenterX,
            closeTo(expectedCenterX, 1.0),
            reason: 'allah_tap_area center X should be imageSide * $_allahCenterX',
          );
          expect(
            actualCenterY,
            closeTo(expectedCenterY, 1.0),
            reason: 'allah_tap_area center Y should be imageSide * $_allahCenterY',
          );
          expect(
            actualRadius,
            closeTo(expectedRadius, 1.0),
            reason: 'allah_tap_area radius should be imageSide * $_allahRadiusFactor',
          );
        },
      );
    }
  });

  testWidgets('tapping allah_tap_area increments count', (WidgetTester tester) async {
    await _pumpAppWithSize(tester, const Size(430, 932));
    expect(find.text('0000'), findsOneWidget);
    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('0001'), findsOneWidget);
  });
}

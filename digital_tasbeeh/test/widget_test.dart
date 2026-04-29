import 'package:digital_tasbeeh/main.dart';
import 'package:digital_tasbeeh/screens/counter_screen.dart';
import 'package:digital_tasbeeh/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  await _pumpAppWithSize(tester, const Size(430, 932));
}

Future<void> _pumpAppWithSize(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  await tester.pumpWidget(const DigitalTasbeehApp());
  for (int i = 0; i < 200; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    final menuReady = find.byIcon(Icons.menu).evaluate().isNotEmpty;
    final lcdReady = find.byKey(const Key('lcd_counter_text')).evaluate().isNotEmpty;
    if (menuReady && lcdReady) {
      break;
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    isCounterScreenTestMode = true;
    StorageService.enableInMemoryBackendForTests();
    await StorageService().resetForTests();
  });

  testWidgets('drawer contains Prayer Dhikr, Dhikr List, and Settings', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Prayer Dhikr'), findsOneWidget);
    expect(find.text('Dhikr List'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('tapping Allah area increments count only there', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text('0000'), findsOneWidget);

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();

    expect(find.text('0001'), findsOneWidget);
  });

  testWidgets('tap exact center of Replay button opens reset dialog', (WidgetTester tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('0002'), findsOneWidget);

    final replayCenter = tester.getCenter(find.byKey(const Key('replay_tap_area')));
    await tester.tapAt(replayCenter);
    await tester.pumpAndSettle();

    expect(find.text('Reset Count?'), findsOneWidget);
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.text('0000'), findsOneWidget);
  });

  testWidgets('pressing Cancel on replay dialog keeps count unchanged', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('0002'), findsOneWidget);

    await tester.tap(find.byKey(const Key('replay_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('Reset Count?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('0002'), findsOneWidget);
  });

  testWidgets('tap exact center of Save button saves count', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('0002'), findsOneWidget);

    final saveCenter = tester.getCenter(find.byKey(const Key('save_tap_area')));
    await tester.tapAt(saveCenter);
    await tester.pumpAndSettle();

    expect(find.text('Count saved'), findsOneWidget);

    await _pumpApp(tester);
    expect(find.text('0002'), findsOneWidget);
  });

  testWidgets('tap slightly outside Save circle does nothing', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('0002'), findsOneWidget);

    final saveRect = tester.getRect(find.byKey(const Key('save_tap_area')));
    final saveCenter = saveRect.center;
    final saveRadius = saveRect.width / 2;
    await tester.tapAt(Offset(saveCenter.dx + saveRadius + 3, saveCenter.dy));
    await tester.pumpAndSettle();

    final storage = StorageService();
    expect(await storage.getTasbeehCount(), 0);
  });

  testWidgets('tap slightly outside Replay circle does not open dialog', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    final replayRect = tester.getRect(find.byKey(const Key('replay_tap_area')));
    final replayCenter = replayRect.center;
    final replayRadius = replayRect.width / 2;
    await tester.tapAt(Offset(replayCenter.dx + replayRadius + 3, replayCenter.dy));
    await tester.pumpAndSettle();

    expect(find.text('Reset Count?'), findsNothing);
    expect(find.text('0000'), findsOneWidget);
  });

  testWidgets('tapping outside image tap areas does not increment count', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    final imageFinder = find.byType(Image).first;
    final imageRect = tester.getRect(imageFinder);
    await tester.tapAt(Offset(imageRect.left + 8, imageRect.top + 8));
    await tester.pumpAndSettle();

    expect(find.text('0000'), findsOneWidget);
  });

  testWidgets('tap zones stay aligned on a small screen', (
    WidgetTester tester,
  ) async {
    await _pumpAppWithSize(tester, const Size(360, 640));

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('0001'), findsOneWidget);

    await tester.tap(find.byKey(const Key('replay_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('Reset Count?'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('0000'), findsOneWidget);
  });

  testWidgets('tap zones stay aligned on a large screen', (
    WidgetTester tester,
  ) async {
    await _pumpAppWithSize(tester, const Size(800, 1280));

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();
    expect(find.text('0001'), findsOneWidget);

    await tester.tap(find.byKey(const Key('save_tap_area')));
    await tester.pumpAndSettle();

    await _pumpAppWithSize(tester, const Size(800, 1280));
    expect(find.text('0001'), findsOneWidget);
  });

  testWidgets('Allah button still increments correctly', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('allah_tap_area')));
    await tester.pumpAndSettle();

    expect(find.text('0001'), findsOneWidget);
  });
}

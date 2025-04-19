import 'package:bomb_timer/bomb_timer_controller.dart';
import 'package:bomb_timer/bomb_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Simple mock class - no code generation needed
class MockBombTimerController extends Mock implements BombTimerController {}

void main() {
  late MockBombTimerController controller;

  setUp(() {
    controller = MockBombTimerController();

    // Setup mock behavior
    when(() => controller.gameOver).thenReturn(false);
    when(() => controller.todayIsChristmas).thenReturn(false);
    when(() => controller.minutes).thenReturn(0);
    when(() => controller.seconds).thenReturn(20);
    when(() => controller.timerText).thenReturn('00:20');
    when(() => controller.showTimer).thenReturn(true);
    when(() => controller.explosionGifKey).thenReturn(UniqueKey());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<BombTimerController>.value(
        value: controller,
        child: const BombTimer(),
      ),
    );
  }

  testWidgets('BombTimer displays initial state correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('00:20'), findsOneWidget);
  });

  testWidgets('Tapping starts the timer', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Get the GestureDetector widget
    final gestureDetector = tester.widget<GestureDetector>(
        find.byKey(const Key('bombTimerGestureDetector')));

    gestureDetector.onTap!();
    verify(() => controller.startTimer()).called(1);
  });

  // Alternative approach to test key events

  testWidgets('Handles R key press', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final bombTimerWidget = tester.widget<BombTimer>(find.byType(BombTimer));
    final handled =
        bombTimerWidget.handleKeyEvent(LogicalKeyboardKey.keyR, controller);

    expect(handled, isTrue);
    verify(() => controller.resetGame()).called(1);
  });
}

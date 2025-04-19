// bomb_timer_widget.dart
import 'package:bomb_timer/widgets/hot_key_row_widget.dart';
import 'package:bomb_timer/widgets/timer_settings_widget.dart';
import 'package:bomb_timer/widgets/todo_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';
import 'bomb_timer_controller.dart';

class BombTimer extends StatelessWidget {
  const BombTimer({super.key});

  // Internal helper to keep key handling logic separated and testable
  bool _handleKeyEvent(LogicalKeyboardKey key, BombTimerController controller,
      BuildContext context) {
    if (key == LogicalKeyboardKey.keyR) {
      controller.resetGame();
      return true;
    } else if (key == LogicalKeyboardKey.space) {
      controller.startTimer();
      return true;
    } else if (key == LogicalKeyboardKey.digit1 ||
        key == LogicalKeyboardKey.numpad1) {
      controller.setTimerPreset(60, 0);
      return true;
    } else if (key == LogicalKeyboardKey.digit2 ||
        key == LogicalKeyboardKey.numpad2) {
      controller.setTimerPreset(20, 0);
      return true;
    } else if (key == LogicalKeyboardKey.digit3 ||
        key == LogicalKeyboardKey.numpad3) {
      controller.setTimerPreset(0, 30);
      return true;
    } else if (key == LogicalKeyboardKey.keyH) {
      showHotkeysDialog(context);
      return true;
    } else if (key == LogicalKeyboardKey.keyT) {
      _showAddTodoDialog(context);
    } else if (key == LogicalKeyboardKey.keyL) {
      controller.toggleTodoVisibility();
      return true;
    }
    return false;
  }

  void showSettings(BuildContext context, BombTimerController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: TimerSettings(
          initialMinutes: controller.minutes,
          initialSeconds: controller.seconds,
          christmasTheme: controller.todayIsChristmas,
          onSave: (mins, secs, christmas) {
            controller.setTimerPreset(mins, secs);
            controller.setChristmasTheme(christmas);
          },
        ),
      ),
    );
  }

  void showHotkeysDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'HOTKEYS',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HotkeyRow(keyName: 'SPACE', action: 'Start Timer'),
            HotkeyRow(keyName: 'R', action: 'Reset Timer'),
            HotkeyRow(keyName: '1', action: 'Set 60 Minutes'),
            HotkeyRow(keyName: '2', action: 'Set 20 Minutes'),
            HotkeyRow(keyName: '3', action: 'Set 30 Seconds'),
            HotkeyRow(keyName: 'T', action: 'Add task'),
            HotkeyRow(keyName: 'L', action: "Toggle Task visiblity"),
            HotkeyRow(keyName: 'H', action: 'Show Help'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BombTimerController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF282828),
          body: Focus(
            key: const Key('bombTimerFocus'),
            autofocus: true,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent) {
                if (_handleKeyEvent(event.logicalKey, controller, context)) {
                  return KeyEventResult.handled;
                }
              }
              return KeyEventResult.ignored;
            },
            child: Center(
              child: SizedBox(
                width: 1920,
                height: 1080,
                child: GestureDetector(
                  key: const Key('bombTimerGestureDetector'),
                  onTap: () => controller.gameOver
                      ? controller.resetGame()
                      : controller.startTimer(),
                  child: Stack(
                    children: [
                      // Bomb image
                      if (!controller.gameOver)
                        Positioned(
                          right: 20,
                          top: 20,
                          child: Image.asset(
                            controller.todayIsChristmas
                                ? 'assets/images/bomb_christmas.png'
                                : 'assets/images/bomb.png',
                            width: 380,
                          ),
                        ),

                      // Explosion GIF
                      if (controller.gameOver)
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              child: GifView.asset(
                                'assets/images/explosion2.gif',
                                key: controller.explosionGifKey,
                                width: 2400,
                                height: 2400,
                                fit: BoxFit.contain,
                                loop: false,
                                frameRate: 24,
                                onFinish: () {
                                  print("Explosion animation completed");
                                },
                              ),
                            ),
                          ),
                        ),

                      // Timer display
                      if (!controller.gameOver) ...[
                        Positioned(
                          right: 170,
                          top: 120,
                          child: Text(
                            '00:00',
                            style: TextStyle(
                              fontFamily: 'digital_7_mono',
                              fontSize: 40,
                              color: Colors.red.withOpacity(0.2),
                            ),
                          ),
                        ),
                        if (controller.showTimer)
                          Positioned(
                            right: 170,
                            top: 120,
                            child: Text(
                              controller.timerText,
                              style: const TextStyle(
                                fontFamily: 'digital_7_mono',
                                fontSize: 40,
                                color: Colors.red,
                                shadows: [
                                  Shadow(color: Colors.red, blurRadius: 2),
                                ],
                              ),
                            ),
                          ),
                      ],

                      // Settings button
                      if (!controller.gameOver)
                        Positioned(
                          top: 20,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.red,
                              size: 40,
                            ),
                            onPressed: () => showSettings(context, controller),
                          ),
                        ),

                      // Add Todo List
                      if (controller.showTodoList)
                        Positioned(
                          left: 20, // Position on left side away from timer
                          top: 120, // Below settings button
                          child: SizedBox(
                            height:
                                400, // Fixed height with scrolling for many items
                            child: SingleChildScrollView(
                              child: const TodoList(),
                            ),
                          ),
                        ),

                      // Reset button when game is over
                      if (controller.gameOver)
                        Positioned(
                          bottom: 50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: controller.resetGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              child: const Text(
                                'RESET BOMB',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final controller = Provider.of<BombTimerController>(context, listen: false);
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ADD TASK'),
        content: TextField(controller: textController),
        actions: [
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.addTodo(textController.text);
                Navigator.pop(context);
              }
            },
            child: Text('ADD'),
          ),
        ],
      ),
    );
  }
}

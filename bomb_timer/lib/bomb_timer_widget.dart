import 'package:bomb_timer/widgets/timer_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif_view/gif_view.dart';
import 'bomb_timer_controller.dart';

class BombTimer extends StatefulWidget {
  const BombTimer({super.key});

  @override
  State<BombTimer> createState() => _BombTimerState();
}

class _BombTimerState extends State<BombTimer> {
  late BombTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BombTimerController(onStateChanged: () => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: TimerSettings(
          initialMinutes: _controller.minutes,
          initialSeconds: _controller.seconds,
          christmasTheme: _controller.todayIsChristmas,
          onSave: (mins, secs, christmas) {
            _controller.setTimerPreset(mins, secs);
            _controller.setChristmasTheme(christmas);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282828),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.keyR) {
              _controller.resetGame();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.space) {
              _controller.startTimer();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit1 ||
                event.logicalKey == LogicalKeyboardKey.numpad1) {
              _controller.setTimerPreset(60, 0);
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
                event.logicalKey == LogicalKeyboardKey.numpad2) {
              _controller.setTimerPreset(20, 0);
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
                event.logicalKey == LogicalKeyboardKey.numpad3) {
              _controller.setTimerPreset(0, 30);
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
              onTap: () => _controller.gameOver
                  ? _controller.resetGame()
                  : _controller.startTimer(),
              child: Stack(
                children: [
                  // Bomb image
                  if (!_controller.gameOver)
                    Positioned(
                      right: 20,
                      top: 20,
                      child: Image.asset(
                        _controller.todayIsChristmas
                            ? 'assets/images/bomb_christmas.png'
                            : 'assets/images/bomb.png',
                        width: 380,
                      ),
                    ),

                  // Explosion GIF
                  if (_controller.gameOver)
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: GifView.asset(
                            'assets/images/explosion2.gif',
                            key: _controller.explosionGifKey,
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
                  if (!_controller.gameOver) ...[
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
                    if (_controller.showTimer)
                      Positioned(
                        right: 170,
                        top: 120,
                        child: Text(
                          _controller.timerText,
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

                  // Settings button - remove duplicate
                  if (!_controller.gameOver)
                    Positioned(
                      top: 20,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.red,
                          size: 40,
                        ),
                        onPressed: showSettings,
                      ),
                    ),

                  // Reset button when game is over
                  if (_controller.gameOver)
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _controller.resetGame,
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
  }
}

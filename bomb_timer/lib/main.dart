import 'package:bomb_timer/widgets/timer_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gif_view/gif_view.dart';

void main() {
  runApp(const BombTimerApp());
}

class BombTimerApp extends StatelessWidget {
  const BombTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bomb Timer',
      theme: ThemeData.dark(),
      home: const BombTimer(),
    );
  }
}

class BombTimer extends StatefulWidget {
  const BombTimer({super.key});

  @override
  State<BombTimer> createState() => _BombTimerState();
}

class _BombTimerState extends State<BombTimer> {
  Key _explosionGifKey = UniqueKey();
  int minutes = 0;
  int seconds = 20;
  bool todayIsChristmas = true;
  bool showTimer = true;
  bool gameOver = false;
  int flashCount = 0;
  Timer? timer;
  Timer? flashTimer;
  final audioPlayer = AudioPlayer();

  @override
  void dispose() {
    timer?.cancel();
    flashTimer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAudio(String filename) async {
    await audioPlayer.play(AssetSource('audio/$filename'));
  }

  void startTimer() {
    setState(() {
      flashCount = 3;
    });

    timer?.cancel();
    flashTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) => decrementTimer());
    flashTimer = Timer.periodic(
        const Duration(milliseconds: 50), (_) => flashTimerDisplay());

    playAudio('armbomb.wav');
  }

  void decrementTimer() {
    setState(() {
      if (seconds == 0 && minutes == 0) {
        timer?.cancel();
        playAudio('doublebeep.wav');
        terroristsWin();
        return;
      }

      if (minutes > 0 && seconds == 0) {
        minutes--;
        seconds = 59;
      } else {
        seconds--;
      }

      if (minutes == 0 && seconds <= 10 && seconds > 0) {
        playAudio('beep.wav');
      }
    });
  }

  void flashTimerDisplay() {
    setState(() {
      showTimer = !showTimer;
      flashCount--;

      if (flashCount == 0) {
        showTimer = true;
        flashTimer?.cancel();
      }
    });
  }

  void terroristsWin() {
    setState(() {
      gameOver = true;
      timer?.cancel();
    });
    playAudio('explode.wav');

    // Auto-reset after explosion finishes (5 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && gameOver) {
        // Check if widget is still mounted and game is over
        resetGame();
      }
    });
  }

  void resetGame() {
    // Cancel any existing timers
    timer?.cancel();
    flashTimer?.cancel();

    setState(() {
      gameOver = false;
      minutes = 0;
      seconds = 20;
      showTimer = true;
      flashCount = 0;
      _explosionGifKey = UniqueKey();
    });

    // Optional: play a reset sound
    playAudio('armbomb.wav');
  }

  void showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: TimerSettings(
          initialMinutes: minutes,
          initialSeconds: seconds,
          christmasTheme: todayIsChristmas,
          onSave: (mins, secs, christmas) {
            setState(() {
              minutes = mins;
              seconds = secs;
              todayIsChristmas = christmas;
            });
          },
        ),
      ),
    );
  }

  String get timerText {
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  void setTimerPreset(int mins, int secs) {
    setState(() {
      minutes = mins;
      seconds = secs;
      showTimer = true;
      gameOver = false;
    });

    startTimer();

    // Show a quick message to confirm the change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Timer set to ${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.withOpacity(0.8),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
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
              resetGame();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.space) {
              startTimer();
              return KeyEventResult.handled;
            }
            // Add preset timer hotkeys
            else if (event.logicalKey == LogicalKeyboardKey.digit1 ||
                event.logicalKey == LogicalKeyboardKey.numpad1) {
              setTimerPreset(60, 0); // 60 minutes
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
                event.logicalKey == LogicalKeyboardKey.numpad2) {
              setTimerPreset(20, 0); // 20 minutes
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
                event.logicalKey == LogicalKeyboardKey.numpad3) {
              setTimerPreset(0, 30); // 30 seconds
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
              onTap: () => gameOver ? resetGame() : startTimer(),
              child: Stack(
                children: [
                  // Bomb image
                  if (!gameOver)
                    Positioned(
                      right: 20, // Adjust based on your needs
                      top: 20,
                      child: Image.asset(
                        todayIsChristmas
                            ? 'assets/images/bomb_christmas.png'
                            : 'assets/images/bomb.png',
                        width: 380,
                      ),
                    ),
                  // Settings button
                  if (!gameOver)
                    Positioned(
                      top: 20,
                      right: 0, // Position to the left of the bomb
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.red,
                          size: 40,
                        ),
                        onPressed: showSettings,
                      ),
                    ),
                  // Explosion - show when game over
                  if (gameOver)
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: GifView.asset(
                            'assets/images/explosion2.gif',
                            width: 2400, // Increase size
                            height: 2400, // Add height for better scaling
                            fit: BoxFit.cover,
                            key: _explosionGifKey,
                            loop: false,
                            onFinish: () {
                              print('Explosion finished');
                            },
                          ),
                        ),
                      ),
                    ),

                  // Timer background
                  if (!gameOver) // FIXED: Show when game is NOT over
                    Positioned(
                      right: 170,
                      top: 120,
                      child: Text(
                        '00:00',
                        style: TextStyle(
                          fontFamily: 'digital_7_mono',
                          fontSize: 40,
                          color: Colors.red.withOpacity(.1),
                        ),
                      ),
                    ),

                  // Active timer
                  if (!gameOver &&
                      showTimer) // FIXED: Only show when game is active and timer should be visible
                    Positioned(
                      right: 170,
                      top: 120,
                      child: Text(
                        timerText,
                        style: const TextStyle(
                          fontFamily: 'digital_7_mono',
                          fontSize: 40,
                          color: Colors.red,
                          shadows: [
                            Shadow(
                              color: Colors.red,
                              blurRadius: 2,
                            ),
                          ],
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

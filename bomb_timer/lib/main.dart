import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

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
      minutes = 0;
      seconds = 20;
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

    // Auto-reset after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      resetGame();
    });
  }

  void resetGame() {
    setState(() {
      gameOver = false;
      minutes = 0;
      seconds = 20;
      showTimer = true;
    });
  }

  String get timerText {
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282828),
      body: Center(
        child: SizedBox(
          width: 1920,
          height: 1080,
          child: GestureDetector(
            onTap: () => startTimer(),
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
                // Explosion - show when game over
                if (gameOver)
                  Positioned(
                    top: -910,
                    left: 0,
                    child: Image.asset(
                      'assets/images/explosion2.gif',
                      width: 2075,
                    ),
                  ),

                // Timer background
                if (!gameOver) // FIXED: Show when game is NOT over
                  Positioned(
                    right: 260,
                    top: 136,
                    child: Text(
                      '00:00',
                      style: TextStyle(
                        fontFamily: 'digital_7_mono',
                        fontSize: 40,
                        color: Colors.red.withOpacity(0.2),
                      ),
                    ),
                  ),

                // Active timer
                if (!gameOver &&
                    showTimer) // FIXED: Only show when game is active and timer should be visible
                  Positioned(
                    right: 260,
                    top: 136,
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
    );
  }
}

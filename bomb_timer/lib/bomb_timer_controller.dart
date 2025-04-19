// bomb_timer_controller.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class BombTimerController extends ChangeNotifier {
  // State variables
  Key explosionGifKey = UniqueKey();
  int minutes = 0;
  int seconds = 20;
  bool todayIsChristmas = true;
  bool showTimer = true;
  bool gameOver = false;
  int flashCount = 0;

  // Private implementation details
  Timer? _timer;
  Timer? _flashTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Get formatted timer text
  String get timerText {
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  // Start the timer countdown
  void startTimer() {
    flashCount = 3;
    _timer?.cancel();
    _flashTimer?.cancel();

    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _decrementTimer());
    _flashTimer = Timer.periodic(
        const Duration(milliseconds: 50), (_) => _flashTimerDisplay());

    _playAudio('armbomb.wav');
    notifyListeners(); // Replace onStateChanged with notifyListeners
  }

  // Reset the game to initial state
  void resetGame() {
    _timer?.cancel();
    _flashTimer?.cancel();

    gameOver = false;
    minutes = 0;
    seconds = 20;
    showTimer = true;
    flashCount = 0;
    explosionGifKey = UniqueKey();

    _playAudio('armbomb.wav');
    notifyListeners(); // Replace onStateChanged with notifyListeners
  }

  // Timer tick implementation
  void _decrementTimer() {
    if (seconds == 0 && minutes == 0) {
      _timer?.cancel();
      _flashTimer?.cancel();
      _terroristsWin();
      return;
    }

    if (seconds == 0) {
      if (minutes > 0) {
        minutes--;
        seconds = 59;
      }
    } else {
      seconds--;
    }

    if (minutes == 0 && seconds <= 10 && seconds > 0) {
      _playAudio('beep.wav');
    }

    notifyListeners(); // Replace onStateChanged with notifyListeners
  }

  // Handle explosion
  void _terroristsWin() {
    gameOver = true;
    _playAudio('explode.wav');
    notifyListeners(); // Replace onStateChanged with notifyListeners

    // Auto-reset after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (!gameOver) return; // Check if user manually reset
      resetGame();
    });
  }

  // Flash timer display
  void _flashTimerDisplay() {
    showTimer = !showTimer;
    flashCount--;

    if (flashCount == 0) {
      showTimer = true;
      _flashTimer?.cancel();
    }

    notifyListeners(); // Replace onStateChanged with notifyListeners
  }

  // Set timer to specific values
  void setTimerPreset(int mins, int secs) {
    minutes = mins;
    seconds = secs;
    showTimer = true;
    gameOver = false;
    notifyListeners(); // Replace onStateChanged with notifyListeners
  }

  // Update Christmas theme
  void setChristmasTheme(bool enabled) {
    todayIsChristmas = enabled;
    notifyListeners(); // Replace onStateChanged with notifyListeners
  }

  // Play audio helper
  Future<void> _playAudio(String filename) async {
    await _audioPlayer.play(AssetSource('audio/$filename'));
  }

  // Clean up resources
  @override
  void dispose() {
    _timer?.cancel();
    _flashTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose(); // Add this to call ChangeNotifier.dispose()
  }
}

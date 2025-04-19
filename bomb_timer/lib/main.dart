import 'package:bomb_timer/bomb_timer_controller.dart';
import 'package:bomb_timer/bomb_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const BombTimerApp());
}

class BombTimerApp extends StatelessWidget {
  const BombTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BombTimerController(), // Create controller here
      child: MaterialApp(
        title: 'Bomb Timer',
        theme: ThemeData.dark(),
        home: const BombTimer(),
      ),
    );
  }
}

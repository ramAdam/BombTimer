// timer_settings.dart
import 'package:flutter/material.dart';

class TimerSettings extends StatefulWidget {
  final int initialMinutes;
  final int initialSeconds;
  final bool christmasTheme;
  final Function(int minutes, int seconds, bool christmas) onSave;

  const TimerSettings({
    super.key,
    required this.initialMinutes,
    required this.initialSeconds,
    required this.christmasTheme,
    required this.onSave,
  });

  @override
  State<TimerSettings> createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<TimerSettings> {
  late int minutes;
  late int seconds;
  late bool christmasTheme;

  @override
  void initState() {
    super.initState();
    minutes = widget.initialMinutes;
    seconds = widget.initialSeconds;
    christmasTheme = widget.christmasTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TIMER SETTINGS',
            style: TextStyle(
              color: Colors.red,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          // Minutes setting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Minutes:', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        if (minutes > 0) minutes--;
                      });
                    },
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      minutes.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'digital_7_mono',
                        fontSize: 24,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        if (minutes < 99) minutes++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          // Seconds setting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seconds:', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        if (seconds > 0) seconds--;
                      });
                    },
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      seconds.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'digital_7_mono',
                        fontSize: 24,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        if (seconds < 59) seconds++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          // Christmas theme toggle
          SwitchListTile(
            title:
                Text('Christmas Theme', style: TextStyle(color: Colors.white)),
            value: christmasTheme,
            activeColor: Colors.red,
            onChanged: (value) {
              setState(() {
                christmasTheme = value;
              });
            },
          ),

          SizedBox(height: 20),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('CANCEL'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  widget.onSave(minutes, seconds, christmasTheme);
                  Navigator.pop(context);
                },
                child: Text('ARM BOMB'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

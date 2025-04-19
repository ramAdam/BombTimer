// Helper widget for consistent hotkey rows
import 'package:flutter/material.dart';

class HotkeyRow extends StatelessWidget {
  final String keyName;
  final String action;

  const HotkeyRow({super.key, required this.keyName, required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              keyName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              action,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

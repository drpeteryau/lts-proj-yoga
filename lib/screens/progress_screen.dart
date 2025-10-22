import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Your Progress',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Icon(Icons.emoji_events, size: 60, color: Colors.amber),
          SizedBox(height: 10),
          Text('You’ve completed 5 sessions this week!'),
        ],
      ),
    );
  }
}

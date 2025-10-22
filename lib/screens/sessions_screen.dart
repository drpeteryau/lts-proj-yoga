import 'package:flutter/material.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Guided Sessions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        YogaCard(title: 'Morning Stretch', duration: '10 mins'),
        YogaCard(title: 'Bedtime Relaxation', duration: '15 mins'),
        YogaCard(title: 'Sun Salutation (Beginner)', duration: '8 mins'),
      ],
    );
  }
}

class YogaCard extends StatelessWidget {
  final String title;
  final String duration;

  const YogaCard({super.key, required this.title, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.self_improvement, color: Colors.teal),
        title: Text(title),
        subtitle: Text('Duration: $duration'),
        trailing: const Icon(Icons.play_arrow),
      ),
    );
  }
}

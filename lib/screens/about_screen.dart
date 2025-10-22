import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          Text('About HealYoga',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            'HealYoga (ZenCore) is designed to help seniors achieve physical and mental well-being through guided yoga sessions, progress tracking, and mindfulness activities.',
          ),
          SizedBox(height: 20),
          Text('Team ZenCore\n• Kaam Yan Hye (Scrum Master)\n• Natalie Narayanan (Product Owner)\n• Jocasta Tan (QA/Tester)\n• Daniel Soong (Developer/Designer)',
              style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

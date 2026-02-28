import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  static const turquoise = Color(0xFF40E0D0);
  static const background = Color(0xFFEAF6F4);
  static const textDark = Color(0xFF1F3D3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        backgroundColor: turquoise,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // App Title Card
            _card(
              child: Column(
                children: const [
                  Text(
                    "HealYoga",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Helping you build healthier habits through guided yoga.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Mission Card
            _card(
              title: "Our Mission",
              child: const Text(
                "HealYoga is designed to encourage regular yoga practice "
                "through guided sessions, calming music, and progress tracking. "
                "We focus on accessibility and simplicity to make wellness "
                "available to everyone.",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Features Card
            _card(
              title: "Key Features",
              child: Column(
                children: const [
                  FeatureItem(text: "Guided yoga sessions"),
                  FeatureItem(text: "Relaxing music & meditation"),
                  FeatureItem(text: "Progress tracking"),
                  FeatureItem(text: "User authentication & profiles"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Credits Card
            _card(
              title: "Credits",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Project Supervisor",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text("Dr. Peter Yau"),

                  SizedBox(height: 16),

                  Text(
                    "Team Members",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("• Jocasta Tan"),
                  Text("• Daniel Soong"),
                  Text("• Kaam Yan Hye"),
                  Text("• Natalie Narayanan"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "© 2026 HealYoga Project\nAll Rights Reserved",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _card({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String text;
  const FeatureItem({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF40E0D0)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
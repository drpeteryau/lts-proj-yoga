import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const HealYogaApp());
}

class HealYogaApp extends StatelessWidget {
  const HealYogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealYoga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF40E0D0), // Turquoise
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF40E0D0),
          secondary: const Color(0xFF00796B),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        fontFamily: 'SF Pro Display', // iOS-style font
      ),
      home: const OnboardingScreen(),
    );
  }
}

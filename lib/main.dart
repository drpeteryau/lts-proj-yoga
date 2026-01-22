import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_gate.dart';
import 'services/global_audio_service.dart'; // ⭐ ADD THIS IMPORT

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase so FirebaseMessaging can return an FCM token
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized');
  } catch (e) {
    print('⚠️ Firebase.initializeApp() failed: $e');
  }

  await Supabase.initialize(
    url: 'https://rkhmailqbmbijsfzhcch.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJraG1haWxxYm1iaWpzZnpoY2NoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5OTA2NzIsImV4cCI6MjA3NzU2NjY3Mn0.WcM8AsP3YSoyBhrS7KRFf2lmxNqSg0FG1bkbihrrffY',
  );

  // ⭐ ADD THIS - Initialize audio service for mini playback bar
  try {
    await GlobalAudioService().initialize();
    print('✅ GlobalAudioService initialized');
  } catch (e) {
    print('⚠️ GlobalAudioService.initialize() failed: $e');
  }

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
      home: const AuthGate(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_gate.dart';
import 'services/global_audio_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

final ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('en'));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rkhmailqbmbijsfzhcch.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJraG1haWxxYm1iaWpzZnpoY2NoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5OTA2NzIsImV4cCI6MjA3NzU2NjY3Mn0.WcM8AsP3YSoyBhrS7KRFf2lmxNqSg0FG1bkbihrrffY',
  );

  // ⭐ CRITICAL: Initialize GlobalAudioService for playback bar and music
  try {
    await GlobalAudioService().initialize();
    print('✅ GlobalAudioService initialized');
  } catch (e) {
    print('⚠️ GlobalAudioService.initialize() failed: $e');
  }

  await NotificationService().init();

  runApp(const HealYogaApp());
}

class HealYogaApp extends StatelessWidget {
  const HealYogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        return MaterialApp(
          title: 'HealYoga',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF40E0D0), // Turquoise
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xFF40E0D0),
              secondary: const Color(0xFF00796B),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              const TextTheme(
                bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
                titleLarge: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          locale: locale, // <--- This controls the current language
          supportedLocales: const [Locale('en'), Locale('zh')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AuthGate(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'main_navigation_screen.dart';
import 'complete_profile_screen.dart';
import '../main.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();

    // 🔄 React to login/logout automatically
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      _checkAuthState();
    });
  }

  Future<void> _ensureProfileExists(User user) async {
    final supabase = Supabase.instance.client;
    try {
      final existingProfile = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existingProfile != null) {
        print('✅ Profile already exists, skipping insert.');
        return;
      }

      // ⏳ Give Supabase a moment to register auth.users row
      await Future.delayed(const Duration(seconds: 1));

      // ✅ Upsert = safe insert/update
      await supabase.from('profiles').upsert({
        'id': user.id,
        'email': user.email,
        'full_name': user.userMetadata?['full_name'] ?? '',
      });
      print('✅ Profile upserted successfully');
    } catch (e) {
      if (e.toString().contains('foreign key constraint')) {
        print('⚠️ Skipping insert: user not yet ready in auth.users');
      } else {
        print('❌ Error ensuring profile: $e');
      }
    }
  }

  Future<void> _checkAuthState() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final user = session.user;
    await _ensureProfileExists(user);

    // 🔍 Fetch profile
    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    print('🔍 Loaded profile: $profile');

    if (profile != null) {
      final savedLanguage = profile['preferred_language'] ?? 'English';

      // Update the global ValueNotifier in main.dart
      appLocale.value =
          savedLanguage == 'Mandarin' ? const Locale('zh') : const Locale('en');

      print('🌐 App language synced to: $savedLanguage');
    }

    final fullName = (profile?['full_name'] as String?)?.trim() ?? '';
    final age = profile?['age'];
    final isIncomplete = fullName.isEmpty || age == null;

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isIncomplete) {
        print(
            '🪷 Incomplete profile detected — going to CompleteProfileScreen');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => CompleteProfileScreen(
              fullName: fullName.isEmpty
                  ? (user.userMetadata?['full_name'] ?? '')
                  : fullName,
              email: user.email ?? '',
            ),
          ),
          (_) => false,
        );
      } else {
        print('🌿 Profile complete — going to MainNavigationScreen');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (_) => false,
        );
      }
    });

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return const LoginScreen();
    }

    // Fallback (shouldn’t appear)
    return const Scaffold(body: SizedBox.shrink());
  }
}

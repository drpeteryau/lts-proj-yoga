import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';

/// Show this banner at the top of any screen where guest users
/// should be nudged to create an account.
/// Usage: just add GuestBanner() at the top of your screen's Column.
class GuestBanner extends StatelessWidget {
  const GuestBanner({super.key});

  static Future<bool> isGuest() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;
    final profile = await Supabase.instance.client
        .from('profiles')
        .select('is_guest')
        .eq('id', user.id)
        .maybeSingle();
    return profile?['is_guest'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isGuest(),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return _GuestBannerContent();
      },
    );
  }
}

class _GuestBannerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1),
        border: Border(
          bottom: BorderSide(color: Color(0xFFFFD54F), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: Color(0xFFF57F17)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Browsing as Guest — progress not permanently saved',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF7C4A00),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF40E0D0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Sign Up',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00695C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'auth_gate.dart';
import 'register_screen.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';
import 'about_us_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;

  // 🎨 App colors - ORIGINAL
  static const background = Color(0xFFEAF6F4);
  static const turquoise = Color(0xFF40E0D0);
  static const textDark = Color(0xFF1F3D3A);
  static const textMuted = Color(0xFF6B8F8A);
  static const webBreakpoint = 1200.0;

  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  bool _isGuest = false;

  int _totalSessions = 0;
  int _totalMinutes = 0;
  int _dailyStreak = 0;
  int _weeklyStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadStats();
  }

  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (!mounted) return;

    setState(() {
      _profile = data;
      _isGuest = data?['is_guest'] == true;
      _isLoading = false;
    });
  }

  Future<void> _loadStats() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final completedSessions = await supabase
        .from('session_completions')
        .select('id')
        .eq('user_id', userId);

    int sessionCount = completedSessions.length;

    final activities = await supabase
        .from('pose_activity')
        .select('duration_seconds, completed_at')
        .eq('user_id', userId)
        .order('completed_at', ascending: false);

    int totalSeconds = 0;
    final Map<String, bool> activityDays = {};

    for (final row in activities) {
      totalSeconds += (row['duration_seconds'] ?? 0) as int;

      final raw = DateTime.parse(row['completed_at']).toLocal();
      final date = DateTime(raw.year, raw.month, raw.day);
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      activityDays[key] = true;
    }

    final totalMinutes = (totalSeconds / 60).ceil();

    int streak = 0;
    DateTime checkDate = DateTime.now();

    while (true) {
      final date = DateTime(checkDate.year, checkDate.month, checkDate.day);
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      if (activityDays[key] == true) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    if (!mounted) return;

    setState(() {
      _totalSessions = sessionCount;
      _totalMinutes = totalMinutes;
      _dailyStreak = streak;
      _weeklyStreak = 0;
    });
  }

  String _getLocalizedDbValue(String? value) {
    if (value == null || value.isEmpty) return '-';

    final l10n = AppLocalizations.of(context)!;
    final v = value.trim();

    if (v == 'Beginner') return l10n.beginner;
    if (v == 'Intermediate') return l10n.intermediate;
    if (v == 'Advanced') return l10n.advanced;

    if (v == ('English')) return l10n.english;
    if (v == ('Mandarin (Simplified)')) return l10n.mandarinSimplified;
    if (v == ('Mandarin (Traditional)')) return l10n.mandarinTraditional;

    if (v.contains('5')) return l10n.min5;
    if (v.contains('10')) return l10n.min10;
    if (v.contains('15')) return l10n.min15;
    if (v.contains('20')) return l10n.min20;
    if (v.contains('30')) return l10n.min30;

    return v;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > webBreakpoint;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = _profile?['full_name'] ?? 'User';
    final email = _profile?['email'] ?? '';
    final imageUrl = _profile?['profile_image_url'];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4F1F0),
              Color(0xFFFFFFFF),
              Color(0xFFE8F9F3),
              Color(0xFFFFE9DB),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: isWeb ? _buildWebLayout(name, email, imageUrl) : _buildMobileLayout(name, email, imageUrl),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Web Layout
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildWebLayout(String name, String email, String? imageUrl) {
    if (_isGuest) return _buildGuestProfilePrompt();
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.profileTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    await GlobalAudioService.playClickSound();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    );
                    _loadProfile();
                    _loadStats();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: turquoise,
                    side: const BorderSide(color: turquoise, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.edit,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    if (_isGuest) _buildGuestSignUpCard(),
                    if (_isGuest) const SizedBox(height: 20),
                    // Row 1: Profile Card (Left) | Stats Grid (Right)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Card - Fixed Width
                        SizedBox(
                          width: 300,
                          child: _buildProfileCard(name, email, imageUrl),
                        ),

                        const SizedBox(width: 24),

                        // Right Column: Stats + Sections
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Stats Grid - 3 columns
                              Row(
                                children: [
                                  _statCard(
                                    AppLocalizations.of(context)!.sessions,
                                    _totalSessions.toString(),
                                  ),
                                  const SizedBox(width: 20),
                                  _statCard(
                                    AppLocalizations.of(context)!.minutesLabel,
                                    _totalMinutes.toString(),
                                  ),
                                  const SizedBox(width: 20),
                                  _statCard(
                                    AppLocalizations.of(context)!.daily,
                                    _dailyStreak.toString(),
                                    highlight: true,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Streak Summary
                              _section(
                                title: AppLocalizations.of(context)!.streakSummary,
                                children: [
                                  _infoRow(
                                    AppLocalizations.of(context)!.weeklyActive,
                                    _weeklyStreak.toString(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Row 2: Preferences | Notifications (2-column grid with equal heights)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _section(
                            title: AppLocalizations.of(context)!.preferences,
                            children: [
                              _infoRow(
                                AppLocalizations.of(context)!.experienceLevel,
                                _getLocalizedDbValue(_profile?['experience_level']),
                              ),
                              _infoRow(
                                AppLocalizations.of(context)!.sessionLength,
                                _getLocalizedDbValue(_profile?['preferred_session_length']),
                              ),
                              _infoRow(
                                AppLocalizations.of(context)!.language,
                                _getLocalizedDbValue(_profile?['preferred_language']),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          child: _section(
                            title: AppLocalizations.of(context)!.notifications,
                            children: [
                              _infoRow(
                                AppLocalizations.of(context)!.pushNotifications,
                                _profile?['push_notifications_enabled'] == true
                                    ? AppLocalizations.of(context)!.enabled
                                    : AppLocalizations.of(context)!.disabled,
                              ),
                              _infoRow(
                                AppLocalizations.of(context)!.dailyReminder,
                                _profile?['daily_practice_reminder'] == true
                                    ? AppLocalizations.of(context)!.enabled
                                    : AppLocalizations.of(context)!.disabled,
                              ),
                              if (_profile?['daily_practice_reminder'] == true)
                                _infoRow(
                                  AppLocalizations.of(context)!.reminderTime,
                                  _profile?['reminder_time']?.toString() ?? '-',
                                ),
                              _infoRow(
                                AppLocalizations.of(context)!.soundEffects,
                                _profile?['sound_effects_enabled'] == true
                                    ? AppLocalizations.of(context)!.enabled
                                    : AppLocalizations.of(context)!.disabled,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Buttons Row - Equal width
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await GlobalAudioService.playClickSound();
                              if (!mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: turquoise,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.aboutus,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await GlobalAudioService.playClickSound();
                              await supabase.auth.signOut(scope: SignOutScope.global);
                              if (!mounted) return;
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const AuthGate()),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.signout,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Mobile Layout
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildMobileLayout(String name, String email, String? imageUrl) {
    // Guests see a simplified sign-up prompt instead of the full profile
    if (_isGuest) return _buildGuestProfilePrompt();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.profileTitle,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                  _loadProfile();
                  _loadStats();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: turquoise,
                  side: const BorderSide(color: turquoise, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.edit,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (_isGuest) _buildGuestSignUpCard(),
                _buildProfileCard(name, email, imageUrl),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _statCard(
                      AppLocalizations.of(context)!.sessions,
                      _totalSessions.toString(),
                    ),
                    const SizedBox(width: 12),
                    _statCard(
                      AppLocalizations.of(context)!.minutesLabel,
                      _totalMinutes.toString(),
                    ),
                    const SizedBox(width: 12),
                    _statCard(
                      AppLocalizations.of(context)!.daily,
                      _dailyStreak.toString(),
                      highlight: true,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _section(
                  title: AppLocalizations.of(context)!.streakSummary,
                  children: [
                    _infoRow(
                      AppLocalizations.of(context)!.weeklyActive,
                      _weeklyStreak.toString(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _section(
                  title: AppLocalizations.of(context)!.preferences,
                  children: [
                    _infoRow(
                      AppLocalizations.of(context)!.experienceLevel,
                      _getLocalizedDbValue(_profile?['experience_level']),
                    ),
                    _infoRow(
                      AppLocalizations.of(context)!.sessionLength,
                      _getLocalizedDbValue(_profile?['preferred_session_length']),
                    ),
                    _infoRow(
                      AppLocalizations.of(context)!.language,
                      _getLocalizedDbValue(_profile?['preferred_language']),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _section(
                  title: AppLocalizations.of(context)!.notifications,
                  children: [
                    _infoRow(
                      AppLocalizations.of(context)!.pushNotifications,
                      _profile?['push_notifications_enabled'] == true
                          ? AppLocalizations.of(context)!.enabled
                          : AppLocalizations.of(context)!.disabled,
                    ),
                    _infoRow(
                      AppLocalizations.of(context)!.dailyReminder,
                      _profile?['daily_practice_reminder'] == true
                          ? AppLocalizations.of(context)!.enabled
                          : AppLocalizations.of(context)!.disabled,
                    ),
                    if (_profile?['daily_practice_reminder'] == true)
                      _infoRow(
                        AppLocalizations.of(context)!.reminderTime,
                        _profile?['reminder_time']?.toString() ?? '-',
                      ),
                    _infoRow(
                      AppLocalizations.of(context)!.soundEffects,
                      _profile?['sound_effects_enabled'] == true
                          ? AppLocalizations.of(context)!.enabled
                          : AppLocalizations.of(context)!.disabled,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await GlobalAudioService.playClickSound();
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: turquoise,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.aboutus,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await GlobalAudioService.playClickSound();
                      await supabase.auth.signOut(scope: SignOutScope.global);
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const AuthGate()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signout,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared Components
  // ─────────────────────────────────────────────────────────────────────────

  /// Full-page guest prompt — replaces profile screen for guest users
  Widget _buildGuestProfilePrompt() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: turquoise.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline_rounded,
                  size: 48, color: turquoise),
            ),
            const SizedBox(height: 24),

            Text(
              'You\'re a Guest',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create a free account to unlock your full profile, save your progress permanently, and track your wellness journey.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14.5,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // Benefits list
            _guestBenefit(Icons.bookmark_rounded, 'Save progress permanently'),
            _guestBenefit(Icons.person_rounded, 'Your own profile & preferences'),
            _guestBenefit(Icons.notifications_rounded, 'Daily practice reminders'),
            _guestBenefit(Icons.bar_chart_rounded, 'Full wellness tracking'),

            const SizedBox(height: 36),

            // Sign up button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: turquoise,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Create Free Account',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sign out option
            TextButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                await supabase.auth.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                        (route) => false,
                  );
                }
              },
              child: Text(
                'Sign out of guest session',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guestBenefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: turquoise.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: turquoise),
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestSignUpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0FAF7), Color(0xFFFFF8E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: turquoise.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: turquoise.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: turquoise,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person_add_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save Your Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You\'re browsing as a guest. Create a free account to keep your progress permanently.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Button
          ElevatedButton(
            onPressed: () async {
              await GlobalAudioService.playClickSound();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: turquoise,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Sign Up',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String name, String email, String? imageUrl) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  turquoise.withOpacity(0.6),
                  turquoise.withOpacity(0.2),
                ],
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? const Icon(Icons.person, size: 48, color: turquoise)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: GoogleFonts.poppins(
              color: textMuted,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _statCard(
      String label,
      String value, {
        bool highlight = false,
      }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: highlight
              ? Border.all(
            color: const Color(0xFFFFA500).withOpacity(0.3),
            width: 2,
          )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.0,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: textMuted,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
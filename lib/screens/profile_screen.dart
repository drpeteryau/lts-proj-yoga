import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'auth_gate.dart';
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

  // 🎨 App colors
  static const background = Color(0xFFEAF6F4);
  static const turquoise = Color(0xFF40E0D0);
  static const textDark = Color(0xFF1F3D3A);
  static const textMuted = Color(0xFF6B8F8A);

  Map<String, dynamic>? _profile;
  bool _isLoading = true;

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
      _isLoading = false;
    });
  }

  Future<void> _loadStats() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Get completed sessions from session_completions (same as progress screen)
    final completedSessions = await supabase
        .from('session_completions')
        .select('id')
        .eq('user_id', userId);

    int sessionCount = completedSessions.length;

    // Get pose activities for minutes calculation
    final activities = await supabase
        .from('pose_activity')
        .select('duration_seconds, completed_at')
        .eq('user_id', userId)
        .order('completed_at', ascending: false);

    // Calculate total minutes from pose activities
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

    // Calculate daily streak (same logic as progress screen)
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
    final isWeb = screenWidth > 600;

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
          child: Column(
            children: [
              // Custom header
              Padding(
                padding: EdgeInsets.all(isWeb ? 24 : 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.profileTitle,
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 32 : 26,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 24 : 20,
                          vertical: isWeb ? 14 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.edit,
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 16 : 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 1000 : double.infinity,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 20),
                      child: Column(
                        children: [
                          // ── WEB: 2-column grid layout ──
                          // ── MOBILE: single-column stack (unchanged) ──
                          if (isWeb) ...[
                            // Row 1: Avatar card (fixed width) | Stats + Streak (right column)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar card – fixed width
                                SizedBox(
                                  width: 300,
                                  child: _card(
                                    isWeb,
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
                                            backgroundImage: imageUrl != null
                                                ? NetworkImage(imageUrl)
                                                : null,
                                            child: imageUrl == null
                                                ? const Icon(Icons.person, size: 48)
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: textDark,
                                          ),
                                        ),
                                        Text(
                                          email,
                                          style: const TextStyle(
                                            color: textMuted,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 24),

                                // Right column: Stats row on top, Streak Summary below
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          _statCard(
                                              AppLocalizations.of(context)!.sessions,
                                              _totalSessions.toString(),
                                              isWeb),
                                          _statCard(
                                              AppLocalizations.of(context)!.minutesLabel,
                                              _totalMinutes.toString(),
                                              isWeb),
                                          _statCard(AppLocalizations.of(context)!.daily,
                                              _dailyStreak.toString(), isWeb,
                                              highlight: true),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Streak summary fills the remaining right-column width
                                      _section(
                                        isWeb,
                                        title:
                                        AppLocalizations.of(context)!.streakSummary,
                                        children: [
                                          _infoRow(
                                              AppLocalizations.of(context)!.weeklyActive,
                                              _weeklyStreak.toString(),
                                              isWeb),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Row 2: Preferences | Notifications
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _section(
                                    isWeb,
                                    title: AppLocalizations.of(context)!.preferences,
                                    children: [
                                      _infoRow(
                                          AppLocalizations.of(context)!.experienceLevel,
                                          _getLocalizedDbValue(_profile?['experience_level']),
                                          isWeb),
                                      _infoRow(
                                          AppLocalizations.of(context)!.sessionLength,
                                          _getLocalizedDbValue(_profile?['preferred_session_length']),
                                          isWeb),
                                      _infoRow(AppLocalizations.of(context)!.language,
                                          _getLocalizedDbValue(_profile?['preferred_language']), isWeb),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _section(
                                    isWeb,
                                    title: AppLocalizations.of(context)!.notifications,
                                    children: [
                                      _infoRow(
                                        AppLocalizations.of(context)!.pushNotifications,
                                        _profile?['push_notifications_enabled'] == true
                                            ? AppLocalizations.of(context)!.enabled
                                            : AppLocalizations.of(context)!.disabled,
                                        isWeb,
                                      ),
                                      _infoRow(
                                        AppLocalizations.of(context)!.dailyReminder,
                                        _profile?['daily_practice_reminder'] == true
                                            ? AppLocalizations.of(context)!.enabled
                                            : AppLocalizations.of(context)!.disabled,
                                        isWeb,
                                      ),
                                      if (_profile?['daily_practice_reminder'] == true)
                                        _infoRow(
                                            AppLocalizations.of(context)!.reminderTime,
                                            _profile?['reminder_time']?.toString() ?? '-',
                                            isWeb),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            // ── MOBILE: single column, unchanged order ──
                            _card(
                              isWeb,
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
                                    padding: const EdgeInsets.all(3),
                                    child: CircleAvatar(
                                      radius: 38,
                                      backgroundImage: imageUrl != null
                                          ? NetworkImage(imageUrl)
                                          : null,
                                      child: imageUrl == null
                                          ? const Icon(Icons.person, size: 36)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: textDark,
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      color: textMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                _statCard(AppLocalizations.of(context)!.sessions,
                                    _totalSessions.toString(), isWeb),
                                _statCard(AppLocalizations.of(context)!.minutesLabel,
                                    _totalMinutes.toString(), isWeb),
                                _statCard(AppLocalizations.of(context)!.daily,
                                    _dailyStreak.toString(), isWeb,
                                    highlight: true),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _section(
                              isWeb,
                              title: AppLocalizations.of(context)!.streakSummary,
                              children: [
                                _infoRow(AppLocalizations.of(context)!.weeklyActive,
                                    _weeklyStreak.toString(), isWeb),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _section(
                              isWeb,
                              title: AppLocalizations.of(context)!.preferences,
                              children: [
                                _infoRow(AppLocalizations.of(context)!.experienceLevel,
                                    _getLocalizedDbValue(_profile?['experience_level']), isWeb),
                                _infoRow(AppLocalizations.of(context)!.sessionLength,
                                    _getLocalizedDbValue(_profile?['preferred_session_length']), isWeb),
                                _infoRow(AppLocalizations.of(context)!.language,
                                    _getLocalizedDbValue(_profile?['preferred_language']), isWeb),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _section(
                              isWeb,
                              title: AppLocalizations.of(context)!.notifications,
                              children: [
                                _infoRow(
                                  AppLocalizations.of(context)!.pushNotifications,
                                  _profile?['push_notifications_enabled'] == true
                                      ? AppLocalizations.of(context)!.enabled
                                      : AppLocalizations.of(context)!.disabled,
                                  isWeb,
                                ),
                                _infoRow(
                                  AppLocalizations.of(context)!.dailyReminder,
                                  _profile?['daily_practice_reminder'] == true
                                      ? AppLocalizations.of(context)!.enabled
                                      : AppLocalizations.of(context)!.disabled,
                                  isWeb,
                                ),
                                if (_profile?['daily_practice_reminder'] == true)
                                  _infoRow(
                                      AppLocalizations.of(context)!.reminderTime,
                                      _profile?['reminder_time']?.toString() ?? '-',
                                      isWeb),
                                _infoRow(
                                  AppLocalizations.of(context)!.soundEffects,
                                  _profile?['sound_effects_enabled'] == true
                                      ? AppLocalizations.of(context)!.enabled
                                      : AppLocalizations.of(context)!.disabled,
                                  isWeb,
                                ),
                              ],
                            ),
                          ],

// About Us Button
                          SizedBox(height: isWeb ? 40 : 28),
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
                                backgroundColor: turquoise, // 👈 solid color
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: isWeb ? 18 : 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.info_outline),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.aboutus,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isWeb ? 18 : 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: isWeb ? 20 : 16),

// Logout – full width
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
                                padding: EdgeInsets.symmetric(vertical: isWeb ? 18 : 16),
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
                                  fontSize: isWeb ? 18 : 17,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isWeb ? 60 : 40),
                        ],
                      ),
                    ),
                  ),
                ),
              )],
          ),
        ),
      ),
    );
  }

  Widget _card(bool isWeb, {required Widget child}) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 32 : 24),
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
      child: child,
    );
  }

  Widget _section(
      bool isWeb, {
        required String title,
        required List<Widget> children,
      }) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 28 : 24),
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
              fontSize: isWeb ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isWeb ? 20 : 16),
          ...children,
        ],
      ),
    );
  }

  Widget _statCard(
      String label,
      String value,
      bool isWeb, {
        bool highlight = false,
      }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isWeb ? 8 : 4),
        padding: EdgeInsets.symmetric(
          vertical: isWeb ? 24 : 20,
          horizontal: isWeb ? 16 : 12,
        ),
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
          border: highlight ? Border.all(
            color: const Color(0xFFFFA500).withOpacity(0.3),
            width: 2,
          ) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: isWeb ? 13 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (highlight) ...[
                  const SizedBox(width: 2),
                  const Text(
                    '',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(bottom: isWeb ? 16 : 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 17 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: textMuted,
              fontSize: isWeb ? 17 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
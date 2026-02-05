import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'auth_gate.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

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

    final activities = await supabase
        .from('pose_activity')
        .select('duration_seconds, completed_at')
        .eq('user_id', userId)
        .order('completed_at', ascending: false);

    int totalSeconds = 0;
    final Set<String> activeDays = {};
    final List<DateTime> times = [];

    for (final row in activities) {
      totalSeconds += (row['duration_seconds'] ?? 0) as int;

      final date = DateTime.parse(row['completed_at']).toLocal();
      final dayKey = '${date.year}-${date.month}-${date.day}';
      activeDays.add(dayKey);

      times.add(date);
    }

    // Sessions (30-min gap rule, same as ProgressScreen)
    int sessions = 0;
    times.sort();
    DateTime? last;

    for (final t in times) {
      if (last == null || t.difference(last).inMinutes > 30) {
        sessions++;
      }
      last = t;
    }

    // Daily streak
    int streak = 0;
    DateTime check = DateTime.now();

    while (true) {
      final key = '${check.year}-${check.month}-${check.day}';
      if (activeDays.contains(key)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    if (!mounted) return;

    setState(() {
      _totalSessions = sessions;
      _totalMinutes = (totalSeconds / 60).ceil();
      _dailyStreak = streak;
      _weeklyStreak = 0; // optional – can compute later
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
  if (v == ('Mandarin')) return l10n.mandarin;

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
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profileTitle,
          style: TextStyle(fontSize: isWeb ? 24 : 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await GlobalAudioService.playClickSound();
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              _loadProfile();
              _loadStats();
            },
            child: Text(
              AppLocalizations.of(context)!.edit,
              style: TextStyle(fontSize: isWeb ? 18 : 16),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isWeb ? 1000 : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isWeb ? 40 : 20),
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
                            fontSize: 20,
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

                // Logout – full width on both platforms
                SizedBox(height: isWeb ? 48 : 32),
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
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: isWeb ? 18 : 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isWeb ? 16 : 14),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.logout,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isWeb ? 18 : 16,
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
    );
  }

  Widget _card(bool isWeb, {required Widget child}) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 32 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: isWeb ? 15 : 10,
            offset: Offset(0, isWeb ? 6 : 4),
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
      padding: EdgeInsets.all(isWeb ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isWeb ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: isWeb ? 12 : 8,
            offset: Offset(0, isWeb ? 4 : 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isWeb ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E6F68),
            ),
          ),
          SizedBox(height: isWeb ? 16 : 12),
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
        margin: EdgeInsets.symmetric(horizontal: isWeb ? 8 : 6),
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFFFF4EC) : const Color(0xFFF7FFFE),
          borderRadius: BorderRadius.circular(isWeb ? 20 : 16),
          border: Border.all(
            color: const Color(0xFF40E0D0).withOpacity(0.25),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: isWeb ? 24 : 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: textMuted,
                fontSize: isWeb ? 15 : 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(bottom: isWeb ? 12 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: isWeb ? 16 : 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: textMuted,
              fontSize: isWeb ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

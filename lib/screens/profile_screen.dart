import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'auth_gate.dart';

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


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = _profile?['full_name'] ?? 'User';
    final email = _profile?['email'] ?? '';
    final imageUrl = _profile?['profile_image_url'];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              _loadProfile();
              _loadStats();
            },
            child: const Text('Edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _card(
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
                  Text(email, style: const TextStyle(color: textMuted)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _statCard('Sessions', _totalSessions.toString()),
                _statCard('Minutes', _totalMinutes.toString()),
                _statCard('Daily 🔥', _dailyStreak.toString(), highlight: true),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              title: 'Streak Summary',
              children: [
                _infoRow('Weekly Active Weeks', _weeklyStreak.toString()),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              title: 'Preferences',
              children: [
                _infoRow(
                  'Experience Level',
                  _profile?['experience_level'] ?? '-',
                ),
                _infoRow(
                  'Session Length',
                  _profile?['preferred_session_length'] ?? '-',
                ),
                _infoRow('Language', _profile?['preferred_language'] ?? '-'),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              title: 'Notifications',
              children: [
                _infoRow(
                  'Push Notifications',
                  _profile?['push_notifications_enabled'] == true
                      ? 'Enabled'
                      : 'Disabled',
                ),
                _infoRow(
                  'Daily Reminder',
                  _profile?['daily_practice_reminder'] == true
                      ? 'Enabled'
                      : 'Disabled',
                ),
                if (_profile?['daily_practice_reminder'] == true)
                  _infoRow(
                    'Reminder Time',
                    _profile?['reminder_time']?.toString() ?? '-',
                  ),
              ],
            ),

            // 🔴 LOGOUT BUTTON — FULL WIDTH
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await supabase.auth.signOut(scope: SignOutScope.global);

                  if (!mounted) return;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(
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
    );
  }

  Widget _card({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E6F68),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFFFF4EC) : const Color(0xFFF7FFFE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF40E0D0).withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            Text(label, style: const TextStyle(color: textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(color: textMuted)),
        ],
      ),
    );
  }
}

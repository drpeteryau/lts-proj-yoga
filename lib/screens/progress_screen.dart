import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:ui' as ui;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final supabase = Supabase.instance.client;

  bool get isWeb => MediaQuery.of(context).size.width > 600;

  bool _isLoading = true;
  String? _error;

  // Data
  int _currentStreak = 0;
  int _totalSessions = 0;
  int _weeklyMinutes = 0;
  final int _weeklyGoal = 300;
  int _totalMinutes = 0;
  final Map<String, bool> _activityDays = {};
  DateTime _currentMonth = DateTime.now();

  // Wellness data
  List<Map<String, dynamic>> _reflections = [];
  bool _hasCheckInThisWeek = false;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      print('🔍 DEBUG: Loading progress for user: $userId');

      final poseActivitiesResponse = await supabase
          .from('pose_activity')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      print('🔍 DEBUG: Found ${poseActivitiesResponse.length} pose activities');
      print('🔍 DEBUG: First few records: ${poseActivitiesResponse.take(3).toList()}');

      _activityDays.clear();

      // Used to infer sessions
      final Map<String, List<DateTime>> grouped = {};

      int weekSeconds = 0;
      int totalSeconds = 0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));

      print('🔍 DEBUG: Week starts on: ${DateFormat('yyyy-MM-dd').format(weekStart)}');

      // Process pose activities
      for (var row in poseActivitiesResponse) {
        final raw = DateTime.parse(row['completed_at']).toLocal();
        final date = DateTime(raw.year, raw.month, raw.day);
        final key = DateFormat('yyyy-MM-dd').format(date);
        _activityDays[key] = true;

        final level = row['session_level'] as String;
        final completedAt = raw;

        grouped.putIfAbsent(level, () => []).add(completedAt);

        final durationSeconds = (row['duration_seconds'] ?? 0) as int;
        totalSeconds += durationSeconds;

        if (!date.isBefore(weekStart)) {
          weekSeconds += durationSeconds;
          print('🔍 DEBUG: Adding ${durationSeconds}s from $key to weekly total');
        }
      }

      // Infer sessions (30 min gap rule)
      int sessionCount = 0;

      grouped.forEach((level, times) {
        times.sort();
        DateTime? last;

        for (final t in times) {
          if (last == null || t.difference(last).inMinutes > 30) {
            sessionCount++;
          }
          last = t;
        }
      });

      final totalMinutesConverted = (totalSeconds / 60).ceil();
      final weekMinutesConverted = (weekSeconds / 60).ceil();

      print('🔍 DEBUG: Total sessions: $sessionCount');
      print('🔍 DEBUG: Total seconds: $totalSeconds, Minutes: $totalMinutesConverted');
      print('🔍 DEBUG: Weekly seconds: $weekSeconds, Minutes: $weekMinutesConverted');
      print('🔍 DEBUG: Activity days: ${_activityDays.keys.toList()}');

      // Load wellness reflections
      final reflectionsResponse = await supabase
          .from('feedback')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);

      if (!mounted) return;

      setState(() {
        _reflections = List<Map<String, dynamic>>.from(reflectionsResponse);
      });

      _hasCheckInThisWeek = _reflections.any((r) {
        final date = DateTime.parse(r['created_at']);
        return !date.isBefore(weekStart);
      });

      _currentStreak = _calculateStreak();
      _weeklyMinutes = weekMinutesConverted;
      _totalSessions = sessionCount;
      _totalMinutes = totalMinutesConverted;

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  int _calculateStreak() {
    if (_activityDays.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    while (true) {
      final key = DateFormat('yyyy-MM-dd').format(checkDate);
      if (_activityDays[key] == true) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  String _getCurrentBadge() {
    if (_weeklyMinutes >= 240) return 'Platinum';
    if (_weeklyMinutes >= 180) return 'Gold';
    if (_weeklyMinutes >= 120) return 'Silver';
    if (_weeklyMinutes >= 60) return 'Bronze';
    return 'None';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF40E0D0)),
        ),
      );
    }

    if (_error != null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading progress', style: GoogleFonts.poppins(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProgressData,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF40E0D0)),
                child: Text('Retry', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 1200 : double.infinity,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWeb ? 40 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Your Progress',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 36 : 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track your journey to wellness',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 18 : 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: isWeb ? 48 : 32),

                    // On web: 2-column layout to use horizontal space properly.
                    // On mobile: single column, same order as before.
                    if (isWeb) ...[
                      // Row 1: Stats | Wellness
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildStatsOverview()),
                          const SizedBox(width: 24),
                          Expanded(child: _buildWellnessCheckInCard()),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Row 2: Weekly Progress | Calendar
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildWeeklyProgress()),
                          const SizedBox(width: 24),
                          Expanded(child: _buildPracticeCalendar()),
                        ],
                      ),
                    ] else ...[
                      _buildStatsOverview(),
                      const SizedBox(height: 24),
                      _buildWellnessCheckInCard(),
                      const SizedBox(height: 24),
                      _buildWeeklyProgress(),
                      const SizedBox(height: 24),
                      _buildPracticeCalendar(),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildStatsOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF40E0D0).withOpacity(0.1),
            const Color(0xFF40E0D0).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatItem(
                icon: Icons.local_fire_department,
                value: _currentStreak.toString(),
                label: 'Day Streak',
                color: const Color(0xFFFF6B6B),
              )),
              Container(width: 1, height: 50, color: Colors.grey[300]),
              Expanded(child: _buildStatItem(
                icon: Icons.self_improvement,
                value: _totalSessions.toString(),
                label: 'Sessions',
                color: const Color(0xFF40E0D0),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem(
                icon: Icons.access_time,
                value: _totalMinutes.toString(),
                label: 'Total Minutes',
                color: const Color(0xFF9D7FEA),
              )),
              Container(width: 1, height: 50, color: Colors.grey[300]),
              Expanded(child: _buildStatItem(
                icon: Icons.emoji_events,
                value: _getCurrentBadge(),
                label: 'This Week',
                color: const Color(0xFFFFD700),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWellnessCheckInCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF40E0D0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFF40E0D0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wellness Check-in',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _hasCheckInThisWeek
                          ? 'Checked in this week ✓'
                          : 'Share how you\'re feeling',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _hasCheckInThisWeek
                            ? const Color(0xFF40E0D0)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showWellnessDialog,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: Text(
                    'New Check-in',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF40E0D0),
                    side: const BorderSide(color: Color(0xFF40E0D0)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showReflectionHistory,
                  icon: const Icon(Icons.history, size: 18),
                  label: Text(
                    'View History',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40E0D0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    final progress = (_weeklyMinutes / _weeklyGoal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_weeklyMinutes min',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF40E0D0),
                ),
              ),
              Text(
                'Goal: $_weeklyGoal min',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF40E0D0)),
            ),
          ),

          const SizedBox(height: 20),

          // Badges
          Text(
            'Weekly Badges',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadge('Bronze', 60, Icons.emoji_events, const Color(0xFFCD7F32)),
              _buildBadge('Silver', 120, Icons.emoji_events, const Color(0xFFC0C0C0)),
              _buildBadge('Gold', 180, Icons.emoji_events, const Color(0xFFFFD700)),
              _buildBadge('Platinum', 240, Icons.diamond, const Color(0xFF40E0D0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String name, int minutes, IconData icon, Color color) {
    final achieved = _weeklyMinutes >= minutes;

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: achieved ? color.withOpacity(0.1) : Colors.grey[100],
            shape: BoxShape.circle,
            border: Border.all(
              color: achieved ? color : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: achieved ? color : Colors.grey[400],
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: achieved ? color : Colors.grey[500],
          ),
        ),
        Text(
          '${minutes}m',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeCalendar() {
    return Container(
      padding: EdgeInsets.all(isWeb ? 28 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calendar',
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 22 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: isWeb ? 24 : 20),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month - 1,
                        );
                      });
                      _loadProgressData();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('MMM yyyy').format(_currentMonth),
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 16 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: isWeb ? 24 : 20),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        );
                      });
                      _loadProgressData();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Weekday headers — stretch on web, fixed on mobile
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((day) => isWeb
                ? Expanded(
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            )
                : SizedBox(
              width: 36,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 12),

          _buildCalendarGrid(),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Practice', const Color(0xFF40E0D0)),
              const SizedBox(width: 20),
              _buildLegend('Rest day', Colors.grey[200]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;

    int offset = firstDay.weekday - 1;
    if (offset < 0) offset = 6;

    // Web: proper 7-column grid, fixed row height so circles stay compact
    if (isWeb) {
      List<Widget> rows = [];
      int cellIndex = 0;

      while (cellIndex < offset + daysInMonth) {
        List<Widget> rowCells = [];
        for (int col = 0; col < 7; col++) {
          if (cellIndex < offset) {
            rowCells.add(const Expanded(child: SizedBox()));
          } else {
            final day = cellIndex - offset + 1;
            if (day > daysInMonth) {
              rowCells.add(const Expanded(child: SizedBox()));
            } else {
              final date = DateTime(_currentMonth.year, _currentMonth.month, day);
              final key = DateFormat('yyyy-MM-dd').format(date);
              final hasActivity = _activityDays[key] == true;
              final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == key;

              rowCells.add(Expanded(
                child: _buildCalendarDay(day, hasActivity, isToday),
              ));
            }
          }
          cellIndex++;
        }
        rows.add(SizedBox(height: 44, child: Row(children: rowCells)));
        rows.add(const SizedBox(height: 4));
      }

      return Column(children: rows);
    }

    // Mobile: original Wrap layout with fixed 36px circles
    List<Widget> dayWidgets = [];

    for (int i = 0; i < offset; i++) {
      dayWidgets.add(const SizedBox(width: 36, height: 36));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final key = DateFormat('yyyy-MM-dd').format(date);
      final hasActivity = _activityDays[key] == true;
      final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == key;

      dayWidgets.add(_buildCalendarDay(day, hasActivity, isToday));
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: dayWidgets,
    );
  }

  Widget _buildCalendarDay(int day, bool hasActivity, bool isToday) {
    final Widget circle = Container(
      width: isWeb ? 40 : 36,
      height: isWeb ? 40 : 36,
      decoration: BoxDecoration(
        color: hasActivity ? const Color(0xFF40E0D0) : Colors.grey[100],
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: Colors.black87, width: 2) : null,
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 15 : 13,
            fontWeight: FontWeight.w500,
            color: hasActivity ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );

    // Web: center the fixed-size circle inside the Expanded column cell
    if (isWeb) {
      return Center(child: circle);
    }

    // Mobile: the circle IS the widget (fixed 36x36, used inside Wrap)
    return circle;
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> _showWellnessDialog() async {
    final saved = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _WellnessCheckInDialog(
        onSubmit: (data) {
          Navigator.of(context).pop(data); // return Map
        },
      ),
    );

    if (saved == null) return;
    if (!mounted) return; //

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase.from('feedback').insert({
        'user_id': userId,
        'feedback_week': 1,
        'fitness_improvement': saved['bodyComfort'],
        'flexibility_improvement': saved['flexibility'],
        'balance_rating': saved['balance'],
        'energy_level': saved['energyLevel'],
        'mental_wellbeing': saved['mood'],
        'daily_confidence': saved['dailyConfidence'],
        'body_connection': saved['bodyConnection'],
        'satisfaction_level': saved['overallWellbeing'],
        'additional_comments': saved['notes'],
        'created_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      await _loadProgressData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wellness check-in saved!')),
      );
    } catch (e) {
      print("INSERT ERROR: $e");
    }
  }

  void _showReflectionHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ReflectionHistoryScreen(reflections: _reflections),
      ),
    );
  }
}

// Wellness Check-in Dialog
class _WellnessCheckInDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const _WellnessCheckInDialog({required this.onSubmit});

  @override
  State<_WellnessCheckInDialog> createState() => _WellnessCheckInDialogState();
}

class _WellnessCheckInDialogState extends State<_WellnessCheckInDialog> {
  int? _bodyComfort;
  int? _flexibility;
  int? _balance;
  int? _energyLevel;
  int? _mood;
  int? _dailyConfidence;
  int? _bodyConnection;
  int? _overallWellbeing;
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wellness Check-in',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'How are you feeling today?',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRatingQuestion('How comfortable does your body feel when doing yoga?', _bodyComfort, (v) => setState(() => _bodyComfort = v)),
                    _buildRatingQuestion('How would you rate your flexibility recently?', _flexibility, (v) => setState(() => _flexibility = v)),
                    _buildRatingQuestion('How steady do you feel when standing or balancing?', _balance, (v) => setState(() => _balance = v)),
                    _buildRatingQuestion('How is your overall energy level?', _energyLevel, (v) => setState(() => _energyLevel = v)),
                    _buildRatingQuestion('How has your mood been lately?', _mood, (v) => setState(() => _mood = v)),
                    _buildRatingQuestion('How confident do you feel doing your daily activities?', _dailyConfidence, (v) => setState(() => _dailyConfidence = v)),
                    _buildRatingQuestion('How connected do you feel to your body during yoga practice?', _bodyConnection, (v) => setState(() => _bodyConnection = v)),
                    _buildRatingQuestion('Overall, how have you been feeling in your body and mind?', _overallWellbeing, (v) => setState(() => _overallWellbeing = v)),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Notes (optional)',
                        labelStyle: GoogleFonts.poppins(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.poppins()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_bodyComfort != null &&
                          _flexibility != null &&
                          _balance != null &&
                          _energyLevel != null &&
                          _mood != null &&
                          _dailyConfidence != null &&
                          _bodyConnection != null &&
                          _overallWellbeing != null) {
                        widget.onSubmit({
                          'bodyComfort': _bodyComfort,
                          'flexibility': _flexibility,
                          'balance': _balance,
                          'energyLevel': _energyLevel,
                          'mood': _mood,
                          'dailyConfidence': _dailyConfidence,
                          'bodyConnection': _bodyConnection,
                          'overallWellbeing': _overallWellbeing,
                          'notes': _notesController.text,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please rate all categories',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40E0D0),
                    ),
                    child: Text('Submit', style: GoogleFonts.poppins(color: Colors.white,)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingQuestion(String label, int? value, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          WellnessGauge(
            value: value ?? 0,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Reflection History Screen
class _ReflectionHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reflections;

  const _ReflectionHistoryScreen({required this.reflections});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reflection History',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: reflections.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No reflections yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: reflections.length,
        itemBuilder: (context, index) {
          final reflection = reflections[index];
          final date = DateTime.parse(reflection['created_at']);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xFF40E0D0),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM dd, yyyy').format(date),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF40E0D0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReflectionItem('Body Comfort', reflection['fitness_improvement']),
                _buildReflectionItem('Flexibility', reflection['flexibility_improvement']),
                _buildReflectionItem('Balance', reflection['balance_rating']),
                _buildReflectionItem('Energy', reflection['energy_level']),
                _buildReflectionItem('Mood', reflection['mental_wellbeing']),
                _buildReflectionItem('Confidence', reflection['daily_confidence']),
                _buildReflectionItem('Mind-Body', reflection['body_connection']),
                _buildReflectionItem('Wellbeing', reflection['satisfaction_level']),

                if (reflection['additional_comments'] != null &&
                    reflection['additional_comments'].toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Notes:',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reflection['additional_comments'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReflectionItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.circle,
                size: 8,
                color: index < (value ?? 0)
                    ? const Color(0xFF40E0D0)
                    : Colors.grey[300],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class WellnessGauge extends StatelessWidget {
  final int value;
  final Function(int) onChanged;

  const WellnessGauge({
    super.key,
    required this.value,
    required this.onChanged,
  });

  double get angle {
    if (value == 0) return -pi / 2;
    return -pi / 2 + ((value - 1) / 4) * pi;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(240, 120),
                painter: _GaugePainter(),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _EmojiPainter(),
                ),
              ),
              Positioned(
                bottom: 20, // ⬅ increase = lower, decrease = higher
                child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()..rotateZ(angle),
                  child: CustomPaint(
                    size: const Size(20, 65),
                    painter: _NeedlePainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) {
            final index = i + 1;
            return GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: value == index
                        ? Colors.green
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  "$index",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: value == index
                        ? Colors.green
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final colors = [
      Colors.red.shade300,
      Colors.orange.shade300,
      Colors.yellow.shade400,
      Colors.green.shade300,
      Colors.teal.shade300,
    ];

    double start = pi;
    for (var c in colors) {
      paint.color = c;
      canvas.drawArc(rect, start, pi / 5, false, paint);
      start += pi / 5;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _EmojiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.4;

    final faces = ["😠", "😕", "😐", "🙂", "😄"];

    for (int i = 0; i < 5; i++) {
      final angle = pi + (i + 0.5) * (pi / 5);

      final offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: faces[i],
          style: const TextStyle(fontSize: 22),
        ),
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr, // 🔒 forced
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        offset -
            Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.35, size.height);
    path.lineTo(size.width * 0.65, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
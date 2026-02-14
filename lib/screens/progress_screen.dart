import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:ui' as ui;
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

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
    if (_weeklyMinutes >= 240) return AppLocalizations.of(context)!.platinum;
    if (_weeklyMinutes >= 180) return AppLocalizations.of(context)!.gold;
    if (_weeklyMinutes >= 120) return AppLocalizations.of(context)!.silver;
    if (_weeklyMinutes >= 60) return AppLocalizations.of(context)!.bronze;
    return AppLocalizations.of(context)!.none;
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
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  _loadProgressData();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF40E0D0)),
                child: Text('Retry', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD4F1F0),
                  Color(0xFFFFFFFF),
                  Color(0xFFE9F8F7),
                  Color(0xFFFFE9DB),
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWeb ? 1200 : double.infinity,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isWeb ? 40 : 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header - simplified
                        Text(
                          'Activity Summary',
                          style: GoogleFonts.poppins(
                            fontSize: isWeb ? 32 : 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: isWeb ? 32 : 24),

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

                          // Daily minutes chart (full width)
                          _buildDailyMinutesChart(),

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
                          _buildWeeklyProgress(),
                          const SizedBox(height: 16),
                          _buildWellnessCheckInCard(),
                          const SizedBox(height: 16),
                          _buildStatsOverview(),
                          const SizedBox(height: 16),
                          _buildDailyMinutesChart(),
                          const SizedBox(height: 24),
                          _buildPracticeCalendar(),
                        ],

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ))
    );
  }

  Widget _buildStatsOverview() {
    return Column(
      children: [
        // First row: Streak and Sessions
        Row(
          children: [
            Expanded(
              child: _buildStatBox(
                icon: Icons.local_fire_department,
                iconColor: const Color(0xFFFF6B6B),
                iconBgColor: const Color(0xFFFFE5E5),
                value: _currentStreak.toString(),
                label: 'Streak',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatBox(
                icon: Icons.self_improvement,
                iconColor: const Color(0xFF40E0D0),
                iconBgColor: const Color(0xFFE0F7F4),
                value: _totalSessions.toString(),
                label: 'Sessions',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Second row: Total Minutes and Badge
        Row(
          children: [
            Expanded(
              child: _buildStatBox(
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFF9D7FEA),
                iconBgColor: const Color(0xFFF3EFFF),
                value: _totalMinutes.toString(),
                label: 'Minutes',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatBox(
                icon: Icons.emoji_events,
                iconColor: const Color(0xFFFFD700),
                iconBgColor: const Color(0xFFFFF8E1),
                value: _getCurrentBadge(),
                label: 'This Week',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xE4E9FFFC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMinutesChart() {
    // Get last 7 days of activity
    final now = DateTime.now();
    final List<Map<String, dynamic>> weekData = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final dayName = DateFormat('E').format(date).substring(0, 3);

      // Calculate minutes for this day (simplified - you may need to adjust based on your data structure)
      int minutesForDay = 0;
      if (_activityDays[dateKey] == true) {
        // Estimate based on average session length
        minutesForDay = (_totalMinutes / max(_activityDays.length, 1)).round();
      }

      weekData.add({
        'day': dayName,
        'minutes': minutesForDay,
        'isToday': i == 0,
      });
    }

    final maxMinutes = weekData.map((d) => d['minutes'] as int).reduce(max).toDouble();
    final hasData = maxMinutes > 0;

    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Text(
                'Daily Minutes',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                'Week',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (!hasData)
          // No data message
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nothing tracked yet',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
          // Chart with bars
            SizedBox(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weekData.map((data) {
                  final minutes = data['minutes'] as int;
                  final dayName = data['day'] as String;
                  final isToday = data['isToday'] as bool;
                  final heightRatio = maxMinutes > 0 ? (minutes / maxMinutes) : 0.0;
                  final barHeight = 100 * heightRatio;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (minutes > 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '$minutes',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isToday ? const Color(0xFF40E0D0) : Colors.black87,
                                ),
                              ),
                            ),
                          Container(
                            height: max(barHeight, minutes > 0 ? 20 : 10),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? const Color(0xFFFFB74D)
                                  : const Color(0xFF40E0D0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dayName,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWellnessCheckInCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xE4E9FFFC),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: const Color(0xFF000000),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wellness Check-In',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _hasCheckInThisWeek
                          ? 'Checked in this week ✓'
                          : 'How are you feeling?',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: _hasCheckInThisWeek
                            ? const Color(0xFF40E0D0)
                            : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await GlobalAudioService.playClickSound();
                    _showWellnessDialog();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF40E0D0),
                    side: const BorderSide(color: Color(0xFF40E0D0), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle, size: 25),
                      const SizedBox(width: 8),
                      Text(
                        'Check-In',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await GlobalAudioService.playClickSound();
                    _showReflectionHistory();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40E0D0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'History',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
          // Header
          Text(
            'This Week',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 28),

          // Circular progress chart
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: progress,
                      progressColor: const Color(0xFF40E0D0),
                      backgroundColor: Colors.grey[200]!,
                    ),
                  ),
                ),

                // Center content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    // Minutes value
                    Text(
                      '$_weeklyMinutes',
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.0,
                      ),
                    ),

                    Text(
                      'min',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'of $_weeklyGoal min',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Badges section
          Text(
            'Weekly Badges',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadge('Bronze', 60, Icons.emoji_events, const Color(0xFFCD7F32)),
              _buildBadge('Silver', 120, Icons.emoji_events, const Color(0xFFC0C0C0)),
              _buildBadge('Gold', 180, Icons.emoji_events, const Color(0xFFFFD700)),
              _buildBadge('Platinum', 240, Icons.diamond, const Color(0xFFB9F2FF)),
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
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: achieved ? Colors.white : Colors.grey[50],
            shape: BoxShape.circle,
            border: Border.all(
              color: achieved ? color : Colors.grey[300]!,
              width: 3,
            ),
            boxShadow: achieved ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: Center(
            child: Icon(
              icon,
              color: achieved ? color : Colors.grey[400],
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: achieved ? Colors.black87 : Colors.grey[500],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$minutes min',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeCalendar() {
    return Container(
      padding: EdgeInsets.all(isWeb ? 28 : 24),
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
                AppLocalizations.of(context)!.calendar,
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 22 : 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: () async {
                      await GlobalAudioService.playClickSound();
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
                    DateFormat.yMMM(Localizations.localeOf(context).toString()).format(_currentMonth),
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 16 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    onPressed: () async {
                      await GlobalAudioService.playClickSound();
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
              _buildLegend(AppLocalizations.of(context)!.practice, const Color(0xFF40E0D0)),
              const SizedBox(width: 20),
              _buildLegend(AppLocalizations.of(context)!.restDay, Colors.grey[200]!),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.checkInSaved)),
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
              AppLocalizations.of(context)!.wellnessDialogTitle,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.wellnessDialogSubtitle,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRatingQuestion(AppLocalizations.of(context)!.qBodyComfort, _bodyComfort, (v) => setState(() => _bodyComfort = v)),
                    _buildRatingQuestion(AppLocalizations.of(context)!.qFlexibility, _flexibility, (v) => setState(() => _flexibility = v)),
                    _buildRatingQuestion(AppLocalizations.of(context)!.qBalance, _balance, (v) => setState(() => _balance = v)),
                    _buildRatingQuestion(AppLocalizations.of(context)!.qEnergy, _energyLevel, (v) => setState(() => _energyLevel = v)),
                    _buildRatingQuestion(AppLocalizations.of(context)!.qMood, _mood, (v) => setState(() => _mood = v)),
                    _buildRatingQuestion(AppLocalizations.of(context)!.qConfidence, _dailyConfidence, (v) => setState(() => _dailyConfidence = v)),
                    _buildRatingQuestion(AppLocalizations.of(context)!.qBodyConnection, _bodyConnection, (v) => setState(() => _bodyConnection = v)),
                    _buildRatingQuestion(AppLocalizations.of(context)!.qOverall, _overallWellbeing, (v) => setState(() => _overallWellbeing = v)),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.notesOptional,
                        labelStyle: GoogleFonts.poppins(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 16),
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
                    onPressed: () async {
                      await GlobalAudioService.playClickSound();
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.cancel, style: GoogleFonts.poppins()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await GlobalAudioService.playClickSound();
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
                              AppLocalizations.of(context)!.rateAllError,
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40E0D0),
                    ),
                    child: Text(AppLocalizations.of(context)!.submit, style: GoogleFonts.poppins(color: Colors.white,)),
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
              fontSize: 16,
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
          onPressed: () async {
            await GlobalAudioService.playClickSound();
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.reflectionHistory,
          style: GoogleFonts.poppins(
            fontSize: 22,
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
              AppLocalizations.of(context)!.noReflections,
              style: GoogleFonts.poppins(
                fontSize: 20,
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
                      size: 20,
                      color: Color(0xFF40E0D0),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF40E0D0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildReflectionItem(AppLocalizations.of(context)!.bodyComfort, reflection['fitness_improvement']),
                _buildReflectionItem(AppLocalizations.of(context)!.flexibility, reflection['flexibility_improvement']),
                _buildReflectionItem(AppLocalizations.of(context)!.balance, reflection['balance_rating']),
                _buildReflectionItem(AppLocalizations.of(context)!.energy, reflection['energy_level']),
                _buildReflectionItem(AppLocalizations.of(context)!.mood, reflection['mental_wellbeing']),
                _buildReflectionItem(AppLocalizations.of(context)!.confidence, reflection['daily_confidence']),
                _buildReflectionItem(AppLocalizations.of(context)!.mindBody, reflection['body_connection']),
                _buildReflectionItem(AppLocalizations.of(context)!.wellbeing, reflection['satisfaction_level']),

                if (reflection['additional_comments'] != null &&
                    reflection['additional_comments'].toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.notes,
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
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.circle,
                size: 14,
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

// Circular progress painter for weekly progress
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 16.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
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
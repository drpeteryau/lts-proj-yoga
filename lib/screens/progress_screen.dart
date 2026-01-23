import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import './wellness_dialog.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _error;

  // Data
  int _currentStreak = 0;
  int _streakWeeks = 0;
  int _totalActivities = 0;
  Map<String, int> _monthActivityMap = {}; // day -> minutes
  Map<String, String> _dailyReflections = {};
  List<ChartData> _chartData = [];
  DateTime _currentMonth = DateTime.now();

  // Weekly Progress & Trophies
  int _weeklyMinutes = 0;
  int _weeklyGoal = 300;
  String _currentTrophy = 'None';

  // Monthly Wellness Check-in
  bool _showWellnessDialog = false;
  int? _lastFeedbackWeek;

  // Wellness form values
  int? _bodyComfort;
  int? _flexibility;
  int? _balance;
  int? _energyLevel;
  int? _mood;
  int? _dailyConfidence;
  int? _bodyConnection;
  int? _overallWellbeing;
  String _balanceReflection = '';
  String _postureReflection = '';
  String _consistencyReflection = '';
  String _otherReflection = '';

  Future<void> _loadDailyFeedback(String userId) async {
    final response = await supabase
        .from('feedback')
        .select()
        .eq('user_id', userId);

    _dailyReflections.clear();

    for (var row in response) {
      final raw = row['created_at'].toString();
      final date = DateTime.parse(raw.split('T')[0]);
      final key = DateFormat('yyyy-MM-dd').format(date);

      final summary = '''
      Body Comfort: ${row['fitness_improvement']}
      Flexibility: ${row['flexibility_improvement']}
      Balance: ${row['balance_rating']}
      Energy: ${row['energy_level']}
      Mood: ${row['mental_wellbeing']}
      Confidence: ${row['daily_confidence']}
      Body Connection: ${row['body_connection']}
      Wellbeing: ${row['satisfaction_level']}
      
      ${row['additional_comments'] ?? ''}
      ''';

      _dailyReflections[key] = summary;
    }
  }

  String _buildWeeklyReflectionSummary() {
    if (_dailyReflections.isEmpty) return "No reflections yet.";

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    int moodTotal = 0, energyTotal = 0, count = 0;

    _dailyReflections.forEach((dateKey, summary) {
      final date = DateTime.parse(dateKey);
      if (!date.isBefore(weekStart)) {
        final lines = summary.split('\n');
        moodTotal += int.tryParse(lines[4].split(':').last.trim()) ?? 0;
        energyTotal += int.tryParse(lines[3].split(':').last.trim()) ?? 0;
        count++;
      }
    });

    if (count == 0) return "No check-ins yet this week.";

    final avgMood = (moodTotal / count).round();
    final avgEnergy = (energyTotal / count).round();

    if (avgMood >= 4 && avgEnergy >= 4) {
      return "You’ve had a strong and positive week 🌟 Keep it up!";
    } else if (avgMood <= 2) {
      return "This week was a little tough 💛 Be kind to yourself.";
    } else {
      return "You’re making steady progress 🌿 Keep going.";
    }
  }

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
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // 1. Fetch all sessions for chart (last 3 months)
      final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
      final sessionsResponse = await supabase
          .from('sessions')
          .select()
          .eq('user_id', userId)
          .gte('date_completed', threeMonthsAgo.toIso8601String().split('T')[0])
          .order('date_completed', ascending: true);

      // 2. Calculate total activities
      final allSessionsResponse = await supabase
          .from('sessions')
          .select()
          .eq('user_id', userId);
      _totalActivities = (allSessionsResponse as List).length;

      // 3. Calculate current streak
      _currentStreak = await _calculateCurrentStreak(userId);
      _streakWeeks = (_currentStreak / 7).floor();

      // 4. Build chart data (weekly aggregation)
      _chartData = _buildChartData(sessionsResponse);

      // 5. Build current month activity map
      final start = DateTime(_currentMonth.year, _currentMonth.month, 1);
      final end = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);

      final monthSessionsResponse = await supabase
          .from('sessions')
          .select()
          .eq('user_id', userId)
          .gte('date_completed', DateFormat('yyyy-MM-dd').format(start))
          .lt('date_completed', DateFormat('yyyy-MM-dd').format(end));

      _monthActivityMap = {};
      for (var session in monthSessionsResponse) {
        final raw = session['date_completed'].toString();
        final date = DateTime.parse(raw.split('T')[0]);
        final key = DateFormat('yyyy-MM-dd').format(date);

        _monthActivityMap[key] =
            (_monthActivityMap[key] ?? 0) +
                (session['duration_minutes'] as int? ?? 0);
      }

      // 6. Fetch current week progress from weekly_progress table
      await _fetchWeeklyProgress(userId);

      // 7. Check if monthly wellness check-in is due
      await _checkWellnessDialog(userId);

      await _loadDailyFeedback(userId);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeeklyProgress(String userId) async {
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekStartStr = DateFormat('yyyy-MM-dd').format(weekStart);

      // Always recalc from sessions
      final weekSessionsResponse = await supabase
          .from('sessions')
          .select()
          .eq('user_id', userId)
          .gte('date_completed', weekStartStr);

      int total = 0;
      for (var session in weekSessionsResponse) {
        total += (session['duration_minutes'] as int? ?? 0);
      }

      _weeklyMinutes = total;
      _weeklyGoal = 300;

      // Upsert into weekly_progress for history
      await supabase.from('weekly_progress').upsert({
        'user_id': userId,
        'week_start': weekStartStr,
        'minutes_completed': _weeklyMinutes,
        'weekly_goal': _weeklyGoal,
      });

      // Trophy logic
      if (_weeklyMinutes >= 240) {
        _currentTrophy = 'Platinum';
      } else if (_weeklyMinutes >= 180) {
        _currentTrophy = 'Gold';
      } else if (_weeklyMinutes >= 120) {
        _currentTrophy = 'Silver';
      } else if (_weeklyMinutes >= 60) {
        _currentTrophy = 'Bronze';
      } else {
        _currentTrophy = 'None';
      }
    } catch (e) {
      print('Error fetching weekly progress: $e');
    }
  }

  Future<void> _checkWellnessDialog(String userId) async {
    try {
      // Get the count of feedback entries
      final feedbackResponse = await supabase
          .from('feedback')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1);

      if (feedbackResponse.isEmpty) {
        // First time user - show after 4 weeks
        final firstSession = await supabase
            .from('sessions')
            .select('date_completed')
            .eq('user_id', userId)
            .order('date_completed', ascending: true)
            .limit(1);

        if (firstSession.isNotEmpty) {
          final firstDate = DateTime.parse(firstSession[0]['date_completed']);
          final weeksSinceStart = DateTime.now().difference(firstDate).inDays ~/ 7;

          if (weeksSinceStart >= 4) {
            _showWellnessDialog = true;
            _lastFeedbackWeek = 1;
          }
        }
      } else {
        // Check if 4 weeks have passed since last feedback
        final lastFeedback = feedbackResponse[0];
        final lastFeedbackDate = DateTime.parse(lastFeedback['created_at']);
        final weeksSinceLast = DateTime.now().difference(lastFeedbackDate).inDays ~/ 7;

        if (weeksSinceLast >= 4) {
          _showWellnessDialog = true;
          _lastFeedbackWeek = (lastFeedback['feedback_week'] ?? 0) + 1;
        }
      }
    } catch (e) {
      print('Error checking wellness dialog: $e');
    }
  }

  List<ChartData> _buildChartData(List<dynamic> sessions) {
    // Group by week and calculate total minutes
    Map<String, double> weeklyData = {};

    for (var session in sessions) {
      final date = DateTime.parse(session['date_completed']).toLocal();
      final weekKey = _getWeekKey(date);
      weeklyData[weekKey] = (weeklyData[weekKey] ?? 0) +
          (session['duration_minutes'] as int? ?? 0).toDouble();
    }

    // Convert to chart data points
    final sortedWeeks = weeklyData.keys.toList()..sort();
    return sortedWeeks.asMap().entries.map((entry) {
      return ChartData(
        x: entry.key.toDouble(),
        y: weeklyData[entry.value]!,
        weekLabel: entry.value,
      );
    }).toList();
  }

  String _getWeekKey(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    return '${weekStart.year}-W${weekStart.month.toString().padLeft(2, '0')}';
  }

  Future<int> _calculateCurrentStreak(String userId) async {
    try {
      final sessionsResponse = await supabase
          .from('sessions')
          .select('date_completed')
          .eq('user_id', userId)
          .order('date_completed', ascending: false);

      if (sessionsResponse.isEmpty) return 0;

      final uniqueDates = <String>{};
      for (var session in sessionsResponse) {
        uniqueDates.add(session['date_completed']);
      }

      final sortedDates = uniqueDates.toList()..sort((a, b) => b.compareTo(a));

      int streak = 0;
      DateTime? lastDate;

      for (var dateStr in sortedDates) {
        final currentDate = DateTime.parse(dateStr);

        if (lastDate == null) {
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));

          if (_isSameDay(currentDate, today) || _isSameDay(currentDate, yesterday)) {
            streak = 1;
            lastDate = currentDate;
          } else {
            break;
          }
        } else {
          final dayDiff = lastDate.difference(currentDate).inDays;
          if (dayDiff == 1) {
            streak++;
            lastDate = currentDate;
          } else {
            break;
          }
        }
      }

      return streak;
    } catch (e) {
      return 0;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
    _loadProgressData();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
    _loadProgressData();
  }

  Future<void> _submitWellnessFeedback() async {
    // Validate all required fields
    if (_bodyComfort == null ||
        _flexibility == null ||
        _balance == null ||
        _energyLevel == null ||
        _mood == null ||
        _dailyConfidence == null ||
        _bodyConnection == null ||
        _overallWellbeing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all required questions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Combine reflections into a structured format
      final reflections = <String, String>{
        'balance': _balanceReflection.trim(),
        'posture': _postureReflection.trim(),
        'consistency': _consistencyReflection.trim(),
        'other': _otherReflection.trim(),
      };

      // Create a formatted comment string
      final List<String> commentParts = [];
      if (_balanceReflection.trim().isNotEmpty) {
        commentParts.add('Balance: ${_balanceReflection.trim()}');
      }
      if (_postureReflection.trim().isNotEmpty) {
        commentParts.add('Posture: ${_postureReflection.trim()}');
      }
      if (_consistencyReflection.trim().isNotEmpty) {
        commentParts.add('Consistency: ${_consistencyReflection.trim()}');
      }
      if (_otherReflection.trim().isNotEmpty) {
        commentParts.add('Other: ${_otherReflection.trim()}');
      }

      final combinedComments = commentParts.isNotEmpty
          ? commentParts.join('\n\n')
          : null;

      // Insert feedback into database
      final feedbackData = {
        'user_id': userId,
        'feedback_week': _lastFeedbackWeek ?? 1,
        'flexibility_improvement': _flexibility,
        'fitness_improvement': _bodyComfort,
        'mental_wellbeing': _mood,
        'satisfaction_level': _overallWellbeing,
        'additional_comments': combinedComments,
        'created_at': DateTime.now().toIso8601String(),
        // Add new fields for comprehensive tracking
        'balance_rating': _balance,
        'energy_level': _energyLevel,
        'daily_confidence': _dailyConfidence,
        'body_connection': _bodyConnection,
      };

      print('Submitting feedback: $feedbackData');

      final response = await supabase
          .from('feedback')
          .insert(feedbackData)
          .select()
          .single();

      print('✅ Feedback submitted successfully: $response');

      final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final summary = '''
      Body Comfort: $_bodyComfort
      Flexibility: $_flexibility
      Balance: $_balance
      Energy: $_energyLevel
      Mood: $_mood
      Confidence: $_dailyConfidence
      Body Connection: $_bodyConnection
      Wellbeing: $_overallWellbeing
      
      $combinedComments
      ''';

      setState(() {
        _dailyReflections[todayKey] = summary;
      });

      await _loadProgressData();

      // Reset form after successful submission
      setState(() {
        _showWellnessDialog = false;
        _bodyComfort = null;
        _flexibility = null;
        _balance = null;
        _energyLevel = null;
        _mood = null;
        _dailyConfidence = null;
        _bodyConnection = null;
        _overallWellbeing = null;
        _balanceReflection = '';
        _postureReflection = '';
        _consistencyReflection = '';
        _otherReflection = '';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for sharing your wellness check-in!'),
            backgroundColor: Color(0xFF2CC5B6),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error submitting feedback: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting feedback: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showMonthlyWellnessDialog(Color primaryTeal) {
    showSeniorFriendlyWellnessDialog(
      context: context,
      primaryTeal: primaryTeal,
      totalActivities: _totalActivities,
      currentStreak: _currentStreak,
      weeklyMinutes: _weeklyMinutes,
      weeklyGoal: _weeklyGoal,
      bodyComfort: _bodyComfort,
      flexibility: _flexibility,
      balance: _balance,
      energyLevel: _energyLevel,
      mood: _mood,
      dailyConfidence: _dailyConfidence,
      bodyConnection: _bodyConnection,
      overallWellbeing: _overallWellbeing,
      onBodyComfortChanged: (value) => setState(() => _bodyComfort = value),
      onFlexibilityChanged: (value) => setState(() => _flexibility = value),
      onBalanceChanged: (value) => setState(() => _balance = value),
      onEnergyLevelChanged: (value) => setState(() => _energyLevel = value),
      onMoodChanged: (value) => setState(() => _mood = value),
      onDailyConfidenceChanged: (value) => setState(() => _dailyConfidence = value),
      onBodyConnectionChanged: (value) => setState(() => _bodyConnection = value),
      onOverallWellbeingChanged: (value) => setState(() => _overallWellbeing = value),
      onBalanceReflectionChanged: (value) => _balanceReflection = value,
      onPostureReflectionChanged: (value) => _postureReflection = value,
      onConsistencyReflectionChanged: (value) => _consistencyReflection = value,
      onOtherReflectionChanged: (value) => _otherReflection = value,
      onSubmit: _submitWellnessFeedback,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF2CC5B6);
    const pageBg = Color(0xFFF2FCFA);

    // Auto-show wellness dialog
    if (_showWellnessDialog && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showMonthlyWellnessDialog(primaryTeal);
        }
      });
    }

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // Simple Header - Just Title
            _buildHeader(),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryTeal))
                  : _error != null
                      ? _buildError()
                      : RefreshIndicator(
                          onRefresh: _loadProgressData,
                          color: primaryTeal,
                          child: _buildProgressTab(primaryTeal),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: const Center(
        child: Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2CC5B6),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTab(Color primaryTeal) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line Chart
          //_buildChart(primaryTeal),

          //const SizedBox(height: 20),

          // Weekly Reflection Summary
          _buildWeeklyReflectionCard(),
          const SizedBox(height: 20),

          // Weekly Trophy Milestones
          _buildWeeklyTrophies(primaryTeal),

          const SizedBox(height: 20),

          _buildWeeklyDailyBars(primaryTeal),

          const SizedBox(height: 16),

          // Month Header with Navigation
          _buildMonthHeader(),

          const SizedBox(height: 16),

          // Streak Stats
          _buildStreakStats(),

          const SizedBox(height: 20),

          // Calendar
          _buildCalendar(primaryTeal),

          const SizedBox(height: 24),

          // Manual Wellness Feedback Card (Always visible)
          _buildWellnessFeedbackCard(primaryTeal),

          const SizedBox(height: 16),

          // Motivational Section
          _buildMotivationalSection(),
        ],
      ),
    );
  }

  /* Monthly Line Chart used to be above weekly milestones
  Widget _buildChart(Color primaryTeal) {
    if (_chartData.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text('No activity data yet. Start practicing!'),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}m',
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < _chartData.length) {
                    final monthAbbr = _getMonthAbbreviation(_chartData[value.toInt()].weekLabel);
                    return Text(
                      monthAbbr,
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _chartData.map((d) => FlSpot(d.x, d.y)).toList(),
              isCurved: true,
              color: primaryTeal,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: primaryTeal.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  } */

  Widget _buildWeeklyDailyBars(Color primaryTeal) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final Map<int, int> dailyTotals = {};

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      dailyTotals[i] = _monthActivityMap[key] ?? 0;
    }

    final maxValue =
    dailyTotals.values.isEmpty ? 60 : dailyTotals.values.reduce((a, b) => a > b ? a : b) + 10;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Week",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                maxY: maxValue.toDouble(),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                ),
                barGroups: dailyTotals.entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.toDouble(),
                        width: 16,
                        borderRadius: BorderRadius.circular(6),
                        color: primaryTeal,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrophies(Color primaryTeal) {
    final trophies = [
      TrophyMilestone(level: 'Bronze', minutes: 60, icon: '🥉'),
      TrophyMilestone(level: 'Silver', minutes: 120, icon: '🥈'),
      TrophyMilestone(level: 'Gold', minutes: 180, icon: '🥇'),
      TrophyMilestone(level: 'Platinum', minutes: 240, icon: '💎'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryTeal.withOpacity(0.1), const Color(0xFFD0F7F0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.emoji_events, color: Color(0xFF2CC5B6), size: 24),
              SizedBox(width: 8),
              Text(
                'Weekly Milestones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$_weeklyMinutes minutes this week',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: trophies.map((trophy) {
              final isAchieved = _weeklyMinutes >= trophy.minutes;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isAchieved ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAchieved ? primaryTeal : Colors.grey.shade300,
                      width: isAchieved ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(trophy.icon, style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 4),
                      Text(
                        trophy.level,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isAchieved ? primaryTeal : Colors.grey,
                        ),
                      ),
                      Text(
                        '${trophy.minutes}m',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrend() {
    final now = DateTime.now();
    final data = <FlSpot>[];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      final summary = _dailyReflections[key];
      if (summary != null) {
        final mood = int.tryParse(summary.split('\n')[4].split(':').last.trim()) ?? 0;
        data.add(FlSpot((6 - i).toDouble(), mood.toDouble()));
      }
    }

    if (data.isEmpty) return const SizedBox();

    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          maxY: 5,
          minY: 0,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: const Color(0xFF2CC5B6),
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthAbbreviation(String weekKey) {
    final parts = weekKey.split('-W');
    if (parts.length == 2) {
      final month = int.tryParse(parts[1]) ?? 1;
      return DateFormat('MMM').format(DateTime(2024, month));
    }
    return '';
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat('MMMM yyyy').format(_currentMonth),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 32),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildStreakStats() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Streak',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Day $_currentStreak',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Sessions',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_totalActivities',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar(Color primaryTeal) {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map((day) => SizedBox(
                    width: 48,
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),

        // Calendar grid
        _buildCalendarGrid(daysInMonth, startingWeekday, primaryTeal),
      ],
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int startingWeekday, Color primaryTeal) {
    List<Widget> dayWidgets = [];

    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 48, height: 48));
    }

    for (int day = 1; day <= daysInMonth; day++) {

      final dateKey = DateFormat('yyyy-MM-dd')
          .format(DateTime(_currentMonth.year, _currentMonth.month, day));

      final hasActivity = _monthActivityMap.containsKey(dateKey);

      final hasReflection = _dailyReflections.containsKey(dateKey);

      final bgColor = hasReflection
          ? const Color(0xFF6BCF63)
          : hasActivity
          ? const Color(0xFFFF9800)
          : Colors.transparent;

      final borderColor = hasReflection
          ? const Color(0xFF6BCF63)
          : hasActivity
          ? const Color(0xFFFF9800)
          : Colors.grey.shade300;

      dayWidgets.add(
        GestureDetector(
          onTap: hasReflection
              ? () {
            showDialog(
              context: context,
              builder: (_) {
                final raw = _dailyReflections[dateKey]!;
                final lines = raw
                    .split('\n')
                    .where((e) => e.trim().isNotEmpty)
                    .toList();

                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('📅', style: TextStyle(fontSize: 26)),
                              const SizedBox(width: 8),
                              Text(
                                dateKey,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _summaryRow("🧘 Body Comfort", lines[0]),
                          _summaryRow("🤸 Flexibility", lines[1]),
                          _summaryRow("⚖ Balance", lines[2]),
                          _summaryRow("⚡ Energy", lines[3]),
                          _summaryRow("😊 Mood", lines[4]),
                          _summaryRow("💪 Confidence", lines[5]),
                          _summaryRow("🧠 Body Connection", lines[6]),
                          _summaryRow("🌟 Wellbeing", lines[7]),

                          const Divider(height: 28),

                          const Text(
                            "Your Reflections",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            lines.skip(9).join('\n'),
                            style: const TextStyle(fontSize: 14),
                          ),

                          const SizedBox(height: 20),

                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2CC5B6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Close"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
              : null,
          child: Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: (hasActivity || hasReflection) ? 0 : 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: (hasActivity || hasReflection)
                        ? Colors.white
                        : Colors.black,
                    fontWeight: (hasActivity || hasReflection)
                        ? FontWeight.w700
                        : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                if (hasReflection)
                  const Positioned(
                    bottom: 4,
                    child: Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.white,
                    ),
                  )
                else if (hasActivity)
                  const Positioned(
                    bottom: 4,
                    child: Icon(
                      Icons.self_improvement,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    // Wrap in rows of 7
    List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayWidgets.sublist(
            i,
            i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2CC5B6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.split(':').last.trim(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2CC5B6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyReflectionCard() {
    final summary = _buildWeeklyReflectionSummary();

    return Center( // 👈 centers the card
      child: Container(
        width: double.infinity, // remove this if present
        constraints: const BoxConstraints(maxWidth: 340), // 👈 makes it look centered
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "This Week's Wellness",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              summary,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWellnessFeedbackCard(Color primaryTeal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F8F5), Color(0xFFD0F7F0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '🌿',
              style: TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness Check-in',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Share how you\'re feeling and track your progress',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showMonthlyWellnessDialog(primaryTeal);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryTeal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Start',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F8F5), Color(0xFFD0F7F0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 28,
              color: Color(0xFF2CC5B6),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep up the great work!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'You\'re building healthy habits that will benefit you for years to come.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $_error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProgressData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/* -------------------------- Models -------------------------- */

class ChartData {
  final double x;
  final double y;
  final String weekLabel;

  ChartData({
    required this.x,
    required this.y,
    required this.weekLabel,
  });
}

class TrophyMilestone {
  final String level;
  final int minutes;
  final String icon;

  TrophyMilestone({
    required this.level,
    required this.minutes,
    required this.icon,
  });
}
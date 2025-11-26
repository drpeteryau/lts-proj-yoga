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
  Map<int, int> _monthActivityMap = {}; // day -> minutes
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
      final startOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
      final endOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
      
      final monthSessionsResponse = await supabase
          .from('sessions')
          .select()
          .eq('user_id', userId)
          .gte('date_completed', startOfMonth.toIso8601String().split('T')[0])
          .lte('date_completed', endOfMonth.toIso8601String().split('T')[0]);

      _monthActivityMap = {};
      for (var session in monthSessionsResponse) {
        final date = DateTime.parse(session['date_completed']);
        final day = date.day;
        _monthActivityMap[day] = (_monthActivityMap[day] ?? 0) + 
            (session['duration_minutes'] as int? ?? 0);
      }

      // 6. Fetch current week progress from weekly_progress table
      await _fetchWeeklyProgress(userId);

      // 7. Check if monthly wellness check-in is due
      await _checkWellnessDialog(userId);

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
      final weekStartStr = DateTime(weekStart.year, weekStart.month, weekStart.day)
          .toIso8601String()
          .split('T')[0];

      final weeklyProgressResponse = await supabase
          .from('weekly_progress')
          .select()
          .eq('user_id', userId)
          .eq('week_start', weekStartStr)
          .maybeSingle();

      if (weeklyProgressResponse != null) {
        _weeklyMinutes = weeklyProgressResponse['minutes_completed'] ?? 0;
        _weeklyGoal = weeklyProgressResponse['weekly_goal'] ?? 300;
      } else {
        // Calculate from sessions if no record exists
        final weekSessionsResponse = await supabase
            .from('sessions')
            .select()
            .eq('user_id', userId)
            .gte('date_completed', weekStartStr);

        _weeklyMinutes = 0;
        for (var session in weekSessionsResponse) {
          _weeklyMinutes += (session['duration_minutes'] as int? ?? 0);
        }

        // Create weekly_progress record
        await supabase.from('weekly_progress').insert({
          'user_id': userId,
          'week_start': weekStartStr,
          'minutes_completed': _weeklyMinutes,
          'weekly_goal': 300,
        });
      }

      // Determine trophy level
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
      final date = DateTime.parse(session['date_completed']);
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
    if (_bodyComfort == null ||
        _flexibility == null ||
        _balance == null ||
        _energyLevel == null ||
        _mood == null ||
        _dailyConfidence == null ||
        _bodyConnection == null ||
        _overallWellbeing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Combine reflections
      final combinedComments = 'Balance: $_balanceReflection\n'
          'Posture: $_postureReflection\n'
          'Consistency: $_consistencyReflection\n'
          'Other: $_otherReflection';

      await supabase.from('feedback').insert({
        'user_id': userId,
        'feedback_week': _lastFeedbackWeek ?? 1,
        'flexibility_improvement': _flexibility,
        'fitness_improvement': _bodyComfort,
        'mental_wellbeing': _mood,
        'satisfaction_level': _overallWellbeing,
        'additional_comments': combinedComments.trim().isEmpty ? null : combinedComments.trim(),
      });

      setState(() {
        _showWellnessDialog = false;
        // Reset all form values
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for sharing your wellness check-in! 🌿'),
          backgroundColor: Color(0xFF2CC5B6),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
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
        _showMonthlyWellnessDialog(primaryTeal);
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
          _buildChart(primaryTeal),
          
          const SizedBox(height: 20),
          
          // Weekly Trophy Milestones
          _buildWeeklyTrophies(primaryTeal),
          
          const SizedBox(height: 20),
          
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
  }

  String _getMonthAbbreviation(String weekKey) {
    final parts = weekKey.split('-W');
    if (parts.length == 2) {
      final month = int.tryParse(parts[1]) ?? 1;
      return DateFormat('MMM').format(DateTime(2024, month));
    }
    return '';
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
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFF2CC5B6), size: 24),
              const SizedBox(width: 8),
              const Text(
                'Weekly Milestones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$_weeklyMinutes minutes this week',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: trophies.map((trophy) {
              final isAchieved = _weeklyMinutes >= trophy.minutes;
              final isNext = !isAchieved && 
                  trophies.indexOf(trophy) > 0 && 
                  _weeklyMinutes >= trophies[trophies.indexOf(trophy) - 1].minutes ||
                  (trophies.indexOf(trophy) == 0 && !isAchieved);

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isAchieved ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAchieved
                          ? primaryTeal
                          : isNext
                              ? primaryTeal.withOpacity(0.3)
                              : Colors.grey.shade300,
                      width: isAchieved ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        trophy.icon,
                        style: TextStyle(
                          fontSize: 32,
                          color: isAchieved ? null : Colors.grey,
                        ),
                      ),
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
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (isNext && !isAchieved)
                        Text(
                          '${trophy.minutes - _weeklyMinutes}m to go',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF2CC5B6),
                          ),
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
                '$_currentStreak Days',
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
    
    // Add empty cells for days before the first day of month
    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 48, height: 48));
    }
    
    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final hasActivity = _monthActivityMap.containsKey(day);
      final minutes = _monthActivityMap[day] ?? 0;
      
      dayWidgets.add(
        Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: hasActivity ? primaryTeal : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: hasActivity ? primaryTeal : Colors.grey.shade300,
              width: hasActivity ? 0 : 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  color: hasActivity ? Colors.white : Colors.black,
                  fontWeight: hasActivity ? FontWeight.w700 : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              if (hasActivity)
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
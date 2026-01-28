import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/yoga_data.dart';
import 'session_detail_screen.dart';
import '../models/yoga_pose.dart';
import '../models/yoga_session.dart';
import 'pose_detail_screen.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String _userName = 'There';
  String _userEmail = '';
  String? _profileImageUrl;
  int _selectedDayIndex = 2;
  Map<String, int> _dailyMinutes = {}; // Store minutes by date
  bool _isLoadingProgress = true;

  // User progress for filtering poses
  bool _intermediateUnlocked = false;
  bool _advancedUnlocked = false;

  final List<Map<String, dynamic>> _weekDays = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserProgress();
    _generateWeekDays();
    _loadDailyProgress();
  }

  Future<void> _loadUserProgress() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await Supabase.instance.client
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null && mounted) {
        setState(() {
          _intermediateUnlocked = response['intermediate_unlocked'] ?? false;
          _advancedUnlocked = response['advanced_unlocked'] ?? false;
        });
      }
    } catch (e) {
      print('Error loading user progress: $e');
    }
  }

  Future<void> _loadDailyProgress() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() => _isLoadingProgress = false);
      return;
    }

    try {
      // Load pose activities from the last 7 days
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      final response = await Supabase.instance.client
          .from('pose_activity')
          .select()
          .eq('user_id', userId)
          .gte('activity_date', weekAgo.toIso8601String().split('T')[0]);

      // Group by date and sum duration
      Map<String, int> minutesByDate = {};
      for (var row in response) {
        final date = row['activity_date'] as String;
        final seconds = (row['duration_seconds'] ?? 0) as int;
        minutesByDate[date] = (minutesByDate[date] ?? 0) + seconds;
      }

      // Convert seconds to minutes
      _dailyMinutes = minutesByDate.map(
        (date, seconds) => MapEntry(date, (seconds / 60).round()),
      );

      // Update week days with real data
      for (int i = 0; i < _weekDays.length; i++) {
        final day = _weekDays[i];
        final dateKey = day['dateKey'] as String;
        _weekDays[i]['minutesCompleted'] = _dailyMinutes[dateKey] ?? 0;
      }

      if (mounted) {
        setState(() => _isLoadingProgress = false);
      }
    } catch (e) {
      print('Error loading daily progress: $e');
      if (mounted) {
        setState(() => _isLoadingProgress = false);
      }
    }
  }

  void _generateWeekDays() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(const Duration(days: 2));

    for (int i = 0; i < 5; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dateKey =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

      _weekDays.add({
        'day': _getDayName(day.weekday),
        'date': day.day.toString(),
        'dateKey': dateKey,
        'minutesCompleted': 0, // Will be updated by _loadDailyProgress
        'isToday': i == 2,
      });
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (profile != null && mounted) {
        setState(() {
          _userName = (profile['full_name'] as String?) ?? 'There';
          _userEmail = user.email ?? '';
          _profileImageUrl = profile['profile_image_url'];
        });
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Profile header with greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF40E0D0).withOpacity(0.2),
                        border: Border.all(
                          color: const Color(0xFF40E0D0).withOpacity(0.3),
                          width: 2,
                        ),
                        image: _profileImageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_profileImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _profileImageUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Color(0xFF40E0D0),
                              size: 28,
                            )
                          : null,
                    ),

                    const SizedBox(width: 12),

                    // Greeting text with minimal font
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userName,
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification bell
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      iconSize: 26,
                      color: Colors.black87,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Welcome title with minimal font (Poppins Light)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Welcome to Your\nYoga Session',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w300, // Light weight = minimal
                    height: 1.25,
                    letterSpacing: -0.3,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Featured class card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildFeaturedClassCard(context),
              ),

              const SizedBox(height: 24),

              const SizedBox(height: 28),

              // Week calendar header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Keep up the good work!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildWeekCalendar(),

              const SizedBox(height: 32),

              // Practice Your Poses Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Practice Your Poses',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF40E0D0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Poses grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildPosesGrid(context),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedClassCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final session = YogaData.beginnerSessions.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionDetailScreen(session: session),
          ),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF9D7FEA), Color(0xFFB8A4F0)],
                      ),
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Day 1',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Do 7 Exercises in\nOnly 6 Minutes',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Start',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF9D7FEA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _weekDays.length,
        itemBuilder: (context, index) {
          final day = _weekDays[index];
          final isToday = day['isToday'] as bool;
          final minutesCompleted = day['minutesCompleted'] as int;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isToday ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isToday ? Colors.black87 : Colors.grey[300]!,
                  width: 1.5,
                ),
                boxShadow: isToday
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day['day'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isToday ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    day['date'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: isToday ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (minutesCompleted > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$minutesCompleted min',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPosesGrid(BuildContext context) {
    // Get real featured poses from yoga data
    final featuredPoses = [
      {
        'pose': YogaData.beginnerMainStanding[3], // Warrior 1
        'session': YogaData.beginnerSessions.first,
        'color': const Color(0xFF6B9BD1),
      },
      {
        'pose': YogaData.intermediateMain[1], // Plank
        'session': YogaData.intermediateSessions.first,
        'color': const Color(0xFFE8A0BF),
      },
      {
        'pose': YogaData.beginnerMainStanding[0], // Back and Chest Stretch
        'session': YogaData.beginnerSessions.first,
        'color': const Color(0xFF9DD9D2),
      },
      {
        'pose': YogaData.intermediateMain[3], // Baby Cobra
        'session': YogaData.intermediateSessions.first,
        'color': const Color(0xFFFFB997),
      },
    ];

    // Filter poses based on unlocked levels
    final availablePoses = featuredPoses.where((poseData) {
      final session = poseData['session'] as YogaSession;
      final level = session.level;
      if (level == 'Beginner') return true;
      if (level == 'Intermediate') return _intermediateUnlocked;
      if (level == 'Advanced') return _advancedUnlocked;
      return false;
    }).toList();

    // Show only first 4 poses
    final displayPoses = availablePoses.take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: displayPoses.length,
      itemBuilder: (context, index) {
        final item = displayPoses[index];
        final pose = item['pose'] as YogaPose;
        final session = item['session'] as YogaSession;
        final color = item['color'] as Color;

        return _buildPoseCard(context, pose, session, color);
      },
    );
  }

  Widget _buildPoseCard(
    BuildContext context,
    YogaPose pose,
    YogaSession session,
    Color badgeColor,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate directly to pose detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoseDetailScreen(
              pose: pose,
              allPoses: session.allPoses,
              currentIndex: session.allPoses.indexWhere((p) => p.id == pose.id),
              sessionLevel: session.level,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                pose.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: badgeColor.withOpacity(0.3));
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        session.level.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      pose.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${pose.durationSeconds}s',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

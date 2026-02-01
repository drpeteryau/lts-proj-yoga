import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/yoga_data.dart';
import 'session_detail_screen.dart';
import '../models/yoga_pose.dart';
import '../models/yoga_session.dart';
import 'pose_detail_screen.dart';
import '../services/global_audio_service.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 1200 : double.infinity,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 40 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isWeb ? 40 : 20),

                    // Profile header with greeting
                    Row(
                      children: [
                        // Profile picture
                        Container(
                          width: isWeb ? 72 : 56,
                          height: isWeb ? 72 : 56,
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
                              ? Icon(
                            Icons.person,
                            color: const Color(0xFF40E0D0),
                            size: isWeb ? 36 : 28,
                          )
                              : null,
                        ),

                        const SizedBox(width: 16),

                        // Greeting text with minimal font
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: GoogleFonts.poppins(
                                  fontSize: isWeb ? 16 : 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userName,
                                style: GoogleFonts.poppins(
                                  fontSize: isWeb ? 28 : 19,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Notification icon
                        IconButton(
                          icon: Icon(
                            Icons.notifications_outlined,
                            size: isWeb ? 32 : 24,
                          ),
                          color: Colors.grey[700],
                          onPressed: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: isWeb ? 50 : 30),

                    // Session card
                    _buildSessionCard(context, isWeb),

                    SizedBox(height: isWeb ? 50 : 30),

                    // "Keep up the good work" section
                    Text(
                      'Keep up the good work!',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 24 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: isWeb ? 24 : 16),

                    // Week days horizontal scroll
                    _buildWeekDaysRow(isWeb),

                    SizedBox(height: isWeb ? 50 : 30),

                    // Poses grid
                    _buildPosesGrid(context, isWeb),

                    SizedBox(height: isWeb ? 40 : 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, bool isWeb) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionDetailScreen(
              session: YogaData.beginnerSessions.first,
            ),
          ),
        );
      },
      child: Container(
        height: isWeb ? 280 : 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isWeb ? 30 : 24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isWeb ? 30 : 24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF40E0D0).withOpacity(0.3),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isWeb ? 32 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 16 : 12,
                        vertical: isWeb ? 10 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Day 1',
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 16 : 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: isWeb ? 16 : 12),
                    Text(
                      'Do 7 Exercises in\nOnly 6 Minutes',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 28 : 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: isWeb ? 20 : 16),
                    ElevatedButton(
                      onPressed: () {
                        GlobalAudioService.playClickSound();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionDetailScreen(
                              session: YogaData.beginnerSessions.first,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40E0D0),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 32 : 24,
                          vertical: isWeb ? 16 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Start',
                            style: GoogleFonts.poppins(
                              fontSize: isWeb ? 18 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: isWeb ? 12 : 8),
                          Icon(
                            Icons.arrow_forward,
                            size: isWeb ? 20 : 16,
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

  Widget _buildWeekDaysRow(bool isWeb) {
    return SizedBox(
      height: isWeb ? 100 : 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _weekDays.length,
        itemBuilder: (context, index) {
          final day = _weekDays[index];
          final isToday = day['isToday'] as bool;
          final minutesCompleted = day['minutesCompleted'] as int;

          return GestureDetector(
            onTap: () {
              GlobalAudioService.playClickSound();
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: isWeb ? 90 : 75,
              margin: EdgeInsets.only(
                right: isWeb ? 16 : 12,
              ),
              decoration: BoxDecoration(
                color: isToday ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(isWeb ? 20 : 16),
                border: isToday
                    ? null
                    : Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
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
                      fontSize: isWeb ? 15 : 13,
                      fontWeight: FontWeight.w400,
                      color: isToday ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: isWeb ? 8 : 6),
                  Text(
                    day['date'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 28 : 24,
                      fontWeight: FontWeight.w600,
                      color: isToday ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (minutesCompleted > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 8 : 6,
                        vertical: isWeb ? 4 : 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$minutesCompleted min',
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 11 : 10,
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

  Widget _buildPosesGrid(BuildContext context, bool isWeb) {
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

    // Determine cross axis count based on screen width
    final crossAxisCount = isWeb ? 4 : 2;
    final childAspectRatio = isWeb ? 0.75 : 0.85;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isWeb ? 20 : 12,
        mainAxisSpacing: isWeb ? 20 : 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: displayPoses.length,
      itemBuilder: (context, index) {
        final item = displayPoses[index];
        final pose = item['pose'] as YogaPose;
        final session = item['session'] as YogaSession;
        final color = item['color'] as Color;

        return _buildPoseCard(context, pose, session, color, isWeb);
      },
    );
  }

  Widget _buildPoseCard(
      BuildContext context,
      YogaPose pose,
      YogaSession session,
      Color badgeColor,
      bool isWeb,
      ) {
    return GestureDetector(
      onTap: () {
        GlobalAudioService.playClickSound();
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
          borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
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
                padding: EdgeInsets.all(isWeb ? 20 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 12 : 10,
                        vertical: isWeb ? 6 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        session.level.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 11 : 10,
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
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isWeb ? 8 : 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white70,
                          size: isWeb ? 16 : 14,
                        ),
                        SizedBox(width: isWeb ? 6 : 4),
                        Text(
                          '${pose.durationSeconds}s',
                          style: GoogleFonts.poppins(
                            fontSize: isWeb ? 14 : 12,
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
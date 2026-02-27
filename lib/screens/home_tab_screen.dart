import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/yoga_data_complete.dart';
import 'session_detail_screen.dart';
import '../models/yoga_pose.dart';
import '../models/yoga_session.dart';
import 'pose_detail_screen.dart';
import 'meditation_screen.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/yoga_localization_helper.dart';
import 'package:intl/intl.dart';

// Combine all yoga sessions from YogaDataComplete class
final yogaSessions = [
  ...YogaDataComplete.beginnerSessions,
  ...YogaDataComplete.intermediateSessions,
  ...YogaDataComplete.advancedSessions,
];

// Combine all yoga poses from YogaDataComplete class
final allYogaPoses = [
  ...YogaDataComplete.beginnerWarmupSitting,
  ...YogaDataComplete.beginnerMainStanding,
  ...YogaDataComplete.beginnerCooldown,
  ...YogaDataComplete.intermediateMain,
  ...YogaDataComplete.intermediateCooldown,
  ...YogaDataComplete.advancedFlow,
  ...YogaDataComplete.advancedCooldown,
];

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String _userName = '';
  String? _profileImageUrl;
  int _selectedDayIndex = DateTime.now().weekday - 1;

  // Wellness data
  int _currentStreak = 0;
  int _totalSessions = 0;
  int _weeklyMinutes = 0;
  int _totalMinutes = 0;

  final List<Map<String, dynamic>> _weekDays = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadWellnessData();
    _generateWeekDays();
  }

  Future<void> _loadUserData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('full_name, profile_image_url')
          .eq('id', userId)
          .maybeSingle();

      if (response != null && mounted) {
        setState(() {
          _userName = (response['full_name'] as String?)?.split(' ').first ?? 'Friend';
          _profileImageUrl = response['profile_image_url'] as String?;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadWellnessData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final poseActivitiesResponse = await Supabase.instance.client
          .from('pose_activity')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      int weekSeconds = 0;
      int totalSeconds = 0;
      final Map<String, bool> activityDays = {};

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));

      for (var row in poseActivitiesResponse) {
        final raw = DateTime.parse(row['completed_at']).toLocal();
        final date = DateTime(raw.year, raw.month, raw.day);
        final key = DateFormat('yyyy-MM-dd').format(date);
        activityDays[key] = true;

        final durationSeconds = (row['duration_seconds'] ?? 0) as int;
        totalSeconds += durationSeconds;

        if (!date.isBefore(weekStart)) {
          weekSeconds += durationSeconds;
        }
      }

      // Calculate streak
      int streak = 0;
      DateTime checkDate = today;
      while (true) {
        final key = DateFormat('yyyy-MM-dd').format(checkDate);
        if (activityDays[key] == true) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }

      int sessions = activityDays.length;

      if (mounted) {
        setState(() {
          _currentStreak = streak;
          _totalSessions = sessions;
          _weeklyMinutes = (weekSeconds / 60).round();
          _totalMinutes = (totalSeconds / 60).round();
        });
      }
    } catch (e) {
      print('Error loading wellness data: $e');
    }
  }

  void _generateWeekDays() {
    _weekDays.clear();
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      _weekDays.add({
        'initial': DateFormat('E').format(day)[0],
        'day': DateFormat('E').format(day),
        'date': day.day.toString(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flower background with opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,  // Increased from 0.15 for better visibility
              child: CustomPaint(
                painter: FlowerBackgroundPainter(),
              ),
            ),
          ),

          // Main content
          Container(
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildMonthSelector(),
                    const SizedBox(height: 12),
                    _buildWeekCalendar(),
                    const SizedBox(height: 32),
                    _buildChairYogaWidget(),
                    const SizedBox(height: 20),
                    _buildSelfCareWidget(),
                    const SizedBox(height: 16),
                    _buildWellnessOverview(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                Text(
                  '${_userName.isEmpty ? 'Friend' : _userName}',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF40E0D0).withOpacity(0.3),
                width: 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB889).withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                  ? Image.network(
                _profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              )
                  : _buildDefaultAvatar(),
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF40E0D0),
            Color(0xFF20B2AA),
          ],
        ),
      ),
      child: Center(
        child: Text(
          _userName.isEmpty ? 'F' : _userName[0].toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                monthName,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,

                ),
              ),
            ],
          ),


        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final isSelected = index == _selectedDayIndex;
          final day = _weekDays[index];

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDayIndex = index);
            },
            child: Column(
              children: [
                const SizedBox(height: 7),
                Text(
                  day['initial']!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? const Color(0xFF40E0D0) : Colors.black45,
                  ),
                ),
                const SizedBox(height: 14),

                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF40E0D0)
                        : const Color(0xCAFFFFFF),
                    shape: BoxShape.circle,
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: const Color(0xFF40E0D0).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 4,
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: Text(
                      day['date']!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelfCareWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          await GlobalAudioService.playClickSound();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF37A00).withOpacity(0.3),
                const Color(0xFF11EDDB).withOpacity(0.1),
              ],
            ),

            borderRadius: BorderRadius.circular(28),


          ),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Zen text
              Text(
                'Find Your Peace',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,

                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Calming sounds for your wellness',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Subtle button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF000000),
                      Color(0xFF000000),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF88FFF2).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Listen Now',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
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

  Widget _buildChairYogaWidget() {
    final beginnerSessions = yogaSessions.where((s) =>
    s.levelKey.toLowerCase() == 'beginner').toList();
    if (beginnerSessions.isEmpty) return const SizedBox();

    final session = beginnerSessions.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          await GlobalAudioService.playClickSound();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionDetailScreen(session: session),
            ),
          );
        },
        child: Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF26A69A), Color(0xFF40E0D0)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    );
                  },
                ),
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          YogaLocalizationHelper.getSessionTitle(context, session.titleKey),
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Perfect for those just starting their yoga journey',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
                          decoration: BoxDecoration(
                            color: const Color(0xB6000000),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          child: Text(
                            'Join Now',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
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

  Widget _buildWellnessOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 4, bottom: 16),
            child: Text(
              'Wellness Overview',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: _buildWellnessCard(
                  icon: Icons.local_fire_department,
                  title: 'Streak',
                  value: '$_currentStreak days',
                  color: const Color(0xFFA5A5A5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWellnessCard(
                  icon: Icons.self_improvement,
                  title: 'Sessions',
                  value: '$_totalSessions',
                  color: const Color(0xFFB0FFF6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildWellnessCard(
                  icon: Icons.timer_outlined,
                  title: 'Weekly',
                  value: '$_weeklyMinutes min',
                  color: const Color(0xFF9B59B6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWellnessCard(
                  icon: Icons.schedule,
                  title: 'Total Time',
                  value: '$_totalMinutes min',
                  color: const Color(0xFF3498DB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7EFE0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Flower background painter
class FlowerBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Skip if size is invalid
    if (size.width <= 0 || size.height <= 0) return;

    // Draw multiple flower shapes with varying opacity and sizes
    _drawFlower(canvas, size.width * 0.15, size.height * 0.12, 80, 0.08);
    _drawFlower(canvas, size.width * 0.88, size.height * 0.25, 65, 0.06);
    _drawFlower(canvas, size.width * 0.08, size.height * 0.45, 90, 0.07);
    _drawFlower(canvas, size.width * 0.82, size.height * 0.58, 70, 0.05);
    _drawFlower(canvas, size.width * 0.25, size.height * 0.75, 75, 0.06);
    _drawFlower(canvas, size.width * 0.92, size.height * 0.82, 60, 0.08);

    // Add some smaller accent flowers
    _drawFlower(canvas, size.width * 0.45, size.height * 0.2, 40, 0.04);
    _drawFlower(canvas, size.width * 0.6, size.height * 0.5, 45, 0.05);
    _drawFlower(canvas, size.width * 0.35, size.height * 0.9, 50, 0.06);
  }

  void _drawFlower(Canvas canvas, double cx, double cy, double size, double opacity) {
    // Clamp opacity between 0 and 1
    final validOpacity = opacity.clamp(0.0, 1.0);

    // Create paint with specified opacity
    final paint = Paint()
      ..color = const Color(0xFF40E0D0).withOpacity(validOpacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    const petals = 6;

    // Draw petals
    for (int i = 0; i < petals; i++) {
      final angle = (i * 2 * 3.14159) / petals;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);

      final path = Path();
      path.moveTo(0, 0);

      // Simplified petal shape
      path.quadraticBezierTo(
        size * 0.3,
        -size * 0.5,
        size * 0.15,
        -size,
      );

      path.quadraticBezierTo(
        0,
        -size * 1.1,
        -size * 0.15,
        -size,
      );

      path.quadraticBezierTo(
        -size * 0.3,
        -size * 0.5,
        0,
        0,
      );

      path.close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = const Color(0xFF40E0D0).withOpacity((validOpacity * 1.2).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(cx, cy), size * 0.25, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
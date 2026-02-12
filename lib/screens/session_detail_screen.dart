import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yoga_session.dart';
import '../models/yoga_pose.dart';
import 'pose_detail_screen.dart';
import 'full_session_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/yoga_localization_helper.dart';

class SessionDetailScreen extends StatefulWidget {
  final YogaSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  Map<String, bool> poseProgress = {};

  @override
  void initState() {
    super.initState();
    _loadPoseProgress();
  }

  Future<void> _loadPoseProgress() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('user_progress')
        .select('pose_id, is_completed')
        .eq('session_level', widget.session.levelKey);

    final progressMap = <String, bool>{};
    for (final row in response) {
      progressMap[row['pose_id'].toString()] = row['is_completed'] == true;
    }

    setState(() {
      poseProgress = progressMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light theme
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Hero image with fade gradient
              _buildHeroSection(),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120), // Space for button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Session title (Chair Yoga, etc.)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          YogaLocalizationHelper.getSessionTitle(context, widget.session.titleKey),
                          style: GoogleFonts.poppins(
                            fontSize: 26, // Elderly-friendly header
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Level badge (Beginner, Intermediate, etc.)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF40E0D0).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.signal_cellular_alt,
                                size: 16,
                                color: Color(0xFF40E0D0),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                YogaLocalizationHelper.getSessionLevel(context, widget.session.levelKey),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF40E0D0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // About this session
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About this Session',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              YogaLocalizationHelper.getSessionDescription(context, widget.session.descriptionKey),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[700],
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Pose list (simple cards, no descriptions)
                      _buildPoseList(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Join Class button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildJoinButton(),
          ),

          // Back button overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.self_improvement,
                  size: 100,
                  color: Colors.grey,
                ),
              );
            },
          ),

          // Gradient fade to white background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,

                  Colors.white, // Full white at bottom
                ],
                stops: const [0.0, 0.3, 0.6, 0.85, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoseList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'Poses in this Session',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          // Pose cards
          ...widget.session.allPoses.asMap().entries.map((entry) {
            final index = entry.key;
            final pose = entry.value;
            final isCompleted = poseProgress[pose.id] ?? false;

            return _buildPoseCard(pose, index + 1, isCompleted);
          }),
        ],
      ),
    );
  }

  Widget _buildPoseCard(YogaPose pose, int number, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await GlobalAudioService.playClickSound();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PoseDetailScreen(
                  pose: pose,
                  allPoses: widget.session.allPoses,
                  currentIndex: number - 1,
                  sessionLevel: widget.session.levelKey,
                ),
              ),
            ).then((_) => _loadPoseProgress());
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white, // Light card
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Number or checkmark circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF40E0D0)
                        : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    )
                        : Text(
                      '$number',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Pose name and duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        YogaLocalizationHelper.getPoseName(context, pose.nameKey),
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pose.durationSeconds ~/ 60}:${(pose.durationSeconds % 60).toString().padLeft(2, '0')} min',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    // Count completed poses
    final completedCount = widget.session.allPoses
        .where((pose) => poseProgress[pose.id] ?? false)
        .length;
    final totalPoses = widget.session.allPoses.length;
    final isFullyCompleted = completedCount == totalPoses && totalPoses > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.8),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator (if started)
          if (completedCount > 0 && !isFullyCompleted)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF40E0D0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF40E0D0).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Color(0xFF40E0D0),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$completedCount of $totalPoses poses completed',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF40E0D0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Join Class button - Turquoise
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullSessionScreen(session: widget.session),
                  ),
                ).then((_) => _loadPoseProgress());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0), // Turquoise
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isFullyCompleted ? 'Practice Again' : 'Join Class',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
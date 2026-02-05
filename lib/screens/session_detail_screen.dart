import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yoga_session.dart';
import '../models/yoga_pose.dart';
import 'pose_detail_screen.dart';
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
  bool isFavorite = false;

  // Responsive helper
  bool get isWeb => MediaQuery.of(context).size.width > 600;
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Image only (no title overlay)
          _buildHeroSection(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // NEW: Header under the image (like reference 2)
                  _buildHeaderSection(),

                  const SizedBox(height: 18),

                  // Info cards (Duration, Poses, Intensity)
                  _buildInfoCards(),

                  const SizedBox(height: 22),

                  // About this session
                  _buildAboutSection(),

                  const SizedBox(height: 22),

                  // Session Overview (Pose list) - now light tiles
                  _buildSessionOverview(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildJoinButton(),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Hero image with gradient
        SizedBox(
          height: 200,
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

              // Bottom gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.4, 0.75, 1.0],
                  ),
                ),
              ),

              // Session title at bottom left
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  YogaLocalizationHelper.getSessionLevel(context, widget.session.levelKey),
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Back button
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              icon: Icons.access_time,
              value: AppLocalizations.of(context)!.minShort(widget.session.totalDurationMinutes),
              label: AppLocalizations.of(context)!.duration,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard(
              icon: Icons.fitness_center,
              value: '${widget.session.allPoses.length}',
              label: AppLocalizations.of(context)!.poses,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard(
              icon: Icons.whatshot,
              value: AppLocalizations.of(context)!.low,
              label: AppLocalizations.of(context)!.intensity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF40E0D0).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF40E0D0),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.aboutSession,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            YogaLocalizationHelper.getSessionDescription(context, widget.session.descriptionKey),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.sessionOverview,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF40E0D0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.poseCount(widget.session.allPoses.length),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF40E0D0),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Pose list (like reference image 2 - dark theme list)
        ...widget.session.allPoses.asMap().entries.map((entry) {
          final index = entry.key;
          final pose = entry.value;
          return _buildPoseListItem(pose, index + 1);
        }),
      ],
    );
  }

  Widget _buildPoseListItem(YogaPose pose, int dayNumber) {
    final isCompleted = poseProgress[pose.id] ?? false;
    final currentIndex = widget.session.allPoses.indexOf(pose);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoseDetailScreen(
              pose: pose,
              allPoses: widget.session.allPoses,
              currentIndex: currentIndex,
              sessionLevel: widget.session.levelKey,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, // ✅ light tile
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Pose thumbnail
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pose.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.self_improvement,
                        color: Colors.black45,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Pose info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    YogaLocalizationHelper.getPoseName(context, pose.nameKey),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87, // ✅ black text
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    YogaLocalizationHelper.getPoseDescription(context, pose.descriptionKey),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700], // ✅ dark grey
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dayNumber(dayNumber),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('|', style: TextStyle(color: Colors.grey[500])),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.minsLabel(pose.durationSeconds ~/ 60),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF40E0D0)
                    : Colors.black.withOpacity(0.04),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF40E0D0)
                      : Colors.black.withOpacity(0.12),
                  width: 2,
                ),
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.play_arrow,
                color: isCompleted ? Colors.white : Colors.black87,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  YogaLocalizationHelper.getSessionTitle(context, widget.session.titleKey),
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        YogaLocalizationHelper.getSessionLevel(context, widget.session.levelKey),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF18BFB3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.poseCount(widget.session.allPoses.length),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }

  Widget _buildJoinButton() {
    return Container(
      padding: EdgeInsets.all(isWeb ? 40 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () async {
            await GlobalAudioService.playClickSound();
            // Start the session - navigate to first pose
            if (widget.session.allPoses.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PoseDetailScreen(
                    pose: widget.session.allPoses.first,
                    allPoses: widget.session.allPoses,
                    currentIndex: 0,
                    sessionLevel: widget.session.levelKey,
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            AppLocalizations.of(context)!.joinClass,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yoga_session.dart';
import '../models/yoga_pose.dart';
import 'pose_detail_screen.dart';
import 'full_session_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/global_audio_service.dart';
import '../utils/yoga_localization_helper.dart';
import '../l10n/app_localizations.dart';

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
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main scrollable content
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 1280 : double.infinity,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero image (now scrollable)
                    _buildHeroSection(),

                    // Session title
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 40 : 24,
                        vertical: isWeb ? 32 : 26,
                      ),
                      child: Text(
                        YogaLocalizationHelper.getSessionTitle(context, widget.session.titleKey),
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 32 : 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                    ),

                    // 3 Circular info boxes
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildInfoBox(
                              label: AppLocalizations.of(context)!.sessionLevelLabel,
                              value: YogaLocalizationHelper.getSessionLevel(context, widget.session.levelKey),
                              color: const Color(0xFFFFF0E4),
                            ),
                          ),
                          SizedBox(width: isWeb ? 16 : 12),
                          Expanded(
                            child: _buildInfoBox(
                              label: AppLocalizations.of(context)!.sessionTotalTimeLabel,
                              value: AppLocalizations.of(context)!.minsLabel(widget.session.totalDurationMinutes),
                              color: const Color(0xFFEBFFFF),
                            ),
                          ),
                          SizedBox(width: isWeb ? 16 : 12),
                          Expanded(
                            child: _buildInfoBox(
                              label: AppLocalizations.of(context)!.sessionTotalPosesLabel,
                              value: AppLocalizations.of(context)!.poseCount(widget.session.allPoses.length),
                              color: const Color(0xFFE1FFF9),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isWeb ? 32 : 24),

                    // About this session
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.aboutThisSession,
                            style: GoogleFonts.poppins(
                              fontSize: isWeb ? 26 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: isWeb ? 12 : 10),
                          Text(
                            YogaLocalizationHelper.getSessionDescription(context, widget.session.descriptionKey),
                            style: GoogleFonts.poppins(
                              fontSize: isWeb ? 20 : 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isWeb ? 36 : 28),

                    // Pose list
                    _buildPoseList(),

                    SizedBox(height: isWeb ? 140 : 120), // Space for button
                  ],
                ),
              ),
            ),
          ),

          // Floating Join Class button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 1280 : double.infinity,
                ),
                child: _buildJoinButton(),
              ),
            ),
          ),

          // Back button overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: isWeb ? (MediaQuery.of(context).size.width - 1280) / 2 + 16 : 16,
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
                icon: Icon(Icons.arrow_back, color: Colors.black87, size: isWeb ? 28 : 24),
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

  Widget _buildInfoBox({
    required String label,
    required String value,
    required Color color,
  }) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isWeb ? 20 : 16,
        horizontal: isWeb ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 14 : 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isWeb ? 6 : 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      height: isWeb ? 400 : 280,
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
                child: Icon(
                  Icons.self_improvement,
                  size: isWeb ? 120 : 100,
                  color: Colors.grey,
                ),
              );
            },
          ),

          // Gradient fade to white background
          Container(
            decoration: const BoxDecoration(
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
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            AppLocalizations.of(context)!.posesPreview,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 26 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: isWeb ? 20 : 16),

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
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Container(
      margin: EdgeInsets.only(bottom: isWeb ? 16 : 12),
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
            padding: EdgeInsets.all(isWeb ? 22 : 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Number or checkmark circle
                Container(
                  width: isWeb ? 52 : 44,
                  height: isWeb ? 52 : 44,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF40E0D0)
                        : const Color(0xFFFFF1DB),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: isWeb ? 28 : 24,
                    )
                        : Text(
                      '$number',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: isWeb ? 20 : 16),

                // Pose name and duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        YogaLocalizationHelper.getPoseName(context, pose.nameKey),
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: isWeb ? 6 : 4),
                      Text(
                        AppLocalizations.of(context)!.durationFormat(
                          (pose.durationSeconds ~/ 60),
                          (pose.durationSeconds % 60).toString().padLeft(2, '0'),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 16 : 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: isWeb ? 20 : 18,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCountdownOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => _CountdownOverlay(
        sessionName: YogaLocalizationHelper.getSessionTitle(context, widget.session.titleKey),
        onComplete: () {
          Navigator.pop(context); // close overlay
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullSessionScreen(session: widget.session),
            ),
          ).then((_) => _loadPoseProgress());
        },
        onSkip: () {
          Navigator.pop(context); // close overlay
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullSessionScreen(session: widget.session),
            ),
          ).then((_) => _loadPoseProgress());
        },
      ),
    );
  }

  Widget _buildJoinButton() {
    final isWeb = MediaQuery.of(context).size.width > 600;

    // Count completed poses
    final completedCount = widget.session.allPoses
        .where((pose) => poseProgress[pose.id] ?? false)
        .length;
    final totalPoses = widget.session.allPoses.length;
    final isFullyCompleted = completedCount == totalPoses && totalPoses > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isWeb ? 40 : 24,
        isWeb ? 32 : 24,
        isWeb ? 40 : 24,
        MediaQuery.of(context).padding.bottom + (isWeb ? 32 : 24),
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
              margin: EdgeInsets.only(bottom: isWeb ? 20 : 16),
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? 20 : 16,
                vertical: isWeb ? 12 : 10,
              ),
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
                  Icon(
                    Icons.check_circle,
                    size: isWeb ? 24 : 20,
                    color: const Color(0xFF40E0D0),
                  ),
                  SizedBox(width: isWeb ? 12 : 10),
                  Text(
                    AppLocalizations.of(context)!.posesCompletedCount(completedCount, totalPoses),
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 17 : 15,
                      color: const Color(0xFF40E0D0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Join Now button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                _showCountdownOverlay();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isWeb ? 20 : 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isFullyCompleted ? AppLocalizations.of(context)!.practiceAgain : AppLocalizations.of(context)!.joinClass,
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 19 : 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: isWeb ? 16 : 12),
                  Container(
                    padding: EdgeInsets.all(isWeb ? 6 : 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: isWeb ? 20 : 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Countdown Overlay
// ─────────────────────────────────────────────────────────────────────────────

class _CountdownOverlay extends StatefulWidget {
  final String sessionName;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const _CountdownOverlay({
    required this.sessionName,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<_CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<_CountdownOverlay>
    with TickerProviderStateMixin {
  int _seconds = 10;
  Timer? _timer;

  // Ring animation
  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;

  // Pulse animation for the number
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // Fade-in for the whole overlay
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // Fade in
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    // Ring sweeps from full (1.0) to empty (0.0) over 10 s
    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 10));
    _ringAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_ringCtrl);
    _ringCtrl.forward();

    // Pulse on each tick
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _pulseCtrl.forward(from: 0);
      setState(() => _seconds--);
      if (_seconds <= 0) {
        t.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ringCtrl.dispose();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Material(
        // On web: dark scrim behind the centred card
        color: isWeb ? Colors.black.withOpacity(0.75) : Colors.transparent,
        child: Center(
          child: isWeb ? _buildCard() : _buildFullScreen(),
        ),
      ),
    );
  }

  // ── Web: centred rounded card ─────────────────────────────────────────────
  Widget _buildCard() {
    return Container(
      width: 480,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A3C40), Color(0xFF0D2E32), Color(0xFF1A3C40)],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ..._buildAmbientCircles(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  // ── Mobile: full screen ───────────────────────────────────────────────────
  Widget _buildFullScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A3C40), Color(0xFF0D2E32), Color(0xFF1A3C40)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          ..._buildAmbientCircles(),
          SafeArea(child: _buildContent()),
        ],
      ),
    );
  }

  // ── Shared content column ─────────────────────────────────────────────────
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),

          // "GET READY" label
          Text(
            'GET READY',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
              letterSpacing: 4,
            ),
          ),

          const SizedBox(height: 10),

          // Session name
          Text(
            widget.sessionName,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 52),

          // Countdown ring + number
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF40E0D0).withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                ),
                // Animated sweep ring
                AnimatedBuilder(
                  animation: _ringAnim,
                  builder: (_, __) => CustomPaint(
                    size: const Size(200, 200),
                    painter: _RingPainter(
                      progress: _ringAnim.value,
                      color: const Color(0xFF40E0D0),
                      trackColor: const Color(0xFF40E0D0).withOpacity(0.12),
                      strokeWidth: 6,
                    ),
                  ),
                ),
                // Pulsing number
                ScaleTransition(
                  scale: _pulseAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_seconds',
                        style: GoogleFonts.poppins(
                          fontSize: 80,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        'seconds',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white38,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 44),

          // Calming message
          Text(
            'Take a deep breath.\nRelax your shoulders and close your eyes.',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white54,
              height: 1.8,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // Skip button
          GestureDetector(
            onTap: widget.onSkip,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.white38, size: 13),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<Widget> _buildAmbientCircles() {
    return [
      Positioned(
        top: -60,
        right: -60,
        child: _ambientCircle(220, const Color(0xFF40E0D0).withOpacity(0.06)),
      ),
      Positioned(
        bottom: -80,
        left: -80,
        child: _ambientCircle(260, const Color(0xFF40E0D0).withOpacity(0.05)),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        left: -40,
        child: _ambientCircle(120, const Color(0xFF40E0D0).withOpacity(0.04)),
      ),
    ];
  }

  Widget _ambientCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

// ── Ring painter ──────────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    const startAngle = -3.14159 / 2; // top

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Track
    canvas.drawCircle(center, radius, trackPaint);

    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * 3.14159 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
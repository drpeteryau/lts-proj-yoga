import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yoga_pose.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/pose_progress_service.dart';

class PoseDetailScreen extends StatefulWidget {
  final YogaPose pose;
  final List<YogaPose> allPoses;
  final int currentIndex;
  final String sessionLevel;

  const PoseDetailScreen({
    super.key,
    required this.pose,
    required this.allPoses,
    required this.currentIndex,
    required this.sessionLevel,
  });

  @override
  State<PoseDetailScreen> createState() => _PoseDetailScreenState();
}



class _PoseDetailScreenState extends State<PoseDetailScreen> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isTimerRunning = false;
  bool _alreadySaved = false;

  bool _showVideoControls = false;
  Timer? _hideControlsTimer;


  // Time tracking
  int _secondsSpent = 0;
  DateTime? _sessionStartTime;

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;

  final PoseProgressService _poseProgressService = PoseProgressService();
  bool _isPoseCompleted = false;
  bool _loadingPoseStatus = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.pose.durationSeconds;
    _sessionStartTime = DateTime.now();
    _loadPoseCompletion();
    _initializeVideo();
    _secondsSpent = 0;
    _alreadySaved = false;
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://rkhmailqbmbijsfzhcch.supabase.co/storage/v1/object/public/pose-videos/beginner/NeckHeadShoulders.MOV',
      ),
    );

    try {
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
    _videoController!.addListener(() {
      if (!mounted) return;

      final playing = _videoController!.value.isPlaying;
      if (playing != _isVideoPlaying) {
        setState(() {
          _isVideoPlaying = playing;
        });
      }
    });
  }

  void _toggleVideo() {
    if (_videoController == null || !_isVideoInitialized) return;

    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
  }

  void _showControlsTemporarily() {
    setState(() {
      _showVideoControls = true;
    });

    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isVideoPlaying) {
        setState(() {
          _showVideoControls = false;
        });
      }
    });
  }

  Future<void> _loadPoseCompletion() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _isPoseCompleted = false;
        _loadingPoseStatus = false;
      });
      return;
    }

    try {
      final completed = await _poseProgressService.isPoseCompleted(
        userId,
        widget.sessionLevel,
        widget.pose.id,
      );

      if (!mounted) return;
      setState(() {
        _isPoseCompleted = completed;
        _loadingPoseStatus = false;
      });
    } catch (e) {
      print('Error loading pose completion: $e');
      if (mounted) {
        setState(() {
          _loadingPoseStatus = false;
        });
      }
    }
  }

  void _startTimer() {
    if (_isTimerRunning) {
      _pauseTimer();
      return;
    }

    setState(() => _isTimerRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _secondsSpent++; // Track actual time spent
        });
      } else {
        _completeTimer();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isTimerRunning = false);
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = widget.pose.durationSeconds;
    });
  }

  Future<void> _completeTimer() async {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isPoseCompleted = true;
    });

    // Save time spent and completion
    await _savePoseProgress();

    // Move to next pose if available
    if (widget.currentIndex < widget.allPoses.length - 1) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PoseDetailScreen(
              pose: widget.allPoses[widget.currentIndex + 1],
              allPoses: widget.allPoses,
              currentIndex: widget.currentIndex + 1,
              sessionLevel: widget.sessionLevel,
            ),
          ),
        );
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hideControlsTimer?.cancel();
    _videoController?.dispose();

    // Save progress when leaving the screen
    if (_secondsSpent > 0) {
      _savePoseProgress();
    }

    super.dispose();
  }

  Future<void> _savePoseProgress() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    if (_alreadySaved) return;
    if (_secondsSpent <= 0) return;

    try {
      final supabase = Supabase.instance.client;

      // Save to pose_activity table with time spent
      await supabase.from('pose_activity').insert({
        'user_id': userId,
        'pose_id': widget.pose.id,
        'pose_name': widget.pose.name,
        'session_level': widget.sessionLevel,
        'duration_seconds': _secondsSpent,
        'completed_at': DateTime.now().toIso8601String(),
        'activity_date': DateTime.now().toIso8601String().split('T')[0],
      });

      // Mark pose as completed
      await _poseProgressService.markPoseCompleted(
        userId,
        widget.sessionLevel,
        widget.pose.id,
      );
      _alreadySaved = true;

      print('✅ Saved pose progress: ${widget.pose.name}, ${_secondsSpent}s');
    } catch (e) {
      print('❌ Error saving pose progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar
            _buildTopBar(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video section
                    _buildVideoSection(),

                    const SizedBox(height: 24),

                    // Sanskrit name
                    _buildSanskritName(),

                    const SizedBox(height: 8),

                    // Pose title
                    _buildPoseTitle(),

                    const SizedBox(height: 16),

                    // Description/Instructions
                    _buildDescription(),

                    const SizedBox(height: 24),

                    // Timer section
                    _buildTimerSection(),

                    // Safety (Safety Tips)
                    _buildBenefits(),

                    const SizedBox(height: 28),

                    // Completion status indicator
                    if (_isPoseCompleted)
                      Container(
                        width: 310,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(left: 30),
                        decoration: BoxDecoration(
                          color: const Color(0xFF40E0D0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF40E0D0),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF40E0D0),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Completed',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF40E0D0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          const Spacer(),

          // Progress indicator
          Text(
            '${widget.currentIndex + 1} of ${widget.allPoses.length}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const Spacer(),

          // Close button
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildVideoSection() {
  return GestureDetector(
onTap: () {
  _toggleVideo();
  _showControlsTemporarily();
},

    child: Container(
      height: 220,
      color: Colors.grey[200],
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🎥 Video
          if (_isVideoInitialized && _videoController != null)
            VideoPlayer(_videoController!)
          else
            Image.network(
              widget.pose.imageUrl,
              fit: BoxFit.cover,
            ),

          // ▶️ Play button (ONLY when paused)
          if (!_isVideoPlaying)
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black87,
                  size: 36,
                ),
              ),
            ),

          // ⏪ Scrub / rewind bar (ONLY when playing)
            if (_isVideoInitialized && _showVideoControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _videoController!,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Color(0xFF40E0D0),
                  bufferedColor: Colors.white38,
                  backgroundColor: Colors.white24,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),

          // 🏷 Video badge
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF40E0D0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Video Tutorial',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSanskritName() {
    return Text(
      'BEGINNER',
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF40E0D0),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPoseTitle() {
    return Text(
      widget.pose.name,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        height: 1.2,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.pose.description,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.grey[700],
        height: 1.6,
      ),
    );
  }

  Widget _buildBenefits() {
    final safetyTips = [
      'Keep your knees slightly bent to avoid joint strain',
      'Engage your core muscles throughout the pose',
      'Don\'t force your heels to touch the ground',
      'Breathe deeply and avoid holding your breath',
      'Exit the pose slowly if you feel any pain',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Tips',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...safetyTips.map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check, color: Color(0xFF40E0D0), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSection() {
    final progress = 1 - (_remainingSeconds / widget.pose.durationSeconds);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // Circular timer with progress ring
          Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring
              SizedBox(
                width: 240,
                height: 240,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF40E0D0),
                  ),
                ),
              ),

              // Inner circle with time
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Timer display
                    Text(
                      _formatTime(_remainingSeconds),
                      style: GoogleFonts.poppins(
                        fontSize: 52,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Play/Pause button
              GestureDetector(
                onTap: _startTimer,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF40E0D0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF40E0D0).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isTimerRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Stop button
              GestureDetector(
                onTap: _stopTimer,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.stop, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Mark as Completed button
          if (!_isPoseCompleted)
            Container(
              width: double.infinity,
              height: 56,
              margin: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Save pose progress with time tracking
                  await _savePoseProgress();

                  setState(() {
                    _isPoseCompleted = true;
                  });

                  // Show success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Text(
                              'Pose marked as completed!',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: const Color(0xFF40E0D0),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: Text(
                  'Mark as Completed',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF40E0D0),
                  side: const BorderSide(color: Color(0xFF40E0D0), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

          // Next/Complete button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                // Save pose progress with time tracking
                await _savePoseProgress();

                setState(() {
                  _isPoseCompleted = true;
                });

                // Navigate to next pose or show completion
                if (widget.currentIndex < widget.allPoses.length - 1) {
                  // Has next pose
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoseDetailScreen(
                        pose: widget.allPoses[widget.currentIndex + 1],
                        allPoses: widget.allPoses,
                        currentIndex: widget.currentIndex + 1,
                        sessionLevel: widget.sessionLevel,
                      ),
                    ),
                  );
                } else {
                  // Last pose - show completion dialog
                  _showCompletionDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                widget.currentIndex < widget.allPoses.length - 1
                    ? 'Next Pose'
                    : 'Complete Session',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '🎉 Congratulations!',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You completed all poses in this session!',
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Icon(Icons.check_circle, color: const Color(0xFF40E0D0), size: 64),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to session list
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Done',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Full Video Player Screen
class _FullVideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController controller;
  final String poseName;

  const _FullVideoPlayerScreen({
    required this.controller,
    required this.poseName,
  });

  @override
  State<_FullVideoPlayerScreen> createState() => _FullVideoPlayerScreenState();
}

class _FullVideoPlayerScreenState extends State<_FullVideoPlayerScreen> {
  bool _isPlaying = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    widget.controller.addListener(_videoListener);
    _startHideControlsTimer();
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _isPlaying = widget.controller.value.isPlaying;
      });
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
      _isPlaying = !_isPlaying;
    });
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    widget.controller.removeListener(_videoListener);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video player
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),

            // Controls overlay
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Top bar
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.poseName,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Play/Pause button
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),

                    const Spacer(),

                    // Bottom controls
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Progress bar
                          VideoProgressIndicator(
                            widget.controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Color(0xFF40E0D0),
                              bufferedColor: Colors.white30,
                              backgroundColor: Colors.white12,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),

                          // Time display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(
                                  widget.controller.value.position,
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _formatDuration(
                                  widget.controller.value.duration,
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

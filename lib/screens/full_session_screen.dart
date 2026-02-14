import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/yoga_pose.dart';
import '../models/yoga_session.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/pose_progress_service.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/yoga_localization_helper.dart';

class FullSessionScreen extends StatefulWidget {
  final YogaSession session;

  const FullSessionScreen({
    super.key,
    required this.session,
  });

  @override
  State<FullSessionScreen> createState() => _FullSessionScreenState();
}

class _FullSessionScreenState extends State<FullSessionScreen> {
  int _currentPoseIndex = 0;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isTimerRunning = false;
  bool _isPaused = false;

  int _totalTimeSpent = 0;
  int _sessionStartSeconds = 0;
  final Set<String> _completedPoseIds = {};

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _showVideoControls = false;
  Timer? _hideControlsTimer;
  double _playbackSpeed = 1.0; // Normal speed

  final PoseProgressService _poseProgressService = PoseProgressService();

  bool get isWeb => MediaQuery.of(context).size.width > 600;

  YogaPose get currentPose => widget.session.allPoses[_currentPoseIndex];
  bool get isLastPose => _currentPoseIndex == widget.session.allPoses.length - 1;
  double get progress => (_currentPoseIndex + 1) / widget.session.allPoses.length;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = currentPose.durationSeconds;
    _loadCompletedPoses();
    _initializeVideo();
    _startTimer();
  }

  Future<void> _loadCompletedPoses() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final supabase = Supabase.instance.client;

      // Load all completed poses for this session level
      final response = await supabase
          .from('user_progress')
          .select('pose_id')
          .eq('user_id', userId)
          .eq('session_level', widget.session.levelKey)
          .eq('is_completed', true);

      if (mounted) {
        setState(() {
          _completedPoseIds.clear();
          for (final row in response) {
            _completedPoseIds.add(row['pose_id'].toString());
          }
        });
      }
    } catch (e) {
      print('Error loading completed poses: $e');
    }
  }

  Future<void> _initializeVideo() async {
    // Placeholder video URL - replace with actual video based on pose
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://rkhmailqbmbijsfzhcch.supabase.co/storage/v1/object/public/pose-videos/beginner/NeckHeadShoulders.MOV',
      ),
    );

    try {
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _toggleVideo() {
    if (_videoController == null || !_isVideoInitialized) return;

    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showVideoControls = true;
    });

    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _videoController?.value.isPlaying == true) {
        setState(() {
          _showVideoControls = false;
        });
      }
    });
  }

  void _startTimer() {
    if (_isTimerRunning) return;

    setState(() {
      _isTimerRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _totalTimeSpent++;
        });
      } else {
        _onPoseComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isPaused = true;
    });
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _skipToNextPose() {
    GlobalAudioService.playClickSound();

    // Only allow if current pose is completed
    if (!_completedPoseIds.contains(currentPose.id)) {
      // Show message that they need to complete current pose first
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete the current pose before moving to the next one',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    _goToNextPose();
  }

  void _goToPreviousPose() async {
    if (_currentPoseIndex <= 0) return;

    GlobalAudioService.playClickSound();

    // Dispose old video controller
    await _videoController?.dispose();

    setState(() {
      _currentPoseIndex--;
      _remainingSeconds = currentPose.durationSeconds;
      _isVideoInitialized = false;
      _isPaused = false;
    });

    // Initialize new video
    await _initializeVideo();

    // Don't auto-start timer when going back
    // User needs to press play
  }

  void _onPoseComplete() async {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });

    // Mark this pose as completed in the session
    _completedPoseIds.add(currentPose.id);

    // Save immediately to database
    await _savePoseCompletion();

    // Show completion dialog with Next/Retry options
    if (mounted) {
      _showPoseCompleteDialog();
    }
  }

  Future<void> _savePoseCompletion() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final supabase = Supabase.instance.client;

      // Save to pose_activity table
      await supabase.from('pose_activity').insert({
        'user_id': userId,
        'pose_id': currentPose.id,
        'pose_name': YogaLocalizationHelper.getPoseName(context, currentPose.nameKey),
        'session_level': widget.session.levelKey,
        'duration_seconds': currentPose.durationSeconds,
        'completed_at': DateTime.now().toIso8601String(),
        'activity_date': DateTime.now().toIso8601String().split('T')[0],
      });

      // Mark pose as completed in user_progress
      await _poseProgressService.markPoseCompleted(
        userId,
        widget.session.levelKey,
        currentPose.id,
      );

      print('✅ Pose completed and saved: ${currentPose.id}');
    } catch (e) {
      print('❌ Error saving pose completion: $e');
    }
  }

  void _showPoseCompleteDialog() {
    GlobalAudioService.playClickSound();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF40E0D0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: Color(0xFF40E0D0),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pose Complete!',
              style: GoogleFonts.poppins(
                fontSize: 26,  // Larger for elderly
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              YogaLocalizationHelper.getPoseName(context, currentPose.nameKey),
              style: GoogleFonts.poppins(
                fontSize: 18,  // Larger
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Great work! What would you like to do?',
              style: GoogleFonts.poppins(
                fontSize: 16,  // Larger
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          // Retry button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.pop(context);
                // Reset timer for current pose
                setState(() {
                  _remainingSeconds = currentPose.durationSeconds;
                  _isPaused = false;
                });
                _startTimer();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF40E0D0), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry This Pose',
                style: GoogleFonts.poppins(
                  fontSize: 18,  // Larger
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF40E0D0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.pop(context);
                _goToNextPose();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isLastPose ? 'Finish Session' : 'Next Pose',
                style: GoogleFonts.poppins(
                  fontSize: 18,  // Larger
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToNextPose() async {
    if (isLastPose) {
      // Session complete - save all progress
      await _saveSessionProgress();
      if (mounted) {
        _showSessionCompleteDialog();
      }
      return;
    }

    // Dispose old video controller
    await _videoController?.dispose();

    setState(() {
      _currentPoseIndex++;
      _remainingSeconds = currentPose.durationSeconds;
      _isVideoInitialized = false;
    });

    // Initialize new video
    await _initializeVideo();

    // Start timer for next pose
    _startTimer();
  }

  Future<void> _saveSessionProgress() async {
    // This is called at the end of session
    // Individual poses are already saved, so just log completion
    print('✅ Session complete! ${_completedPoseIds.length} poses completed');
  }

  void _showSessionCompleteDialog() {
    GlobalAudioService.playClickSound();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF40E0D0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: Color(0xFF40E0D0),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.sessionComplete,
              style: GoogleFonts.poppins(
                fontSize: 28,  // Larger
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.completedPosesCount(widget.session.allPoses.length),
              style: GoogleFonts.poppins(
                fontSize: 18,  // Larger
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${(_totalTimeSpent ~/ 60)} ${AppLocalizations.of(context)!.minutes} total',
              style: GoogleFonts.poppins(
                fontSize: 16,  // Larger
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to session list
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
                AppLocalizations.of(context)!.done ?? 'Done',
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Video section - fills top half
              Expanded(
                child: _buildVideoSection(),
              ),

              // Bottom panel - scrollable
              Expanded(
                child: _buildBottomPanel(),
              ),
            ],
          ),

          // Close button overlay (top left)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  _showExitDialog();
                },
              ),
            ),
          ),

          // Pose counter overlay (top right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentPoseIndex + 1}/${widget.session.allPoses.length}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Dark theme like pose detail
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            _buildTimerSection(),
            _buildControlButtons(),
            _buildPoseInfo(),
            _buildPlaylist(),
            const SizedBox(height: 40), // Extra space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    return GestureDetector(
      onTap: _showControlsTemporarily,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isVideoInitialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF40E0D0),
                ),
              ),

            // Video controls (bottom) - matching pose detail style
            if (_isVideoInitialized)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress bar
                      VideoProgressIndicator(
                        _videoController!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Color(0xFF40E0D0),
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white12,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),

                      const SizedBox(height: 8),

                      // Control buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Playback speed button
                          PopupMenuButton<double>(
                            icon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${_playbackSpeed}x',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onSelected: (speed) {
                              setState(() {
                                _playbackSpeed = speed;
                                _videoController!.setPlaybackSpeed(speed);
                              });
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(value: 0.5, child: Text('0.5x', style: GoogleFonts.poppins())),
                              PopupMenuItem(value: 0.75, child: Text('0.75x', style: GoogleFonts.poppins())),
                              PopupMenuItem(value: 1.0, child: Text('1.0x (Normal)', style: GoogleFonts.poppins())),
                              PopupMenuItem(value: 1.25, child: Text('1.25x', style: GoogleFonts.poppins())),
                              PopupMenuItem(value: 1.5, child: Text('1.5x', style: GoogleFonts.poppins())),
                              PopupMenuItem(value: 2.0, child: Text('2.0x', style: GoogleFonts.poppins())),
                            ],
                          ),

                          const Spacer(),

                          // Volume button
                          IconButton(
                            icon: Icon(
                              _videoController!.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_videoController!.value.volume > 0) {
                                  _videoController!.setVolume(0);
                                } else {
                                  _videoController!.setVolume(1.0);
                                }
                              });
                            },
                          ),

                          // Fullscreen button
                          IconButton(
                            icon: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => _FullscreenVideoPlayer(
                                    controller: _videoController!,
                                    poseName: YogaLocalizationHelper.getPoseName(context, currentPose.nameKey),
                                    playbackSpeed: _playbackSpeed,
                                    onSpeedChanged: (speed) {
                                      setState(() {
                                        _playbackSpeed = speed;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Tap to play/pause overlay
            if (_showVideoControls && _isVideoInitialized)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 48,
                          color: Colors.white,
                        ),
                        onPressed: _toggleVideo,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: [
          // Pose name - larger font
          Text(
            YogaLocalizationHelper.getPoseName(context, currentPose.nameKey),
            style: GoogleFonts.poppins(
              fontSize: 24,  // Larger for elderly
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Duration badge with clock icon (like pose detail)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF40E0D0).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFF40E0D0),
                ),
                const SizedBox(width: 6),
                Text(
                  '${currentPose.durationSeconds ~/ 60}:${(currentPose.durationSeconds % 60).toString().padLeft(2, '0')} min',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF40E0D0),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Timer display - very large
          Text(
            _formatTime(_remainingSeconds),
            style: GoogleFonts.poppins(
              fontSize: 64,  // Even larger
              fontWeight: FontWeight.bold,
              color: const Color(0xFF40E0D0),
              height: 1,
            ),
          ),
          const SizedBox(height: 16),

          // Progress text row - larger fonts
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' ${AppLocalizations.of(context)!.totalTime}',
                style: GoogleFonts.poppins(
                  fontSize: 14,  // Larger
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _formatTime(_totalTimeSpent),
                style: GoogleFonts.poppins(
                  fontSize: 18,  // Larger
                  color: Colors.white,  // Better contrast
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).round()}% ${AppLocalizations.of(context)!.completed}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,  // Larger
                    color: Colors.white,  // Better contrast
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Previous button - outlined style (like pose detail)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _currentPoseIndex > 0 ? _goToPreviousPose : null,

              label: Text(
                'Previous',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: _currentPoseIndex > 0
                      ? Colors.white.withOpacity(0.3)
                      : Colors.grey[800]!,
                  width: 2,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Play/Pause button - large circular (centered)
          Container(
            width: 80,  // Larger for easier tapping
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF40E0D0),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isPaused || !_isTimerRunning ? Icons.play_arrow : Icons.pause,
                size: 40,  // Larger
                color: Colors.white,
              ),
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                if (_isPaused || !_isTimerRunning) {
                  _resumeTimer();
                } else {
                  _pauseTimer();
                }
              },
            ),
          ),

          const SizedBox(width: 14),

          // Next button - teal filled (like pose detail)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _skipToNextPose,

              label: Text(
                AppLocalizations.of(context)!.next,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoseInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // Slightly lighter dark gray
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.aboutThisPose,
            style: GoogleFonts.poppins(
              fontSize: 20,  // Larger for elderly
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Use instructions, not description
          Text(
            currentPose.instructions,  // Changed from descriptionKey
            style: GoogleFonts.poppins(
              fontSize: 17,  // Larger, easier to read
              color: Colors.white,  // Better contrast
              height: 1.7,
            ),
          ),
          const SizedBox(height: 24),
          // Safety tips header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.safetyTips,
                style: GoogleFonts.poppins(
                  fontSize: 20,  // Larger for elderly
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Use modifications as safety tips
          ...currentPose.modifications.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip,
                    style: GoogleFonts.poppins(
                      fontSize: 16,  // Larger, easier to read
                      color: Colors.white,  // Better contrast
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPlaylist() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              children: [
                Text(
                  'Session Playlist',
                  style: GoogleFonts.poppins(
                    fontSize: 22,  // Larger for elderly
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF40E0D0).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_completedPoseIds.length}/${widget.session.allPoses.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,  // Larger
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF40E0D0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...widget.session.allPoses.asMap().entries.map((entry) {
            final index = entry.key;
            final pose = entry.value;
            final isCompleted = _completedPoseIds.contains(pose.id);
            final isCurrent = index == _currentPoseIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),  // More padding
              decoration: BoxDecoration(
                color: isCurrent
                    ? const Color(0xFF40E0D0).withOpacity(0.15)
                    : const Color(0xFF2A2A2A),  // Dark theme
                border: Border.all(
                  color: isCurrent ? const Color(0xFF40E0D0) : Colors.grey[800]!,
                  width: isCurrent ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Pose number or checkmark - larger
                  Container(
                    width: 42,  // Larger
                    height: 42,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF40E0D0)
                          : isCurrent
                          ? const Color(0xFF40E0D0).withOpacity(0.2)
                          : Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                        Icons.check,
                        size: 24,  // Larger
                        color: Colors.white,
                      )
                          : Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,  // Larger
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? const Color(0xFF40E0D0) : Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Pose name and duration
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          YogaLocalizationHelper.getPoseName(context, pose.nameKey),
                          style: GoogleFonts.poppins(
                            fontSize: 17,  // Larger
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                            color: Colors.white,  // White for dark theme
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${pose.durationSeconds ~/ 60}:${(pose.durationSeconds % 60).toString().padLeft(2, '0')} min',
                          style: GoogleFonts.poppins(
                            fontSize: 14,  // Larger
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Current playing indicator
                  if (isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Playing',
                        style: GoogleFonts.poppins(
                          fontSize: 13,  // Larger
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          AppLocalizations.of(context)!.exitSession,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.exitSessionMessage,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await GlobalAudioService.playClickSound();
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await GlobalAudioService.playClickSound();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit session
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.exit,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fullscreen Video Player
class _FullscreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String poseName;
  final double playbackSpeed;
  final Function(double) onSpeedChanged;

  const _FullscreenVideoPlayer({
    required this.controller,
    required this.poseName,
    required this.playbackSpeed,
    required this.onSpeedChanged,
  });

  @override
  State<_FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<_FullscreenVideoPlayer> {
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late double _currentSpeed;

  @override
  void initState() {
    super.initState();
    _currentSpeed = widget.playbackSpeed;
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.controller.value.isPlaying) {
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
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
    });
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
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
        onTap: () async {
          await GlobalAudioService.playClickSound();
          _toggleControls();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video player - fill screen
            Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: widget.controller.value.size.width,
                  height: widget.controller.value.size.height,
                  child: VideoPlayer(widget.controller),
                ),
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
                                size: 28,
                              ),
                              onPressed: () async {
                                await GlobalAudioService.playClickSound();
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.poseName,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
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
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 48,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await GlobalAudioService.playClickSound();
                          _togglePlayPause();
                        },
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

                          // Time and controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Current time / Total time
                              Text(
                                '${_formatDuration(widget.controller.value.position)} / ${_formatDuration(widget.controller.value.duration)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),

                              Row(
                                children: [
                                  // Playback speed
                                  PopupMenuButton<double>(
                                    icon: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${_currentSpeed}x',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    onSelected: (speed) {
                                      setState(() {
                                        _currentSpeed = speed;
                                        widget.controller.setPlaybackSpeed(speed);
                                        widget.onSpeedChanged(speed);
                                      });
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(value: 0.5, child: Text('0.5x', style: GoogleFonts.poppins())),
                                      PopupMenuItem(value: 0.75, child: Text('0.75x', style: GoogleFonts.poppins())),
                                      PopupMenuItem(value: 1.0, child: Text('1.0x (Normal)', style: GoogleFonts.poppins())),
                                      PopupMenuItem(value: 1.25, child: Text('1.25x', style: GoogleFonts.poppins())),
                                      PopupMenuItem(value: 1.5, child: Text('1.5x', style: GoogleFonts.poppins())),
                                      PopupMenuItem(value: 2.0, child: Text('2.0x', style: GoogleFonts.poppins())),
                                    ],
                                  ),

                                  const SizedBox(width: 8),

                                  // Volume
                                  IconButton(
                                    icon: Icon(
                                      widget.controller.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (widget.controller.value.volume > 0) {
                                          widget.controller.setVolume(0);
                                        } else {
                                          widget.controller.setVolume(1.0);
                                        }
                                      });
                                    },
                                  ),
                                ],
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
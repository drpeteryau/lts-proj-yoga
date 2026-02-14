import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

import '../l10n/app_localizations.dart';
import '../models/yoga_pose.dart';
import '../services/global_audio_service.dart';
import '../utils/yoga_localization_helper.dart';

/// Pose Detail Screen - Information/Learning page
/// No timer, no completion tracking, just educational content
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
  late int _currentPoseIndex;

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _showVideoControls = false;
  Timer? _hideControlsTimer;
  double _playbackSpeed = 1.0;

  // Practice time tracking (no completion, just analytics)
  DateTime? _poseStartTime;
  final Set<String> _savedPoseIds = {};

  bool get isWeb => MediaQuery.of(context).size.width > 600;
  YogaPose get currentPose => widget.allPoses[_currentPoseIndex];

  @override
  void initState() {
    super.initState();
    _currentPoseIndex = widget.currentIndex.clamp(0, widget.allPoses.length - 1);
    _poseStartTime = DateTime.now();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    await _videoController?.dispose();

    // Placeholder video URL
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://rkhmailqbmbijsfzhcch.supabase.co/storage/v1/object/public/pose-videos/beginner/NeckHeadShoulders.MOV',
      ),
    );

    try {
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!.setPlaybackSpeed(_playbackSpeed);
      await _videoController!.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
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
      if (mounted && (_videoController?.value.isPlaying ?? false)) {
        setState(() {
          _showVideoControls = false;
        });
      }
    });
  }

  Future<void> _flushPoseTime() async {
    if (_poseStartTime == null) return;
    if (_savedPoseIds.contains(currentPose.id)) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final secondsSpent = DateTime.now().difference(_poseStartTime!).inSeconds;
    if (secondsSpent < 5) return; // Only track if spent at least 5 seconds

    try {
      await Supabase.instance.client.from('pose_activity').insert({
        'user_id': userId,
        'pose_id': currentPose.id,
        'pose_name': YogaLocalizationHelper.getPoseName(context, currentPose.nameKey),
        'session_level': widget.sessionLevel,
        'duration_seconds': secondsSpent,
        'completed_at': DateTime.now().toIso8601String(),
        'activity_date': DateTime.now().toIso8601String().split('T')[0],
      });

      _savedPoseIds.add(currentPose.id);
      debugPrint('✅ Saved practice time: ${currentPose.id}, ${secondsSpent}s');
    } catch (e) {
      debugPrint('❌ Error saving practice time: $e');
    }
  }

  Future<void> _goToPose(int newIndex) async {
    if (newIndex < 0 || newIndex >= widget.allPoses.length) return;
    if (newIndex == _currentPoseIndex) return;

    await GlobalAudioService.playClickSound();
    await _flushPoseTime();

    setState(() {
      _currentPoseIndex = newIndex;
      _poseStartTime = DateTime.now();
    });

    await _initializeVideo();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoController?.dispose();
    _flushPoseTime();
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
              // Video section - top half
              Expanded(
                child: _buildVideoSection(),
              ),

              // Information section - bottom half
              Expanded(
                child: _buildInformationPanel(),
              ),
            ],
          ),

          // Close button (top-left)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  await _flushPoseTime();
                  if (mounted) Navigator.of(context).pop();
                },
              ),
            ),
          ),

          // Pose counter (top-right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentPoseIndex + 1}/${widget.allPoses.length}',
                style: GoogleFonts.poppins(
                  fontSize: 16,  // Larger
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

            // Video controls (bottom)
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
                          // Playback speed
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

  Widget _buildInformationPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
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

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pose name
                  Text(
                    YogaLocalizationHelper.getPoseName(context, currentPose.nameKey),
                    style: GoogleFonts.poppins(
                      fontSize: 28,  // Very large for elderly
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Duration badge
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
                          size: 18,
                          color: Color(0xFF40E0D0),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${currentPose.durationSeconds ~/ 60}:${(currentPose.durationSeconds % 60).toString().padLeft(2, '0')} min',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF40E0D0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // How to do this pose
                  Text(
                    'How to Do This Pose',
                    style: GoogleFonts.poppins(
                      fontSize: 22,  // Large
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Instructions
                  Text(
                    currentPose.instructions,
                    style: GoogleFonts.poppins(
                      fontSize: 17,  // Large, easy to read
                      color: Colors.white,  // Good contrast
                      height: 1.7,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Safety tips section
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
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Safety Tips',
                        style: GoogleFonts.poppins(
                          fontSize: 22,  // Large
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Safety tips list
                  ...currentPose.modifications.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
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
                              fontSize: 16,  // Large
                              color: Colors.white,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 32),

                  // Info notice
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'This is for learning only. To track progress, use "Join Class" from the session screen.',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.blue[200],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Navigation buttons at bottom
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                // Previous button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentPoseIndex > 0
                        ? () => _goToPose(_currentPoseIndex - 1)
                        : null,

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

                // Next button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentPoseIndex < widget.allPoses.length - 1
                        ? () => _goToPose(_currentPoseIndex + 1)
                        : null,

                    label: Text(
                      'Next',
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
                      disabledBackgroundColor: Colors.grey[800],
                    ),
                  ),
                ),
              ],
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
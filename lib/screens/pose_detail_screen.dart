import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

import '../l10n/app_localizations.dart';
import '../models/yoga_pose.dart';
import '../services/global_audio_service.dart';
import '../utils/yoga_localization_helper.dart';

/// A "session-style" pose detail screen (similar layout to FullSessionScreen),
/// but **no timer** and users can jump between poses freely.
class PoseDetailScreen extends StatefulWidget {

  final VideoPlayerController? controller;
  final double? playbackSpeed;
  final ValueChanged<double>? onSpeedChanged;
  final YogaPose pose;
  final List<YogaPose> allPoses;
  final int currentIndex;
  final String sessionLevel;
  final int _currentPoseIndex = 0;

  const PoseDetailScreen({
    super.key,
    required this.pose,
    required this.allPoses,
    required this.currentIndex,
    required this.sessionLevel,
    this.controller,
    this.playbackSpeed,
    this.onSpeedChanged,
  });

  @override
  State<PoseDetailScreen> createState() => _PoseDetailScreenState();
}

class _PoseDetailScreenState extends State<PoseDetailScreen> {
  // Navigation
  late int _currentPoseIndex;

  // Video
  bool _showControls = true;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;

  bool _showVideoControls = false;
  Timer? _hideControlsTimer;

  // Practice-time tracking per pose (no completion gating)
  DateTime? _poseStartTime;
  final Set<String> _savedPoseIds = <String>{};

  double _currentSpeed = 1.0;


  VideoPlayerController? get _activeController => _videoController ?? widget.controller;

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }


  bool get isWeb => MediaQuery.of(context).size.width > 600;

  YogaPose get _pose => widget.allPoses[_currentPoseIndex];

  @override
  void initState() {
    super.initState();
    _currentPoseIndex = widget.currentIndex.clamp(0, widget.allPoses.length - 1);
    _poseStartTime = DateTime.now();
    _currentSpeed = widget.playbackSpeed ?? 1.0;
    _initializeVideoForPose(_pose);
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && (_activeController?.value.isPlaying ?? false)) {
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
    final ctrl = _activeController;
    if (ctrl == null) return;
    setState(() {
      if (ctrl.value.isPlaying) {
        ctrl.pause();
      } else {
        ctrl.play();
      }
    });
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoController?.dispose();
    _flushPoseTime(); // best-effort
    super.dispose();
  }

  Future<void> _initializeVideoForPose(YogaPose pose) async {
    // Dispose old controller
    final old = _videoController;
    _videoController = null;
    _isVideoInitialized = false;
    _isVideoPlaying = false;
    old?.removeListener(_videoListener);
    await old?.dispose();

    // TODO: Replace with a real mapping from pose -> video url.
    // For now, this matches FullSessionScreen's placeholder approach.
    final videoUrl =
        'https://rkhmailqbmbijsfzhcch.supabase.co/storage/v1/object/public/pose-videos/beginner/NeckHeadShoulders.MOV';

    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _videoController = controller;

    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      controller.addListener(_videoListener);

      if (!mounted) return;
      setState(() {
        _isVideoInitialized = true;
        _isVideoPlaying = controller.value.isPlaying;
      });
    } catch (e) {
      // If video fails, UI will fall back to the pose image.
      debugPrint('Error initializing video: $e');
      if (!mounted) return;
      setState(() {
        _isVideoInitialized = false;
        _isVideoPlaying = false;
      });
    }
  }

  void _videoListener() {
    if (!mounted || _videoController == null) return;
    final playing = _videoController!.value.isPlaying;
    if (playing != _isVideoPlaying) {
      setState(() => _isVideoPlaying = playing);
    }
  }



  void _showControlsTemporarily() {
    setState(() => _showVideoControls = true);
    _startHideControlsTimer();
  }



  Future<void> _flushPoseTime() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final started = _poseStartTime;
    if (started == null) return;

    final secondsSpent = DateTime.now().difference(started).inSeconds;
    if (secondsSpent <= 0) return;

    // avoid duplicating inserts for the same pose within a single visit
    if (_savedPoseIds.contains(_pose.id)) return;

    try {
      await Supabase.instance.client.from('pose_activity').insert({
        'user_id': userId,
        'pose_id': _pose.id,
        'pose_name': YogaLocalizationHelper.getPoseName(context, _pose.nameKey),
        'session_level': widget.sessionLevel,
        'duration_seconds': secondsSpent,
        'completed_at': DateTime.now().toIso8601String(),
        'activity_date': DateTime.now().toIso8601String().split('T')[0],
      });

      _savedPoseIds.add(_pose.id);
      debugPrint('✅ Saved pose time: ${_pose.id}, ${secondsSpent}s');
    } catch (e) {
      debugPrint('❌ Error saving pose time: $e');
    }
  }

  Future<void> _goToPose(int newIndex) async {
    if (newIndex < 0 || newIndex >= widget.allPoses.length) return;
    if (newIndex == _currentPoseIndex) return;

    await GlobalAudioService.playClickSound();

    // Save time spent on current pose before switching
    await _flushPoseTime();

    setState(() {
      _currentPoseIndex = newIndex;
      _poseStartTime = DateTime.now();
      _showVideoControls = false;
    });

    await _initializeVideoForPose(_pose);
  }



  void _openPosePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * (isWeb ? 0.55 : 0.65),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Poses',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: widget.allPoses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final p = widget.allPoses[index];
                    final selected = index == _currentPoseIndex;
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        _goToPose(index);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF40E0D0).withOpacity(0.12) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? const Color(0xFF40E0D0) : Colors.black12,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                p.imageUrl,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.black12,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_not_supported_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                YogaLocalizationHelper.getPoseName(context, p.nameKey),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(Icons.check_circle, color: Color(0xFF40E0D0)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _buildVideoSection()),
              Expanded(child: _buildBottomPanel()),
            ],
          ),

          // Close button (top-left)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _roundIconButton(
              icon: Icons.close,
              onTap: () async {
                await GlobalAudioService.playClickSound();
                await _flushPoseTime();
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ),

          // Poses button (top-right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: _roundIconButton(
              icon: Icons.list_alt_rounded,
              onTap: () async {
                await GlobalAudioService.playClickSound();
                _openPosePicker();
              },

            ),
          ),

          // Index indicator (top-center)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${_currentPoseIndex + 1} / ${widget.allPoses.length}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }



  Widget _buildVideoSection() {
    return GestureDetector(
      onTap: () {
        _toggleControls();
        _showControlsTemporarily();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player - fill screen
          Positioned.fill(
            child: Builder(
              builder: (context) {
                final ctrl = _activeController;
                if (ctrl == null || !ctrl.value.isInitialized) {
                  return const Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  );
                }
                final size = ctrl.value.size;
                return FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: VideoPlayer(ctrl),
                  ),
                );
              },
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
                        (_activeController?.value.isPlaying ?? false) ? Icons.pause : Icons.play_arrow,
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
                        Builder(
                          builder: (context) {
                            final ctrl = _activeController;
                            if (ctrl == null || !ctrl.value.isInitialized) {
                              return const SizedBox.shrink();
                            }
                            return VideoProgressIndicator(
                              ctrl,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Color(0xFF40E0D0),
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white12,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            );
                          },
                        ),

                        // Time and controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Current time / Total time
                            Text(
                              '${_formatDuration((_activeController?.value.position) ?? Duration.zero)} / ${_formatDuration((_activeController?.value.duration) ?? Duration.zero)}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black,
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
                                      _activeController?.setPlaybackSpeed(speed);
                                      widget.onSpeedChanged?.call(speed);
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
                                    ((_activeController?.value.volume ?? 0) > 0) ? Icons.volume_up : Icons.volume_off,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (((_activeController?.value.volume ?? 0) > 0)) {
                                        _activeController?.setVolume(0);
                                      } else {
                                        _activeController?.setVolume(1.0);
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
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 18, 20, isWeb ? 24 : 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Grab handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 14),

          // Main content scroll
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoseTitle(),

                  const SizedBox(height: 16),
                  _buildDescription(),

                  _buildBenefits(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Navigation row (free toggle, no completion requirement)
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _currentPoseIndex > 0 ? () => _goToPose(_currentPoseIndex - 1) : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Previous',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _currentPoseIndex < widget.allPoses.length - 1
                      ? () => _goToPose(_currentPoseIndex + 1)
                      : () => _goToPose(_currentPoseIndex), // last pose: stay
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40E0D0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _currentPoseIndex < widget.allPoses.length - 1
                        ? AppLocalizations.of(context)!.nextPose
                        : AppLocalizations.of(context)!.nextPose,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPoseTitle() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      Text(
      YogaLocalizationHelper.getPoseName(context, _pose.nameKey),
      style: GoogleFonts.poppins(
        fontSize: isWeb ? 26 : 26,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      ),
      ]),
    );
  }



  Widget _buildDescription() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          AppLocalizations.of(context)!.aboutThisPose,
      style: GoogleFonts.poppins(
        fontSize: 22,  // Larger for elderly
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    const SizedBox(height: 16),
    // Use instructions, not description
    Text(
    _pose.instructions,  // Changed from descriptionKey
    style: GoogleFonts.poppins(
    fontSize: 17,  // Larger, easier to read
    fontWeight: FontWeight.w400,
    color: Colors.black,  // Better contrast
    height: 1.7,
    ),
    ),
    ]),
    );
  }

  Widget _buildBenefits() {
    // Keep this lightweight but informative.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.safetyTips,
            style: GoogleFonts.poppins(
              fontSize: 20,  // Larger for elderly
              fontWeight: FontWeight.bold,
              color: const Color(0xFF40E0D0),
            ),
          ),
          const SizedBox(height: 12),
          // Use modifications as safety tips
          ..._pose.modifications.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 22,  // Larger
                  color: Color(0xFF40E0D0),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip,
                    style: GoogleFonts.poppins(
                      fontSize: 16,  // Larger, easier to read
                      color: Colors.black,  // Better contrast
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

  Widget _tipRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(fontSize: 14, height: 1.45, color: Colors.black87),
          ),
        ),
      ],
    );
  }

}

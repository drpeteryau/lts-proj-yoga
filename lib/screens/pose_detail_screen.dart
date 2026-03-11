import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import '../l10n/app_localizations.dart';
import '../models/yoga_pose.dart';
import '../services/global_audio_service.dart';
import '../services/simple_pin_dialog.dart';
import '../services/simple_pin_service.dart';
import '../utils/yoga_localization_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants & Theme
// ─────────────────────────────────────────────────────────────────────────────
const _kTeal = Color(0xFF40E0D0);
const _kControlsHide = Duration(seconds: 3);
const _kMinTrackSec = 5;
const _kWebBreak = 900.0;
const _kPlaceholderUrl =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

// Light-mode palette
const _kBg = Colors.white;
const _kSurface = Color(0xFFF8F8F8);
const _kText = Color(0xFF1A1A1A);
const _kSubText = Color(0xFF666666);
const _kBorder = Color(0xFFE8E8E8);
const _kWebBg = Color(0xFFF5F5F5);
const _kWebSidebar = Colors.white;
const _kWebTopBar = Colors.white;

// ─────────────────────────────────────────────────────────────────────────────
// PoseDetailScreen
// ─────────────────────────────────────────────────────────────────────────────

/// Educational pose detail screen (no timer, no completion tracking).
/// • Mobile  → 16:9 video at top + scrollable info below
/// • Web     → YouTube-style: video+info left, pose sidebar right (light mode)
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
  YogaPose get _pose => widget.allPoses[_currentPoseIndex];

  VideoPlayerController? _ctrl;
  bool _videoReady = false;
  final ValueNotifier<bool> _showControls = ValueNotifier(true);
  Timer? _hideTimer;
  double _speed = 1.0;

  DateTime? _poseStart;
  final Set<String> _tracked = {};

  // ── Lifecycle ──────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentPoseIndex =
        widget.currentIndex.clamp(0, widget.allPoses.length - 1);
    _poseStart = DateTime.now();
    _checkPin();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _showControls.dispose();
    _ctrl?.dispose();
    _flushTime();
    super.dispose();
  }

  // ── PIN / init ─────────────────────────────────────────────────────────

  Future<void> _checkPin() async {
    if (SimplePinService.isPinVerifiedThisSession()) {
      await _initVideo();
      return;
    }
    Future.microtask(() {
      if (mounted) _showPinDialog();
    });
  }

  void _showPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimplePinDialog(onSuccess: _initVideo),
    );
  }

  Future<void> _initVideo() async {
    // Dispose old controller first
    final old = _ctrl;
    if (old != null) {
      if (mounted) setState(() => _videoReady = false);
      await old.dispose();
      _ctrl = null;
    }

    final pose = _pose;
    final VideoPlayerController c;
    if (pose.videoAsset?.isNotEmpty == true) {
      c = VideoPlayerController.asset(pose.videoAsset!);
    } else if (pose.videoUrl?.isNotEmpty == true) {
      c = VideoPlayerController.networkUrl(Uri.parse(pose.videoUrl!));
    } else {
      c = VideoPlayerController.networkUrl(Uri.parse(_kPlaceholderUrl));
    }
    _ctrl = c;

    try {
      await c.initialize();
      await Future.wait([
        c.setLooping(true),
        c.setPlaybackSpeed(_speed),
        c.play(),
      ]);
      if (mounted) {
        setState(() => _videoReady = true);
        _revealControls();
      }
    } catch (e) {
      debugPrint('❌ Video init: $e');
      if (mounted) setState(() => _videoReady = false);
    }
  }

  // ── Video controls ────────────────────────────────────────────────────

  void _togglePlay() {
    final c = _ctrl;
    if (c == null || !_videoReady) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
    setState(() {});
    _revealControls();
  }

  void _revealControls() {
    _showControls.value = true;
    _hideTimer?.cancel();
    // Only auto-hide while playing; if paused, controls stay visible permanently
    if (_ctrl?.value.isPlaying ?? false) {
      _hideTimer = Timer(_kControlsHide, () {
        if (mounted && (_ctrl?.value.isPlaying ?? false)) {
          _showControls.value = false;
        }
      });
    }
  }

  // ── Analytics ─────────────────────────────────────────────────────────
  // pose_detail_screen is browse-only. Do NOT write to pose_activity here —
  // only full_session_screen (timer-started) should count toward progress.
  Future<void> _flushTime() async {
    _poseStart = null;
  }

  // ── Navigation ────────────────────────────────────────────────────────

  Future<void> _goTo(int i) async {
    if (i < 0 || i >= widget.allPoses.length || i == _currentPoseIndex) return;
    await GlobalAudioService.playClickSound();
    await _flushTime();
    setState(() {
      _currentPoseIndex = i;
      _poseStart = DateTime.now();
      _videoReady = false;
    });
    await _initVideo();
  }

  Future<void> _onClose() async {
    await GlobalAudioService.playClickSound();
    await _flushTime();
    if (mounted) Navigator.of(context).pop();
  }

  // ── Fullscreen ────────────────────────────────────────────────────────
  // KEY FIX: We do NOT pass ownership of the controller to fullscreen.
  // Fullscreen receives the same controller instance. On push we keep
  // playing; on pop the controller is still valid and continues playing.

  Future<void> _openFullscreen() async {
    final c = _ctrl;
    if (c == null || !_videoReady) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenPlayer(
          controller: c,
          poseName:
          YogaLocalizationHelper.getPoseName(context, _pose.nameKey),
          speed: _speed,
          onSpeedChanged: (s) => setState(() => _speed = s),
        ),
      ),
    );
    if (!mounted) return;
    // On web, the VideoPlayer platform view loses its texture when the
    // fullscreen route is popped. Force a remount by toggling _videoReady.
    if (kIsWeb) {
      setState(() => _videoReady = false);
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
    }
    _ctrl?.play();
    _revealControls();
    setState(() => _videoReady = true);
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width >= _kWebBreak;
    return Scaffold(
      backgroundColor: isWeb ? _kWebBg : _kBg,
      body: isWeb ? _webLayout() : _mobileLayout(),
    );
  }

  // ── Mobile layout ─────────────────────────────────────────────────────

  Widget _mobileLayout() {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // 16:9 video block (black bg extends behind status bar)
            SliverToBoxAdapter(
              child: Container(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _VideoCore(
                    pinVerified: SimplePinService.isPinVerifiedThisSession(),
                    ready: _videoReady,
                    ctrl: _ctrl,
                    showControls: _showControls,
                    speed: _speed,
                    onTap: _togglePlay,
                    onTogglePlay: _togglePlay,
                    onSpeedChanged: (s) {
                      setState(() {
                        _speed = s;
                        _ctrl?.setPlaybackSpeed(s);
                      });
                    },
                    onFullscreen: _openFullscreen,
                  ),
                ),
              ),
            ),

            // Info panel (white card with rounded top)
            SliverToBoxAdapter(
              child: _InfoPanel(
                pose: _pose,
                sessionLevel: widget.sessionLevel,
                currentIndex: _currentPoseIndex,
                totalPoses: widget.allPoses.length,
                onPrevious:
                _currentPoseIndex > 0 ? () => _goTo(_currentPoseIndex - 1) : null,
                onNext: _currentPoseIndex < widget.allPoses.length - 1
                    ? () => _goTo(_currentPoseIndex + 1)
                    : null,
                isWeb: false,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 16),
            ),
          ],
        ),

        // Close button (over the black video area)
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 12,
          child: _CircleBtn(
            icon: Icons.close,
            iconColor: _kTeal,
            bg: Colors.white.withOpacity(0.92),
            onTap: _onClose,
          ),
        ),

        // Pose counter (over the black video area)
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 12,
          child: _CounterBadge(
              current: _currentPoseIndex + 1,
              total: widget.allPoses.length),
        ),
      ],
    );
  }

  // ── Web layout (light, YouTube-style) ─────────────────────────────────

  Widget _webLayout() {
    return Column(
      children: [
        _WebBar(onClose: _onClose),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: video + info
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 16:9 video
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: _VideoCore(
                            pinVerified:
                            SimplePinService.isPinVerifiedThisSession(),
                            ready: _videoReady,
                            ctrl: _ctrl,
                            showControls: _showControls,
                            speed: _speed,
                            onTap: _togglePlay,
                            onTogglePlay: _togglePlay,
                            onSpeedChanged: (s) {
                              setState(() {
                                _speed = s;
                                _ctrl?.setPlaybackSpeed(s);
                              });
                            },
                            onFullscreen: _openFullscreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _InfoPanel(
                        pose: _pose,
                        sessionLevel: widget.sessionLevel,
                        currentIndex: _currentPoseIndex,
                        totalPoses: widget.allPoses.length,
                        onPrevious: _currentPoseIndex > 0
                            ? () => _goTo(_currentPoseIndex - 1)
                            : null,
                        onNext: _currentPoseIndex < widget.allPoses.length - 1
                            ? () => _goTo(_currentPoseIndex + 1)
                            : null,
                        isWeb: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Right: sidebar
              Container(
                width: 340,
                decoration: const BoxDecoration(
                  color: _kWebSidebar,
                  border: Border(
                      left: BorderSide(color: _kBorder, width: 1)),
                ),
                child: _PoseSidebar(
                  poses: widget.allPoses,
                  currentIndex: _currentPoseIndex,
                  onTap: _goTo,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VideoCore  — shared by mobile & web, sits inside an AspectRatio(16/9)
// ─────────────────────────────────────────────────────────────────────────────

class _VideoCore extends StatelessWidget {
  final bool pinVerified;
  final bool ready;
  final VideoPlayerController? ctrl;
  final ValueNotifier<bool> showControls;
  final double speed;
  final VoidCallback onTap;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onFullscreen;

  const _VideoCore({
    required this.pinVerified,
    required this.ready,
    required this.ctrl,
    required this.showControls,
    required this.speed,
    required this.onTap,
    required this.onTogglePlay,
    required this.onSpeedChanged,
    required this.onFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    if (!pinVerified) return _PinWait();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video or spinner — IgnorePointer so the VideoPlayer never eats taps
            if (ready && ctrl != null)
              IgnorePointer(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: ctrl!.value.aspectRatio,
                    child: VideoPlayer(ctrl!),
                  ),
                ),
              )
            else
              const Center(child: CircularProgressIndicator(color: _kTeal)),

            // Controls – always in tree so ValueListenableBuilder keeps ticking
            if (ready && ctrl != null)
              ValueListenableBuilder<bool>(
                valueListenable: showControls,
                builder: (_, vis, child) => IgnorePointer(
                  ignoring: !vis,
                  child: AnimatedOpacity(
                    opacity: vis ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 220),
                    child: child,
                  ),
                ),
                child: _VideoOverlay(
                  ctrl: ctrl!,
                  speed: speed,
                  onTogglePlay: onTogglePlay,
                  onSpeedChanged: onSpeedChanged,
                  onFullscreen: onFullscreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VideoOverlay  — gradient + centre play/pause + bottom scrub bar
// ─────────────────────────────────────────────────────────────────────────────

class _VideoOverlay extends StatelessWidget {
  final VideoPlayerController ctrl;
  final double speed;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onFullscreen;

  const _VideoOverlay({
    required this.ctrl,
    required this.speed,
    required this.onTogglePlay,
    required this.onSpeedChanged,
    required this.onFullscreen,
  });

  static String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Top-to-bottom gradient — IgnorePointer so it never eats taps
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.40),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.80),
                ],
                stops: const [0.0, 0.25, 0.60, 1.0],
              ),
            ),
          ),
        ),

        // Centre play/pause — tap handled by outer GestureDetector
        Center(
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.52),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30, width: 1.5),
            ),
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: ctrl,
              builder: (_, v, __) => Icon(
                v.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: ctrl,
              builder: (ctx, v, __) {
                final dur = v.duration;
                final pos = v.position;
                final prog = dur.inMilliseconds > 0
                    ? (pos.inMilliseconds / dur.inMilliseconds)
                    .clamp(0.0, 1.0)
                    : 0.0;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Scrub slider
                    SliderTheme(
                      data: SliderTheme.of(ctx).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12),
                        trackHeight: 2.5,
                        activeTrackColor: _kTeal,
                        inactiveTrackColor: Colors.white30,
                        thumbColor: _kTeal,
                        overlayColor: _kTeal.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: prog,
                        onChanged: (val) => ctrl.seekTo(Duration(
                            milliseconds:
                            (val * dur.inMilliseconds).round())),
                      ),
                    ),
                    // Time + controls row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Text(
                            '${_fmt(pos)} / ${_fmt(dur)}',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.white70),
                          ),
                          const Spacer(),
                          _SpeedBtn(
                              currentSpeed: speed,
                              onSelected: onSpeedChanged),
                          _VolBtn(ctrl: ctrl),
                          IconButton(
                            onPressed: onFullscreen,
                            icon: const Icon(Icons.fullscreen,
                                color: Colors.white, size: 22),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 34, minHeight: 34),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoPanel  — light mode, adapts mobile vs web text colours
// ─────────────────────────────────────────────────────────────────────────────

class _InfoPanel extends StatelessWidget {
  final YogaPose pose;
  final String sessionLevel;
  final int currentIndex;
  final int totalPoses;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isWeb;

  const _InfoPanel({
    required this.pose,
    required this.sessionLevel,
    required this.currentIndex,
    required this.totalPoses,
    required this.onPrevious,
    required this.onNext,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle (mobile only)
        if (!isWeb)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),

        Padding(
          padding: EdgeInsets.fromLTRB(
              isWeb ? 0 : 20, isWeb ? 0 : 10, isWeb ? 0 : 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pose name
              Text(
                YogaLocalizationHelper.getPoseName(context, pose.nameKey),
                style: GoogleFonts.poppins(
                    fontSize: isWeb ? 22 : 24,
                    fontWeight: FontWeight.bold,
                    color: _kText,
                    height: 1.25),
              ),
              const SizedBox(height: 10),

              // Duration badge
              _DurBadge(
                  minutes: pose.durationSeconds ~/ 60,
                  seconds: pose.durationSeconds % 60,
                  l10n: l10n),
              const SizedBox(height: 24),

              // How-to
              Text(l10n.howToDoTitle,
                  style: GoogleFonts.poppins(
                      fontSize: isWeb ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: _kText)),
              const SizedBox(height: 10),
              Text(
                YogaLocalizationHelper.getPoseInstructions(
                    context, pose.instructions),
                style: GoogleFonts.poppins(
                    fontSize: isWeb ? 14 : 15,
                    color: _kSubText,
                    height: 1.75),
              ),
              const SizedBox(height: 28),

              // Safety tips
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.health_and_safety,
                      color: Colors.orange, size: 20),
                ),
                const SizedBox(width: 10),
                Text(l10n.safetyTips,
                    style: GoogleFonts.poppins(
                        fontSize: isWeb ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
              ]),
              const SizedBox(height: 12),

              ...pose.modifications.map((tipKey) {
                final tip = YogaLocalizationHelper.getPoseModifications(
                    context, tipKey);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: const Icon(Icons.check,
                            size: 11, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(tip,
                            style: GoogleFonts.poppins(
                                fontSize: isWeb ? 13 : 14,
                                color: _kSubText,
                                height: 1.6)),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Info notice
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.blue.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.blue, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(l10n.learningNotice,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blue[700],
                              height: 1.5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Back / Next buttons
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _kTeal,
                      side: BorderSide(
                          color: onPrevious != null
                              ? _kTeal
                              : Colors.grey[300]!,
                          width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(l10n.back,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: onPrevious != null
                                ? _kTeal
                                : Colors.grey[400])),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kTeal,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[200],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(l10n.next,
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ],
    );

    if (isWeb) return body;

    // Mobile: white rounded-top card
    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -3)),
        ],
      ),
      child: body,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PoseSidebar — light mode YouTube-style pose list
// ─────────────────────────────────────────────────────────────────────────────

class _PoseSidebar extends StatelessWidget {
  final List<YogaPose> poses;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _PoseSidebar({
    required this.poses,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text('All Poses',
              style: GoogleFonts.poppins(
                  color: _kText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: poses.length,
            itemBuilder: (_, i) => _SidebarCard(
              pose: poses[i],
              index: i,
              isActive: i == currentIndex,
              onTap: () => onTap(i),
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarCard extends StatelessWidget {
  final YogaPose pose;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarCard({
    required this.pose,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  static const _grads = [
    [Color(0xFF40E0D0), Color(0xFF0077B6)],
    [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    [Color(0xFF7B2FBE), Color(0xFF40E0D0)],
    [Color(0xFF56CCF2), Color(0xFF2F80ED)],
    [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
  ];

  @override
  Widget build(BuildContext context) {
    final name = YogaLocalizationHelper.getPoseName(context, pose.nameKey);
    final mins = pose.durationSeconds ~/ 60;
    final secs = (pose.durationSeconds % 60).toString().padLeft(2, '0');
    final g = _grads[index % _grads.length];

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? _kTeal.withOpacity(0.08) : Colors.transparent,
          border: isActive
              ? const Border(left: BorderSide(color: _kTeal, width: 3))
              : null,
        ),
        child: Row(
          children: [
            // Thumbnail
            SizedBox(
              width: 110,
              height: 62,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    pose.imageUrl?.isNotEmpty == true
                        ? Image.network(pose.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _GradThumb(g: g))
                        : _GradThumb(g: g),
                    // Duration badge
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text('$mins:$secs',
                            style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                    if (isActive)
                      Container(
                        color: Colors.black.withOpacity(0.35),
                        child: const Center(
                          child: Icon(Icons.play_circle_fill,
                              color: _kTeal, size: 26),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive ? _kTeal : _kText),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('Pose ${index + 1}',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: _kSubText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradThumb extends StatelessWidget {
  final List<Color> g;
  const _GradThumb({required this.g});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: g,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
    ),
    child: Center(
      child: Icon(Icons.self_improvement,
          color: Colors.white.withOpacity(0.45), size: 22),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// _WebBar — light mode top bar
// ─────────────────────────────────────────────────────────────────────────────

class _WebBar extends StatelessWidget {
  final VoidCallback onClose;
  const _WebBar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: _kWebTopBar,
        border: Border(bottom: BorderSide(color: _kBorder, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.arrow_back, color: _kSubText, size: 22),
          ),
          const SizedBox(width: 6),
          Text('HEAL YOGA',
              style: GoogleFonts.poppins(
                  color: _kTeal,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FullscreenPlayer
// KEY: does NOT dispose the controller. The parent keeps ownership.
// On pop, parent resumes playback.
// ─────────────────────────────────────────────────────────────────────────────

class _FullscreenPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String poseName;
  final double speed;
  final ValueChanged<double> onSpeedChanged;

  const _FullscreenPlayer({
    required this.controller,
    required this.poseName,
    required this.speed,
    required this.onSpeedChanged,
  });

  @override
  State<_FullscreenPlayer> createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<_FullscreenPlayer> {
  final ValueNotifier<bool> _show = ValueNotifier(true);
  Timer? _hideTimer;
  late double _speed;

  @override
  void initState() {
    super.initState();
    _speed = widget.speed;
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
    _scheduleHide();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _show.dispose();
    // Restore orientation & system UI – do NOT dispose the controller here
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(_kControlsHide, () {
      if (mounted && widget.controller.value.isPlaying) {
        _show.value = false;
      }
    });
  }

  void _toggleUi() {
    _show.value = !_show.value;
    if (_show.value) _scheduleHide();
  }

  void _togglePlay() {
    setState(() {
      widget.controller.value.isPlaying
          ? widget.controller.pause()
          : widget.controller.play();
    });
    _scheduleHide();
  }

  static String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await GlobalAudioService.playClickSound();
          _toggleUi();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video — IgnorePointer so it never eats taps
            IgnorePointer(
              child: Center(
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: VideoPlayer(widget.controller),
                ),
              ),
            ),

            // Controls overlay
            ValueListenableBuilder<bool>(
              valueListenable: _show,
              builder: (_, vis, __) => IgnorePointer(
                ignoring: !vis,
                child: AnimatedOpacity(
                  opacity: vis ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  child: _buildOverlay(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background — IgnorePointer so it never eats taps
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0.0, 0.3, 0.65, 1.0],
              ),
            ),
          ),
        ),

        // Controls column on top
        Column(
          children: [
            // Top bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await GlobalAudioService.playClickSound();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(widget.poseName,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Centre play/pause
            GestureDetector(
              onTap: _togglePlay,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30),
                ),
                child: ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: widget.controller,
                  builder: (_, v, __) => Icon(
                    v.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Bottom scrub + controls
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: widget.controller,
                builder: (ctx, v, __) {
                  final dur = v.duration;
                  final pos = v.position;
                  final prog = dur.inMilliseconds > 0
                      ? (pos.inMilliseconds / dur.inMilliseconds)
                      .clamp(0.0, 1.0)
                      : 0.0;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(ctx).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                          trackHeight: 3,
                          activeTrackColor: _kTeal,
                          inactiveTrackColor: Colors.white30,
                          thumbColor: _kTeal,
                        ),
                        child: Slider(
                          value: prog,
                          onChanged: (val) => widget.controller.seekTo(
                            Duration(
                                milliseconds:
                                (val * dur.inMilliseconds).round()),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_fmt(pos)} / ${_fmt(dur)}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.white70)),
                          Row(children: [
                            _SpeedBtn(
                              currentSpeed: _speed,
                              onSelected: (s) {
                                setState(() => _speed = s);
                                widget.controller.setPlaybackSpeed(s);
                                widget.onSpeedChanged(s);
                              },
                            ),
                            _VolBtn(ctrl: widget.controller),
                          ]),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _PinWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 48, color: _kTeal),
          const SizedBox(height: 14),
          Text('Waiting for PIN…',
              style: GoogleFonts.poppins(
                  color: Colors.white54, fontSize: 14)),
        ],
      ),
    ),
  );
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bg;
  final VoidCallback onTap;

  const _CircleBtn(
      {required this.icon,
        required this.iconColor,
        required this.bg,
        required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: bg,
    shape: const CircleBorder(),
    elevation: 3,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    ),
  );
}

class _CounterBadge extends StatelessWidget {
  final int current;
  final int total;
  const _CounterBadge({required this.current, required this.total});

  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
    decoration: BoxDecoration(
      color: _kTeal,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2))
      ],
    ),
    child: Text('$current/$total',
        style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white)),
  );
}

class _DurBadge extends StatelessWidget {
  final int minutes;
  final int seconds;
  final AppLocalizations l10n;
  const _DurBadge(
      {required this.minutes,
        required this.seconds,
        required this.l10n});

  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: _kTeal.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.access_time, size: 14, color: _kTeal),
        const SizedBox(width: 5),
        Text(
          l10n.durationFormat(
              minutes, seconds.toString().padLeft(2, '0')),
          style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _kTeal),
        ),
      ],
    ),
  );
}

class _SpeedBtn extends StatelessWidget {
  final double currentSpeed;
  final ValueChanged<double> onSelected;
  const _SpeedBtn(
      {required this.currentSpeed, required this.onSelected});

  static const _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) => PopupMenuButton<double>(
    tooltip: 'Speed',
    color: const Color(0xFF2A2A2A),
    icon: Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text('${currentSpeed}x',
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ),
    onSelected: onSelected,
    itemBuilder: (_) => _speeds
        .map((s) => PopupMenuItem(
      value: s,
      child: Text(s == 1.0 ? '1.0x (Normal)' : '${s}x',
          style: GoogleFonts.poppins(
              fontSize: 13, color: Colors.white70)),
    ))
        .toList(),
  );
}

class _VolBtn extends StatefulWidget {
  final VideoPlayerController ctrl;
  const _VolBtn({required this.ctrl});

  @override
  State<_VolBtn> createState() => _VolBtnState();
}

class _VolBtnState extends State<_VolBtn> {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<VideoPlayerValue>(
    valueListenable: widget.ctrl,
    builder: (_, v, __) => IconButton(
      onPressed: () => widget.ctrl.setVolume(v.volume == 0 ? 1.0 : 0.0),
      icon: Icon(
        v.volume == 0 ? Icons.volume_off : Icons.volume_up,
        color: Colors.white,
        size: 20,
      ),
      padding: EdgeInsets.zero,
      constraints:
      const BoxConstraints(minWidth: 34, minHeight: 34),
    ),
  );
}
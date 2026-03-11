import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import '../l10n/app_localizations.dart';
import '../models/yoga_pose.dart';
import '../models/yoga_session.dart';
import '../services/global_audio_service.dart';
import '../services/pose_progress_service.dart';
import '../services/simple_pin_dialog.dart';
import '../services/simple_pin_service.dart';
import '../utils/yoga_localization_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants  (mirrors pose_detail_screen.dart)
// ─────────────────────────────────────────────────────────────────────────────
const _kTeal = Color(0xFF40E0D0);
const _kControlsHide = Duration(seconds: 3);
const _kWebBreak = 900.0;
const _kPlaceholderUrl =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

const _kBg = Colors.white;
const _kText = Color(0xFF1A1A1A);
const _kSubText = Color(0xFF666666);
const _kBorder = Color(0xFFE8E8E8);
const _kWebBg = Color(0xFFF5F5F5);
const _kWebSidebar = Colors.white;

// ─────────────────────────────────────────────────────────────────────────────
// FullSessionScreen
// ─────────────────────────────────────────────────────────────────────────────

class FullSessionScreen extends StatefulWidget {
  final YogaSession session;
  const FullSessionScreen({super.key, required this.session});

  @override
  State<FullSessionScreen> createState() => _FullSessionScreenState();
}

class _FullSessionScreenState extends State<FullSessionScreen> {
  // ── Pose state ──────────────────────────────────────────────────────────
  int _poseIdx = 0;
  YogaPose get _pose => widget.session.allPoses[_poseIdx];
  bool get _isLast => _poseIdx == widget.session.allPoses.length - 1;
  double get _progress => (_poseIdx + 1) / widget.session.allPoses.length;

  // ── Timer ────────────────────────────────────────────────────────────────
  int _remaining = 0;
  int _totalSpent = 0;
  Timer? _timer;
  bool _timerRunning = false;
  bool _paused = false;

  // ── Video ────────────────────────────────────────────────────────────────
  VideoPlayerController? _ctrl;
  bool _videoReady = false;
  final ValueNotifier<bool> _showControls = ValueNotifier(true);
  Timer? _hideTimer;
  double _speed = 1.0;

  // ── Completion tracking ─────────────────────────────────────────────────
  final Set<String> _completedIds = {};
  final PoseProgressService _progressSvc = PoseProgressService();

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hideTimer?.cancel();
    _showControls.dispose();
    _ctrl?.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PIN / Init
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _checkPin() async {
    if (SimplePinService.isPinVerifiedThisSession()) {
      await _initSession();
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
      builder: (_) => SimplePinDialog(onSuccess: _initSession),
    );
  }

  Future<void> _initSession() async {
    setState(() {
      _poseIdx = 0;
      _remaining = _pose.durationSeconds;
    });
    await _initVideo();
    _startTimer();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Video
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _initVideo() async {
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
      debugPrint('❌ Video: $e');
      if (mounted) setState(() => _videoReady = false);
    }
  }

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

  // Fullscreen: share controller, don't dispose it
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

  // ─────────────────────────────────────────────────────────────────────────
  // Timer
  // ─────────────────────────────────────────────────────────────────────────

  void _startTimer() {
    if (_timerRunning) return;
    setState(() {
      _timerRunning = true;
      _paused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > 0) {
        setState(() {
          _remaining--;
          _totalSpent++;
        });
      } else {
        _onPoseComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _timerRunning = false;
      _paused = true;
    });
  }

  void _resumeTimer() => _startTimer();

  // ─────────────────────────────────────────────────────────────────────────
  // Pose navigation
  // ─────────────────────────────────────────────────────────────────────────

  void _skipToNext() {
    GlobalAudioService.playClickSound();
    if (!_completedIds.contains(_pose.id)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.completeCurrentPoseFirst,
            style: GoogleFonts.poppins()),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    _goToNext();
  }

  Future<void> _goToPrev() async {
    if (_poseIdx <= 0) return;
    GlobalAudioService.playClickSound();
    _timer?.cancel();
    await _initVideo();
    setState(() {
      _poseIdx--;
      _remaining = _pose.durationSeconds;
      _videoReady = false;
      _paused = false;
      _timerRunning = false;
    });
    await _initVideo();
  }

  Future<void> _jumpToPose(int i) async {
    GlobalAudioService.playClickSound();
    _timer?.cancel();
    setState(() {
      _poseIdx = i;
      _remaining = _pose.durationSeconds;
      _videoReady = false;
      _paused = false;
      _timerRunning = false;
    });
    await _initVideo();
  }

  void _onPoseComplete() async {
    _timer?.cancel();
    setState(() => _timerRunning = false);
    _completedIds.add(_pose.id);
    await _savePose();
    if (mounted) _showPoseCompleteDialog();
  }

  Future<void> _goToNext() async {
    if (_isLast) {
      await _saveSession();
      if (mounted) _showSessionCompleteDialog();
      return;
    }
    final old = _ctrl;
    if (old != null) {
      setState(() => _videoReady = false);
      await old.dispose();
      _ctrl = null;
    }
    setState(() {
      _poseIdx++;
      _remaining = _pose.durationSeconds;
      _videoReady = false;
    });
    await _initVideo();
    _startTimer();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Database
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _savePose() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    try {
      final sb = Supabase.instance.client;
      await sb.from('pose_activity').insert({
        'user_id': uid,
        'pose_id': _pose.id,
        'pose_name':
        YogaLocalizationHelper.getPoseName(context, _pose.nameKey),
        'session_level': widget.session.levelKey,
        'duration_seconds': _pose.durationSeconds,
        'completed_at': DateTime.now().toIso8601String(),
        'activity_date': DateTime.now().toIso8601String().split('T')[0],
      });
      await _progressSvc.markPoseCompleted(
          uid, widget.session.levelKey, _pose.id);
    } catch (e) {
      debugPrint('❌ savePose: $e');
    }
  }

  Future<void> _saveSession() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    try {
      final total = widget.session.allPoses
          .fold<int>(0, (s, p) => s + p.durationSeconds);
      await Supabase.instance.client.from('session_completions').insert({
        'user_id': uid,
        'session_id': widget.session.id,
        'session_name': widget.session.titleKey,
        'session_level': widget.session.levelKey,
        'total_poses': widget.session.allPoses.length,
        'total_duration_seconds': total,
        'completed_at': DateTime.now().toIso8601String(),
        'completion_date':
        DateTime.now().toIso8601String().split('T')[0],
      });
    } catch (e) {
      debugPrint('❌ saveSession: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dialogs
  // ─────────────────────────────────────────────────────────────────────────

  void _showPoseCompleteDialog() {
    GlobalAudioService.playClickSound();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: _kTeal.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle,
                  size: 64, color: _kTeal),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(ctx)!.poseComplete,
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _kText),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
                YogaLocalizationHelper.getPoseName(
                    ctx, _pose.nameKey),
                style: GoogleFonts.poppins(
                    fontSize: 16, color: _kSubText),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(ctx)!.greatWorkChoice,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: _kSubText),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.pop(ctx);
                setState(() {
                  _remaining = _pose.durationSeconds;
                  _paused = false;
                });
                _startTimer();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _kTeal, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(ctx)!.retryPose,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _kTeal)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.pop(ctx);
                _goToNext();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _kTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                  _isLast
                      ? AppLocalizations.of(ctx)!.finishSession
                      : AppLocalizations.of(ctx)!.nextPose,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSessionCompleteDialog() {
    GlobalAudioService.playClickSound();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: _kTeal.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle,
                  size: 64, color: _kTeal),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(ctx)!.sessionComplete,
                style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _kText),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
                AppLocalizations.of(ctx)!
                    .completedPosesCount(widget.session.allPoses.length),
                style: GoogleFonts.poppins(
                    fontSize: 16, color: _kSubText),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
                AppLocalizations.of(ctx)!.totalMinutesSpent(
                    _totalSpent ~/ 60,
                    AppLocalizations.of(ctx)!.minutes),
                style: GoogleFonts.poppins(
                    fontSize: 14, color: _kSubText),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await GlobalAudioService.playClickSound();
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _kTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(ctx)!.done ?? 'Done',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    if (_timerRunning) _pauseTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(ctx)!.exitSessionTitle,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _kText)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_completedIds.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.green.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(ctx)!.posesCompletedInfo(
                                _completedIds.length,
                                widget.session.allPoses.length),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _kText),
                          ),
                          const SizedBox(height: 3),
                          Text(
                              AppLocalizations.of(ctx)!.progressSaved,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.green[700])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(AppLocalizations.of(ctx)!.continueLater,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: _kSubText, height: 1.4)),
            ] else ...[
              Row(children: [
                const Icon(Icons.info_outline,
                    color: Colors.orange, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                      AppLocalizations.of(ctx)!.noPosesCompleted,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: _kText)),
                ),
              ]),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(ctx)!.completeOneToSave,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: _kSubText)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (!_timerRunning && _remaining > 0) _startTimer();
            },
            child: Text(AppLocalizations.of(ctx)!.stayButton,
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _kTeal)),
          ),
          ElevatedButton(
            onPressed: () {
              GlobalAudioService.playClickSound();
              Navigator.pop(ctx);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 22, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLocalizations.of(ctx)!.exit,
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  String _fmtTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width >= _kWebBreak;
    return Scaffold(
      backgroundColor: isWeb ? _kWebBg : _kBg,
      body: isWeb ? _webLayout() : _mobileLayout(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Mobile layout
  // ─────────────────────────────────────────────────────────────────────────

  Widget _mobileLayout() {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // 16:9 video
            SliverToBoxAdapter(
              child: Container(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _VideoCore(
                    pinVerified:
                    SimplePinService.isPinVerifiedThisSession(),
                    ready: _videoReady,
                    ctrl: _ctrl,
                    showControls: _showControls,
                    speed: _speed,
                    onTap: () {
                      _togglePlay();
                    },
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

            // Session panel (white rounded-top card)
            SliverToBoxAdapter(
              child: _SessionPanel(
                pose: _pose,
                session: widget.session,
                poseIdx: _poseIdx,
                remaining: _remaining,
                totalSpent: _totalSpent,
                progress: _progress,
                timerRunning: _timerRunning,
                paused: _paused,
                completedIds: _completedIds,
                onPause: _pauseTimer,
                onResume: _resumeTimer,
                onPrev: _poseIdx > 0 ? _goToPrev : null,
                onSkip: _skipToNext,
                onJump: _jumpToPose,
                isWeb: false,
                fmtTime: _fmtTime,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 16),
            ),
          ],
        ),

        // Close button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 12,
          child: _CircleBtn(
            icon: Icons.close,
            iconColor: _kTeal,
            bg: Colors.white.withOpacity(0.92),
            onTap: _showExitDialog,
          ),
        ),

        // Pose counter
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 12,
          child: _CounterBadge(
              current: _poseIdx + 1,
              total: widget.session.allPoses.length),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Web layout
  // ─────────────────────────────────────────────────────────────────────────

  Widget _webLayout() {
    return Column(
      children: [
        _WebBar(
          title: YogaLocalizationHelper.getSessionTitle(
              context, widget.session.titleKey),
          onClose: _showExitDialog,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: video + session info
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            onTap: () {
                              _togglePlay();
                            },
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
                      _SessionPanel(
                        pose: _pose,
                        session: widget.session,
                        poseIdx: _poseIdx,
                        remaining: _remaining,
                        totalSpent: _totalSpent,
                        progress: _progress,
                        timerRunning: _timerRunning,
                        paused: _paused,
                        completedIds: _completedIds,
                        onPause: _pauseTimer,
                        onResume: _resumeTimer,
                        onPrev: _poseIdx > 0 ? _goToPrev : null,
                        onSkip: _skipToNext,
                        onJump: _jumpToPose,
                        isWeb: true,
                        fmtTime: _fmtTime,
                      ),
                    ],
                  ),
                ),
              ),

              // Right: playlist sidebar
              Container(
                width: 340,
                decoration: const BoxDecoration(
                  color: _kWebSidebar,
                  border: Border(
                      left: BorderSide(color: _kBorder, width: 1)),
                ),
                child: _PlaylistSidebar(
                  poses: widget.session.allPoses,
                  currentIndex: _poseIdx,
                  completedIds: _completedIds,
                  onTap: _jumpToPose,
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
// _SessionPanel  — timer + controls + pose info + playlist (mobile only playlist)
// ─────────────────────────────────────────────────────────────────────────────

class _SessionPanel extends StatelessWidget {
  final YogaPose pose;
  final YogaSession session;
  final int poseIdx;
  final int remaining;
  final int totalSpent;
  final double progress;
  final bool timerRunning;
  final bool paused;
  final Set<String> completedIds;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback? onPrev;
  final VoidCallback onSkip;
  final ValueChanged<int> onJump;
  final bool isWeb;
  final String Function(int) fmtTime;

  const _SessionPanel({
    required this.pose,
    required this.session,
    required this.poseIdx,
    required this.remaining,
    required this.totalSpent,
    required this.progress,
    required this.timerRunning,
    required this.paused,
    required this.completedIds,
    required this.onPause,
    required this.onResume,
    required this.onPrev,
    required this.onSkip,
    required this.onJump,
    required this.isWeb,
    required this.fmtTime,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle (mobile)
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
              isWeb ? 0 : 20, isWeb ? 0 : 8, isWeb ? 0 : 20, 0),
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
                    height: 1.2),
              ),
              const SizedBox(height: 10),

              // Duration badge
              _DurBadge(
                  minutes: pose.durationSeconds ~/ 60,
                  seconds: pose.durationSeconds % 60,
                  l10n: l10n),
              const SizedBox(height: 24),

              // ── Timer display ──
              Center(
                child: Column(
                  children: [
                    Text(
                      fmtTime(remaining),
                      style: GoogleFonts.poppins(
                          fontSize: isWeb ? 56 : 60,
                          fontWeight: FontWeight.bold,
                          color: _kTeal,
                          height: 1),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(' ${l10n.totalTime}',
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        Text(fmtTime(totalSpent),
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: _kText,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _kTeal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(progress * 100).round()}% ${l10n.completed}',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: _kTeal,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Pause / Resume + Prev / Skip buttons ──
              Row(children: [
                // Previous
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPrev,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _kTeal,
                      side: BorderSide(
                          color: onPrev != null ? _kTeal : Colors.grey[300]!,
                          width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(l10n.back,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: onPrev != null
                                ? _kTeal
                                : Colors.grey[400])),
                  ),
                ),
                const SizedBox(width: 10),

                // Pause / Resume
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: timerRunning ? onPause : onResume,
                    icon: Icon(
                        timerRunning ? Icons.pause : Icons.play_arrow,
                        size: 18),
                    label: Text(
                        timerRunning ? l10n.pause : l10n.resume,
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      timerRunning ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Skip / Next
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSkip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kTeal,
                      foregroundColor: Colors.white,
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
              const SizedBox(height: 28),

              // ── About this pose ──
              Text(l10n.aboutThisPose,
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
              const SizedBox(height: 24),

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
              ...pose.modifications.map((key) {
                final tip = YogaLocalizationHelper.getPoseModifications(
                    context, key);
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

              // On mobile, show inline playlist; on web it's the sidebar
              if (!isWeb) ...[
                const SizedBox(height: 28),
                _InlinePlaylist(
                  poses: session.allPoses,
                  currentIndex: poseIdx,
                  completedIds: completedIds,
                  onJump: onJump,
                  l10n: l10n,
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );

    if (isWeb) return content;

    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -3)),
        ],
      ),
      child: content,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InlinePlaylist  — used in mobile's scrollable panel
// ─────────────────────────────────────────────────────────────────────────────

class _InlinePlaylist extends StatelessWidget {
  final List<YogaPose> poses;
  final int currentIndex;
  final Set<String> completedIds;
  final ValueChanged<int> onJump;
  final AppLocalizations l10n;

  const _InlinePlaylist({
    required this.poses,
    required this.currentIndex,
    required this.completedIds,
    required this.onJump,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(l10n.sessionPlaylist,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _kText)),
          const SizedBox(width: 10),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kTeal.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${completedIds.length}/${poses.length}',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _kTeal),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        ...poses.asMap().entries.map((e) {
          final i = e.key;
          final p = e.value;
          final done = completedIds.contains(p.id);
          final isCur = i == currentIndex;
          final canTap = done || isCur;
          return GestureDetector(
            onTap: canTap ? () => onJump(i) : null,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCur
                    ? _kTeal.withOpacity(0.10)
                    : done
                    ? Colors.grey[50]
                    : Colors.grey[100],
                border: Border.all(
                    color: isCur
                        ? _kTeal
                        : done
                        ? Colors.grey[200]!
                        : Colors.grey[300]!,
                    width: isCur ? 2 : 1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  // Index / check / lock
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: done
                          ? _kTeal
                          : isCur
                          ? _kTeal.withOpacity(0.2)
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: done
                          ? const Icon(Icons.check,
                          size: 20, color: Colors.white)
                          : !canTap
                          ? Icon(Icons.lock_outline,
                          size: 16, color: Colors.grey[500])
                          : Text('${i + 1}',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isCur
                                  ? _kTeal
                                  : Colors.grey[500])),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          YogaLocalizationHelper.getPoseName(
                              context, p.nameKey),
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: isCur
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color:
                              canTap ? _kText : Colors.grey[500]),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.durationFormat(
                              p.durationSeconds ~/ 60,
                              (p.durationSeconds % 60)
                                  .toString()
                                  .padLeft(2, '0')),
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: canTap
                                  ? _kSubText
                                  : Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  if (isCur)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _kTeal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(l10n.playing,
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    )
                  else if (!canTap)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.lock, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 3),
                        Text('Locked',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500])),
                      ]),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PlaylistSidebar  — web sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _PlaylistSidebar extends StatelessWidget {
  final List<YogaPose> poses;
  final int currentIndex;
  final Set<String> completedIds;
  final ValueChanged<int> onTap;

  const _PlaylistSidebar({
    required this.poses,
    required this.currentIndex,
    required this.completedIds,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(children: [
            Text(l10n.sessionPlaylist,
                style: GoogleFonts.poppins(
                    color: _kText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _kTeal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${completedIds.length}/${poses.length}',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kTeal)),
            ),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: poses.length,
            itemBuilder: (_, i) {
              final p = poses[i];
              final done = completedIds.contains(p.id);
              final isCur = i == currentIndex;
              final canTap = done || isCur;
              final g = _grads[i % _grads.length];

              return InkWell(
                onTap: canTap ? () => onTap(i) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isCur ? _kTeal.withOpacity(0.08) : Colors.transparent,
                    border: isCur
                        ? const Border(
                        left: BorderSide(color: _kTeal, width: 3))
                        : null,
                  ),
                  child: Row(children: [
                    // Thumbnail
                    SizedBox(
                      width: 110,
                      height: 62,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(fit: StackFit.expand, children: [
                          p.imageUrl?.isNotEmpty == true
                              ? Image.network(p.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _GradThumb(g: g))
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
                              child: Text(
                                '${p.durationSeconds ~/ 60}:${(p.durationSeconds % 60).toString().padLeft(2, '0')}',
                                style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          // Status overlay
                          if (isCur)
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: Icon(Icons.play_circle_fill,
                                    color: _kTeal, size: 26),
                              ),
                            )
                          else if (done)
                            Container(
                              color: Colors.black.withOpacity(0.25),
                              child: const Center(
                                child: Icon(Icons.check_circle,
                                    color: Colors.white, size: 24),
                              ),
                            )
                          else if (!canTap)
                              Container(
                                color: Colors.black.withOpacity(0.45),
                                child: const Center(
                                  child: Icon(Icons.lock_outline,
                                      color: Colors.white54, size: 22),
                                ),
                              ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            YogaLocalizationHelper.getPoseName(
                                context, p.nameKey),
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: canTap
                                    ? (isCur ? _kTeal : _kText)
                                    : _kSubText),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text('Pose ${i + 1}',
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: _kSubText)),
                        ],
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VideoCore  (identical to pose_detail_screen.dart — shared pattern)
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
// _VideoOverlay  (identical pattern to pose_detail_screen.dart)
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
        // Gradient — IgnorePointer so it never eats taps
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Text('${_fmt(pos)} / ${_fmt(dur)}',
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: Colors.white70)),
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
// _FullscreenPlayer  (same as pose_detail — does NOT dispose controller)
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
          Text(AppLocalizations.of(context)!.waitingForPin,
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

class _WebBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  const _WebBar({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) => Container(
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
          icon: const Icon(Icons.close, color: _kSubText, size: 22),
        ),
        const SizedBox(width: 16),

        if (title.isNotEmpty)
          Expanded(
            child: Text(title,
                style: GoogleFonts.poppins(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
      ],
    ),
  );
}

const _kWebTopBar = Colors.white;

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
      padding:
      const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
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
  Widget build(BuildContext context) =>
      ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: widget.ctrl,
        builder: (_, v, __) => IconButton(
          onPressed: () =>
              widget.ctrl.setVolume(v.volume == 0 ? 1.0 : 0.0),
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
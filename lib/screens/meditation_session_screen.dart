import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import 'meditation_screen.dart';

class MeditationSessionScreen extends StatefulWidget {
  final MeditationSession session;
  static bool isActive = false;

  const MeditationSessionScreen({
    super.key,
    required this.session,
  });

  @override
  State<MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState
    extends State<MeditationSessionScreen>
    with TickerProviderStateMixin {

  final GlobalAudioService _audioService = GlobalAudioService();

  late AnimationController _breathingController;
  late AnimationController _backgroundController;
  late AnimationController _completionController;
  late AnimationController _shimmerController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _completionFade;

  bool _completionTriggered = false;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    MeditationSessionScreen.isActive = true;

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _completionFade = CurvedAnimation(
      parent: _completionController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.7, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 6,
      ),
      TweenSequenceItem(tween: ConstantTween(1.2), weight: 6),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 0.7)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 6,
      ),
      TweenSequenceItem(tween: ConstantTween(0.7), weight: 6),
    ]).animate(_breathingController);

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 0.6), weight: 6),
      TweenSequenceItem(tween: ConstantTween(0.6), weight: 6),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.2), weight: 6),
      TweenSequenceItem(tween: ConstantTween(0.2), weight: 6),
    ]).animate(_breathingController);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _backgroundController.dispose();
    _completionController.dispose();
    _shimmerController.dispose();
    MeditationSessionScreen.isActive = false;
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  String _breathingPhaseText(int phaseIndex) {
    switch (phaseIndex) {
      case 0:
        return "Inhale...";
      case 1:
        return "Hold...";
      case 2:
        return "Exhale...";
      case 3:
        return "Hold...";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {

    final isComplete =
        _audioService.sessionTotal != Duration.zero &&
        _audioService.sessionRemaining == Duration.zero;

    if (isComplete && !_completionTriggered) {
      _completionTriggered = true;
      _completionController.forward();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [

          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, _) {
              final alignment = Alignment(
                (_backgroundController.value * 2) - 1,
                0,
              );

              return Image.network(
                widget.session.imageUrl,
                fit: BoxFit.cover,
                alignment: alignment,
              );
            },
          ),

          AnimatedBuilder(
            animation: Listenable.merge([
              _audioService,
              _breathingController,
            ]),
            builder: (context, _) {

              final isPreparing = _audioService.isPreparing;

              final seconds =
                  _audioService.sessionRemaining.inSeconds;

              final phase = seconds % 24;

              int currentPhaseIndex;

              if (phase < 6) {
                currentPhaseIndex = 0;
              } else if (phase < 12) {
                currentPhaseIndex = 1;
              } else if (phase < 18) {
                currentPhaseIndex = 2;
              } else {
                currentPhaseIndex = 3;
              }

              final breathingText =
                  _breathingPhaseText(currentPhaseIndex);

              return Stack(
                fit: StackFit.expand,
                children: [

                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    color: Colors.black.withOpacity(0.3),
                  ),

                  SafeArea(
                    child: Column(
                      children: [

                        Align(
                          alignment: Alignment.topLeft,
                         child: Padding(
    padding: const EdgeInsets.only(left: 8),
    child: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white70, width: 1.5),
        ),
        child: const Icon(
          Icons.remove,
          color: Colors.white,
          size: 28,
        ),
      ),
    ),
  ),
),

                        const Spacer(),

                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 800),
                          opacity: isPreparing ? 0.0 : 1.0,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white
                                        .withOpacity(_glowAnimation.value),
                                    blurRadius: 60,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

AnimatedSwitcher(
  duration: const Duration(milliseconds: 600),
  child: isPreparing
      ? Column(
          key: const ValueKey("preparing"),
          children: [
            const Text(
              "Preparing your session...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: () async {
                _audioService.cancelPendingSessionStart();
await _audioService.clearSound();
if (mounted) Navigator.pop(context);
              },
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white70),
                ),
                child: const Center(
                  child: Text(
                    "Cancel Session",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      : Text(
          breathingText,
          key: const ValueKey("breathing"),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
),

                        const SizedBox(height: 40),

                        if (!isPreparing)
                          Text(
                            _formatDuration(
                                _audioService.sessionRemaining),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                        const SizedBox(height: 40),

                        if (!isComplete && !isPreparing)
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _audioService.togglePlayPause();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _audioService.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              // 🔥 ADDED END SESSION BUTTON
                              const SizedBox(height: 20),

GestureDetector(
  onTap: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "End Session?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to end your meditation session?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "End",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _audioService.clearSound();
      if (mounted) Navigator.pop(context);
    }
  },
  child: Container(
    width: 220,
    padding: const EdgeInsets.symmetric(
      vertical: 16,
    ),
    decoration: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.redAccent.withOpacity(0.5),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    ),
    child: const Center(
      child: Text(
        "End Session",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),
                          
                      ],
                          )
                          
                          
                        else if (isComplete)
                          FadeTransition(
                            opacity: _completionFade,
                            child: const Text(
                              "Session Complete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
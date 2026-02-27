import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import 'meditation_screen.dart';

class MeditationSessionScreen extends StatefulWidget {
  final MeditationSession session;

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

  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  int _lastPhase = -1;

  @override
  void initState() {
    super.initState();

    if (_audioService.sessionRemaining == Duration.zero) {
      _audioService.startSessionTimer(
        Duration(minutes: widget.session.durationMinutes),
      );
    }

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat(reverse: true);

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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [

          // 🌊 SAFE background drift using Alignment (never cuts)
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

          // 🌈 Main animated UI
          AnimatedBuilder(
            animation: Listenable.merge([
              _audioService,
              _breathingController,
            ]),
            builder: (context, _) {

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

              if (currentPhaseIndex != _lastPhase &&
                  _audioService.isPlaying &&
                  !isComplete) {

                _lastPhase = currentPhaseIndex;

                if (currentPhaseIndex == 0) {
                  _audioService.playBreathingCue("inhale");
                } else if (currentPhaseIndex == 1) {
                  _audioService.playBreathingCue("hold");
                } else if (currentPhaseIndex == 2) {
                  _audioService.playBreathingCue("exhale");
                } else {
                  _audioService.playBreathingCue("hold");
                }
              }

              final breathingText =
                  _breathingPhaseText(currentPhaseIndex);

              Color overlayColor;
              switch (currentPhaseIndex) {
                case 0:
                  overlayColor = Colors.teal.withOpacity(0.35);
                  break;
                case 1:
                  overlayColor = Colors.teal.withOpacity(0.25);
                  break;
                case 2:
                  overlayColor = Colors.indigo.withOpacity(0.35);
                  break;
                default:
                  overlayColor = Colors.indigo.withOpacity(0.25);
              }

              return Stack(
                fit: StackFit.expand,
                children: [

                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    color: overlayColor,
                  ),

                  SafeArea(
                    child: Column(
                      children: [

                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        const Spacer(),

                        Transform.scale(
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

                        const SizedBox(height: 30),

                        Text(
                          breathingText,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 40),

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

                        if (!isComplete)
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
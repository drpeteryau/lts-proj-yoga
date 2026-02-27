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
  bool _isExiting = false; // ✅ prevents preparing from reappearing
  

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
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                              ? AnimatedBuilder(
                                  key: const ValueKey("preparing"),
                                  animation: _shimmerController,
                                  builder: (context, child) {
                                    return ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          begin: Alignment(
                                              -1 + 2 * _shimmerController.value,
                                              0),
                                          end: Alignment(
                                              1 + 2 * _shimmerController.value,
                                              0),
                                          colors: const [
                                            Colors.white24,
                                            Colors.white70,
                                            Colors.white24,
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        "Preparing your session...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
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
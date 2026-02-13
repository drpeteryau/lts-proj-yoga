import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _fadeController;
  late AnimationController _textController;
  late AnimationController _particleController;

  late Animation<double> _glowAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    // Glow pulse animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Fade in background
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
      _glowController.repeat(reverse: true);
      _particleController.repeat();
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _fadeController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeAnimation,
          _glowAnimation,
          _textScaleAnimation,
          _textFadeAnimation,
          _particleAnimation,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(
                    const Color(0xFF0A1F1E),
                    const Color(0xFF1A3D3B),
                    _fadeAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF1A3D3B),
                    const Color(0xFF2C5F5D),
                    _fadeAnimation.value,
                  )!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Ambient turquoise glow orbs
                Positioned(
                  top: 100,
                  left: 50,
                  child: _buildGlowOrb(120, 0.15 + _glowAnimation.value * 0.1),
                ),
                Positioned(
                  bottom: 150,
                  right: 60,
                  child: _buildGlowOrb(150, 0.12 + _glowAnimation.value * 0.08),
                ),
                Positioned(
                  top: 300,
                  right: 100,
                  child: _buildGlowOrb(100, 0.1 + _glowAnimation.value * 0.06),
                ),

                // Floating particles with turquoise glow (reduced from 15 to 8)
                ...List.generate(8, (index) {
                  final offset = (index * 0.15) % 1.0;
                  final animValue = (_particleAnimation.value + offset) % 1.0;
                  return Positioned(
                    left: 40.0 + index * 45,
                    top: 100.0 + (index % 3) * 200 + (math.sin(animValue * 2 * math.pi) * 40),
                    child: Opacity(
                      opacity: (0.4 + math.sin(animValue * 2 * math.pi) * 0.2) * _fadeAnimation.value,
                      child: Container(
                        width: 8 + (index % 2) * 2,
                        height: 8 + (index % 2) * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF40E0D0).withOpacity(0.7),
                              const Color(0xFF40E0D0).withOpacity(0.0),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF40E0D0).withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Center content with mega glow
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main turquoise glow circle
                      Opacity(
                        opacity: _textFadeAnimation.value,
                        child: Transform.scale(
                          scale: _textScaleAnimation.value,
                          child: Container(
                            width: 180 + _glowAnimation.value * 20,
                            height: 180 + _glowAnimation.value * 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF40E0D0).withOpacity(0.15),
                                  const Color(0xFF40E0D0).withOpacity(0.05),
                                  const Color(0xFF40E0D0).withOpacity(0.0),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF40E0D0).withOpacity(0.3 + _glowAnimation.value * 0.2),
                                  blurRadius: 80 + _glowAnimation.value * 40,
                                  spreadRadius: 20 + _glowAnimation.value * 10,
                                ),
                                BoxShadow(
                                  color: const Color(0xFF40E0D0).withOpacity(0.5 + _glowAnimation.value * 0.2),
                                  blurRadius: 120 + _glowAnimation.value * 60,
                                  spreadRadius: 30 + _glowAnimation.value * 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // ZENCORE text with glow
                      Opacity(
                        opacity: _textFadeAnimation.value,
                        child: Transform.scale(
                          scale: _textScaleAnimation.value,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    const Color(0xFF40E0D0),
                                    const Color(0xFF7FFFD4),
                                    const Color(0xFF40E0D0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ).createShader(bounds),
                                child: Text(
                                  'ZENCORE',
                                  style: GoogleFonts.poppins(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: 12,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: const Color(0xFF40E0D0).withOpacity(0.8),
                                        blurRadius: 30,
                                      ),
                                      Shadow(
                                        color: const Color(0xFF40E0D0).withOpacity(0.6),
                                        blurRadius: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Find Your Inner Peace',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3,
                                  color: const Color(0xFF40E0D0).withOpacity(0.9),
                                  shadows: [
                                    Shadow(
                                      color: const Color(0xFF40E0D0).withOpacity(0.5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),

                      // Glowing loading indicator
                      Opacity(
                        opacity: _textFadeAnimation.value * 0.7,
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF40E0D0).withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Ripple effect
                Center(
                  child: CustomPaint(
                    size: const Size(500, 500),
                    painter: TurquoiseRipplePainter(
                      animationValue: _glowAnimation.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlowOrb(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFF1E9D4).withOpacity(opacity),
            const Color(0xFF40E0D0).withOpacity(opacity * 0.5),
            const Color(0xFF40E0D0).withOpacity(0.0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF40E0D0).withOpacity(opacity * 0.5),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

// Turquoise ripple painter
class TurquoiseRipplePainter extends CustomPainter {
  final double animationValue;

  TurquoiseRipplePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw 2 expanding turquoise ripples (reduced from 4 for performance)
    for (int i = 0; i < 2; i++) {
      final delay = i * 0.5;
      final adjustedValue = (animationValue - delay).clamp(0.0, 1.0);

      if (adjustedValue > 0) {
        final radius = maxRadius * adjustedValue * 0.7;
        final opacity = (1 - adjustedValue) * 0.25;

        final paint = Paint()
          ..color = const Color(0xFF40E0D0).withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(TurquoiseRipplePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
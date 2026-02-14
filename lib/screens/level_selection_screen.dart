import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_progress.dart';
import '../services/progress_service.dart';
import '../data/yoga_data_complete.dart';
import 'session_detail_screen.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final ProgressService _progressService = ProgressService();
  UserProgress? _userProgress;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final progress = await _progressService.getUserProgress(userId);

      setState(() {
        _userProgress = progress;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Helper method to safely get session counts as int
  int _getSessionsCompleted(String level) {
    if (_userProgress == null) return 0;

    switch (level) {
      case 'beginner':
        return (_userProgress!.beginnerSessionsCompleted ?? 0);
      case 'intermediate':
        return (_userProgress!.intermediateSessionsCompleted ?? 0);
      case 'advanced':
        return (_userProgress!.advancedSessionsCompleted ?? 0);
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    if (_isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4F1F0),
              Color(0xFFFFFFFF),
              Color(0xFFE8F9F3),
              Color(0xFFFFE9DB),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF40E0D0),
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4F1F0),
              Color(0xFFFFFFFF),
              Color(0xFFE8F9F3),
              Color(0xFFFFE9DB),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.errorLoadingProgress,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  GlobalAudioService.playClickSound();
                  _loadUserProgress();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40E0D0),
                ),
                child: Text(
                  AppLocalizations.of(context)!.retry,
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4F1F0),
              Color(0xFFFFFFFF),
              Color(0xFFE8F9F3),
              Color(0xFFFFE9DB),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 1200 : double.infinity,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isWeb ? 40.0 : 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isWeb ?5 : 12),

                        // Header - Motivating text
                        Text(
                          'Begin Your',
                          style: GoogleFonts.poppins(
                            fontSize: isWeb ? 36 : 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'Wellness Journey',
                          style: GoogleFonts.poppins(
                            fontSize: isWeb ? 36 : 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF40E0D0),
                            height: 1.2,
                          ),
                        ),



                        SizedBox(height: isWeb ? 48 : 32),

                        // Beginner Card
                        _buildLevelCard(
                          context,
                          title: AppLocalizations.of(context)!.beginnerTitle,
                          subtitle: AppLocalizations.of(context)!.beginnerSubtitle,
                          description: AppLocalizations.of(context)!.beginnerDesc,
                          imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600',
                          color: const Color(0xCD000000),
                          isLocked: false,
                          sessionsCompleted: _getSessionsCompleted('beginner'),
                          onTap: () {
                            GlobalAudioService.playClickSound();
                            final session = YogaDataComplete.beginnerSessions.first;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SessionDetailScreen(session: session),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: isWeb ? 28 : 20),

                        // Intermediate Card
                        _buildLevelCard(
                          context,
                          title: AppLocalizations.of(context)!.intermediateTitle,
                          subtitle: AppLocalizations.of(context)!.intermediateSubtitle,
                          description: AppLocalizations.of(context)!.intermediateDesc,
                          imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=600',
                          color: const Color(0xCD000000),
                          isLocked: !(_userProgress?.intermediateUnlocked ?? false),
                          sessionsCompleted: _getSessionsCompleted('intermediate'),
                          progress: (_userProgress?.progressToIntermediate ?? 0.0),
                          requiredSessions: UserProgress.sessionsRequiredForIntermediate,
                          currentLevelSessions: _getSessionsCompleted('beginner'),
                          onTap: () {
                            if (_userProgress?.intermediateUnlocked ?? false) {
                              GlobalAudioService.playClickSound();
                              final session = YogaDataComplete.intermediateSessions.first;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SessionDetailScreen(session: session),
                                ),
                              );
                            } else {
                              _showLockedDialog(
                                AppLocalizations.of(context)!.intermediateTitle,
                                UserProgress.sessionsRequiredForIntermediate,
                                _getSessionsCompleted('beginner'),
                              );
                            }
                          },
                        ),

                        SizedBox(height: isWeb ? 28 : 20),

                        // Advanced Card
                        _buildLevelCard(
                          context,
                          title: AppLocalizations.of(context)!.advancedTitle,
                          subtitle: AppLocalizations.of(context)!.advancedSubtitle,
                          description: AppLocalizations.of(context)!.advancedDesc,
                          imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600',
                          color: const Color(0xCD000000),
                          isLocked: !(_userProgress?.advancedUnlocked ?? false),
                          sessionsCompleted: _getSessionsCompleted('advanced'),
                          progress: (_userProgress?.progressToAdvanced ?? 0.0),
                          requiredSessions: UserProgress.sessionsRequiredForAdvanced,
                          currentLevelSessions: _getSessionsCompleted('intermediate'),
                          needsIntermediate: !(_userProgress?.intermediateUnlocked ?? false),
                          onTap: () {
                            if (_userProgress?.advancedUnlocked ?? false) {
                              GlobalAudioService.playClickSound();
                              final session = YogaDataComplete.advancedSessions.first;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SessionDetailScreen(session: session),
                                ),
                              );
                            } else {
                              if (!(_userProgress?.intermediateUnlocked ?? false)) {
                                _showLockedDialog(
                                  AppLocalizations.of(context)!.advancedTitle,
                                  UserProgress.sessionsRequiredForIntermediate,
                                  _getSessionsCompleted('beginner'),
                                  message: AppLocalizations.of(context)!.unlockIntermediateFirst,
                                );
                              } else {
                                _showLockedDialog(
                                  AppLocalizations.of(context)!.advancedTitle,
                                  UserProgress.sessionsRequiredForAdvanced,
                                  _getSessionsCompleted('intermediate'),
                                );
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),)));
  }

  Widget _buildLevelCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String description,
        required String imageUrl,
        required Color color,
        required bool isLocked,
        required int sessionsCompleted,
        required VoidCallback onTap,
        double? progress,
        int? requiredSessions,
        int? currentLevelSessions,
        bool needsIntermediate = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220, // Taller for elderly-friendly spacing
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), // More rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: color.withOpacity(0.3),
                  );
                },
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Lock overlay (darkens more when locked)
              if (isLocked)
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Badge and check/lock icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            title.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 13, // Larger
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        if (isLocked)
                          Icon(
                            Icons.lock_outline,
                            color: Colors.white.withOpacity(0.9),
                            size: 28,
                          )
                        else if (sessionsCompleted > 0)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Locked state - show requirements clearly
                    if (isLocked) ...[
                      // Unlock message
                      if (needsIntermediate)
                        Text(
                          'Complete Intermediate first',
                          style: GoogleFonts.poppins(
                            fontSize: 18, // Larger
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      else if (requiredSessions != null && currentLevelSessions != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete ${requiredSessions - currentLevelSessions} more sessions to unlock',
                              style: GoogleFonts.poppins(
                                fontSize: 18, // Larger
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$currentLevelSessions of $requiredSessions sessions completed',
                              style: GoogleFonts.poppins(
                                fontSize: 15, // Larger
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 12),

                      // Progress bar
                      if (progress != null && progress > 0 && !needsIntermediate)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 8, // Thicker bar
                          ),
                        ),
                    ]
                    // Unlocked state - show title and description
                    else ...[
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 24, // Larger for elderly
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 15, // Larger for elderly
                          color: Colors.white.withOpacity(0.95),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (sessionsCompleted > 0) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: color,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$sessionsCompleted sessions completed',
                              style: GoogleFonts.poppins(
                                fontSize: 14, // Larger
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  void _showLockedDialog(
      String levelName,
      int requiredSessions,
      int currentSessions, {
        String? message,
      }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.lock_outline, color: Color(0xFF40E0D0)),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.lockedLevelTitle(levelName),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message ??
                  AppLocalizations.of(context)!.completeSessionsToUnlock(requiredSessions - currentSessions),
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: currentSessions / requiredSessions,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF40E0D0),
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.sessionsProgress(currentSessions, requiredSessions),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              GlobalAudioService.playClickSound();
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.ok,
              style: GoogleFonts.poppins(
                color: const Color(0xFF40E0D0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
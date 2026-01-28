import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_progress.dart';
import '../services/progress_service.dart';
import '../data/yoga_data.dart';
import '../data/yoga_data_complete.dart';
import 'session_detail_screen.dart';

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
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF40E0D0),
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading progress',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserProgress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40E0D0),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Header
                Text(
                  'Choose Your',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Level',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 32),

                // Beginner Card
                _buildLevelCard(
                  context,
                  title: 'Beginner',
                  subtitle: 'Chair Yoga',
                  description: 'Perfect for those just starting their yoga journey',
                  imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600',
                  color: const Color(0xFF40E0D0),
                  isLocked: false,
                  sessionsCompleted: _getSessionsCompleted('beginner'),
                  onTap: () {
                    final session = YogaDataComplete.beginnerSessions.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionDetailScreen(session: session),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Intermediate Card
                _buildLevelCard(
                  context,
                  title: 'Intermediate',
                  subtitle: 'Hatha yoga on the mat',
                  description: 'Build strength with challenging sequences',
                  imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=600',
                  color: const Color(0xFF35C9BA),
                  isLocked: !(_userProgress?.intermediateUnlocked ?? false),
                  sessionsCompleted: _getSessionsCompleted('intermediate'),
                  progress: (_userProgress?.progressToIntermediate ?? 0.0),
                  requiredSessions: UserProgress.sessionsRequiredForIntermediate,
                  currentLevelSessions: _getSessionsCompleted('beginner'),
                  onTap: () {
                    if (_userProgress?.intermediateUnlocked ?? false) {
                      final session = YogaDataComplete.intermediateSessions.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SessionDetailScreen(session: session),
                        ),
                      );
                    } else {
                      _showLockedDialog(
                        'Intermediate',
                        UserProgress.sessionsRequiredForIntermediate,
                        _getSessionsCompleted('beginner'),
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Advanced Card
                _buildLevelCard(
                  context,
                  title: 'Advanced',
                  subtitle: 'Dynamic sun salutation flow',
                  description: 'Challenge yourself with flowing sequences',
                  imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600',
                  color: const Color(0xFF2AB5A5),
                  isLocked: !(_userProgress?.advancedUnlocked ?? false),
                  sessionsCompleted: _getSessionsCompleted('advanced'),
                  progress: (_userProgress?.progressToAdvanced ?? 0.0),
                  requiredSessions: UserProgress.sessionsRequiredForAdvanced,
                  currentLevelSessions: _getSessionsCompleted('intermediate'),
                  needsIntermediate: !(_userProgress?.intermediateUnlocked ?? false),
                  onTap: () {
                    if (_userProgress?.advancedUnlocked ?? false) {
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
                          'Advanced',
                          UserProgress.sessionsRequiredForIntermediate,
                          _getSessionsCompleted('beginner'),
                          message: 'Unlock Intermediate level first!',
                        );
                      } else {
                        _showLockedDialog(
                          'Advanced',
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
      ),
    );
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
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            title.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
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
                          'Unlock Intermediate first',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      else if (requiredSessions != null && currentLevelSessions != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete ${requiredSessions - currentLevelSessions} more',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$currentLevelSessions / $requiredSessions sessions',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
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
                            minHeight: 6,
                          ),
                        ),
                    ]
                    // Unlocked state - show title and description
                    else ...[
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (sessionsCompleted > 0) ...[
                        const SizedBox(height: 8),
                        Text(
                          '$sessionsCompleted sessions completed',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
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
              '$levelName Locked',
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
                  'Complete ${requiredSessions - currentSessions} more sessions to unlock this level.',
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
              '$currentSessions / $requiredSessions sessions',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
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
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: const Color(0xFFF8F9FA),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF40E0D0),
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        color: const Color(0xFFF8F9FA),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserProgress,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xFFF8F9FA),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Header
                const Text(
                  'Choose Your',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'Practice Level',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF40E0D0),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Complete sessions to unlock new levels',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 36),

                // Beginner Card (Always Unlocked)
                _buildLevelCard(
                  context,
                  title: 'Beginner',
                  subtitle: 'Chair yoga for gentle practice',
                  description: 'Perfect for those just starting their yoga journey',
                  imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600',
                  color: const Color(0xFF40E0D0),
                  isLocked: false,
                  sessionsCompleted: _userProgress?.beginnerSessionsCompleted ?? 0,
                  onTap: () {
                    // Navigate directly to first session
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
                  sessionsCompleted: _userProgress?.intermediateSessionsCompleted ?? 0,
                  progress: _userProgress?.progressToIntermediate ?? 0.0,
                  requiredSessions: UserProgress.sessionsRequiredForIntermediate,
                  currentLevelSessions: _userProgress?.beginnerSessionsCompleted ?? 0,
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
                        _userProgress?.beginnerSessionsCompleted ?? 0,
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
                  sessionsCompleted: _userProgress?.advancedSessionsCompleted ?? 0,
                  progress: _userProgress?.progressToAdvanced ?? 0.0,
                  requiredSessions: UserProgress.sessionsRequiredForAdvanced,
                  currentLevelSessions: _userProgress?.intermediateSessionsCompleted ?? 0,
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
                      _showLockedDialog(
                        'Advanced',
                        UserProgress.sessionsRequiredForAdvanced,
                        _userProgress?.intermediateSessionsCompleted ?? 0,
                        needsIntermediate: !(_userProgress?.intermediateUnlocked ?? false),
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLockedDialog(String level, int required, int current, {bool needsIntermediate = false}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF40E0D0).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF40E0D0),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$level Level',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              if (needsIntermediate)
                const Text(
                  'Unlock Intermediate level first',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                )
              else ...[
                Text(
                  'Complete ${required - current} more ${level == 'Advanced' ? 'Intermediate' : 'Beginner'} session${required - current == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: current / required,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$current / $required completed',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40E0D0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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
        required VoidCallback onTap,
        bool isLocked = false,
        int sessionsCompleted = 0,
        double progress = 0.0,
        int? requiredSessions,
        int? currentLevelSessions,
        bool needsIntermediate = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isLocked
                  ? Colors.grey.withOpacity(0.15)
                  : color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: isLocked
                        ? ColorFilter.mode(
                      Colors.grey.withOpacity(0.3),
                      BlendMode.saturation,
                    )
                        : null,
                  ),
                ),
              ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(isLocked ? 0.6 : 0.4),
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),

            // Lock Icon Overlay
            if (isLocked)
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey.withOpacity(0.9)
                              : color.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      if (!isLocked && sessionsCompleted > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$sessionsCompleted ✓',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Bottom Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Progress bar for locked levels
                      if (isLocked && requiredSessions != null && currentLevelSessions != null && !needsIntermediate) ...[
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$currentLevelSessions / $requiredSessions to unlock',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else if (!isLocked)
                        Row(
                          children: [
                            const Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Start Practice',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
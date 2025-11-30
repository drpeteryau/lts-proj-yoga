import 'package:flutter/material.dart';
import '../models/yoga_pose.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/progress_service.dart';
import '../services/pose_progress_service.dart';

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
  late int _remainingSeconds;
  Timer? _timer;
  bool _isTimerRunning = false;

  final PoseProgressService _poseProgressService = PoseProgressService();
  bool _isPoseCompleted = false;
  bool _loadingPoseStatus = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.pose.durationSeconds;
    _loadPoseCompletion();
  }

  Future<void> _loadPoseCompletion() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _isPoseCompleted = false;
        _loadingPoseStatus = false;
      });
      return;
    }

    try {
      final completed = await _poseProgressService.isPoseCompleted(
        userId,
        widget.sessionLevel,
        widget.pose.id,
      );

      if (!mounted) return;
      setState(() {
        _isPoseCompleted = completed;
        _loadingPoseStatus = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isPoseCompleted = false;
        _loadingPoseStatus = false;
      });
    }
  }

  Future<void> _onMarkPoseCompleted() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _poseProgressService.markPoseCompleted(
        userId,
        widget.sessionLevel,
        widget.pose.id,
      );

      if (!mounted) return;
      setState(() {
        _isPoseCompleted = true;
      });

      // ✅ Check if ALL poses in the session are now completed
      final allCompleted = await _checkAllPosesCompleted(userId);

      if (allCompleted) {
        // If this was the last pose to complete, track session completion
        await _trackSessionCompletion();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session completed! 🎉'),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF40E0D0),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pose completed 🌿'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving progress: $e')),
      );
    }
  }

  // ✅ NEW: Check if all poses in the session are completed
  Future<bool> _checkAllPosesCompleted(String userId) async {
    try {
      for (final pose in widget.allPoses) {
        final completed = await _poseProgressService.isPoseCompleted(
          userId,
          widget.sessionLevel,
          pose.id,
        );
        if (!completed) {
          return false; // Found an incomplete pose
        }
      }
      return true; // All poses completed
    } catch (e) {
      print('Error checking pose completion: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTimerRunning = false;
        });
        _showNextPoseDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = widget.pose.durationSeconds;
    });
  }

  void _showNextPoseDialog() {
    if (widget.currentIndex < widget.allPoses.length - 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Great Job!', style: TextStyle(fontSize: 24)),
          content: const Text(
            'Ready for the next pose?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Stay Here', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _goToNextPose();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0),
              ),
              child: const Text(
                'Next Pose',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🎉 Congratulations!',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You completed all poses!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Great work on your practice today.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to session list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF40E0D0),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Finish',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _trackSessionCompletion() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final progressService = ProgressService();

      final updatedProgress = await progressService.completeSession(
        userId,
        widget.sessionLevel,
      );

      // Check if a level was just unlocked
      if (mounted) {
        if (updatedProgress.canUnlockIntermediate &&
            updatedProgress.intermediateUnlocked) {
          _showLevelUnlockedDialog('Intermediate');
        } else if (updatedProgress.canUnlockAdvanced &&
            updatedProgress.advancedUnlocked) {
          _showLevelUnlockedDialog('Advanced');
        }
      }

      // Save to sessions table
      await Supabase.instance.client.from('sessions').insert({
        'user_id': userId,
        'session_id': 'session_${DateTime.now().millisecondsSinceEpoch}',
        'level': widget.sessionLevel,
        'date_completed': DateTime.now().toIso8601String().split('T')[0],
        'duration_minutes': widget.allPoses.fold<int>(
          0,
              (sum, pose) => sum + (pose.durationSeconds / 60).ceil(),
        ),
      });
    } catch (e) {
      print('Error tracking session completion: $e');
    }
  }

  void _showLevelUnlockedDialog(String level) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE3F8F5), Color(0xFFD0F7F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                'Level Unlocked!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF40E0D0),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Congratulations! You\'ve unlocked $level Level!',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Keep up the amazing work on your yoga journey! 🧘‍♀️',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40E0D0),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToNextPose() {
    if (widget.currentIndex < widget.allPoses.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PoseDetailScreen(
            pose: widget.allPoses[widget.currentIndex + 1],
            allPoses: widget.allPoses,
            currentIndex: widget.currentIndex + 1,
            sessionLevel: widget.sessionLevel,
          ),
        ),
      );
    }
  }

  Color _getCategoryColor() {
    if (widget.pose.category == 'warmup') {
      return const Color(0xFF5FE9D8);
    } else if (widget.pose.category == 'cooldown') {
      return const Color(0xFF30C5B5);
    }
    return const Color(0xFF40E0D0);
  }

  @override
  Widget build(BuildContext context) {
    final pose = widget.pose;
    final progress = widget.currentIndex + 1;
    final total = widget.allPoses.length;
    final categoryColor = _getCategoryColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('$progress of $total',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress / total,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                  minHeight: 8,
                ),
              ),
            ),

            // Pose Image
            Container(
              height: 280,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  pose.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.self_improvement,
                          size: 80,
                          color: categoryColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pose.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Pose Name
                  Text(
                    pose.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    pose.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Timer Display
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: categoryColor.withOpacity(0.1),
                        border: Border.all(
                          color: categoryColor,
                          width: 6,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_remainingSeconds',
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),
                          Text(
                            'seconds',
                            style: TextStyle(
                              fontSize: 16,
                              color: categoryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Timer Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _resetTimer,
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('Reset', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                        icon: Icon(
                          _isTimerRunning ? Icons.pause : Icons.play_arrow,
                          size: 24,
                        ),
                        label: Text(
                          _isTimerRunning ? 'Pause' : 'Start',
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Instructions Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: categoryColor, size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          pose.instructions,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Modifications Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.health_and_safety_outlined, color: categoryColor, size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              'Safety Tips',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...pose.modifications.map((mod) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, color: categoryColor, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  mod,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _loadingPoseStatus || _isPoseCompleted
                              ? null
                              : _onMarkPoseCompleted,
                          icon: Icon(
                            _isPoseCompleted ? Icons.check_circle : Icons.check_circle_outline,
                            size: 20,
                          ),
                          label: Text(
                            _isPoseCompleted ? 'Completed' : 'Mark Complete',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: _isPoseCompleted ? Colors.green : categoryColor,
                              width: 2,
                            ),
                            foregroundColor: _isPoseCompleted ? Colors.green : categoryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      if (widget.currentIndex < widget.allPoses.length - 1) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _goToNextPose,
                            icon: const Icon(Icons.arrow_forward, size: 20),
                            label: const Text('Next',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: categoryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
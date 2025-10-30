import 'package:flutter/material.dart';
import '../models/yoga_pose.dart';
import 'dart:async';

class PoseDetailScreen extends StatefulWidget {
  final YogaPose pose;
  final List<YogaPose> allPoses;
  final int currentIndex;

  const PoseDetailScreen({
    super.key,
    required this.pose,
    required this.allPoses,
    required this.currentIndex,
  });

  @override
  State<PoseDetailScreen> createState() => _PoseDetailScreenState();
}

class _PoseDetailScreenState extends State<PoseDetailScreen> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.pose.durationSeconds;
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

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!', style: TextStyle(fontSize: 24)),
        content: const Text(
          'You completed the entire session!\n\nGreat work on your practice today.',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to session list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF40E0D0),
            ),
            child: const Text(
              'Finish',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
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
          ),
        ),
      );
    }
  }

  void _goToPreviousPose() {
    if (widget.currentIndex > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PoseDetailScreen(
            pose: widget.allPoses[widget.currentIndex - 1],
            allPoses: widget.allPoses,
            currentIndex: widget.currentIndex - 1,
          ),
        ),
      );
    }
  }

  Color _getCategoryColor() {
    // Use different shades of turquoise for different categories
    if (widget.pose.category == 'warmup') {
      return const Color(0xFF5FE9D8); // Light turquoise
    } else if (widget.pose.category == 'cooldown') {
      return const Color(0xFF30C5B5); // Darker turquoise
    }
    return const Color(0xFF40E0D0); // Default turquoise for main poses
  }

  @override
  Widget build(BuildContext context) {
    final pose = widget.pose;
    final progress = widget.currentIndex + 1;
    final total = widget.allPoses.length;
    final categoryColor = _getCategoryColor();

    return Scaffold(
      appBar: AppBar(
        title: Text('$progress of $total', style: const TextStyle(fontSize: 20)),
        backgroundColor: categoryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: progress / total,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
              minHeight: 6,
            ),

            // Pose Image
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                pose.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: categoryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.self_improvement,
                      size: 100,
                      color: categoryColor,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pose.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Pose Name
                  Text(
                    pose.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    pose.description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Timer Display
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: categoryColor,
                          width: 4,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$_remainingSeconds',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),
                          Text(
                            'seconds',
                            style: TextStyle(
                              fontSize: 18,
                              color: categoryColor,
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
                        icon: const Icon(Icons.refresh, size: 24),
                        label: const Text('Reset', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                        icon: Icon(
                          _isTimerRunning ? Icons.pause : Icons.play_arrow,
                          size: 28,
                        ),
                        label: Text(
                          _isTimerRunning ? 'Pause' : 'Start',
                          style: const TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Instructions
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pose.instructions,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Modifications
                  const Text(
                    'Modifications for Safety',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...pose.modifications.map((mod) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: categoryColor, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            mod,
                            style: const TextStyle(
                              fontSize: 17,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 32),

                  // Navigation Buttons
                  Row(
                    children: [
                      if (widget.currentIndex > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _goToPreviousPose,
                            icon: const Icon(Icons.arrow_back, size: 24),
                            label: const Text('Previous', style: TextStyle(fontSize: 18)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: categoryColor, width: 2),
                              foregroundColor: categoryColor,
                            ),
                          ),
                        ),
                      if (widget.currentIndex > 0 &&
                          widget.currentIndex < widget.allPoses.length - 1)
                        const SizedBox(width: 16),
                      if (widget.currentIndex < widget.allPoses.length - 1)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _goToNextPose,
                            icon: const Icon(Icons.arrow_forward, size: 24),
                            label: const Text('Next Pose', style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: categoryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
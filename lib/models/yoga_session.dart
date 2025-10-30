import 'yoga_pose.dart';

class YogaSession {
  final String id;
  final String title;
  final String level; // Beginner, Intermediate, Advanced
  final String description;
  final int totalDurationMinutes;
  final List<YogaPose> warmupPoses;
  final List<YogaPose> mainPoses;
  final List<YogaPose> cooldownPoses;

  YogaSession({
    required this.id,
    required this.title,
    required this.level,
    required this.description,
    required this.totalDurationMinutes,
    required this.warmupPoses,
    required this.mainPoses,
    required this.cooldownPoses,
  });

  List<YogaPose> get allPoses => [...warmupPoses, ...mainPoses, ...cooldownPoses];
}

import 'yoga_pose.dart';

class YogaSession {
  final String id;
  final String titleKey;
  final String levelKey; // Beginner, Intermediate, Advanced
  final String descriptionKey;
  final int totalDurationMinutes;
  final List<YogaPose> warmupPoses;
  final List<YogaPose> mainPoses;
  final List<YogaPose> cooldownPoses;

  YogaSession({
    required this.id,
    required this.titleKey,
    required this.levelKey,
    required this.descriptionKey,
    required this.totalDurationMinutes,
    required this.warmupPoses,
    required this.mainPoses,
    required this.cooldownPoses,
  });

  List<YogaPose> get allPoses => [...warmupPoses, ...mainPoses, ...cooldownPoses];
}

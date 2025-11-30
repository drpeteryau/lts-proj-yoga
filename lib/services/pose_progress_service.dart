import 'package:supabase_flutter/supabase_flutter.dart';

class PoseProgressService {
  final _supabase = Supabase.instance.client;

  /// Check if a specific pose is completed for a user
  Future<bool> isPoseCompleted(
      String userId,
      String sessionLevel,
      String poseId,
      ) async {
    try {
      final response = await _supabase
          .from('pose_progress')
          .select('is_completed')
          .eq('user_id', userId)
          .eq('session_level', sessionLevel)
          .eq('pose_id', poseId)
          .maybeSingle();

      if (response == null) return false;
      return response['is_completed'] == true;
    } catch (e) {
      print('Error checking pose completion: $e');
      return false;
    }
  }

  /// Mark a pose as completed
  Future<void> markPoseCompleted(
      String userId,
      String sessionLevel,
      String poseId,
      ) async {
    try {
      await _supabase.from('pose_progress').upsert({
        'user_id': userId,
        'session_level': sessionLevel,
        'pose_id': poseId,
        'is_completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error marking pose completed: $e');
      rethrow;
    }
  }

  /// Get all completed poses for a session level
  Future<List<String>> getCompletedPosesForLevel(
      String userId,
      String sessionLevel,
      ) async {
    try {
      final response = await _supabase
          .from('pose_progress')
          .select('pose_id')
          .eq('user_id', userId)
          .eq('session_level', sessionLevel)
          .eq('is_completed', true);

      return (response as List)
          .map((item) => item['pose_id'] as String)
          .toList();
    } catch (e) {
      print('Error getting completed poses: $e');
      return [];
    }
  }

  /// Reset all pose progress for a user
  Future<void> resetUserPoseProgress(String userId) async {
    try {
      await _supabase
          .from('pose_progress')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      print('Error resetting pose progress: $e');
      rethrow;
    }
  }

  /// Reset pose progress for a specific session level
  Future<void> resetLevelPoseProgress(
      String userId,
      String sessionLevel,
      ) async {
    try {
      await _supabase
          .from('pose_progress')
          .delete()
          .eq('user_id', userId)
          .eq('session_level', sessionLevel);
    } catch (e) {
      print('Error resetting level pose progress: $e');
      rethrow;
    }
  }
}

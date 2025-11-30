import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_progress.dart';

class ProgressService {
  final _supabase = Supabase.instance.client;

  // Get user progress from database
  Future<UserProgress> getUserProgress(String userId) async {
    try {
      final response = await _supabase
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // Create initial progress record
        final newProgress = UserProgress(userId: userId);
        await _supabase.from('user_progress').insert(newProgress.toJson());
        return newProgress;
      }

      return UserProgress.fromJson(response);
    } catch (e) {
      print('Error getting user progress: $e');
      rethrow;
    }
  }

  // Update progress after completing a session
  Future<UserProgress> completeSession(String userId, String level) async {
    try {
      final progress = await getUserProgress(userId);

      int beginnerCount = progress.beginnerSessionsCompleted;
      int intermediateCount = progress.intermediateSessionsCompleted;
      int advancedCount = progress.advancedSessionsCompleted;

      // Increment counter based on level
      switch (level) {
        case 'Beginner':
          beginnerCount++;
          break;
        case 'Intermediate':
          intermediateCount++;
          break;
        case 'Advanced':
          advancedCount++;
          break;
      }

      // Check if we should unlock next level
      bool intermediateUnlocked = progress.intermediateUnlocked;
      bool advancedUnlocked = progress.advancedUnlocked;

      if (!intermediateUnlocked &&
          beginnerCount >= UserProgress.sessionsRequiredForIntermediate) {
        intermediateUnlocked = true;
      }

      if (!advancedUnlocked &&
          intermediateUnlocked &&
          intermediateCount >= UserProgress.sessionsRequiredForAdvanced) {
        advancedUnlocked = true;
      }

      // Update in database
      final updatedProgress = progress.copyWith(
        beginnerSessionsCompleted: beginnerCount,
        intermediateSessionsCompleted: intermediateCount,
        advancedSessionsCompleted: advancedCount,
        totalSessionsCompleted: progress.totalSessionsCompleted + 1,
        intermediateUnlocked: intermediateUnlocked,
        advancedUnlocked: advancedUnlocked,
        lastUpdated: DateTime.now(),
      );

      await _supabase
          .from('user_progress')
          .upsert(updatedProgress.toJson());

      return updatedProgress;
    } catch (e) {
      print('Error completing session: $e');
      rethrow;
    }
  }

  // Manually unlock a level (admin/testing purposes)
  Future<void> unlockLevel(String userId, String level) async {
    try {
      final progress = await getUserProgress(userId);

      Map<String, dynamic> updates = {
        'user_id': userId,
        'last_updated': DateTime.now().toIso8601String(),
      };

      if (level == 'Intermediate') {
        updates['intermediate_unlocked'] = true;
      } else if (level == 'Advanced') {
        updates['advanced_unlocked'] = true;
      }

      await _supabase.from('user_progress').upsert(updates);
    } catch (e) {
      print('Error unlocking level: $e');
      rethrow;
    }
  }

  // Reset progress (for testing)
  Future<void> resetProgress(String userId) async {
    try {
      final resetProgress = UserProgress(userId: userId);
      await _supabase
          .from('user_progress')
          .upsert(resetProgress.toJson());
    } catch (e) {
      print('Error resetting progress: $e');
      rethrow;
    }
  }
}
class UserProgress {
  final String userId;
  final String currentLevel; // 'Beginner', 'Intermediate', 'Advanced'
  final bool beginnerUnlocked;
  final bool intermediateUnlocked;
  final bool advancedUnlocked;
  final int beginnerSessionsCompleted;
  final int intermediateSessionsCompleted;
  final int advancedSessionsCompleted;
  final int totalSessionsCompleted;
  final DateTime? lastUpdated;

  UserProgress({
    required this.userId,
    this.currentLevel = 'Beginner',
    this.beginnerUnlocked = true, // Always unlocked
    this.intermediateUnlocked = false,
    this.advancedUnlocked = false,
    this.beginnerSessionsCompleted = 0,
    this.intermediateSessionsCompleted = 0,
    this.advancedSessionsCompleted = 0,
    this.totalSessionsCompleted = 0,
    this.lastUpdated,
  });

  // Requirements for unlocking levels
  static const int sessionsRequiredForIntermediate = 5;
  static const int sessionsRequiredForAdvanced = 5;

  // Calculate progress towards next level
  double get progressToIntermediate {
    if (intermediateUnlocked) return 1.0;
    return (beginnerSessionsCompleted / sessionsRequiredForIntermediate).clamp(0.0, 1.0);
  }

  double get progressToAdvanced {
    if (advancedUnlocked) return 1.0;
    return (intermediateSessionsCompleted / sessionsRequiredForAdvanced).clamp(0.0, 1.0);
  }

  // Check if levels can be unlocked
  bool get canUnlockIntermediate {
    return !intermediateUnlocked && 
           beginnerSessionsCompleted >= sessionsRequiredForIntermediate;
  }

  bool get canUnlockAdvanced {
    return !advancedUnlocked && 
           intermediateUnlocked && 
           intermediateSessionsCompleted >= sessionsRequiredForAdvanced;
  }

  // Convert to/from Map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'current_level': currentLevel,
      'beginner_unlocked': beginnerUnlocked,
      'intermediate_unlocked': intermediateUnlocked,
      'advanced_unlocked': advancedUnlocked,
      'beginner_sessions_completed': beginnerSessionsCompleted,
      'intermediate_sessions_completed': intermediateSessionsCompleted,
      'advanced_sessions_completed': advancedSessionsCompleted,
      'total_sessions_completed': totalSessionsCompleted,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['user_id'] as String,
      currentLevel: json['current_level'] as String? ?? 'Beginner',
      beginnerUnlocked: json['beginner_unlocked'] as bool? ?? true,
      intermediateUnlocked: json['intermediate_unlocked'] as bool? ?? false,
      advancedUnlocked: json['advanced_unlocked'] as bool? ?? false,
      beginnerSessionsCompleted: json['beginner_sessions_completed'] as int? ?? 0,
      intermediateSessionsCompleted: json['intermediate_sessions_completed'] as int? ?? 0,
      advancedSessionsCompleted: json['advanced_sessions_completed'] as int? ?? 0,
      totalSessionsCompleted: json['total_sessions_completed'] as int? ?? 0,
      lastUpdated: json['last_updated'] != null 
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }

  UserProgress copyWith({
    String? userId,
    String? currentLevel,
    bool? beginnerUnlocked,
    bool? intermediateUnlocked,
    bool? advancedUnlocked,
    int? beginnerSessionsCompleted,
    int? intermediateSessionsCompleted,
    int? advancedSessionsCompleted,
    int? totalSessionsCompleted,
    DateTime? lastUpdated,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      currentLevel: currentLevel ?? this.currentLevel,
      beginnerUnlocked: beginnerUnlocked ?? this.beginnerUnlocked,
      intermediateUnlocked: intermediateUnlocked ?? this.intermediateUnlocked,
      advancedUnlocked: advancedUnlocked ?? this.advancedUnlocked,
      beginnerSessionsCompleted: beginnerSessionsCompleted ?? this.beginnerSessionsCompleted,
      intermediateSessionsCompleted: intermediateSessionsCompleted ?? this.intermediateSessionsCompleted,
      advancedSessionsCompleted: advancedSessionsCompleted ?? this.advancedSessionsCompleted,
      totalSessionsCompleted: totalSessionsCompleted ?? this.totalSessionsCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

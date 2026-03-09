import '../models/yoga_pose.dart';
import '../models/yoga_session.dart';

class YogaDataComplete {
// ============================================
// BEGINNER LEVEL - Chair Yoga
// ============================================
// ============================================
// BEGINNER LEVEL — Sitting Warmups
// ============================================

  static final List<YogaPose> beginnerWarmupSitting = [
    YogaPose(
      id: 'bw_sit_01',
      nameKey: 'yogaHeadNeckShoulders',
      descriptionKey: 'yogaDescHeadNeck',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 180,
      modifications: ['yogaModMoveSlowly', 'yogaModStopDizzy', 'yogaModChairSupport'],
      instructions: 'yogaInstHeadNeck',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_02',
      nameKey: 'yogaStraightArms',
      descriptionKey: 'yogaDescStraightArms',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 60,
      modifications: ['yogaModElbowsStraight', 'yogaModControlledMove'],
      instructions: 'yogaInstStraightArms',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_03',
      nameKey: 'yogaBentArms',
      descriptionKey: 'yogaDescBentArms',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 60,
      modifications: ['yogaModFingersShoulders', 'yogaModSlowRolls'],
      instructions: 'yogaInstBentArms',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_04',
      nameKey: 'yogaShouldersLateral',
      descriptionKey: 'yogaDescShouldersLateral',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 120,
      modifications: ['yogaModButtocksDown', 'yogaModFaceForward'],
      instructions: 'yogaInstShouldersLateral',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_05',
      nameKey: 'yogaShouldersTorsoTwist',
      descriptionKey: 'yogaDescShouldersTorsoTwist',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500',
      videoAsset: 'assets/videos/shouldertorsotwist.mp4',
      durationSeconds: 67,
      modifications: ['yogaModHipsStable', 'yogaModShouldersLevel'],
      instructions: 'yogaInstShouldersTorsoTwist',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_06',
      nameKey: 'yogaLegRaiseBent',
      descriptionKey: 'yogaDescLegRaiseBent',
      imageUrl: 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?w=500',
      durationSeconds: 90,
      modifications: ['yogaModChairSupport', 'yogaModBackStraight'],
      instructions: 'yogaInstLegRaiseBent',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_07',
      nameKey: 'yogaLegRaiseStraight',
      descriptionKey: 'yogaDescLegRaiseStraight',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 90,
      modifications: ['yogaModBeginBent', 'yogaModUseChairForSupport'],
      instructions: 'yogaInstLegRaiseStraight',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_08',
      nameKey: 'yogaGoddessTwist',
      descriptionKey: 'yogaDescGoddessTwist',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 120,
      modifications: ['yogaModKneesToes', 'yogaModHipsGrounded'],
      instructions: 'yogaInstGoddessTwist',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_09',
      nameKey: 'yogaGoddessStrength',
      descriptionKey: 'yogaDescGoddessStrength',
      imageUrl: 'https://images.unsplash.com/photo-1599447292326-e6daae7ae9cb?w=500',
      durationSeconds: 120,
      modifications: ['yogaModTorsoUpright', 'yogaModChairBalance'],
      instructions: 'yogaInstGoddessStrength',
      category: 'warmup',
    ),
  ];


// ============================================
// BEGINNER LEVEL — Standing Main Poses
// ============================================

  static final List<YogaPose> beginnerMainStanding = [
    YogaPose(
      id: 'bw_main_01',
      nameKey: 'yogaBackChestStretch',
      descriptionKey: 'yogaDescBackChestStretch',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 120,
      modifications: ['yogaModArmsLegsStraight', 'yogaModEngageCore'],
      instructions: 'yogaInstBackChestStretch',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_02',
      nameKey: 'yogaStandingCrunch',
      descriptionKey: 'yogaDescStandingCrunch',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 150,
      modifications: ['yogaModAvoidPregnancy', 'yogaModMoveSlowly'],
      instructions: 'yogaInstStandingCrunch',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_03',
      nameKey: 'yogaWarrior3Supported',
      descriptionKey: 'yogaDescWarrior3Supported',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 120,
      modifications: ['yogaModOneHandChair', 'yogaModStraightLine'],
      instructions: 'yogaInstWarrior3',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_04',
      nameKey: 'yogaWarrior1Supported',
      descriptionKey: 'yogaDescWarrior1Supported',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 120,
      modifications: ['yogaModShortenStance', 'yogaModSquareHips'],
      instructions: 'yogaInstWarrior1',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_05',
      nameKey: 'yogaWarrior2Supported',
      descriptionKey: 'yogaDescWarrior2Supported',
      imageUrl: 'https://images.unsplash.com/photo-1599447292326-e6daae7ae9cb?w=500',
      durationSeconds: 120,
      modifications: ['yogaModKneesToes', 'yogaModLevelShoulders'],
      instructions: 'yogaInstWarrior2',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_06',
      nameKey: 'yogaTriangleSupported',
      descriptionKey: 'yogaDescTriangleSupported',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 120,
      modifications: ['yogaModUseBlock', 'yogaModHipsForward'],
      instructions: 'yogaInstTriangle',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_07',
      nameKey: 'yogaReverseWarrior2',
      descriptionKey: 'yogaDescReverseWarrior2',
      imageUrl: 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?w=500',
      durationSeconds: 120,
      modifications: ['yogaModFrontKneeBent', 'yogaModGazeDirection'],
      instructions: 'yogaInstReverseWarrior',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_08',
      nameKey: 'yogaSideAngleSupported',
      descriptionKey: 'yogaDescSideAngleSupported',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500',
      durationSeconds: 120,
      modifications: ['yogaModUseBlock', 'yogaModTuckTailbone'],
      instructions: 'yogaInstSideAngle',
      category: 'main',
    ),
  ];


// ============================================
// BEGINNER LEVEL — Cooldown
// ============================================

  static final List<YogaPose> beginnerCooldown = [
    YogaPose(
      id: 'bw_cd_01',
      nameKey: 'yogaGentleBreathing',
      descriptionKey: 'yogaDescGentleBreathing',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 180,
      modifications: ['yogaModSitOrLieDown', 'yogaModCloseEyesIfComfortable'],
      instructions: 'yogaInstGentleBreathing',
      category: 'cooldown',
    ),
  ];


// ============================================
// BEGINNER LEVEL — Sessions
// ============================================

  static final List<YogaSession> beginnerSessions = [
    YogaSession(
      id: 'beginner_1',
      titleKey: 'yogaSessionGentleChair',
      levelKey: 'Beginner',
      descriptionKey: 'yogaDescGentleChair',
      totalDurationMinutes: 35,
      warmupPoses: beginnerWarmupSitting,
      mainPoses: beginnerMainStanding,
      cooldownPoses: beginnerCooldown,
    ),
    YogaSession(
      id: 'beginner_2',
      titleKey: 'yogaSessionMorningMobility',
      levelKey: 'Beginner',
      descriptionKey: 'yogaDescMorningMobility',
      totalDurationMinutes: 20,
      warmupPoses: beginnerWarmupSitting.take(5).toList(),
      mainPoses: beginnerMainStanding.take(4).toList(),
      cooldownPoses: beginnerCooldown,
    ),
    YogaSession(
      id: 'beginner_3',
      titleKey: 'yogaSessionWarriorSeries',
      levelKey: 'Beginner',
      descriptionKey: 'yogaDescWarriorSeries',
      totalDurationMinutes: 25,
      warmupPoses: beginnerWarmupSitting.take(4).toList(),
      mainPoses: beginnerMainStanding.sublist(3, 8).toList(),
      cooldownPoses: beginnerCooldown,
    ),
  ];


// ============================================
// INTERMEDIATE LEVEL — Main Poses (Hatha Yoga)
// ============================================

  static final List<YogaPose> intermediateMain = [
    YogaPose(
      id: 'int_main_01',
      nameKey: 'yogaDownwardDog',
      descriptionKey: 'yogaDescDownwardDog',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      videoAsset: 'assets/videos/downwardfacingdog.mp4',
      durationSeconds: 82,
      modifications: ['yogaModBendKnees', 'yogaModHeelsLifted'],
      instructions: 'yogaInstDownwardDog',
      category: 'main',
    ),
    YogaPose(
      id: 'int_main_02',
      nameKey: 'yogaPlank',
      descriptionKey: 'yogaDescPlank',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 90,
      modifications: ['yogaModLowerKnees', 'yogaModFeetTogether'],
      instructions: 'yogaInstPlank',
      category: 'main',
    ),
    YogaPose(
      id: 'int_main_03',
      nameKey: 'yogaEightPointPose',
      descriptionKey: 'yogaDescEightPoint',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: ['yogaModAvoidPregnancy', 'yogaModSlowControl'],
      instructions: 'yogaInstEightPoint',
      category: 'main',
    ),
    YogaPose(
      id: 'int_main_04',
      nameKey: 'yogaBabyCobra',
      descriptionKey: 'yogaDescBabyCobra',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 90,
      modifications: ['yogaModLiftPalms', 'yogaModPressFeet'],
      instructions: 'yogaInstBabyCobra',
      category: 'main',
    ),
    YogaPose(
      id: 'int_main_05',
      nameKey: 'yogaFullCobra',
      descriptionKey: 'yogaDescFullCobra',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 90,
      modifications: ['yogaModNoLockElbows', 'yogaModTuckStomach'],
      instructions: 'yogaInstFullCobra',
      category: 'main',
    ),
  ];


// ============================================
// INTERMEDIATE LEVEL — Cooldown
// (uses same cooldown as beginner for consistency)
// ============================================

  static final List<YogaPose> intermediateCooldown = [
    YogaPose(
      id: 'int_cd_01',
      nameKey: 'yogaGentleBreathing',
      descriptionKey: 'Cooldown breathing to settle heart rate and calm the mind.',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 180,
      modifications: ['yogaModSitOrLieDown', 'yogaModCloseEyesIfComfortable'],
      instructions: 'yogaInstGentleBreathingIntermediate',
      category: 'cooldown',
    ),
  ];


// ============================================
// INTERMEDIATE LEVEL — Sessions
// ============================================

  static final List<YogaSession> intermediateSessions = [
    YogaSession(
      id: 'intermediate_1',
      titleKey: 'yogaSessionHathaFundamentals',
      levelKey: 'Intermediate',
      descriptionKey: 'yogaDescHathaFundamentals',
      totalDurationMinutes: 30,
      warmupPoses: [], // intermediate warmup intentionally minimal
      mainPoses: intermediateMain,
      cooldownPoses: intermediateCooldown,
    ),
    YogaSession(
      id: 'intermediate_2',
      titleKey: 'yogaSessionCoreStrength',
      levelKey: 'Intermediate',
      descriptionKey: 'yogaDescCoreStrength',
      totalDurationMinutes: 20,
      warmupPoses: [],
      mainPoses: intermediateMain.take(3).toList(),
      cooldownPoses: intermediateCooldown,
    ),
    YogaSession(
      id: 'intermediate_3',
      titleKey: 'yogaSessionBackbendFlow',
      levelKey: 'Intermediate',
      descriptionKey: 'yogaDescBackbendFlow',
      totalDurationMinutes: 25,
      warmupPoses: [],
      mainPoses: intermediateMain.sublist(2).toList(),
      cooldownPoses: intermediateCooldown,
    ),
  ];

// ============================================
// ADVANCED LEVEL — Sun Salutation Flow
// ============================================

  static final List<YogaPose> advancedFlow = [
    YogaPose(
      id: 'adv_main_01',
      nameKey: 'yogaSunSalutation',
      descriptionKey: 'yogaDescSunSalutation',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      videoAsset: 'assets/videos/sunsalutation.mp4',
      durationSeconds: 83,
      modifications: ['yogaModRestChildPose', 'yogaModSlowTransitions', 'yogaModBendDownwardDog'],
      instructions: 'yogaInstSunSalutation',
      // '''
      // This flowing sequence repeats continuously — one breath per movement.

      // 1. Inhale — Downward Dog
      //   Lift hips high, lengthen spine.

      // 2. Exhale — Plank
      //   Shift forward into strong plank position.

      // 3. Inhale — Knees-Chest-Chin (Eight-Point Pose)
      //   Lower down with control, hips lifted.

      // 4. Exhale — Baby Cobra
      //   Lift chest gently, elbows close.

      // 5. Inhale — Full Cobra
      //   Straighten arms slightly, open chest.

      // 6. Exhale — Return to Downward Dog
      //   Press back into inverted V-shape.

      // Repeat for 5–10 rounds or to your ability level.
      // ''',
      category: 'main',
    ),
  ];


// ============================================
// ADVANCED LEVEL — Cooldown (reuse for consistency)
// ============================================

  static final List<YogaPose> advancedCooldown = [
    YogaPose(
      id: 'adv_cd_01',
      nameKey: 'yogaGentleBreathing',
      descriptionKey: 'Final calming breathwork to restore balance after a strong flow.',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 180,
      modifications: ['yogaModSitOrLie', 'yogaModCushionUnderKnees'],
      instructions: 'yogaGentleBreathingAdvanced',
      category: 'cooldown',
    ),
  ];


// ============================================
// ADVANCED LEVEL — Sessions
// ============================================

  static final List<YogaSession> advancedSessions = [
    YogaSession(
      id: 'advanced_1',
      titleKey: 'yogaSessionSunSalutation',
      levelKey: 'Advanced',
      descriptionKey: 'yogaDescSunSalutationSession',
      totalDurationMinutes: 15,
      warmupPoses: [], // advanced users begin with direct dynamic flow
      mainPoses: advancedFlow,
      cooldownPoses: advancedCooldown,
    ),
    YogaSession(
      id: 'advanced_2',
      titleKey: 'yogaSessionExtendedFlow',
      levelKey: 'Advanced',
      descriptionKey: 'yogaDescExtendedFlow',
      totalDurationMinutes: 25,
      warmupPoses: [],
      mainPoses: advancedFlow,
      cooldownPoses: advancedCooldown,
    ),
  ];

}
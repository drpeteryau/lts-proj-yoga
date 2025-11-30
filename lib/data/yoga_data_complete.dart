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
      name: 'Head, Neck and Shoulders Stretch',
      description: 'Gentle seated stretches releasing neck and shoulder tension.',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 180,
      modifications: [
        'Move slowly',
        'Stop if dizzy',
        'Use chair back for support'
      ],
      instructions:
      'Tilt head up/down for 5–10 breaths each. Turn head right/left 3 rounds. Drop ear to shoulder with light hand support.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_02',
      name: 'Straight Arms Rotation',
      description: 'Arm rotations to warm up shoulders and upper back.',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 60,
      modifications: ['Keep elbows straight', 'Smooth controlled movement'],
      instructions:
      'Make fists, rotate straight arms 10 times forward and 10 times backward.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_03',
      name: 'Bent Arm Rotation',
      description: 'Shoulder mobility exercise with bent elbows.',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 60,
      modifications: ['Keep fingers on shoulders', 'Slow controlled rolls'],
      instructions:
      'Touch elbows in front, circle up behind head and back down. 10 rounds each direction.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_04',
      name: 'Shoulders Lateral Stretch',
      description: 'Side-body stretch improving flexibility.',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 120,
      modifications: ['Keep buttocks down', 'Face forward'],
      instructions:
      'Drop right hand to chair, lift left arm overhead. Hold 5–10 breaths. Switch sides.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_05',
      name: 'Shoulders & Torso Twist',
      description: 'A gentle detoxifying twist.',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500',
      durationSeconds: 120,
      modifications: ['Keep hips stable', 'Keep shoulders level'],
      instructions:
      'Lift arms, rotate torso right, hold chair for support. Hold 5–10 breaths each side.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_06',
      name: 'Leg Raise (Bent)',
      description: 'Strengthen legs and activate core.',
      imageUrl: 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?w=500',
      durationSeconds: 90,
      modifications: ['Use chair back for support', 'Keep back straight'],
      instructions:
      'Lift bent leg with back straight. Hold, lower with control. Switch legs.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_07',
      name: 'Leg Raise (Straight)',
      description: 'Straight-leg lift for advanced strength.',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 90,
      modifications: ['Begin with bent-knee version', 'Use chair for support'],
      instructions:
      'Lift straightened leg, hold as long as possible. Release and switch legs.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_08',
      name: 'Goddess Pose — Torso Twist',
      description: 'Wide-leg seated pose for mobility.',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 120,
      modifications: ['Align knees with toes', 'Keep hips grounded'],
      instructions:
      'Open knees wide, stretch torso to side. Hold 5–10 breaths, switch side.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'bw_sit_09',
      name: 'Goddess Pose — Leg Strengthening',
      description: 'Strengthening variation of seated Goddess.',
      imageUrl: 'https://images.unsplash.com/photo-1599447292326-e6daae7ae9cb?w=500',
      durationSeconds: 120,
      modifications: ['Keep torso upright', 'Use chair for balance'],
      instructions:
      'Lift thighs off chair while in Goddess stance. Hold 5–10 breaths. Repeat.',
      category: 'warmup',
    ),
  ];


// ============================================
// BEGINNER LEVEL — Standing Main Poses
// ============================================

  static final List<YogaPose> beginnerMainStanding = [
    YogaPose(
      id: 'bw_main_01',
      name: 'Back and Chest Stretch',
      description: 'L-shape stretch improving upper-body flexibility.',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 120,
      modifications: ['Keep arms and legs straight', 'Engage core'],
      instructions:
      'Hold chair, hinge into L-shape, keep back flat. Hold 5–10 breaths.',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_02',
      name: 'Standing Crunch',
      description: 'Dynamic core-strengthening movement.',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 150,
      modifications: ['Avoid during pregnancy', 'Move slowly'],
      instructions:
      'From L-shape, extend leg back on inhale, crunch knee forward on exhale. Repeat.',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_03',
      name: 'Warrior 3 (Supported)',
      description: 'Balance and strength with chair support.',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 120,
      modifications: ['Keep one hand on chair', 'Maintain a straight line'],
      instructions:
      'Lift hand off chair, hold balance. Switch legs and repeat.',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_04',
      name: 'Warrior 1 (Supported)',
      description: 'Beginner-friendly Warrior stance.',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 120,
      modifications: ['Shorten stance', 'Square hips'],
      instructions:
      'Step back, bend front knee, raise arms. Hold 5–10 breaths.',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_05',
      name: 'Warrior 2 (Supported)',
      description: 'Side-facing warrior for hip opening.',
      imageUrl: 'https://images.unsplash.com/photo-1599447292326-e6daae7ae9cb?w=500',
      durationSeconds: 120,
      modifications: ['Align knee with toes', 'Level shoulders'],
      instructions:
      'Turn toes outward, stretch arms, look forward. Hold.',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_06',
      name: 'Triangle Pose (Supported)',
      description: 'Deep side-body extension.',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 120,
      modifications: ['Use block', 'Keep hips forward'],
      instructions:
      'Straighten front leg, lower hand to ankle or block, reach upward.',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_07',
      name: 'Reverse Warrior 2',
      description: 'Back-arching warrior stretch.',
      imageUrl: 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?w=500',
      durationSeconds: 120,
      modifications: ['Keep front knee bent', 'Choose gaze direction'],
      instructions:
      'Sweep top arm overhead while leaning back. Hold.',
      category: 'main',
    ),
    YogaPose(
      id: 'bw_main_08',
      name: 'Side Angle Pose (Supported)',
      description: 'Strengthens legs and opens ribs.',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500',
      durationSeconds: 120,
      modifications: ['Use block', 'Tuck tailbone slightly'],
      instructions:
      'Lower hand inside foot, stretch upper arm diagonally overhead.',
      category: 'main',
    ),
  ];


// ============================================
// BEGINNER LEVEL — Cooldown
// ============================================

  static final List<YogaPose> beginnerCooldown = [
    YogaPose(
      id: 'bw_cd_01',
      name: 'Gentle Breathing',
      description: 'Full-body relaxation and calm breathing.',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 180,
      modifications: ['Sit or lie down', 'Close eyes if comfortable'],
      instructions:
      'Relax shoulders, place hands on lap, breathe slowly through the nose.',
      category: 'cooldown',
    ),
  ];


// ============================================
// BEGINNER LEVEL — Sessions
// ============================================

  static final List<YogaSession> beginnerSessions = [
    YogaSession(
      id: 'beginner_1',
      title: 'Gentle Chair Yoga',
      level: 'Beginner',
      description:
      'A gentle introduction suitable for seniors or those wanting a slow, supported practice. Includes full seated warmup and supported standing postures.',
      totalDurationMinutes: 35,
      warmupPoses: beginnerWarmupSitting,
      mainPoses: beginnerMainStanding,
      cooldownPoses: beginnerCooldown,
    ),
    YogaSession(
      id: 'beginner_2',
      title: 'Morning Mobility',
      level: 'Beginner',
      description:
      'A light morning routine focusing on joint mobility, breathing, and supported strength work.',
      totalDurationMinutes: 20,
      warmupPoses: beginnerWarmupSitting.take(5).toList(),
      mainPoses: beginnerMainStanding.take(4).toList(),
      cooldownPoses: beginnerCooldown,
    ),
    YogaSession(
      id: 'beginner_3',
      title: 'Warrior Series',
      level: 'Beginner',
      description:
      'A confidence-building sequence exploring Warrior I, II, and supporting transitions.',
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
    name: 'Downward Dog',
    description: 'A foundational inverted V pose that stretches the full body.',
    imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
    durationSeconds: 120,
    modifications: [
      'Bend knees if hamstrings are tight',
      'Practice with heels lifted'
    ],
    instructions:
    'Place hands shoulder-width apart, feet hip-width apart. Lift hips high, press chest towards thighs. Hold 5–10 breaths.',
    category: 'main',
  ),
  YogaPose(
    id: 'int_main_02',
    name: 'Plank Pose',
    description: 'Full-body strength builder engaging core, arms, and legs.',
    imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
    durationSeconds: 90,
    modifications: [
      'Lower knees for a gentler version',
      'Feet together for added challenge'
    ],
    instructions:
    'Stack shoulders over wrists, engage core, lengthen from head to heels. Hold 5–10 breaths.',
    category: 'main',
  ),
  YogaPose(
    id: 'int_main_03',
    name: 'Eight-Point Pose (Ashtangasana)',
    description: 'Strength-building pose lowering chest, chin, knees and toes.',
    imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
    durationSeconds: 90,
    modifications: [
      'Avoid during pregnancy',
      'Lower with slow control to protect shoulders'
    ],
    instructions:
    'From tabletop, lower chest and chin to mat while hips stay lifted. Hold 5–10 breaths.',
    category: 'main',
  ),
  YogaPose(
    id: 'int_main_04',
    name: 'Baby Cobra',
    description: 'Gentle backbend strengthening upper back and spine.',
    imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
    durationSeconds: 90,
    modifications: [
      'Lift palms for challenge',
      'Press feet down for stability'
    ],
    instructions:
    'From prone, press chest up lightly, keep elbows close and shoulders away from ears. Hold 5–10 breaths.',
    category: 'main',
  ),
  YogaPose(
    id: 'int_main_05',
    name: 'Full Cobra Pose',
    description: 'A stronger chest-opening backbend engaging the whole body.',
    imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
    durationSeconds: 90,
    modifications: [
      'Do not lock elbows',
      'Tuck stomach slightly for spine support'
    ],
    instructions:
    'Straighten elbows, lift chest higher without scrunching shoulders. Hold 5–10 breaths.',
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
    name: 'Gentle Breathing',
    description: 'Cooldown breathing to settle heart rate and calm the mind.',
    imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
    durationSeconds: 180,
    modifications: ['Sit or lie down', 'Close eyes if comfortable'],
    instructions:
    'Place hands on belly or lap, relax shoulders, breathe through the nose slowly and naturally.',
    category: 'cooldown',
  ),
];


// ============================================
// INTERMEDIATE LEVEL — Sessions
// ============================================

static final List<YogaSession> intermediateSessions = [
  YogaSession(
    id: 'intermediate_1',
    title: 'Hatha Fundamentals',
    level: 'Intermediate',
    description:
    'A classic mat-based Hatha sequence focusing on alignment, breath, and full-body engagement. Ideal for practitioners ready to move beyond chair support.',
    totalDurationMinutes: 30,
    warmupPoses: [], // intermediate warmup intentionally minimal
    mainPoses: intermediateMain,
    cooldownPoses: intermediateCooldown,
  ),
  YogaSession(
    id: 'intermediate_2',
    title: 'Core Strength Builder',
    level: 'Intermediate',
    description:
    'A short but powerful session focusing on Plank, Eight-Point Pose, and controlled transitions. Boosts core strength and shoulder stability.',
    totalDurationMinutes: 20,
    warmupPoses: [],
    mainPoses: intermediateMain.take(3).toList(),
    cooldownPoses: intermediateCooldown,
  ),
  YogaSession(
    id: 'intermediate_3',
    title: 'Backbend Flow',
    level: 'Intermediate',
    description:
    'A spine-strengthening sequence moving from Eight-Point Pose into Baby Cobra and Full Cobra. Builds confidence in backbending.',
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
      name: 'Sun Salutation Flow',
      description:
      'A dynamic sequence linking breath and movement. Builds strength, heat, coordination, and stamina.',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 300, // 5 minutes
      modifications: [
        'Rest in Child’s Pose between rounds if needed',
        'Slow down transitions if breath becomes strained',
        'Bend knees in Downward Dog for comfort'
      ],
      instructions: '''
This flowing sequence repeats continuously — one breath per movement.

1. Inhale — Downward Dog  
   Lift hips high, lengthen spine.

2. Exhale — Plank  
   Shift forward into strong plank position.

3. Inhale — Knees-Chest-Chin (Eight-Point Pose)  
   Lower down with control, hips lifted.

4. Exhale — Baby Cobra  
   Lift chest gently, elbows close.

5. Inhale — Full Cobra  
   Straighten arms slightly, open chest.

6. Exhale — Return to Downward Dog  
   Press back into inverted V-shape.

Repeat for 5–10 rounds or to your ability level.
''',
      category: 'main',
    ),
  ];


// ============================================
// ADVANCED LEVEL — Cooldown (reuse for consistency)
// ============================================

  static final List<YogaPose> advancedCooldown = [
    YogaPose(
      id: 'adv_cd_01',
      name: 'Gentle Breathing',
      description: 'Final calming breathwork to restore balance after a strong flow.',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 180,
      modifications: ['Sit upright or lie flat', 'Place cushion under knees'],
      instructions:
      'Breathe softly through the nose, lengthening exhales. Allow the entire body to settle and cool down.',
      category: 'cooldown',
    ),
  ];


// ============================================
// ADVANCED LEVEL — Sessions
// ============================================

  static final List<YogaSession> advancedSessions = [
    YogaSession(
      id: 'advanced_1',
      title: 'Sun Salutation Flow',
      level: 'Advanced',
      description:
      'A dynamic mat-based flow designed to synchronise breath and movement. This session builds endurance and full-body strength through repeated Sun Salutation cycles.',
      totalDurationMinutes: 15,
      warmupPoses: [], // advanced users begin with direct dynamic flow
      mainPoses: advancedFlow,
      cooldownPoses: advancedCooldown,
    ),
    YogaSession(
      id: 'advanced_2',
      title: 'Extended Flow Practice',
      level: 'Advanced',
      description:
      'A deeper and longer Sun Salutation practice — ideal for experienced practitioners wanting a continuous challenge with breath-led movement.',
      totalDurationMinutes: 25,
      warmupPoses: [],
      mainPoses: advancedFlow,
      cooldownPoses: advancedCooldown,
    ),
  ];

}

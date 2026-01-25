import '../models/yoga_pose.dart';
import '../models/yoga_session.dart';

class YogaData {
  // ============================================================================
  // BEGINNER LEVEL - CHAIR YOGA
  // ============================================================================

  // Beginner Warmup Poses (Sitting)
  static final List<YogaPose> beginnerWarmup = [
    YogaPose(
      id: 'beginner_warmup_1',
      name: 'Head, Neck and Shoulders Stretch',
      description: 'Gentle stretches to release tension in head, neck and shoulders',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 120,
      modifications: ['Move slowly', 'Stop if you feel dizzy', 'Keep shoulders down'],
      instructions: '''Sit with feet grounded and apart, knees above ankles. Lengthen spine.

Head Tilt: Breathe in, tilt head up. Hold for 5 breaths. Tilt down, chin to chest. Hold 5-10 breaths. Repeat 3 times.

Head Turn: Turn head right, chin to right shoulder. Hold 5 breaths. Turn left. Hold 5-10 breaths. Repeat 3 times.

Ear to Shoulder: Drop right ear to right shoulder. Right palm holds head. Bend left arm behind back. Hold 5 breaths. Repeat other side. Do 3 times each side.''',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_2',
      name: 'Straight Arms Rotation',
      description: 'Rotate arms to warm up shoulders',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 60,
      modifications: ['Keep movements smooth', 'Do not bend elbows'],
      instructions: 'Thumbs inside fingers to make fists. Rotate arms in one direction without bending elbows. Repeat 10 times. Change direction. Repeat 10 times.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_3',
      name: 'Bent Arm Rotation',
      description: 'Shoulder mobility with bent arms',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 60,
      modifications: ['Move at your own pace'],
      instructions: 'Fingers on shoulders. Touch elbows in front of chest, then lift elbows behind head and touch wrists behind head. Roll arms to front, touch elbows in front. Repeat 10 times each direction.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_4',
      name: 'Shoulders Lateral Stretch',
      description: 'Side body stretch',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: ['Keep buttock on chair', 'Face forward'],
      instructions: 'Lift arms. Drop right arm to hold chair seat, stretch left arm over head. Feel left side stretch. Face front. Left buttock stays on chair. Hold 5-10 breaths. Repeat 3 times each side.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_5',
      name: 'Shoulders and Torso Twist',
      description: 'Spinal twist for detoxification',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: ['Keep hips still', 'Shoulders level'],
      instructions: 'Lift and straighten arms. Turn torso and shoulders right, hold chair rest to twist deeper. Hips don\'t move, shoulders level. Hold 5-10 breaths. Repeat 3 times each side. Slow, deep breathing massages internal organs.',
      category: 'warmup',
    ),
  ];

  // Beginner Main Poses (Sitting)
  static final List<YogaPose> beginnerMainSitting = [
    YogaPose(
      id: 'beginner_main_1',
      name: 'Leg Raise (Bent)',
      description: 'Strengthen legs and core',
      imageUrl: 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?w=500',
      durationSeconds: 60,
      modifications: ['Hold chair sides if needed', 'Back against rest for support'],
      instructions: 'Lift right leg high without hand support, keep back straight. Stick back to chair rest if needed. Hold as long as possible, release with control. Repeat left leg. Progress to no hand support.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_main_2',
      name: 'Leg Raise (Straight)',
      description: 'Advanced leg strengthening',
      imageUrl: 'https://images.unsplash.com/photo-1599447292326-e6daae7ae9cb?w=500',
      durationSeconds: 60,
      modifications: ['Use chair support initially', 'Keep back straight'],
      instructions: 'Lift right leg and straighten it without hand support. Keep back straight, use chair rest if needed. Hold as long as possible, release with control. Repeat left leg.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_main_3',
      name: 'Goddess Pose (Torso Twist)',
      description: 'Side stretch in wide leg position',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 90,
      modifications: ['Toes point same direction as knees'],
      instructions: 'Widen knees to sides, toes point same direction as knees. Palms on thighs, stretch torso right by straightening left arm. Feel left side stretch. Hold 5-10 breaths each side.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_main_4',
      name: 'Goddess Pose (Leg Stretch)',
      description: 'Strengthen legs in wide stance',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 60,
      modifications: ['Upper body perpendicular to ground'],
      instructions: 'Widen knees to sides, toes aligned with knees. Lift thighs from chair, use leg strength. Upper body perpendicular to ground. Hold 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
  ];

  // Beginner Main Poses (Standing)
  static final List<YogaPose> beginnerMainStanding = [
    YogaPose(
      id: 'beginner_standing_1',
      name: 'Back and Chest Stretch',
      description: 'Full body stretch with chair support',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 90,
      modifications: ['Feet hip-width apart', 'Keep abdomen in'],
      instructions: 'Face chair rest. Hold top of chair. Stand feet hip-width apart. Upper body parallel with ground. Hips stack over feet, forming horizontal "L". Arms and legs straight. Keep abdomen in. Feel stretch in arms, back, legs. Hold 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_2',
      name: 'Standing Crunch',
      description: 'Core strengthening with leg movement',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 90,
      modifications: ['Not for pregnant women', 'Keep upper body parallel'],
      instructions: 'Hold top of chair rest. Feet together. Upper body parallel with ground, forming "L" shape. Arms and legs straight. Abdomen in. Inhale: straighten right leg back. Exhale: crunch right knee to chest. Repeat 5-10 times each leg.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_3',
      name: 'Warrior 3',
      description: 'Balance and strengthen',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: ['Start with both hands on chair', 'Progress to one hand'],
      instructions: 'Hold chair rest. Upper body parallel with ground. Lift one hand off chair. Hold 5-10 breaths. Release. Repeat other hand. Change legs. Strengthens legs and abdomen, keeps body and mind agile.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_4',
      name: 'Warrior 1',
      description: 'Leg strengthening and spinal stretch',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: ['Square hips', 'Tuck tailbone'],
      instructions: 'Sit across chair. Right leg bent, left leg straight. Right toes to 12 o\'clock, left toes to 11 o\'clock. Square hips. Tuck tailbone. Arms up and straight. Look at palms. Stretch spine from tailbone. Hold 5-10 breaths. Repeat 3 times each side. Induces deep breath, relieves neck and shoulder stiffness, strengthens legs.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_5',
      name: 'Warrior 2',
      description: 'Leg and back strengthening',
      imageUrl: 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?w=500',
      durationSeconds: 90,
      modifications: ['Knee and toes aligned', 'Tailbone tucked'],
      instructions: 'From Warrior 1, turn left toes to 3 o\'clock, right toes stay at 12 o\'clock. Right knee and toes aligned. Tailbone tucked. Look at right hand. Hold 5-10 breaths. Strengthens legs and back, tones abdomen and arms.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_6',
      name: 'Triangle Pose',
      description: 'Strengthen legs and expand chest',
      imageUrl: 'https://images.unsplash.com/photo-1599447292326-e6daae7ae9cb?w=500',
      durationSeconds: 90,
      modifications: ['Use block if needed', 'Hips forward'],
      instructions: 'From Warrior 2, straighten bent leg. Stretch both arms right, lower right palm along right ankle. Left arm stretches up. Hips forward. Look to top palm. Hold 5-10 breaths. Change sides. Strengthens legs and ankles, relieves back pain.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_7',
      name: 'Reverse Warrior 2',
      description: 'Strengthen obliques and legs',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 90,
      modifications: ['Look up or forward as comfortable'],
      instructions: 'From Warrior 2, stretch right arm over head, palm down. Left arm stretches along left leg. Look at right hand or left hand. Hold 5-10 breaths. Strengthens legs, back, obliques. Tones abdomen and arms.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_8',
      name: 'Side Angle Pose',
      description: 'Deep side stretch and strengthening',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 90,
      modifications: ['Use block to raise palm', 'Tuck tailbone'],
      instructions: 'From Warrior 2, lower palm inside right foot. Use block if needed. Stretch left arm over head, palm down. Look up at left hand. Tailbone tucked. Hold 5-10 breaths. Change sides. Strengthens legs, expands chest, aids digestion.',
      category: 'main',
    ),
  ];

  // Beginner Cooldown
  static final List<YogaPose> beginnerCooldown = [
    YogaPose(
      id: 'beginner_cooldown_1',
      name: 'Seated Rest',
      description: 'Return to calm seated position',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 120,
      modifications: ['Breathe deeply', 'Close eyes if comfortable'],
      instructions: 'Sit comfortably in chair. Feet flat on floor. Hands resting on thighs. Breathe deeply and naturally. Allow your body to rest and integrate the practice.',
      category: 'cooldown',
    ),
  ];

  // ============================================================================
  // INTERMEDIATE LEVEL - HATHA YOGA (On the Mat)
  // ============================================================================

  static final List<YogaPose> intermediateMain = [
    YogaPose(
      id: 'intermediate_1',
      name: 'Downward Facing Dog',
      description: 'Inverted V position - full body strengthening',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 90,
      modifications: ['Bend knees if needed', 'Spread fingers wide'],
      instructions: '''Palms shoulder-width apart. Fingers spread like spider web. Fingertips press down strongly so wrists don't bear too much weight. Feel suction from hand placement.

Feet hips-width apart. Push hips back. Pose looks like inverted "V". Elongate outer sides of arms until you feel suction in core or belly. Hold 5-10 breaths. Repeat 3 times.

Strengthens legs, feet, arms, hands, back and core. Invigorates brain by reducing fatigue.''',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_2',
      name: 'Plank Pose',
      description: 'Core strengthening in straight line position',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: ['Feet can be together for advanced', 'Keep core tight'],
      instructions: '''Hands shoulder-width apart, under shoulder sockets. Feet hips-width apart on toes, legs hugging together.

From head to feet should form slanting straight line. Core tight by sucking belly inwards. Hold 5-10 breaths. Repeat 3 times.

Feet together for level-up practice. Strengthens entire core, arms, and legs.''',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_3',
      name: 'Eight-Point Pose (Ashtangasana)',
      description: 'Caterpillar pose for arm strength',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: ['Not for pregnant women', 'Lower with control'],
      instructions: '''From lowered knees tabletop, shift torso forward. Lower chest to mat with control.

Chin, chest, palms, knees and toes grounded while belly lifted. Shoulders press toward torso, core sucked in. Elbows squeeze to torso. Hold 5-10 breaths. Repeat 3 times.

Realigns spine, strengthens chin, neck, arms.''',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_4',
      name: 'Baby Cobra',
      description: 'Gentle backbend for spine strengthening',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 90,
      modifications: ['Lift palms off mat for advanced', 'Toes pointed'],
      instructions: '''From Eight-point pose, shift forward so whole body except chest is grounded. Toes pointed.

Press lower body and feet into ground to lift chest further. Hold 5-10 breaths. Repeat 3 times.

Strengthens spine, expands lung capacity, alleviates backache. Lift palms from mat for level-up.''',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_5',
      name: 'Full Cobra (Bhujangasana)',
      description: 'Deep backbend for spine and chest',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 90,
      modifications: ['Keep shoulders down', 'Chest up'],
      instructions: '''From Baby Cobra, push up and straighten elbows to full cobra. Shoulders down, chest up. Hold 5-10 breaths. Repeat 3 times.

Strengthens spine and arm strength, expands lung capacity, alleviates backache, stimulates pelvic region.''',
      category: 'main',
    ),
  ];

  // ============================================================================
  // ADVANCED LEVEL - SUN SALUTATION FLOW
  // ============================================================================

  static final List<YogaPose> advancedFlow = [
    YogaPose(
      id: 'advanced_1',
      name: 'Sun Salutation Flow',
      description: 'Dynamic flow combining 5 poses - one breath, one movement',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 300,
      modifications: ['Start with 5 rounds', 'Progress to 10 rounds', 'Rest as needed'],
      instructions: '''Combine 5 poses from intermediate level into a flowing sequence:

1. Downward Facing Dog
2. Plank Pose
3. Eight-Point Pose (Ashtangasana)
4. Baby Cobra
5. Full Cobra
6. Return to Downward Facing Dog

Ensure ONE BREATH, ONE MOVEMENT throughout the flow.

Repeat 5 to 10 rounds, or to your ability.

Benefits: Strengthening, stretching, cardio, breath awareness. Builds heat, stamina, and mental focus.''',
      category: 'main',
    ),
  ];

  // ============================================================================
  // SESSIONS
  // ============================================================================

  static final List<YogaSession> beginnerSessions = [
    YogaSession(
      id: 'beginner_1',
      title: 'Gentle Chair Yoga - Full Session',
      level: 'Beginner',
      description: 'Complete chair yoga session suitable for most people. Practice on empty stomach or 2 hours after meal.',
      totalDurationMinutes: 35,
      warmupPoses: beginnerWarmup,
      mainPoses: [...beginnerMainSitting, ...beginnerMainStanding],
      cooldownPoses: beginnerCooldown,
    ),
    YogaSession(
      id: 'beginner_2',
      title: 'Chair Yoga - Seated Focus',
      level: 'Beginner',
      description: 'Focus on seated chair poses. Great for limited mobility.',
      totalDurationMinutes: 20,
      warmupPoses: beginnerWarmup.take(3).toList(),
      mainPoses: beginnerMainSitting,
      cooldownPoses: beginnerCooldown,
    ),
    YogaSession(
      id: 'beginner_3',
      title: 'Chair Yoga - Standing Focus',
      level: 'Beginner',
      description: 'Chair-supported standing poses for balance and strength.',
      totalDurationMinutes: 25,
      warmupPoses: beginnerWarmup.take(3).toList(),
      mainPoses: beginnerMainStanding,
      cooldownPoses: beginnerCooldown,
    ),
    YogaSession(
      id: 'beginner_4',
      title: 'Quick Chair Yoga',
      level: 'Beginner',
      description: 'Shorter session for busy days.',
      totalDurationMinutes: 15,
      warmupPoses: beginnerWarmup.take(2).toList(),
      mainPoses: [beginnerMainSitting[0], beginnerMainSitting[2], beginnerMainStanding[0]],
      cooldownPoses: beginnerCooldown,
    ),
  ];

  static final List<YogaSession> intermediateSessions = [
    YogaSession(
      id: 'intermediate_1',
      title: 'Hatha Yoga - Foundation',
      level: 'Intermediate',
      description: 'Classic hatha yoga poses on the mat. Build strength and flexibility.',
      totalDurationMinutes: 30,
      warmupPoses: [intermediateMain[0]], // Start with downward dog
      mainPoses: intermediateMain,
      cooldownPoses: [intermediateMain[0]], // End with downward dog
    ),
    YogaSession(
      id: 'intermediate_2',
      title: 'Hatha Yoga - Core Focus',
      level: 'Intermediate',
      description: 'Emphasize core strengthening poses.',
      totalDurationMinutes: 20,
      warmupPoses: [intermediateMain[0]],
      mainPoses: [intermediateMain[1], intermediateMain[2], intermediateMain[3]],
      cooldownPoses: [intermediateMain[0]],
    ),
    YogaSession(
      id: 'intermediate_3',
      title: 'Hatha Yoga - Backbends',
      level: 'Intermediate',
      description: 'Focus on spine flexibility and chest opening.',
      totalDurationMinutes: 20,
      warmupPoses: [intermediateMain[0], intermediateMain[1]],
      mainPoses: [intermediateMain[2], intermediateMain[3], intermediateMain[4]],
      cooldownPoses: [intermediateMain[0]],
    ),
  ];

  static final List<YogaSession> advancedSessions = [
    YogaSession(
      id: 'advanced_1',
      title: 'Sun Salutation Flow',
      level: 'Advanced',
      description: 'Dynamic vinyasa flow. One breath, one movement. Builds stamina and focus.',
      totalDurationMinutes: 20,
      warmupPoses: [],
      mainPoses: advancedFlow,
      cooldownPoses: [],
    ),
    YogaSession(
      id: 'advanced_2',
      title: 'Extended Sun Salutation',
      level: 'Advanced',
      description: 'Longer practice with more rounds. Challenge yourself.',
      totalDurationMinutes: 30,
      warmupPoses: [],
      mainPoses: advancedFlow,
      cooldownPoses: [],
    ),
  ];
}
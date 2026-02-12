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
      nameKey: 'yogaHeadNeckShoulders',
      descriptionKey: 'yogaHeadNeckShouldersDesc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 180, // 3 minutes for complete sequence
      modifications: [
        'Move slowly and gently',
        'Stop if you feel dizzy or pain',
        'Keep shoulders relaxed and down',
        'Never force the stretch',
        'Breathe deeply throughout',
      ],
      instructions: '''Breathe in and tilt your head up, feel your neck being stretched. Hold the pose for 5 deep breaths. Then tilt your head down to bring your chin to the chest. Hold the pose for 5-10 deep breaths. Repeat 3 times.

Turn your head to the right so that your chin points to your right shoulder. Hold for 5 deep breaths. Turn your head to the left so that your chin points to your left shoulder. Hold for 5-10 deep breaths. Repeat 3 times.

Drop your right ear to your right shoulder without lifting your left shoulder. Use your right palm to hold down your head. Bend your left arm behind your back to increase the stretch sensation. Hold the pose for 5 deep breaths. Then drop your left ear to your left shoulder without lifting your right shoulder. Use your left palm to hold down your head. Bend your right arm to your back to increase the stretch sensation. Hold the pose for 5-10 deep breaths. Repeat 3 times.''',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_2',
      nameKey: 'yogaStraightArms',
      descriptionKey: 'yogaStraightArmsDesc',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 60,
      modifications: [
        'Keep movements smooth and controlled',
        'Do not bend elbows',
        'Stop if you feel shoulder pain',
        'Maintain steady breathing',
      ],
      instructions: 'Thumbs inside your fingers to make it into a fist, rotate your arms in one direction without bending your elbows. Repeat 10 times. Change direction. Repeat 10 times.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_3',
      nameKey: 'yogaBentArms',
      descriptionKey: 'yogaBentArmsDesc',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 60,
      modifications: [
        'Move at your own comfortable pace',
        'Keep shoulders down',
        'Don\'t force elbows to touch if uncomfortable',
        'Breathe normally throughout',
      ],
      instructions: 'Fingers on your shoulders, touch your elbows in front of your chest, then lift your elbows behind your head and touch your wrists behind your head. Roll your arms to the front and touch your elbows in front of your chest. Repeat 10 times. Change direction and repeat 10 times.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_4',
      nameKey: 'yogaShouldersLateral',
      descriptionKey: 'yogaShouldersLateralDesc',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep buttock firmly on chair',
        'Face forward throughout',
        'Don\'t lean too far if uncomfortable',
        'Engage core for stability',
      ],
      instructions: 'Lift your arms. Drop your right arm to hold on to the seat of the chair and stretch your left arm over your head. Feel the left side of your body being stretched. Facing the front. Ensure your left buttock does not lift away from the chair. Hold the pose for 5-10 breaths. Repeat 3 times. Do the same for the other direction.',
      category: 'warmup',
    ),
    YogaPose(
      id: 'beginner_warmup_5',
      nameKey: 'yogaShouldersTorsoTwist',
      descriptionKey: 'yogaShouldersTorsoTwistDesc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep hips stable and not moving',
        'Maintain level shoulders',
        'Don\'t force the twist',
        'Breathe deeply to enhance detox',
      ],
      instructions: 'Lift your arms and straighten them, turn your torso and shoulders to your right, hold onto the chair rest to twist deeper. Ensure your hips are not moving and your shoulders are level. Hold the pose for 5-10 breaths. Repeat 3 times. Do the same for the other direction.',
      category: 'warmup',
    ),
  ];

  // Beginner Main Poses (Sitting)
  static final List<YogaPose> beginnerMainSitting = [
    YogaPose(
      id: 'beginner_main_1',
      nameKey: 'yogaLegRaiseBent',
      descriptionKey: 'yogaLegRaiseBentDesc',
      imageUrl: 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?w=500',
      durationSeconds: 60,
      modifications: [
        'Use chair sides for support if needed',
        'Stick back to chair rest for support',
        'Progress gradually to no hand support',
        'Keep back straight throughout',
      ],
      instructions: 'Lift right leg high without using hand support while ensuring your back remains straight. Stick your back to the chair rest for support if you cannot have your back straight. Once the leg is up, hold the pose for as long as you can, then release the leg with control. Do the same with the left leg. Progress into leg raise without hand support.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_main_2',
      nameKey: 'yogaLegRaiseStraight',
      descriptionKey: 'yogaLegRaiseStraightDesc',
      imageUrl: 'https://images.unsplash.com/photo-1599447292326-e6daae7ae9cb?w=500',
      durationSeconds: 60,
      modifications: [
        'Hold chair sides initially if needed',
        'Keep back straight and supported',
        'Release leg slowly with control',
        'Don\'t lock knee joint',
      ],
      instructions: 'Lift right leg and straighten it without using hand support while ensuring your back remains straight. Stick your back to the chair rest for support if you cannot have your back straight. Once the leg is up, hold the pose for as long as you can, then release the leg with control. Do the same with the left leg.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_main_3',
      nameKey: 'yogaGoddess',
      descriptionKey: 'yogaGoddessDesc',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500',
      durationSeconds: 90,
      modifications: [
        'Ensure toes point same direction as knees',
        'Keep knees aligned with toes',
        'Don\'t strain if flexibility is limited',
        'Engage core for stability',
      ],
      instructions: 'Widen the knees to the sides, ensure your toes point in the same direction as your knees. Place your palms on your respective thighs and stretch your torso to your right by straightening your left arm. Feel the left side of your body being stretched. Hold the pose for 5-10 breaths. Repeat the same for the other side.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_main_4',
      nameKey: 'yogaGoddessLeg',
      descriptionKey: 'yogaGoddessLegDesc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 60,
      modifications: [
        'Toes and knees aligned',
        'Keep upper body perpendicular',
        'Use leg strength, not momentum',
        'Lower down if balance is difficult',
      ],
      instructions: 'Widen the knees to the sides, ensure your toes point in the same direction as your knees. Lift your thighs away from the chair, use your leg strength to support the pose and ensure your upper body is perpendicular to the ground. Hold the pose for 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
  ];

  // Beginner Main Poses (Standing)
  static final List<YogaPose> beginnerMainStanding = [
    YogaPose(
      id: 'beginner_standing_1',
      nameKey: 'yogaBackChestStretch',
      descriptionKey: 'yogaBackChestStretchDesc',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep arms and legs straight',
        'Hips stack over feet',
        'Engage abdomen',
        'Use chair for stable support',
      ],
      instructions: 'Face the chair rest. Hold on to the top of the chair rest. Stand with feet hip-width apart in front of the chair. Upper body is parallel with the ground. The hips should stack over your feet so that your body forms a horizontal "L" shape. Ensure your arms and legs are straight. Keep your abdomen in. Feel the stretch in your arms, back and legs. Hold the pose for 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_2',
      nameKey: 'yogaStandingCrunch',
      descriptionKey: 'yogaStandingCrunchDesc',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep chair stable',
        'Control the movement',
        'Engage core throughout',
        'Coordinate breath with movement',
      ],
      instructions: 'Face the chair rest. Hold on to the top of the chair rest. Stand with feet together. Upper body is parallel with the ground. The hips should stack over your feet so that your body forms a horizontal "L" shape. Ensure your arms and legs are straight. Keep your abdomen in. Straighten your right leg back with every inhalation, crunch your right knee to your chest with exhalation. Repeat 5-10 times. Repeat the same with your left leg.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_3',
      nameKey: 'yogaWarrior3',
      descriptionKey: 'yogaWarrior3Desc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep chair for balance',
        'Engage core for stability',
        'Don\'t lock standing knee',
        'Progress gradually to one hand',
      ],
      instructions: 'Face the chair rest. Hold on to the top of the chair rest. Stand with feet together. Upper body is parallel with the ground. The hips should stack over your feet so that your body forms a horizontal "L" shape. Lift one hand off the chair rest. Hold the pose for 5-10 breaths. Release the hand. Repeat with the other hand. Release the hand and leg. Change to the other leg and do the same.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_4',
      nameKey: 'yogaWarrior1',
      descriptionKey: 'yogaWarrior1Desc',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: [
        'Square hips forward',
        'Tuck tailbone',
        'Don\'t arch lower back',
        'Modify arms if shoulders tight',
      ],
      instructions: 'Sit across the chair so that your right leg is bent, your left leg is straight. Right toes point to 12 o\'clock while left toes point to 11 o\'clock. Square your hips. Tuck your tailbone. Arms up and straighten them. Look at your palms. Stretch your spine from your tailbone. Hold the pose for 5-10 breaths. Repeat 3 times. Change legs and change direction.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_5',
      nameKey: 'yogaWarrior2',
      descriptionKey: 'yogaWarrior2Desc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: [
        'Align knee with toes',
        'Keep tailbone tucked',
        'Don\'t lean forward',
        'Engage legs equally',
      ],
      instructions: 'From Warrior 1, turn your left toes to 3 o\'clock while maintaining your right toes pointing to 12 o\'clock. Ensure your right knee and toes are aligned. Keep your tailbone tucked. Look at your right hand. Hold for 5-10 breaths.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_6',
      nameKey: 'yogaTriangle',
      descriptionKey: 'yogaTriangleDesc',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep both legs straight',
        'Hips stay forward',
        'Use block if needed for bottom hand',
        'Don\'t force the stretch',
      ],
      instructions: 'From Warrior 2 pose, straighten the bent right leg, stretch both arms to the right, lower your right palm along your right ankle, left arm stretch up, hips forward, look to your top palm. Hold the pose for 5-10 breaths. Change side.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_7',
      nameKey: 'yogaReverseWarrior2',
      descriptionKey: 'yogaReverseWarrior2Desc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep bent knee stable',
        'Don\'t collapse into side body',
        'Engage core',
        'Choose comfortable gaze direction',
      ],
      instructions: 'From Warrior 2 pose, reverse your warrior 2 by stretching your right arm over head with your palm facing down. Your left arm stretches along your left leg. Either look to your right hand or your left hand. Hold the pose for 5-10 breaths.',
      category: 'main',
    ),
    YogaPose(
      id: 'beginner_standing_8',
      nameKey: 'yogaSideAngle',
      descriptionKey: 'yogaSideAngleDesc',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: [
        'Use block for bottom hand if needed',
        'Keep tailbone tucked',
        'Don\'t let knee collapse inward',
        'Engage both legs',
      ],
      instructions: 'From Warrior 2 pose, lower your palm inside your right foot. Use a block to raise your palm if the pose becomes inaccessible. Stretch your left arm over your head with palm facing down. Look up at your left hand. Ensure your tailbone is tucked. Hold the pose for 5-10 breaths. Change side.',
      category: 'main',
    ),
  ];

  // Beginner Cooldown
  static final List<YogaPose> beginnerCooldown = [
    YogaPose(
      id: 'beginner_cooldown_1',
      nameKey: 'yogaSeatedForwardFold',
      descriptionKey: 'yogaSeatedForwardFoldDesc',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 120,
      modifications: [
        'Sit on edge of chair if needed',
        'Bend knees slightly if hamstrings tight',
        'Don\'t force the stretch',
        'Relax shoulders and neck',
      ],
      instructions: 'Sit on chair, feet flat. Hinge at hips, fold forward over legs. Let arms hang or rest on thighs. Breathe deeply. Feel the stretch in back and hamstrings. Hold 5-10 breaths.',
      category: 'cooldown',
    ),
    YogaPose(
      id: 'beginner_cooldown_2',
      nameKey: 'yogaSeatedTwist',
      descriptionKey: 'yogaSeatedTwistDesc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: [
        'Keep spine long',
        'Don\'t force twist',
        'Breathe into the twist',
        'Release slowly',
      ],
      instructions: 'Sit tall, feet grounded. Twist torso to right, left hand on right knee, right hand behind you. Breathe deeply. Hold 5-10 breaths. Return to center slowly. Repeat other side.',
      category: 'cooldown',
    ),
  ];

  // ============================================================================
  // INTERMEDIATE LEVEL - HATHA YOGA (ON MAT)
  // ============================================================================

  static final List<YogaPose> intermediateWarmup = [
    YogaPose(
      id: 'intermediate_warmup_1',
      nameKey: 'yogaCatCow',
      descriptionKey: 'yogaCatCowDesc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 90,
      modifications: [
        'Move with breath',
        'Keep wrists under shoulders',
        'Don\'t force the arch',
        'Engage core gently',
      ],
      instructions: 'Start on hands and knees. Inhale, arch back, look up (cow). Exhale, round spine, tuck chin (cat). Flow between poses with breath. Repeat 10 times.',
      category: 'warmup',
    ),
  ];

  static final List<YogaPose> intermediateMain = [
    YogaPose(
      id: 'intermediate_main_1',
      nameKey: 'yogaDownwardDog',
      descriptionKey: 'yogaDownwardDogDesc',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 90,
      modifications: [
        'Fingers spread like spider web',
        'Press fingertips down firmly',
        'Heels don\'t need to touch ground',
        'Bend knees if hamstrings tight',
      ],
      instructions: 'Feet hips width apart. Hands shoulder width apart. Push the hips back. The pose looks like an inverted "V". Elongate the outer sides of the arms until you feel some suction in your core or belly area. Hold the pose for 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_main_2',
      nameKey: 'yogaPlank',
      descriptionKey: 'yogaPlankDesc',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 60,
      modifications: [
        'Hands under shoulders',
        'Legs hug together',
        'Engage core strongly',
        'Don\'t let hips sag or pike up',
      ],
      instructions: 'Hands shoulder width apart and under your shoulder sockets. Feet hips width apart and on your toes but feel your legs hugging together. From the head to the feet should form a slanting straight line. Ensure your core is tight by sucking your belly inwards. Hold the pose for 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_main_3',
      nameKey: 'yoga8Point',
      descriptionKey: 'yoga8PointDesc',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500',
      durationSeconds: 60,
      modifications: [
        'Lower with control',
        'Keep belly lifted',
        'Elbows stay close to body',
        'Use knees if too challenging',
      ],
      instructions: 'From a lowered knees tabletop pose, shift your torso forward and lower your chest to the mat with control. Your chin, chest, palms, knees and toes are grounded while your belly is lifted. Shoulders press towards your torso and suck in your core. Squeeze your elbows to your torso. Hold the pose for 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_main_4',
      nameKey: 'yogaBabyCobra',
      descriptionKey: 'yogaBalbyCobraDesc',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 60,
      modifications: [
        'Keep toes pointed',
        'Press lower body into ground',
        'Shoulders stay down',
        'Don\'t strain neck',
      ],
      instructions: 'From Eight-point pose, shift forward so that your whole body except your chest is grounded. Your toes should be pointed. Press your lower body and feet into the ground to further lift your chest. Hold the pose for 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
    YogaPose(
      id: 'intermediate_main_5',
      nameKey: 'yogaFullCobra',
      descriptionKey: 'yogaFullCobraDesc',
      imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=500',
      durationSeconds: 60,
      modifications: [
        'Keep shoulders down',
        'Chest lifts up and forward',
        'Don\'t lock elbows completely',
        'Engage legs',
      ],
      instructions: 'From baby cobra, push up and straighten your elbows to a full cobra. Keep your shoulders down and chest up. Hold the pose for 5-10 breaths. Repeat 3 times.',
      category: 'main',
    ),
  ];

  static final List<YogaPose> intermediateCooldown = [
    YogaPose(
      id: 'intermediate_cooldown_1',
      nameKey: 'yogaChildsPose',
      descriptionKey: 'yogaChildsPoseDesc',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500',
      durationSeconds: 120,
      modifications: [
        'Knees can be wide or together',
        'Forehead rests on mat',
        'Arms can extend or rest by sides',
        'Breathe deeply and relax',
      ],
      instructions: 'From hands and knees, sit hips back to heels. Extend arms forward or rest by sides. Forehead on mat. Breathe deeply. Rest and restore. Hold as long as needed.',
      category: 'cooldown',
    ),
  ];

  // ============================================================================
  // ADVANCED LEVEL - SUN SALUTATION FLOW
  // ============================================================================

  static final List<YogaPose> advancedMain = [
    YogaPose(
      id: 'advanced_main_1',
      nameKey: 'yogaSunSalutation',
      descriptionKey: 'yogaSunSalutationDesc',
      imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500',
      durationSeconds: 300, // 5 minutes for full flow
      modifications: [
        'One breath, one movement',
        'Move with control',
        'Take breaks as needed',
        'Modify any pose as required',
      ],
      instructions: 'Combine the 5 poses from the intermediate level in this app into a flow sequence. Move from downward dog to plank, to 8-point pose, baby cobra, full cobra and downward dog. Ensure one breath, one movement. Repeat 5 to 10 rounds, or to your ability.',
      category: 'main',
    ),
  ];

  // ============================================================================
  // SESSIONS
  // ============================================================================

  static final List<YogaSession> beginnerSessions = [
    YogaSession(
      id: 'beginner_session_1',
      titleKey: 'yogaBeginnerSession1',
      levelKey: 'beginner',
      descriptionKey: 'yogaBeginnerSession1Desc',
      totalDurationMinutes: 15,
      warmupPoses: [
        beginnerWarmup[0], // Head, Neck and Shoulders
        beginnerWarmup[1], // Straight Arms Rotation
      ],
      mainPoses: [
        beginnerMainSitting[0], // Leg Raise Bent
        beginnerMainSitting[1], // Leg Raise Straight
      ],
      cooldownPoses: [
        beginnerCooldown[0], // Seated Forward Fold
      ],
    ),
    YogaSession(
      id: 'beginner_session_2',
      titleKey: 'yogaBeginnerSession2',
      levelKey: 'beginner',
      descriptionKey: 'yogaBeginnerSession2Desc',
      totalDurationMinutes: 20,
      warmupPoses: [
        beginnerWarmup[2], // Bent Arm Rotation
        beginnerWarmup[3], // Shoulders Lateral Stretch
        beginnerWarmup[4], // Shoulders and Torso Twist
      ],
      mainPoses: [
        beginnerMainSitting[2], // Goddess Pose Torso Twist
        beginnerMainSitting[3], // Goddess Pose Leg
        beginnerMainStanding[0], // Back and Chest Stretch
      ],
      cooldownPoses: [
        beginnerCooldown[1], // Seated Twist
      ],
    ),
    YogaSession(
      id: 'beginner_session_3',
      titleKey: 'yogaBeginnerSession3',
      levelKey: 'beginner',
      descriptionKey: 'yogaBeginnerSession3Desc',
      totalDurationMinutes: 25,
      warmupPoses: beginnerWarmup.take(3).toList(),
      mainPoses: [
        beginnerMainStanding[1], // Standing Crunch
        beginnerMainStanding[2], // Warrior 3
        beginnerMainStanding[3], // Warrior 1
        beginnerMainStanding[4], // Warrior 2
      ],
      cooldownPoses: beginnerCooldown,
    ),
  ];

  static final List<YogaSession> intermediateSessions = [
    YogaSession(
      id: 'intermediate_session_1',
      titleKey: 'yogaIntermediateSession1',
      levelKey: 'intermediate',
      descriptionKey: 'yogaIntermediateSession1Desc',
      totalDurationMinutes: 20,
      warmupPoses: [intermediateWarmup[0]],
      mainPoses: [
        intermediateMain[0], // Downward Dog
        intermediateMain[1], // Plank
        intermediateMain[2], // 8-Point
      ],
      cooldownPoses: [intermediateCooldown[0]],
    ),
    YogaSession(
      id: 'intermediate_session_2',
      titleKey: 'yogaIntermediateSession2',
      levelKey: 'intermediate',
      descriptionKey: 'yogaIntermediateSession2Desc',
      totalDurationMinutes: 25,
      warmupPoses: [intermediateWarmup[0]],
      mainPoses: intermediateMain,
      cooldownPoses: [intermediateCooldown[0]],
    ),
  ];

  static final List<YogaSession> advancedSessions = [
    YogaSession(
      id: 'advanced_session_1',
      titleKey: 'yogaAdvancedSession1',
      levelKey: 'advanced',
      descriptionKey: 'yogaAdvancedSession1Desc',
      totalDurationMinutes: 30,
      warmupPoses: [intermediateWarmup[0]],
      mainPoses: [advancedMain[0]],
      cooldownPoses: [intermediateCooldown[0]],
    ),
  ];
}
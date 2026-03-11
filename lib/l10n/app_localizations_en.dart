// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get registerTitle => 'Begin Your Wellness Journey';

  @override
  String get registerSubtitle => 'Create your account to get started';

  @override
  String get stepPersonal => 'Personal';

  @override
  String get stepPreferences => 'Preferences';

  @override
  String get stepAccount => 'Account';

  @override
  String get getToknowYou => '👋 Let\'s Get to Know You';

  @override
  String get tellUsAbout => 'Tell us a bit about yourself';

  @override
  String get yourPreferences => '⚙️ Your Preferences';

  @override
  String get customizeYoga => 'Customize your yoga experience';

  @override
  String get secureAccount => '🔐 Secure Your Account';

  @override
  String get createCredentials => 'Create your login credentials';

  @override
  String get passwordReqTitle => 'Password Requirements:';

  @override
  String get reqLength => 'At least 8 characters';

  @override
  String get reqUpper => '1 uppercase letter (A-Z)';

  @override
  String get reqLower => '1 lowercase letter (a-z)';

  @override
  String get reqNumber => '1 number (0-9)';

  @override
  String get reqSpecial => '1 special character (!@#\$%...)';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get back => 'Back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get ageHint => 'Enter your age';

  @override
  String get emailHint => 'your.email@example.com';

  @override
  String get passwordHint =>
      'Min 8 chars: 1 uppercase, 1 lowercase, 1 number, 1 special char';

  @override
  String get errEmailEmpty => 'Please enter your email';

  @override
  String get errEmailInvalid => 'Please enter a valid email address';

  @override
  String get errPasswordEmpty => 'Please enter a password';

  @override
  String get errNameEmpty => 'Please enter your full name';

  @override
  String get errAgeEmpty => 'Please enter a valid age (numbers only)';

  @override
  String get errAgeRange => 'Please enter a valid age between 1 and 120';

  @override
  String get checkEmailMsg => 'Please check your email to confirm your account';

  @override
  String welcomeName(String name) {
    return 'Welcome, $name! 🌿';
  }

  @override
  String get completeProfileTitle => 'Complete Your Profile 🌸';

  @override
  String get completeProfileSubtitle =>
      'Just a few quick details to personalize your yoga journey.';

  @override
  String get preferredLanguage => 'Preferred Language';

  @override
  String get enterValidAge => 'Please enter a valid age';

  @override
  String get profileCompleted => 'Profile completed 🌿';

  @override
  String saveProfileFailed(String error) {
    return 'Failed to save profile: $error';
  }

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get continueButton => 'Continue';

  @override
  String get under18 => 'Under 18';

  @override
  String ageRange(int start, int end) {
    return '$start-$end years';
  }

  @override
  String get welcomeBack => 'Welcome Back 🧘‍♀️';

  @override
  String get loginSubtitle => 'Log in to continue your healing journey.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get logIn => 'Log In';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get fillRequiredFields => 'Please fill in all required fields';

  @override
  String get loginSuccess => 'Welcome back 🌿';

  @override
  String loginFailed(String error) {
    return 'Login failed: $error';
  }

  @override
  String googleSignInFailed(String error) {
    return 'Google Sign-In failed: $error';
  }

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordTitle => 'Reset Your Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email and we\'ll send you a reset link';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Password reset link sent! Check your email 📧';

  @override
  String resetLinkFailed(String error) {
    return 'Failed to send reset link: $error';
  }

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get invalidCredentials =>
      'Invalid email or password. Please try again.';

  @override
  String get emailNotVerified =>
      'Please verify your email before logging in. Check your inbox.';

  @override
  String get accountNotFound =>
      'No account found with this email. Please register first.';

  @override
  String get tooManyAttempts =>
      'Too many login attempts. Please try again later.';

  @override
  String get networkError =>
      'Network error. Please check your connection and try again.';

  @override
  String get unknownError => 'An unexpected error occurred. Please try again.';

  @override
  String get emailAlreadyExists =>
      'This email is already registered. Please log in instead.';

  @override
  String get weakPassword =>
      'Password is too weak. Please follow the requirements.';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get onboardingHeading => 'Feel stronger';

  @override
  String get onboardingDesc =>
      'Learn from the world\'s best yoga\ncoaches anytime at home or on\nthe go.';

  @override
  String get letsExplore => 'Let\'s explore';

  @override
  String get navHome => 'Home';

  @override
  String get navSessions => 'Sessions';

  @override
  String get navProgress => 'Progress';

  @override
  String get navMeditation => 'Meditation';

  @override
  String get navProfile => 'Profile';

  @override
  String get appTagline => 'Find Your Inner Peace';

  @override
  String get goodMorning => 'Good Morning!';

  @override
  String get goodAfternoon => 'Good Afternoon!';

  @override
  String get goodEvening => 'Good Evening!';

  @override
  String get friend => 'Friend';

  @override
  String get findYourPeace => 'Find Your Peace';

  @override
  String get calmingSounds => 'Calming sounds for your wellness';

  @override
  String get listenNow => 'Listen Now';

  @override
  String get yogaSubtitle =>
      'Perfect for those just starting their yoga journey';

  @override
  String get joinNow => 'Join Now';

  @override
  String get wellnessOverview => 'Wellness Overview';

  @override
  String get haveANiceDay => 'Have a nice day!';

  @override
  String get selectDate => 'Select Date';

  @override
  String get todaysPractice => 'Today\'s Practice';

  @override
  String get recommendedForYou => 'Recommended for you';

  @override
  String get seeAll => 'See All';

  @override
  String get ambient => 'Ambient';

  @override
  String get streak => 'Streak';

  @override
  String get sessions => 'Sessions';

  @override
  String get weekly => 'Weekly';

  @override
  String get totalTime => 'Total Time';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String minutesCount(int count) {
    return '$count min';
  }

  @override
  String get beginYour => 'Begin Your';

  @override
  String get wellnessJourney => 'Wellness Journey';

  @override
  String get beginnerSubtitle => 'Chair Yoga';

  @override
  String get beginnerDesc =>
      'Perfect for those just starting their yoga journey';

  @override
  String get intermediateSubtitle => 'Hatha yoga on the mat';

  @override
  String get intermediateDesc => 'Build strength with challenging sequences';

  @override
  String get advancedSubtitle => 'Dynamic sun salutation flow';

  @override
  String get advancedDesc => 'Challenge yourself with flowing sequences';

  @override
  String lockedLevelTitle(String levelName) {
    return '$levelName Locked';
  }

  @override
  String completeSessionsToUnlock(int count) {
    return 'Complete $count more sessions to unlock';
  }

  @override
  String get unlockIntermediateFirst => 'Unlock Intermediate first';

  @override
  String sessionsProgress(int current, int required) {
    return '$current / $required sessions';
  }

  @override
  String sessionsCompletedCount(int count) {
    return '$count sessions completed';
  }

  @override
  String get errorLoadingProgress => 'Error loading progress';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get enterPasscodeHint => 'Admin Passcode 🔐';

  @override
  String get moreInfo => 'More Info';

  @override
  String get enterPinCode => 'Enter PIN Code';

  @override
  String get pinInstructions => 'Enter 4-digit code to watch videos';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get backdoorAccess => 'Backdoor Access';

  @override
  String get backdoorAdminMsg =>
      'You have admin access to change the video PIN.';

  @override
  String get backdoorPathInstructions =>
      'Go to Profile > Settings to change the PIN code.';

  @override
  String get beginnerTitle => 'Beginner Sessions';

  @override
  String get warmup => 'Warm-up';

  @override
  String get mainPractice => 'Main Practice';

  @override
  String get cooldown => 'Cool-down';

  @override
  String get viewDetails => 'View Details';

  @override
  String poseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poses',
      one: '1 pose',
    );
    return '$_temp0';
  }

  @override
  String sessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions completed',
      one: '1 session completed',
    );
    return '$_temp0';
  }

  @override
  String get intermediateTitle => 'Intermediate Sessions';

  @override
  String get hathaPractice => 'Hatha Practice';

  @override
  String get startSession => 'Start Session';

  @override
  String get advancedTitle => 'Advanced Sessions';

  @override
  String get dynamicFlowNotice =>
      'Dynamic flow practice. Move with your breath.';

  @override
  String get advancedLabel => 'ADVANCED';

  @override
  String get highIntensity => 'High intensity';

  @override
  String get sunSalutationTitle => 'Sun Salutation Flow';

  @override
  String get repeatRounds => 'Repeat 5-10 rounds • One breath, one movement';

  @override
  String get beginFlow => 'Begin Flow';

  @override
  String get step1 => '1. Downward Dog';

  @override
  String get step2 => '2. Plank';

  @override
  String get step3 => '3. Eight-Point Pose';

  @override
  String get step4 => '4. Baby Cobra';

  @override
  String get step5 => '5. Full Cobra';

  @override
  String get step6 => '6. Return to Downward Dog';

  @override
  String get yogaHeadNeckShoulders => 'Head, Neck and Shoulders Stretch';

  @override
  String get yogaStraightArms => 'Straight Arms Rotation';

  @override
  String get yogaBentArms => 'Bent Arm Rotation';

  @override
  String get yogaShouldersLateral => 'Shoulders Lateral Stretch';

  @override
  String get yogaShouldersTorsoTwist => 'Shoulders & Torso Twist';

  @override
  String get yogaLegRaiseBent => 'Leg Raise (Bent)';

  @override
  String get yogaLegRaiseStraight => 'Leg Raise (Straight)';

  @override
  String get yogaGoddessTwist => 'Goddess Pose — Torso Twist';

  @override
  String get yogaGoddessStrength => 'Goddess Pose — Leg Strengthening';

  @override
  String get yogaBackChestStretch => 'Back and Chest Stretch';

  @override
  String get yogaStandingCrunch => 'Standing Crunch';

  @override
  String get yogaWarrior3Supported => 'Warrior 3 (Supported)';

  @override
  String get yogaWarrior1Supported => 'Warrior 1 (Supported)';

  @override
  String get yogaWarrior2Supported => 'Warrior 2 (Supported)';

  @override
  String get yogaTriangleSupported => 'Triangle Pose (Supported)';

  @override
  String get yogaReverseWarrior2 => 'Reverse Warrior 2';

  @override
  String get yogaSideAngleSupported => 'Side Angle Pose (Supported)';

  @override
  String get yogaGentleBreathing => 'Gentle Breathing';

  @override
  String get yogaDownwardDog => 'Downward Dog';

  @override
  String get yogaPlank => 'Plank Pose';

  @override
  String get yogaEightPoint => 'Eight-Point Pose (Ashtangasana)';

  @override
  String get yogaBabyCobra => 'Baby Cobra';

  @override
  String get yogaFullCobra => 'Full Cobra Pose';

  @override
  String get yogaSunSalutation => 'Sun Salutation Flow';

  @override
  String get yogaSessionGentleChair => 'Gentle Chair Yoga';

  @override
  String get yogaSessionMorningMobility => 'Morning Mobility';

  @override
  String get yogaSessionWarriorSeries => 'Warrior Series';

  @override
  String get yogaSessionHathaFundamentals => 'Hatha Fundamentals';

  @override
  String get yogaSessionCoreStrength => 'Core Strength Builder';

  @override
  String get yogaSessionBackbendFlow => 'Backbend Flow';

  @override
  String get yogaSessionSunSalutation => 'Sun Salutation Flow';

  @override
  String get yogaSessionExtendedFlow => 'Extended Flow Practice';

  @override
  String get yogaDescHeadNeck =>
      'Gentle seated stretches releasing neck and shoulder tension.';

  @override
  String get yogaDescGentleChair =>
      'Make sure the chair is stable by placing it against a wall. Beginner’s level of Chair yoga is suitable for most people. Yoga should be practised with an empty or relatively empty stomach, or at least 2 hours after a meal.';

  @override
  String get yogaDescMorningMobility =>
      'A light morning routine focusing on joint mobility, breathing, and supported strength work.';

  @override
  String get yogaDescWarriorSeries =>
      'A confidence-building sequence exploring Warrior I, II, and supporting transitions.';

  @override
  String get yogaDescHathaFundamentals =>
      'A classic mat-based Hatha sequence focusing on alignment, breath, and full-body engagement. Ideal for practitioners ready to move beyond chair support.';

  @override
  String get yogaDescCoreStrength =>
      'A short but powerful session focusing on Plank, Eight-Point Pose, and controlled transitions. Boosts core strength and shoulder stability.';

  @override
  String get yogaDescBackbendFlow =>
      'A spine-strengthening sequence moving from Eight-Point Pose into Baby Cobra and Full Cobra. Builds confidence in backbending.';

  @override
  String get yogaDescSunSalutationSession =>
      'A dynamic mat-based flow designed to synchronise breath and movement. This session builds endurance and full-body strength through repeated Sun Salutation cycles.';

  @override
  String get yogaDescExtendedFlow =>
      'A deeper and longer Sun Salutation practice — ideal for experienced practitioners wanting a continuous challenge with breath-led movement.';

  @override
  String get yogaDescStraightArms =>
      'Arm rotations to warm up shoulders and upper back.';

  @override
  String get yogaDescBentArms => 'Shoulder mobility exercise with bent elbows.';

  @override
  String get yogaDescShouldersLateral =>
      'Side-body stretch improving flexibility.';

  @override
  String get yogaDescShouldersTorsoTwist => 'A gentle detoxifying twist.';

  @override
  String get yogaDescLegRaiseBent => 'Strengthen legs and activate core.';

  @override
  String get yogaDescLegRaiseStraight =>
      'Straight-leg lift for advanced strength.';

  @override
  String get yogaDescGoddessTwist => 'Wide-leg seated pose for mobility.';

  @override
  String get yogaDescGoddessStrength =>
      'Strengthening variation of seated Goddess.';

  @override
  String get yogaDescBackChestStretch =>
      'L-shape stretch improving upper-body flexibility.';

  @override
  String get yogaDescStandingCrunch => 'Dynamic core-strengthening movement.';

  @override
  String get yogaDescWarrior3Supported =>
      'Balance and strength with chair support.';

  @override
  String get yogaDescWarrior1Supported => 'Beginner-friendly Warrior stance.';

  @override
  String get yogaDescWarrior2Supported =>
      'Side-facing warrior for hip opening.';

  @override
  String get yogaDescTriangleSupported => 'Deep side-body extension.';

  @override
  String get yogaDescReverseWarrior2 => 'Back-arching warrior stretch.';

  @override
  String get yogaDescSideAngleSupported => 'Strengthens legs and opens ribs.';

  @override
  String get yogaDescGentleBreathing =>
      'Full-body relaxation and calm breathing.';

  @override
  String get yogaDescDownwardDog =>
      'A foundational inverted V pose that stretches the full body.';

  @override
  String get yogaDescPlank =>
      'Full-body strength builder engaging core, arms, and legs.';

  @override
  String get yogaDescEightPoint =>
      'Strength-building pose lowering chest, chin, knees and toes.';

  @override
  String get yogaDescBabyCobra =>
      'Gentle backbend strengthening upper back and spine.';

  @override
  String get yogaDescFullCobra =>
      'A stronger chest-opening backbend engaging the whole body.';

  @override
  String get yogaDescSunSalutation =>
      'A dynamic sequence linking breath and movement. Builds strength, heat, coordination, and stamina.';

  @override
  String get yogaInstHeadNeck =>
      'Tilt head up/down for 5–10 breaths each. Turn head right/left 3 rounds. Drop ear to shoulder with light hand support.';

  @override
  String get yogaInstStraightArms =>
      'Make fists, rotate straight arms 10 times forward and 10 times backward.';

  @override
  String get yogaInstBentArms =>
      'Touch elbows in front, circle up behind head and back down. 10 rounds each direction.';

  @override
  String get yogaInstShouldersLateral =>
      'Drop right hand to chair, lift left arm overhead. Hold 5–10 breaths. Switch sides.';

  @override
  String get yogaInstShouldersTorsoTwist =>
      'Lift arms, rotate torso right, hold chair for support. Hold 5–10 breaths each side.';

  @override
  String get yogaInstLegRaiseBent =>
      'Lift bent leg with back straight. Hold, lower with control. Switch legs.';

  @override
  String get yogaInstLegRaiseStraight =>
      'Lift straightened leg, hold as long as possible. Release and switch legs.';

  @override
  String get yogaInstGoddessTwist =>
      'Open knees wide, stretch torso to side. Hold 5–10 breaths, switch side.';

  @override
  String get yogaInstGoddessStrength =>
      'Lift thighs off chair while in Goddess stance. Hold 5–10 breaths. Repeat.';

  @override
  String get yogaInstBackChestStretch =>
      'Hold chair, hinge into L-shape, keep back flat. Hold 5–10 breaths.';

  @override
  String get yogaInstStandingCrunch =>
      'From L-shape, extend leg back on inhale, crunch knee forward on exhale. Repeat.';

  @override
  String get yogaInstWarrior3 =>
      'Lift hand off chair, hold balance. Switch legs and repeat.';

  @override
  String get yogaInstWarrior1 =>
      'Step back, bend front knee, raise arms. Hold 5–10 breaths.';

  @override
  String get yogaInstWarrior2 =>
      'Turn toes outward, stretch arms, look forward. Hold.';

  @override
  String get yogaInstTriangle =>
      'Straighten front leg, lower hand to ankle or block, reach upward.';

  @override
  String get yogaInstReverseWarrior =>
      'Sweep top arm overhead while leaning back. Hold.';

  @override
  String get yogaInstSideAngle =>
      'Lower hand inside foot, stretch upper arm diagonally overhead.';

  @override
  String get yogaInstGentleBreathing =>
      'Relax shoulders, place hands on lap, breathe slowly through the nose.';

  @override
  String get yogaInstDownwardDog =>
      'Place hands shoulder-width apart, feet hip-width apart. Lift hips high, press chest towards thighs. Hold 5–10 breaths.';

  @override
  String get yogaInstPlank =>
      'Stack shoulders over wrists, engage core, lengthen from head to heels. Hold 5–10 breaths.';

  @override
  String get yogaInstEightPoint =>
      'From tabletop, lower chest and chin to mat while hips stay lifted. Hold 5–10 breaths.';

  @override
  String get yogaInstBabyCobra =>
      'From prone, press chest up lightly, keep elbows close and shoulders away from ears. Hold 5–10 breaths.';

  @override
  String get yogaInstFullCobra =>
      'Straighten elbows, lift chest higher without scrunching shoulders. Hold 5–10 breaths.';

  @override
  String get yogaInstGentleBreathingIntermediate =>
      'Place hands on belly or lap, relax shoulders, breathe through the nose slowly and naturally.';

  @override
  String get yogaInstSunSalutation =>
      'This flowing sequence repeats continuously — one breath per movement.\n 1. Inhale — Downward Dog\n Lift hips high, lengthen spine.\n 2. Exhale — Plank\n Shift forward into strong plank position.\n 3. Inhale — Knees-Chest-Chin (Eight-Point Pose)\n Lower down with control, hips lifted.\n 4. Exhale — Baby Cobra\n Lift chest gently, elbows close.\n 5. Inhale — Full Cobra\n Straighten arms slightly, open chest.\n 6. Exhale — Return to Downward Dog\n Press back into inverted V-shape.\n Repeat for 5–10 rounds or to your ability level.';

  @override
  String get yogaGentleBreathingAdvanced =>
      'Breathe softly through the nose, lengthening exhales. Allow the entire body to settle and cool down.';

  @override
  String get yogaModMoveSlowly => 'Move slowly';

  @override
  String get yogaModStopDizzy => 'Stop if dizzy';

  @override
  String get yogaModChairSupport => 'Use chair back for support';

  @override
  String get yogaModElbowsStraight => 'Keep elbows straight';

  @override
  String get yogaModControlledMove => 'Smooth controlled movement';

  @override
  String get yogaModFingersShoulders => 'Keep fingers on shoulders';

  @override
  String get yogaModSlowRolls => 'Slow controlled rolls';

  @override
  String get yogaModButtocksDown => 'Keep buttocks down';

  @override
  String get yogaModFaceForward => 'Face forward';

  @override
  String get yogaModHipsStable => 'Keep hips stable';

  @override
  String get yogaModShouldersLevel => 'Keep shoulders level';

  @override
  String get yogaModBackStraight => 'Keep back straight';

  @override
  String get yogaModBeginBent => 'Begin with bent-knee version';

  @override
  String get yogaModUseChairForSupport => 'Use chair for support';

  @override
  String get yogaModKneesToes => 'Align knees with toes';

  @override
  String get yogaModHipsGrounded => 'Keep hips grounded';

  @override
  String get yogaModTorsoUpright => 'Keep torso upright';

  @override
  String get yogaModChairBalance => 'Use chair for balance';

  @override
  String get yogaModArmsLegsStraight => 'Keep arms and legs straight';

  @override
  String get yogaModEngageCore => 'Engage core';

  @override
  String get yogaModAvoidPregnancy => 'Avoid during pregnancy';

  @override
  String get yogaModOneHandChair => 'Keep one hand on chair';

  @override
  String get yogaModStraightLine => 'Maintain a straight line';

  @override
  String get yogaModShortenStance => 'Shorten stance';

  @override
  String get yogaModSquareHips => 'Square hips';

  @override
  String get yogaModLevelShoulders => 'Level shoulders';

  @override
  String get yogaModUseBlock => 'Use block';

  @override
  String get yogaModHipsForward => 'Keep hips forward';

  @override
  String get yogaModFrontKneeBent => 'Keep front knee bent';

  @override
  String get yogaModGazeDirection => 'Choose gaze direction';

  @override
  String get yogaModTuckTailbone => 'Tuck tailbone slightly';

  @override
  String get yogaModSitOrLieDown => 'Sit or lie down';

  @override
  String get yogaModCloseEyesIfComfortable => 'Close eyes if comfortable';

  @override
  String get yogaModBendKnees => 'Bend knees if hamstrings are tight';

  @override
  String get yogaModHeelsLifted => 'Practice with heels lifted';

  @override
  String get yogaModLowerKnees => 'Lower knees for a gentler version';

  @override
  String get yogaModFeetTogether => 'Feet together for added challenge';

  @override
  String get yogaModSlowControl =>
      'Lower with slow control to protect shoulders';

  @override
  String get yogaModLiftPalms => 'Lift palms for challenge';

  @override
  String get yogaModPressFeet => 'Press feet down for stability';

  @override
  String get yogaModNoLockElbows => 'Do not lock elbows';

  @override
  String get yogaModTuckStomach => 'Tuck stomach slightly for spine support';

  @override
  String get yogaModRestChildPose =>
      'Rest in Child’s Pose between rounds if needed';

  @override
  String get yogaModSlowTransitions =>
      'Slow down transitions if breath becomes strained';

  @override
  String get yogaModBendDownwardDog => 'Bend knees in Downward Dog for comfort';

  @override
  String get yogaModSitOrLie => 'Sit upright or lie flat';

  @override
  String get yogaModCushionUnderKnees => 'Place cushion under knees';

  @override
  String get sessionLevelLabel => 'Level';

  @override
  String get sessionTotalTimeLabel => 'Total Time';

  @override
  String get sessionTotalPosesLabel => 'Total Poses';

  @override
  String get aboutThisSession => 'About this Session';

  @override
  String get posesPreview => 'Poses Preview';

  @override
  String posesCompletedCount(int completed, int total) {
    return '$completed of $total poses completed';
  }

  @override
  String get practiceAgain => 'Practice Again';

  @override
  String get posesLabel => 'poses';

  @override
  String get duration => 'Duration';

  @override
  String get poses => 'Poses';

  @override
  String get intensity => 'Intensity';

  @override
  String get low => 'Low';

  @override
  String get aboutSession => 'About Session';

  @override
  String get sessionOverview => 'Session Overview';

  @override
  String get joinClass => 'Join Class';

  @override
  String dayNumber(int number) {
    return 'Day $number';
  }

  @override
  String minsLabel(int count) {
    return '$count Mins';
  }

  @override
  String get completeCurrentPoseFirst =>
      'Please complete the current pose first!';

  @override
  String get poseComplete => 'Pose Complete!';

  @override
  String get greatWorkChoice => 'Great work! What would you like to do next?';

  @override
  String get retryPose => 'Repeat Pose';

  @override
  String get nextPose => 'Next Pose';

  @override
  String get finishSession => 'Finish Session';

  @override
  String get sessionComplete => 'Session Complete!';

  @override
  String completedPoses(int count) {
    return '$count poses completed';
  }

  @override
  String totalMinutesSpent(int value, String unit) {
    return 'You practiced for $value $unit';
  }

  @override
  String get totaltime => 'Total Time:';

  @override
  String get howToPose => 'How to do this pose';

  @override
  String get sessionPlaylist => 'Session Poses';

  @override
  String get playing => 'Playing';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get waitingForPin => 'Waiting for PIN...';

  @override
  String get exitSessionTitle => 'Exit Session?';

  @override
  String posesCompletedInfo(int completed, int total) {
    return '$completed of $total poses completed';
  }

  @override
  String get progressSaved => 'Progress saved ✓';

  @override
  String get continueLater =>
      'You can continue from where you left off anytime!';

  @override
  String get noPosesCompleted => 'No poses completed yet';

  @override
  String get completeOneToSave =>
      'Complete at least one pose to save your progress.';

  @override
  String get stayButton => 'Stay';

  @override
  String get playbackNormal => 'Normal';

  @override
  String poseProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get videoTutorial => 'Video Tutorial';

  @override
  String get safetyTips => 'Safety Tips';

  @override
  String get tip1 => 'Keep your knees slightly bent to avoid joint strain';

  @override
  String get tip2 => 'Engage your core muscles throughout the pose';

  @override
  String get tip3 => 'Don\'t force your heels to touch the ground';

  @override
  String get tip4 => 'Breathe deeply and avoid holding your breath';

  @override
  String get tip5 => 'Exit the pose slowly if you feel any pain';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get completed => 'Completed';

  @override
  String get poseMarkedSuccess => 'Pose marked as completed!';

  @override
  String get completeSession => 'Complete Session';

  @override
  String get congratulations => '🎉 Congratulations!';

  @override
  String get sessionCompleteDesc => 'You completed all poses in this session!';

  @override
  String get done => 'Done';

  @override
  String get poseDetailTitle => 'Pose Details';

  @override
  String get howToDoTitle => 'How to Do This Pose';

  @override
  String get learningNotice =>
      'This is for learning only. To track progress, use \"Join Class\" from the session screen.';

  @override
  String poseCurrentCount(int current, int total) {
    return '$current of $total';
  }

  @override
  String durationFormat(int minutes, String seconds) {
    return '$minutes:$seconds min';
  }

  @override
  String get calendar => 'Calendar';

  @override
  String get activitySummary => 'Activity Summary';

  @override
  String get totalMinutes => 'Minutes';

  @override
  String get thisWeek => 'This Week';

  @override
  String get dailyMinutes => 'Daily Minutes';

  @override
  String get week => 'Week';

  @override
  String get nothingTracked => 'Nothing tracked yet';

  @override
  String get min => 'min';

  @override
  String ofGoal(int goal) {
    return 'of $goal min';
  }

  @override
  String get weeklyBadges => 'Badges';

  @override
  String get wellnessCheckIn => 'Wellness Check-In';

  @override
  String get checkedInThisWeek => 'Checked in this week ✓';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get checkInButton => 'Check-In';

  @override
  String get historyButton => 'History';

  @override
  String get practice => 'Practice';

  @override
  String get restDay => 'Rest day';

  @override
  String get reflectionHistory => 'Reflection History';

  @override
  String get noReflections => 'No reflections yet';

  @override
  String get bodyComfort => 'Body Comfort';

  @override
  String get flexibility => 'Flexibility';

  @override
  String get balance => 'Balance';

  @override
  String get energy => 'Energy';

  @override
  String get mood => 'Mood';

  @override
  String get confidence => 'Confidence';

  @override
  String get mindBody => 'Mind-Body';

  @override
  String get wellbeing => 'Wellbeing';

  @override
  String get notes => 'Notes: ';

  @override
  String get wellnessDialogTitle => 'Wellness Check-in';

  @override
  String get wellnessDialogSubtitle => 'How are you feeling today?';

  @override
  String get qBodyComfort =>
      'How comfortable does your body feel when doing yoga?';

  @override
  String get qFlexibility => 'How would you rate your flexibility recently?';

  @override
  String get qBalance => 'How steady do you feel when standing or balancing?';

  @override
  String get qEnergy => 'How is your overall energy level?';

  @override
  String get qMood => 'How has your mood been lately?';

  @override
  String get qConfidence =>
      'How confident do you feel doing your daily activities?';

  @override
  String get qBodyConnection =>
      'How connected do you feel to your body during yoga practice?';

  @override
  String get qOverall =>
      'Overall, how have you been feeling in your body and mind?';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get rateAllError => 'Please rate all categories';

  @override
  String get checkInSaved => 'Wellness check-in saved!';

  @override
  String get platinum => 'Platinum';

  @override
  String get gold => 'Gold';

  @override
  String get silver => 'Silver';

  @override
  String get bronze => 'Bronze';

  @override
  String get none => 'None';

  @override
  String get section1Title => 'Section 1 – Physical Comfort & Mobility';

  @override
  String get section2Title => 'Section 2 – Energy & Mood';

  @override
  String get section3Title => 'Section 3 – Awareness & Confidence';

  @override
  String get section4Title => '⭐ Overall Wellbeing';

  @override
  String get qBodyComfortFull =>
      '1️⃣ How comfortable does your body feel during movement?';

  @override
  String get optComfort1 => 'Not comfortable';

  @override
  String get optComfort2 => 'Slightly comfortable';

  @override
  String get optComfort3 => 'Moderately comfortable';

  @override
  String get optComfort4 => 'Very comfortable';

  @override
  String get optComfort5 => 'Extremely comfortable';

  @override
  String get qFlexibilityFull =>
      '2️⃣ How would you describe your flexibility recently?';

  @override
  String get optFlexibility1 => 'Much stiffer';

  @override
  String get optFlexibility2 => 'A little stiff';

  @override
  String get optFlexibility3 => 'About the same';

  @override
  String get optFlexibility4 => 'A bit more flexible';

  @override
  String get optFlexibility5 => 'Much more flexible';

  @override
  String get qBalanceFull =>
      '3️⃣ How steady do you feel when standing or balancing?';

  @override
  String get optBalance1 => 'Not steady at all';

  @override
  String get optBalance2 => 'Slightly steady';

  @override
  String get optBalance3 => 'Moderately steady';

  @override
  String get optBalance4 => 'Very steady';

  @override
  String get optBalance5 => 'Extremely steady';

  @override
  String get qEnergyFull => '4️⃣ How is your overall energy level?';

  @override
  String get optEnergy1 => 'Very low';

  @override
  String get optEnergy2 => 'Low';

  @override
  String get optEnergy3 => 'Average';

  @override
  String get optEnergy4 => 'Good';

  @override
  String get optEnergy5 => 'Very good';

  @override
  String get qMoodFull => '5️⃣ How has your mood been lately?';

  @override
  String get optMood1 => 'Often stressed or down';

  @override
  String get optMood2 => 'Sometimes stressed';

  @override
  String get optMood3 => 'Mostly okay';

  @override
  String get optMood4 => 'Mostly positive';

  @override
  String get optMood5 => 'Very positive and calm';

  @override
  String get qConfidenceFull =>
      '6️⃣ How confident do you feel performing daily activities?';

  @override
  String get optConfidence1 => 'Not confident';

  @override
  String get optConfidence2 => 'Slightly confident';

  @override
  String get optConfidence3 => 'Somewhat confident';

  @override
  String get optConfidence4 => 'Confident';

  @override
  String get optConfidence5 => 'Very confident';

  @override
  String get qBodyConnectionFull =>
      '7️⃣ How connected do you feel to your body during yoga practice?';

  @override
  String get optConnection1 => 'Not connected';

  @override
  String get optConnection2 => 'A little connected';

  @override
  String get optConnection3 => 'Moderately connected';

  @override
  String get optConnection4 => 'Very connected';

  @override
  String get optConnection5 => 'Deeply connected';

  @override
  String get qOverallFull =>
      '8️⃣ Overall, how would you rate your wellbeing this month?';

  @override
  String get optOverall1 => 'Poor';

  @override
  String get optOverall2 => 'Fair';

  @override
  String get optOverall3 => 'Good';

  @override
  String get optOverall4 => 'Very good';

  @override
  String get optOverall5 => 'Excellent';

  @override
  String get monthlyReflections => '💭 Monthly Reflections (Optional)';

  @override
  String get shareImprovements =>
      'Share specific improvements you\'ve noticed:';

  @override
  String get labelBalance => '🧘 Balance Improvements';

  @override
  String get hintBalance => 'e.g., I can stand on one leg longer...';

  @override
  String get labelPosture => '🪑 Posture Improvements';

  @override
  String get hintPosture => 'e.g., My back feels straighter...';

  @override
  String get labelConsistency => '📅 Consistency & Habits';

  @override
  String get hintConsistency => 'e.g., I practice every morning now...';

  @override
  String get labelOther => '💬 Other Thoughts';

  @override
  String get hintOther => 'Any other improvements or notes...';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get submitCheckIn => 'Submit Check-in';

  @override
  String get validationErrorCheckIn =>
      'Please answer all required questions before submitting';

  @override
  String get nowPlaying => 'Now Playing';

  @override
  String get moreDetails => 'More details';

  @override
  String get aboutThisSound => 'About This Sound';

  @override
  String get category => 'Category';

  @override
  String get type => 'Type';

  @override
  String get meditationType => 'Meditation & Relaxation';

  @override
  String get benefits => 'Benefits';

  @override
  String get soundBenefit1 => '• Reduces stress and anxiety';

  @override
  String get soundBenefit2 => '• Improves focus and concentration';

  @override
  String get soundBenefit3 => '• Promotes better sleep';

  @override
  String get soundBenefit4 => '• Enhances overall well-being';

  @override
  String get meditationHeader => 'Meditation & Sounds';

  @override
  String get quickStart => 'Quick Start';

  @override
  String get guidedMeditationSection => 'Guided Meditations';

  @override
  String get ambientSoundsSection => 'Ambient Sounds';

  @override
  String get ambientSoundsSubtitle => 'Real nature sounds to help you relax';

  @override
  String get morningClarityTitle => 'Morning Clarity';

  @override
  String get morningClarityDesc => 'Start your day with calm intention';

  @override
  String get deepBreathingTitle => 'Deep Breathing';

  @override
  String get deepBreathingDesc => 'Reduce stress with focused breath';

  @override
  String get eveningWindDownTitle => 'Evening Wind Down';

  @override
  String get eveningWindDownDesc => 'Release the day and prepare for rest';

  @override
  String get oceanWavesTitle => 'Ocean Waves';

  @override
  String get oceanWavesDesc => 'Gentle waves on the shore';

  @override
  String get rainSoundsTitle => 'Rain Sounds';

  @override
  String get rainSoundsDesc => 'Soft rain and thunder';

  @override
  String get forestBirdsTitle => 'Forest Birds';

  @override
  String get forestBirdsDesc => 'Birds chirping in nature';

  @override
  String get cracklingFireTitle => 'Crackling Fire';

  @override
  String get cracklingFireDesc => 'Warm fireplace sounds';

  @override
  String get whiteNoiseTitle => 'White Noise';

  @override
  String get whiteNoiseDesc => 'Pure white noise for focus';

  @override
  String get flowingWaterTitle => 'Flowing Water';

  @override
  String get flowingWaterDesc => 'Gentle stream sounds';

  @override
  String get windChimesTitle => 'Wind Chimes';

  @override
  String get windChimesDesc => 'Peaceful wind chimes';

  @override
  String get nightCricketsTitle => 'Night Crickets';

  @override
  String get nightCricketsDesc => 'Evening cricket sounds';

  @override
  String get meditationHeaderTitle => 'Choose Your Meditation';

  @override
  String get meditationHeaderSubtitle => 'Pause & Breathe';

  @override
  String get meditationQuickStart => 'Quick Start • 5-10 min';

  @override
  String get meditationAllSection => 'All Meditations';

  @override
  String get meditationCategoryLabel => 'Meditation';

  @override
  String meditationDurationMin(int count) {
    return '$count min';
  }

  @override
  String get meditationSessionMorningTitle => 'Morning Clarity';

  @override
  String get meditationSessionMorningDesc =>
      'Start your day with calm intention';

  @override
  String get meditationSessionBreathingTitle => 'Deep Breathing';

  @override
  String get meditationSessionBreathingDesc =>
      'Reduce stress with focused breath';

  @override
  String get meditationSessionEveningTitle => 'Evening Wind Down';

  @override
  String get meditationSessionEveningDesc =>
      'Release the day and prepare for rest';

  @override
  String get soundCategory => 'Ambient';

  @override
  String get meditationPreparing => 'Preparing your session...';

  @override
  String get meditationCancel => 'Cancel Session';

  @override
  String get meditationEndSession => 'End Session';

  @override
  String get meditationComplete => 'Session Complete';

  @override
  String get meditationInhale => 'Inhale...';

  @override
  String get meditationExhale => 'Exhale...';

  @override
  String get meditationHold => 'Hold...';

  @override
  String get meditationEndTitle => 'End Session?';

  @override
  String get meditationEndMessage =>
      'Are you sure you want to end your meditation session?';

  @override
  String get meditationConfirmEnd => 'End';

  @override
  String get profileTitle => 'Profile';

  @override
  String get edit => 'Edit';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String get daily => 'Streak';

  @override
  String get streakSummary => 'Streak Summary';

  @override
  String get weeklyActive => 'Weekly Active Weeks';

  @override
  String get preferences => 'Preferences';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get signout => 'Sign Out';

  @override
  String get aboutus => 'About us';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get save => 'Save';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get photoUpdated => 'Profile image updated';

  @override
  String get photoRemoved => 'Profile image removed';

  @override
  String get photoFail => 'Upload failed';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get age => 'Age';

  @override
  String get experienceLevel => 'Experience Level';

  @override
  String get sessionLength => 'Session Length';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushEnabledMsg => 'Push notifications enabled! 🔔';

  @override
  String get dailyReminder => 'Daily Practice Reminder';

  @override
  String get dailyReminderEnabled => 'Daily Reminder Enabled!';

  @override
  String get dailyEnabledMsg => 'We will remind you every day to practice. 🌞';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get dailyReminderNotification => 'Daily Practice Reminder';

  @override
  String get dailyReminderBody => 'Time for your daily session! 🏃‍♀️';

  @override
  String get sound => 'Sound';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get appVolume => 'App Volume';

  @override
  String get systemVolume => 'System Volume';

  @override
  String get appVolumeDesc => 'Adjusts volume for sounds in this app';

  @override
  String get systemVolumeDesc => 'Adjusts your device system volume';

  @override
  String get validationError => 'Name and age are required';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get min5 => '5 minutes';

  @override
  String get min10 => '10 minutes';

  @override
  String get min15 => '15 minutes';

  @override
  String get min20 => '20 minutes';

  @override
  String get min30 => '30 minutes';

  @override
  String get english => 'English';

  @override
  String get mandarinSimplified => 'Mandarin (Simplified)';

  @override
  String get mandarinTraditional => 'Mandarin (Traditional)';

  @override
  String completedPosesCount(int count) {
    return 'You completed $count poses!';
  }

  @override
  String get minutes => 'minutes';

  @override
  String get next => 'Next';

  @override
  String get aboutThisPose => 'About this pose';

  @override
  String get exitSession => 'Exit Session?';

  @override
  String get exitSessionMessage =>
      'Your progress will not be saved if you exit now. Are you sure?';

  @override
  String get exit => 'Exit';

  @override
  String get aboutUsTitle => 'About Us';

  @override
  String get appName => 'Zencore';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get ourMission => 'Our Mission';

  @override
  String get missionStatement =>
      'Making wellness accessible to everyone through gentle chair yoga, calming meditation, and mindful practice.';

  @override
  String get projectTeam => 'Project Team';

  @override
  String get projectSupervisor => 'Project Supervisor';

  @override
  String get developmentTeam => 'Development Team';

  @override
  String get yogaInstructor => 'Yoga Instructor';

  @override
  String get keyFeatures => 'Key Features';

  @override
  String get featureChairYoga => 'Chair Yoga Sessions';

  @override
  String get featureMeditation => 'Guided Meditation';

  @override
  String get featureProgress => 'Progress Tracking';

  @override
  String get featureSounds => 'Calming Sounds';

  @override
  String get licensesTitle => 'Open Source Licenses';

  @override
  String get licenseDescription =>
      'HealYoga is built with open-source software. You can view the full list of licenses below.';

  @override
  String get viewLicensesButton => 'View All Licenses';

  @override
  String get copyright => '© 2026 ZENCORE';

  @override
  String get allRightsReserved => 'All Rights Reserved';
}

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
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String dayCount(int number) {
    return 'Day $number';
  }

  @override
  String get mainSessionTitle => 'Do 7 Exercises in\nOnly 6 Minutes';

  @override
  String get start => 'Start';

  @override
  String get keepUpWork => 'Keep up the good work!';

  @override
  String minShort(int count) {
    return '$count min';
  }

  @override
  String poseDurationSeconds(int seconds) {
    return '$seconds seconds';
  }

  @override
  String durationFormat(int minutes) {
    return '$minutes min';
  }

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get chooseYour => 'Choose Your';

  @override
  String get level => 'Level';

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
  String completeMore(int count) {
    return 'Complete $count more';
  }

  @override
  String completeSessionsToUnlock(int count) {
    return 'Complete $count more';
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
  String minutesCount(int count) {
    return '$count minutes';
  }

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
  String get nextPose => 'Next Pose';

  @override
  String get completeSession => 'Complete Session';

  @override
  String get congratulations => '🎉 Congratulations!';

  @override
  String get sessionCompleteDesc => 'You completed all poses in this session!';

  @override
  String get done => 'Done';

  @override
  String get progressHeader => 'Your Progress';

  @override
  String get progressSubtitle => 'Track your journey to wellness';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get totalMinutes => 'Total Minutes';

  @override
  String get thisWeek => 'This Week';

  @override
  String weeklyGoal(int goal) {
    return 'Goal: $goal min';
  }

  @override
  String get weeklyBadges => 'Weekly Badges';

  @override
  String get checkedInMsg => 'Checked in this week ✓';

  @override
  String get shareFeeling => 'Share how you\'re feeling';

  @override
  String get newCheckIn => 'New Check-in';

  @override
  String get viewHistory => 'View History';

  @override
  String get calendar => 'Calendar';

  @override
  String get practice => 'Practice';

  @override
  String get restDay => 'Rest day';

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
  String get notes => 'Notes: ';

  @override
  String get rateAllError => 'Please rate all categories';

  @override
  String get checkInSaved => 'Wellness check-in saved!';

  @override
  String get reflectionHistory => 'Reflection History';

  @override
  String get noReflections => 'No reflections yet';

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
  String get welcomeBackSounds => 'Welcome back,';

  @override
  String get findYourPeace => 'Find Your Peace';

  @override
  String get tabAll => 'All';

  @override
  String get tabRecent => 'Recent';

  @override
  String get tabSaved => 'Saved';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get mostPopular => 'Most Popular';

  @override
  String get latest => 'Latest';

  @override
  String get noRecentSounds => 'No recent sounds';

  @override
  String get noSavedSounds => 'No saved sounds yet';

  @override
  String get noFavoriteSounds => 'No favorite sounds yet';

  @override
  String get savedSuccess => 'Saved!';

  @override
  String get removedFromSaved => 'Removed from saved';

  @override
  String get audioLoadError => 'Failed to load audio. Please try another one.';

  @override
  String get soundOceanWaves => 'Ocean Waves';

  @override
  String get soundForestRain => 'Forest Rain';

  @override
  String get soundTibetanBowls => 'Tibetan Bowls';

  @override
  String get soundPeacefulPiano => 'Peaceful Piano';

  @override
  String get soundMountainStream => 'Mountain Stream';

  @override
  String get soundWindChimes => 'Wind Chimes';

  @override
  String get soundGentleThunder => 'Gentle Thunder';

  @override
  String get soundSingingBirds => 'Singing Birds';

  @override
  String get categoryNature => 'Nature';

  @override
  String get categoryMeditation => 'Meditation';

  @override
  String get categoryAmbient => 'Ambient';

  @override
  String get profileTitle => 'Profile';

  @override
  String get edit => 'Edit';

  @override
  String get sessions => 'Sessions';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String get daily => 'Daily 🔥';

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
  String get logout => 'LOG OUT';

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
  String get mandarin => 'Mandarin';

  @override
  String get sessionComplete => 'Session Complete!';

  @override
  String completedPosesCount(int count) {
    return 'You completed $count poses!';
  }

  @override
  String get minutes => 'minutes';

  @override
  String get totalTime => 'TOTAL TIME';

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
}

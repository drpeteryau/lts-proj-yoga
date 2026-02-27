import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Begin Your Wellness Journey'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started'**
  String get registerSubtitle;

  /// No description provided for @stepPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get stepPersonal;

  /// No description provided for @stepPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get stepPreferences;

  /// No description provided for @stepAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get stepAccount;

  /// No description provided for @getToknowYou.
  ///
  /// In en, this message translates to:
  /// **'👋 Let\'s Get to Know You'**
  String get getToknowYou;

  /// No description provided for @tellUsAbout.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself'**
  String get tellUsAbout;

  /// No description provided for @yourPreferences.
  ///
  /// In en, this message translates to:
  /// **'⚙️ Your Preferences'**
  String get yourPreferences;

  /// No description provided for @customizeYoga.
  ///
  /// In en, this message translates to:
  /// **'Customize your yoga experience'**
  String get customizeYoga;

  /// No description provided for @secureAccount.
  ///
  /// In en, this message translates to:
  /// **'🔐 Secure Your Account'**
  String get secureAccount;

  /// No description provided for @createCredentials.
  ///
  /// In en, this message translates to:
  /// **'Create your login credentials'**
  String get createCredentials;

  /// No description provided for @passwordReqTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements:'**
  String get passwordReqTitle;

  /// No description provided for @reqLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get reqLength;

  /// No description provided for @reqUpper.
  ///
  /// In en, this message translates to:
  /// **'1 uppercase letter (A-Z)'**
  String get reqUpper;

  /// No description provided for @reqLower.
  ///
  /// In en, this message translates to:
  /// **'1 lowercase letter (a-z)'**
  String get reqLower;

  /// No description provided for @reqNumber.
  ///
  /// In en, this message translates to:
  /// **'1 number (0-9)'**
  String get reqNumber;

  /// No description provided for @reqSpecial.
  ///
  /// In en, this message translates to:
  /// **'1 special character (!@#\$%...)'**
  String get reqSpecial;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get ageHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Min 8 chars: 1 uppercase, 1 lowercase, 1 number, 1 special char'**
  String get passwordHint;

  /// No description provided for @errEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errEmailEmpty;

  /// No description provided for @errEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get errEmailInvalid;

  /// No description provided for @errPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get errPasswordEmpty;

  /// No description provided for @errNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get errNameEmpty;

  /// No description provided for @errAgeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age (numbers only)'**
  String get errAgeEmpty;

  /// No description provided for @errAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age between 1 and 120'**
  String get errAgeRange;

  /// No description provided for @checkEmailMsg.
  ///
  /// In en, this message translates to:
  /// **'Please check your email to confirm your account'**
  String get checkEmailMsg;

  /// No description provided for @welcomeName.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}! 🌿'**
  String welcomeName(String name);

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile 🌸'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Just a few quick details to personalize your yoga journey.'**
  String get completeProfileSubtitle;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// No description provided for @enterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get enterValidAge;

  /// No description provided for @profileCompleted.
  ///
  /// In en, this message translates to:
  /// **'Profile completed 🌿'**
  String get profileCompleted;

  /// No description provided for @saveProfileFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile: {error}'**
  String saveProfileFailed(String error);

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @under18.
  ///
  /// In en, this message translates to:
  /// **'Under 18'**
  String get under18;

  /// No description provided for @ageRange.
  ///
  /// In en, this message translates to:
  /// **'{start}-{end} years'**
  String ageRange(int start, int end);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back 🧘‍♀️'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your healing journey.'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get dontHaveAccount;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillRequiredFields;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome back 🌿'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailed(String error);

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed: {error}'**
  String googleSignInFailed(String error);

  /// No description provided for @onboardingHeading.
  ///
  /// In en, this message translates to:
  /// **'Feel stronger'**
  String get onboardingHeading;

  /// No description provided for @onboardingDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn from the world\'s best yoga\ncoaches anytime at home or on\nthe go.'**
  String get onboardingDesc;

  /// No description provided for @letsExplore.
  ///
  /// In en, this message translates to:
  /// **'Let\'s explore'**
  String get letsExplore;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get navSessions;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navSounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get navMeditation;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String dayCount(int number);

  /// No description provided for @mainSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Do 7 Exercises in\nOnly 6 Minutes'**
  String get mainSessionTitle;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @keepUpWork.
  ///
  /// In en, this message translates to:
  /// **'Keep up the good work!'**
  String get keepUpWork;

  /// No description provided for @minShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minShort(int count);

  /// No description provided for @poseDurationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String poseDurationSeconds(int seconds);

  /// No description provided for @durationFormat.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationFormat(int minutes);

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @chooseYour.
  ///
  /// In en, this message translates to:
  /// **'Choose Your'**
  String get chooseYour;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @beginnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chair Yoga'**
  String get beginnerSubtitle;

  /// No description provided for @beginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Perfect for those just starting their yoga journey'**
  String get beginnerDesc;

  /// No description provided for @intermediateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hatha yoga on the mat'**
  String get intermediateSubtitle;

  /// No description provided for @intermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Build strength with challenging sequences'**
  String get intermediateDesc;

  /// No description provided for @advancedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dynamic sun salutation flow'**
  String get advancedSubtitle;

  /// No description provided for @advancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Challenge yourself with flowing sequences'**
  String get advancedDesc;

  /// No description provided for @lockedLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'{levelName} Locked'**
  String lockedLevelTitle(String levelName);

  /// No description provided for @completeMore.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} more'**
  String completeMore(int count);

  /// No description provided for @completeSessionsToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} more'**
  String completeSessionsToUnlock(int count);

  /// No description provided for @unlockIntermediateFirst.
  ///
  /// In en, this message translates to:
  /// **'Unlock Intermediate first'**
  String get unlockIntermediateFirst;

  /// No description provided for @sessionsProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {required} sessions'**
  String sessionsProgress(int current, int required);

  /// No description provided for @sessionsCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions completed'**
  String sessionsCompletedCount(int count);

  /// No description provided for @errorLoadingProgress.
  ///
  /// In en, this message translates to:
  /// **'Error loading progress'**
  String get errorLoadingProgress;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @beginnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Beginner Sessions'**
  String get beginnerTitle;

  /// No description provided for @warmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get warmup;

  /// No description provided for @mainPractice.
  ///
  /// In en, this message translates to:
  /// **'Main Practice'**
  String get mainPractice;

  /// No description provided for @cooldown.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get cooldown;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @poseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pose} other{{count} poses}}'**
  String poseCount(int count);

  /// Text showing how many sessions a user has finished
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session completed} other{{count} sessions completed}}'**
  String sessionsCompleted(int count);

  /// No description provided for @intermediateTitle.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Sessions'**
  String get intermediateTitle;

  /// No description provided for @hathaPractice.
  ///
  /// In en, this message translates to:
  /// **'Hatha Practice'**
  String get hathaPractice;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @advancedTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Sessions'**
  String get advancedTitle;

  /// No description provided for @dynamicFlowNotice.
  ///
  /// In en, this message translates to:
  /// **'Dynamic flow practice. Move with your breath.'**
  String get dynamicFlowNotice;

  /// No description provided for @advancedLabel.
  ///
  /// In en, this message translates to:
  /// **'ADVANCED'**
  String get advancedLabel;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutesCount(int count);

  /// No description provided for @highIntensity.
  ///
  /// In en, this message translates to:
  /// **'High intensity'**
  String get highIntensity;

  /// No description provided for @sunSalutationTitle.
  ///
  /// In en, this message translates to:
  /// **'Sun Salutation Flow'**
  String get sunSalutationTitle;

  /// No description provided for @repeatRounds.
  ///
  /// In en, this message translates to:
  /// **'Repeat 5-10 rounds • One breath, one movement'**
  String get repeatRounds;

  /// No description provided for @beginFlow.
  ///
  /// In en, this message translates to:
  /// **'Begin Flow'**
  String get beginFlow;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'1. Downward Dog'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'2. Plank'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'3. Eight-Point Pose'**
  String get step3;

  /// No description provided for @step4.
  ///
  /// In en, this message translates to:
  /// **'4. Baby Cobra'**
  String get step4;

  /// No description provided for @step5.
  ///
  /// In en, this message translates to:
  /// **'5. Full Cobra'**
  String get step5;

  /// No description provided for @step6.
  ///
  /// In en, this message translates to:
  /// **'6. Return to Downward Dog'**
  String get step6;

  /// No description provided for @yogaHeadNeckShoulders.
  ///
  /// In en, this message translates to:
  /// **'Head, Neck and Shoulders Stretch'**
  String get yogaHeadNeckShoulders;

  /// No description provided for @yogaStraightArms.
  ///
  /// In en, this message translates to:
  /// **'Straight Arms Rotation'**
  String get yogaStraightArms;

  /// No description provided for @yogaBentArms.
  ///
  /// In en, this message translates to:
  /// **'Bent Arm Rotation'**
  String get yogaBentArms;

  /// No description provided for @yogaShouldersLateral.
  ///
  /// In en, this message translates to:
  /// **'Shoulders Lateral Stretch'**
  String get yogaShouldersLateral;

  /// No description provided for @yogaShouldersTorsoTwist.
  ///
  /// In en, this message translates to:
  /// **'Shoulders & Torso Twist'**
  String get yogaShouldersTorsoTwist;

  /// No description provided for @yogaLegRaiseBent.
  ///
  /// In en, this message translates to:
  /// **'Leg Raise (Bent)'**
  String get yogaLegRaiseBent;

  /// No description provided for @yogaLegRaiseStraight.
  ///
  /// In en, this message translates to:
  /// **'Leg Raise (Straight)'**
  String get yogaLegRaiseStraight;

  /// No description provided for @yogaGoddessTwist.
  ///
  /// In en, this message translates to:
  /// **'Goddess Pose — Torso Twist'**
  String get yogaGoddessTwist;

  /// No description provided for @yogaGoddessStrength.
  ///
  /// In en, this message translates to:
  /// **'Goddess Pose — Leg Strengthening'**
  String get yogaGoddessStrength;

  /// No description provided for @yogaBackChestStretch.
  ///
  /// In en, this message translates to:
  /// **'Back and Chest Stretch'**
  String get yogaBackChestStretch;

  /// No description provided for @yogaStandingCrunch.
  ///
  /// In en, this message translates to:
  /// **'Standing Crunch'**
  String get yogaStandingCrunch;

  /// No description provided for @yogaWarrior3Supported.
  ///
  /// In en, this message translates to:
  /// **'Warrior 3 (Supported)'**
  String get yogaWarrior3Supported;

  /// No description provided for @yogaWarrior1Supported.
  ///
  /// In en, this message translates to:
  /// **'Warrior 1 (Supported)'**
  String get yogaWarrior1Supported;

  /// No description provided for @yogaWarrior2Supported.
  ///
  /// In en, this message translates to:
  /// **'Warrior 2 (Supported)'**
  String get yogaWarrior2Supported;

  /// No description provided for @yogaTriangleSupported.
  ///
  /// In en, this message translates to:
  /// **'Triangle Pose (Supported)'**
  String get yogaTriangleSupported;

  /// No description provided for @yogaReverseWarrior2.
  ///
  /// In en, this message translates to:
  /// **'Reverse Warrior 2'**
  String get yogaReverseWarrior2;

  /// No description provided for @yogaSideAngleSupported.
  ///
  /// In en, this message translates to:
  /// **'Side Angle Pose (Supported)'**
  String get yogaSideAngleSupported;

  /// No description provided for @yogaGentleBreathing.
  ///
  /// In en, this message translates to:
  /// **'Gentle Breathing'**
  String get yogaGentleBreathing;

  /// No description provided for @yogaDownwardDog.
  ///
  /// In en, this message translates to:
  /// **'Downward Dog'**
  String get yogaDownwardDog;

  /// No description provided for @yogaPlank.
  ///
  /// In en, this message translates to:
  /// **'Plank Pose'**
  String get yogaPlank;

  /// No description provided for @yogaEightPoint.
  ///
  /// In en, this message translates to:
  /// **'Eight-Point Pose (Ashtangasana)'**
  String get yogaEightPoint;

  /// No description provided for @yogaBabyCobra.
  ///
  /// In en, this message translates to:
  /// **'Baby Cobra'**
  String get yogaBabyCobra;

  /// No description provided for @yogaFullCobra.
  ///
  /// In en, this message translates to:
  /// **'Full Cobra Pose'**
  String get yogaFullCobra;

  /// No description provided for @yogaSunSalutation.
  ///
  /// In en, this message translates to:
  /// **'Sun Salutation Flow'**
  String get yogaSunSalutation;

  /// No description provided for @yogaSessionGentleChair.
  ///
  /// In en, this message translates to:
  /// **'Gentle Chair Yoga'**
  String get yogaSessionGentleChair;

  /// No description provided for @yogaSessionMorningMobility.
  ///
  /// In en, this message translates to:
  /// **'Morning Mobility'**
  String get yogaSessionMorningMobility;

  /// No description provided for @yogaSessionWarriorSeries.
  ///
  /// In en, this message translates to:
  /// **'Warrior Series'**
  String get yogaSessionWarriorSeries;

  /// No description provided for @yogaSessionHathaFundamentals.
  ///
  /// In en, this message translates to:
  /// **'Hatha Fundamentals'**
  String get yogaSessionHathaFundamentals;

  /// No description provided for @yogaSessionCoreStrength.
  ///
  /// In en, this message translates to:
  /// **'Core Strength Builder'**
  String get yogaSessionCoreStrength;

  /// No description provided for @yogaSessionBackbendFlow.
  ///
  /// In en, this message translates to:
  /// **'Backbend Flow'**
  String get yogaSessionBackbendFlow;

  /// No description provided for @yogaSessionSunSalutation.
  ///
  /// In en, this message translates to:
  /// **'Sun Salutation Flow'**
  String get yogaSessionSunSalutation;

  /// No description provided for @yogaSessionExtendedFlow.
  ///
  /// In en, this message translates to:
  /// **'Extended Flow Practice'**
  String get yogaSessionExtendedFlow;

  /// No description provided for @yogaDescHeadNeck.
  ///
  /// In en, this message translates to:
  /// **'Gentle seated stretches releasing neck and shoulder tension.'**
  String get yogaDescHeadNeck;

  /// No description provided for @yogaDescGentleChair.
  ///
  /// In en, this message translates to:
  /// **'Make sure the chair is stable by placing it against a wall. Beginner’s level of Chair yoga is suitable for most people. Yoga should be practised with an empty or relatively empty stomach, or at least 2 hours after a meal.'**
  String get yogaDescGentleChair;

  /// No description provided for @yogaDescMorningMobility.
  ///
  /// In en, this message translates to:
  /// **'A light morning routine focusing on joint mobility, breathing, and supported strength work.'**
  String get yogaDescMorningMobility;

  /// No description provided for @yogaDescWarriorSeries.
  ///
  /// In en, this message translates to:
  /// **'A confidence-building sequence exploring Warrior I, II, and supporting transitions.'**
  String get yogaDescWarriorSeries;

  /// No description provided for @yogaDescHathaFundamentals.
  ///
  /// In en, this message translates to:
  /// **'A classic mat-based Hatha sequence focusing on alignment, breath, and full-body engagement. Ideal for practitioners ready to move beyond chair support.'**
  String get yogaDescHathaFundamentals;

  /// No description provided for @yogaDescCoreStrength.
  ///
  /// In en, this message translates to:
  /// **'A short but powerful session focusing on Plank, Eight-Point Pose, and controlled transitions. Boosts core strength and shoulder stability.'**
  String get yogaDescCoreStrength;

  /// No description provided for @yogaDescBackbendFlow.
  ///
  /// In en, this message translates to:
  /// **'A spine-strengthening sequence moving from Eight-Point Pose into Baby Cobra and Full Cobra. Builds confidence in backbending.'**
  String get yogaDescBackbendFlow;

  /// No description provided for @yogaDescSunSalutationSession.
  ///
  /// In en, this message translates to:
  /// **'A dynamic mat-based flow designed to synchronise breath and movement. This session builds endurance and full-body strength through repeated Sun Salutation cycles.'**
  String get yogaDescSunSalutationSession;

  /// No description provided for @yogaDescExtendedFlow.
  ///
  /// In en, this message translates to:
  /// **'A deeper and longer Sun Salutation practice — ideal for experienced practitioners wanting a continuous challenge with breath-led movement.'**
  String get yogaDescExtendedFlow;

  /// No description provided for @yogaDescStraightArms.
  ///
  /// In en, this message translates to:
  /// **'Arm rotations to warm up shoulders and upper back.'**
  String get yogaDescStraightArms;

  /// No description provided for @yogaDescBentArms.
  ///
  /// In en, this message translates to:
  /// **'Shoulder mobility exercise with bent elbows.'**
  String get yogaDescBentArms;

  /// No description provided for @yogaDescShouldersLateral.
  ///
  /// In en, this message translates to:
  /// **'Side-body stretch improving flexibility.'**
  String get yogaDescShouldersLateral;

  /// No description provided for @yogaDescShouldersTorsoTwist.
  ///
  /// In en, this message translates to:
  /// **'A gentle detoxifying twist.'**
  String get yogaDescShouldersTorsoTwist;

  /// No description provided for @yogaDescLegRaiseBent.
  ///
  /// In en, this message translates to:
  /// **'Strengthen legs and activate core.'**
  String get yogaDescLegRaiseBent;

  /// No description provided for @yogaDescLegRaiseStraight.
  ///
  /// In en, this message translates to:
  /// **'Straight-leg lift for advanced strength.'**
  String get yogaDescLegRaiseStraight;

  /// No description provided for @yogaDescGoddessTwist.
  ///
  /// In en, this message translates to:
  /// **'Wide-leg seated pose for mobility.'**
  String get yogaDescGoddessTwist;

  /// No description provided for @yogaDescGoddessStrength.
  ///
  /// In en, this message translates to:
  /// **'Strengthening variation of seated Goddess.'**
  String get yogaDescGoddessStrength;

  /// No description provided for @yogaDescBackChestStretch.
  ///
  /// In en, this message translates to:
  /// **'L-shape stretch improving upper-body flexibility.'**
  String get yogaDescBackChestStretch;

  /// No description provided for @yogaDescStandingCrunch.
  ///
  /// In en, this message translates to:
  /// **'Dynamic core-strengthening movement.'**
  String get yogaDescStandingCrunch;

  /// No description provided for @yogaDescWarrior3Supported.
  ///
  /// In en, this message translates to:
  /// **'Balance and strength with chair support.'**
  String get yogaDescWarrior3Supported;

  /// No description provided for @yogaDescWarrior1Supported.
  ///
  /// In en, this message translates to:
  /// **'Beginner-friendly Warrior stance.'**
  String get yogaDescWarrior1Supported;

  /// No description provided for @yogaDescWarrior2Supported.
  ///
  /// In en, this message translates to:
  /// **'Side-facing warrior for hip opening.'**
  String get yogaDescWarrior2Supported;

  /// No description provided for @yogaDescTriangleSupported.
  ///
  /// In en, this message translates to:
  /// **'Deep side-body extension.'**
  String get yogaDescTriangleSupported;

  /// No description provided for @yogaDescReverseWarrior2.
  ///
  /// In en, this message translates to:
  /// **'Back-arching warrior stretch.'**
  String get yogaDescReverseWarrior2;

  /// No description provided for @yogaDescSideAngleSupported.
  ///
  /// In en, this message translates to:
  /// **'Strengthens legs and opens ribs.'**
  String get yogaDescSideAngleSupported;

  /// No description provided for @yogaDescGentleBreathing.
  ///
  /// In en, this message translates to:
  /// **'Full-body relaxation and calm breathing.'**
  String get yogaDescGentleBreathing;

  /// No description provided for @yogaDescDownwardDog.
  ///
  /// In en, this message translates to:
  /// **'A foundational inverted V pose that stretches the full body.'**
  String get yogaDescDownwardDog;

  /// No description provided for @yogaDescPlank.
  ///
  /// In en, this message translates to:
  /// **'Full-body strength builder engaging core, arms, and legs.'**
  String get yogaDescPlank;

  /// No description provided for @yogaDescEightPoint.
  ///
  /// In en, this message translates to:
  /// **'Strength-building pose lowering chest, chin, knees and toes.'**
  String get yogaDescEightPoint;

  /// No description provided for @yogaDescBabyCobra.
  ///
  /// In en, this message translates to:
  /// **'Gentle backbend strengthening upper back and spine.'**
  String get yogaDescBabyCobra;

  /// No description provided for @yogaDescFullCobra.
  ///
  /// In en, this message translates to:
  /// **'A stronger chest-opening backbend engaging the whole body.'**
  String get yogaDescFullCobra;

  /// No description provided for @yogaDescSunSalutation.
  ///
  /// In en, this message translates to:
  /// **'A dynamic sequence linking breath and movement. Builds strength, heat, coordination, and stamina.'**
  String get yogaDescSunSalutation;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @poses.
  ///
  /// In en, this message translates to:
  /// **'Poses'**
  String get poses;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensity;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @aboutSession.
  ///
  /// In en, this message translates to:
  /// **'About Session'**
  String get aboutSession;

  /// No description provided for @sessionOverview.
  ///
  /// In en, this message translates to:
  /// **'Session Overview'**
  String get sessionOverview;

  /// No description provided for @joinClass.
  ///
  /// In en, this message translates to:
  /// **'Join Class'**
  String get joinClass;

  /// No description provided for @dayNumber.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String dayNumber(int number);

  /// No description provided for @minsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Mins'**
  String minsLabel(int count);

  /// No description provided for @poseProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String poseProgress(int current, int total);

  /// No description provided for @videoTutorial.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorial'**
  String get videoTutorial;

  /// No description provided for @safetyTips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTips;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Keep your knees slightly bent to avoid joint strain'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Engage your core muscles throughout the pose'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Don\'t force your heels to touch the ground'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'Breathe deeply and avoid holding your breath'**
  String get tip4;

  /// No description provided for @tip5.
  ///
  /// In en, this message translates to:
  /// **'Exit the pose slowly if you feel any pain'**
  String get tip5;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @poseMarkedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pose marked as completed!'**
  String get poseMarkedSuccess;

  /// No description provided for @nextPose.
  ///
  /// In en, this message translates to:
  /// **'Next Pose'**
  String get nextPose;

  /// No description provided for @completeSession.
  ///
  /// In en, this message translates to:
  /// **'Complete Session'**
  String get completeSession;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations!'**
  String get congratulations;

  /// No description provided for @sessionCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'You completed all poses in this session!'**
  String get sessionCompleteDesc;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @progressHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get progressHeader;

  /// No description provided for @progressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your journey to wellness'**
  String get progressSubtitle;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @totalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total Minutes'**
  String get totalMinutes;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @weeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal: {goal} min'**
  String weeklyGoal(int goal);

  /// No description provided for @weeklyBadges.
  ///
  /// In en, this message translates to:
  /// **'Weekly Badges'**
  String get weeklyBadges;

  /// No description provided for @checkedInMsg.
  ///
  /// In en, this message translates to:
  /// **'Checked in this week ✓'**
  String get checkedInMsg;

  /// No description provided for @shareFeeling.
  ///
  /// In en, this message translates to:
  /// **'Share how you\'re feeling'**
  String get shareFeeling;

  /// No description provided for @newCheckIn.
  ///
  /// In en, this message translates to:
  /// **'New Check-in'**
  String get newCheckIn;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @restDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get restDay;

  /// No description provided for @wellnessDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness Check-in'**
  String get wellnessDialogTitle;

  /// No description provided for @wellnessDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get wellnessDialogSubtitle;

  /// No description provided for @qBodyComfort.
  ///
  /// In en, this message translates to:
  /// **'How comfortable does your body feel when doing yoga?'**
  String get qBodyComfort;

  /// No description provided for @qFlexibility.
  ///
  /// In en, this message translates to:
  /// **'How would you rate your flexibility recently?'**
  String get qFlexibility;

  /// No description provided for @qBalance.
  ///
  /// In en, this message translates to:
  /// **'How steady do you feel when standing or balancing?'**
  String get qBalance;

  /// No description provided for @qEnergy.
  ///
  /// In en, this message translates to:
  /// **'How is your overall energy level?'**
  String get qEnergy;

  /// No description provided for @qMood.
  ///
  /// In en, this message translates to:
  /// **'How has your mood been lately?'**
  String get qMood;

  /// No description provided for @qConfidence.
  ///
  /// In en, this message translates to:
  /// **'How confident do you feel doing your daily activities?'**
  String get qConfidence;

  /// No description provided for @qBodyConnection.
  ///
  /// In en, this message translates to:
  /// **'How connected do you feel to your body during yoga practice?'**
  String get qBodyConnection;

  /// No description provided for @qOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall, how have you been feeling in your body and mind?'**
  String get qOverall;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes: '**
  String get notes;

  /// No description provided for @rateAllError.
  ///
  /// In en, this message translates to:
  /// **'Please rate all categories'**
  String get rateAllError;

  /// No description provided for @checkInSaved.
  ///
  /// In en, this message translates to:
  /// **'Wellness check-in saved!'**
  String get checkInSaved;

  /// No description provided for @reflectionHistory.
  ///
  /// In en, this message translates to:
  /// **'Reflection History'**
  String get reflectionHistory;

  /// No description provided for @noReflections.
  ///
  /// In en, this message translates to:
  /// **'No reflections yet'**
  String get noReflections;

  /// No description provided for @platinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get platinum;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @bronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get bronze;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @section1Title.
  ///
  /// In en, this message translates to:
  /// **'Section 1 – Physical Comfort & Mobility'**
  String get section1Title;

  /// No description provided for @section2Title.
  ///
  /// In en, this message translates to:
  /// **'Section 2 – Energy & Mood'**
  String get section2Title;

  /// No description provided for @section3Title.
  ///
  /// In en, this message translates to:
  /// **'Section 3 – Awareness & Confidence'**
  String get section3Title;

  /// No description provided for @section4Title.
  ///
  /// In en, this message translates to:
  /// **'⭐ Overall Wellbeing'**
  String get section4Title;

  /// No description provided for @qBodyComfortFull.
  ///
  /// In en, this message translates to:
  /// **'1️⃣ How comfortable does your body feel during movement?'**
  String get qBodyComfortFull;

  /// No description provided for @optComfort1.
  ///
  /// In en, this message translates to:
  /// **'Not comfortable'**
  String get optComfort1;

  /// No description provided for @optComfort2.
  ///
  /// In en, this message translates to:
  /// **'Slightly comfortable'**
  String get optComfort2;

  /// No description provided for @optComfort3.
  ///
  /// In en, this message translates to:
  /// **'Moderately comfortable'**
  String get optComfort3;

  /// No description provided for @optComfort4.
  ///
  /// In en, this message translates to:
  /// **'Very comfortable'**
  String get optComfort4;

  /// No description provided for @optComfort5.
  ///
  /// In en, this message translates to:
  /// **'Extremely comfortable'**
  String get optComfort5;

  /// No description provided for @qFlexibilityFull.
  ///
  /// In en, this message translates to:
  /// **'2️⃣ How would you describe your flexibility recently?'**
  String get qFlexibilityFull;

  /// No description provided for @optFlexibility1.
  ///
  /// In en, this message translates to:
  /// **'Much stiffer'**
  String get optFlexibility1;

  /// No description provided for @optFlexibility2.
  ///
  /// In en, this message translates to:
  /// **'A little stiff'**
  String get optFlexibility2;

  /// No description provided for @optFlexibility3.
  ///
  /// In en, this message translates to:
  /// **'About the same'**
  String get optFlexibility3;

  /// No description provided for @optFlexibility4.
  ///
  /// In en, this message translates to:
  /// **'A bit more flexible'**
  String get optFlexibility4;

  /// No description provided for @optFlexibility5.
  ///
  /// In en, this message translates to:
  /// **'Much more flexible'**
  String get optFlexibility5;

  /// No description provided for @qBalanceFull.
  ///
  /// In en, this message translates to:
  /// **'3️⃣ How steady do you feel when standing or balancing?'**
  String get qBalanceFull;

  /// No description provided for @optBalance1.
  ///
  /// In en, this message translates to:
  /// **'Not steady at all'**
  String get optBalance1;

  /// No description provided for @optBalance2.
  ///
  /// In en, this message translates to:
  /// **'Slightly steady'**
  String get optBalance2;

  /// No description provided for @optBalance3.
  ///
  /// In en, this message translates to:
  /// **'Moderately steady'**
  String get optBalance3;

  /// No description provided for @optBalance4.
  ///
  /// In en, this message translates to:
  /// **'Very steady'**
  String get optBalance4;

  /// No description provided for @optBalance5.
  ///
  /// In en, this message translates to:
  /// **'Extremely steady'**
  String get optBalance5;

  /// No description provided for @qEnergyFull.
  ///
  /// In en, this message translates to:
  /// **'4️⃣ How is your overall energy level?'**
  String get qEnergyFull;

  /// No description provided for @optEnergy1.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get optEnergy1;

  /// No description provided for @optEnergy2.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get optEnergy2;

  /// No description provided for @optEnergy3.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get optEnergy3;

  /// No description provided for @optEnergy4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get optEnergy4;

  /// No description provided for @optEnergy5.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get optEnergy5;

  /// No description provided for @qMoodFull.
  ///
  /// In en, this message translates to:
  /// **'5️⃣ How has your mood been lately?'**
  String get qMoodFull;

  /// No description provided for @optMood1.
  ///
  /// In en, this message translates to:
  /// **'Often stressed or down'**
  String get optMood1;

  /// No description provided for @optMood2.
  ///
  /// In en, this message translates to:
  /// **'Sometimes stressed'**
  String get optMood2;

  /// No description provided for @optMood3.
  ///
  /// In en, this message translates to:
  /// **'Mostly okay'**
  String get optMood3;

  /// No description provided for @optMood4.
  ///
  /// In en, this message translates to:
  /// **'Mostly positive'**
  String get optMood4;

  /// No description provided for @optMood5.
  ///
  /// In en, this message translates to:
  /// **'Very positive and calm'**
  String get optMood5;

  /// No description provided for @qConfidenceFull.
  ///
  /// In en, this message translates to:
  /// **'6️⃣ How confident do you feel performing daily activities?'**
  String get qConfidenceFull;

  /// No description provided for @optConfidence1.
  ///
  /// In en, this message translates to:
  /// **'Not confident'**
  String get optConfidence1;

  /// No description provided for @optConfidence2.
  ///
  /// In en, this message translates to:
  /// **'Slightly confident'**
  String get optConfidence2;

  /// No description provided for @optConfidence3.
  ///
  /// In en, this message translates to:
  /// **'Somewhat confident'**
  String get optConfidence3;

  /// No description provided for @optConfidence4.
  ///
  /// In en, this message translates to:
  /// **'Confident'**
  String get optConfidence4;

  /// No description provided for @optConfidence5.
  ///
  /// In en, this message translates to:
  /// **'Very confident'**
  String get optConfidence5;

  /// No description provided for @qBodyConnectionFull.
  ///
  /// In en, this message translates to:
  /// **'7️⃣ How connected do you feel to your body during yoga practice?'**
  String get qBodyConnectionFull;

  /// No description provided for @optConnection1.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get optConnection1;

  /// No description provided for @optConnection2.
  ///
  /// In en, this message translates to:
  /// **'A little connected'**
  String get optConnection2;

  /// No description provided for @optConnection3.
  ///
  /// In en, this message translates to:
  /// **'Moderately connected'**
  String get optConnection3;

  /// No description provided for @optConnection4.
  ///
  /// In en, this message translates to:
  /// **'Very connected'**
  String get optConnection4;

  /// No description provided for @optConnection5.
  ///
  /// In en, this message translates to:
  /// **'Deeply connected'**
  String get optConnection5;

  /// No description provided for @qOverallFull.
  ///
  /// In en, this message translates to:
  /// **'8️⃣ Overall, how would you rate your wellbeing this month?'**
  String get qOverallFull;

  /// No description provided for @optOverall1.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get optOverall1;

  /// No description provided for @optOverall2.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get optOverall2;

  /// No description provided for @optOverall3.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get optOverall3;

  /// No description provided for @optOverall4.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get optOverall4;

  /// No description provided for @optOverall5.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get optOverall5;

  /// No description provided for @monthlyReflections.
  ///
  /// In en, this message translates to:
  /// **'💭 Monthly Reflections (Optional)'**
  String get monthlyReflections;

  /// No description provided for @shareImprovements.
  ///
  /// In en, this message translates to:
  /// **'Share specific improvements you\'ve noticed:'**
  String get shareImprovements;

  /// No description provided for @labelBalance.
  ///
  /// In en, this message translates to:
  /// **'🧘 Balance Improvements'**
  String get labelBalance;

  /// No description provided for @hintBalance.
  ///
  /// In en, this message translates to:
  /// **'e.g., I can stand on one leg longer...'**
  String get hintBalance;

  /// No description provided for @labelPosture.
  ///
  /// In en, this message translates to:
  /// **'🪑 Posture Improvements'**
  String get labelPosture;

  /// No description provided for @hintPosture.
  ///
  /// In en, this message translates to:
  /// **'e.g., My back feels straighter...'**
  String get hintPosture;

  /// No description provided for @labelConsistency.
  ///
  /// In en, this message translates to:
  /// **'📅 Consistency & Habits'**
  String get labelConsistency;

  /// No description provided for @hintConsistency.
  ///
  /// In en, this message translates to:
  /// **'e.g., I practice every morning now...'**
  String get hintConsistency;

  /// No description provided for @labelOther.
  ///
  /// In en, this message translates to:
  /// **'💬 Other Thoughts'**
  String get labelOther;

  /// No description provided for @hintOther.
  ///
  /// In en, this message translates to:
  /// **'Any other improvements or notes...'**
  String get hintOther;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @submitCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Submit Check-in'**
  String get submitCheckIn;

  /// No description provided for @validationErrorCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Please answer all required questions before submitting'**
  String get validationErrorCheckIn;

  /// No description provided for @bodyComfort.
  ///
  /// In en, this message translates to:
  /// **'Body Comfort'**
  String get bodyComfort;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @mindBody.
  ///
  /// In en, this message translates to:
  /// **'Mind-Body'**
  String get mindBody;

  /// No description provided for @wellbeing.
  ///
  /// In en, this message translates to:
  /// **'Wellbeing'**
  String get wellbeing;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get moreDetails;

  /// No description provided for @aboutThisSound.
  ///
  /// In en, this message translates to:
  /// **'About This Sound'**
  String get aboutThisSound;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @meditationType.
  ///
  /// In en, this message translates to:
  /// **'Meditation & Relaxation'**
  String get meditationType;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @soundBenefit1.
  ///
  /// In en, this message translates to:
  /// **'• Reduces stress and anxiety'**
  String get soundBenefit1;

  /// No description provided for @soundBenefit2.
  ///
  /// In en, this message translates to:
  /// **'• Improves focus and concentration'**
  String get soundBenefit2;

  /// No description provided for @soundBenefit3.
  ///
  /// In en, this message translates to:
  /// **'• Promotes better sleep'**
  String get soundBenefit3;

  /// No description provided for @soundBenefit4.
  ///
  /// In en, this message translates to:
  /// **'• Enhances overall well-being'**
  String get soundBenefit4;

  /// No description provided for @welcomeBackSounds.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBackSounds;

  /// No description provided for @findYourPeace.
  ///
  /// In en, this message translates to:
  /// **'Find Your Peace'**
  String get findYourPeace;

  /// No description provided for @tabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// No description provided for @tabRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get tabRecent;

  /// No description provided for @tabSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get tabSaved;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tabFavorites;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @noRecentSounds.
  ///
  /// In en, this message translates to:
  /// **'No recent sounds'**
  String get noRecentSounds;

  /// No description provided for @noSavedSounds.
  ///
  /// In en, this message translates to:
  /// **'No saved sounds yet'**
  String get noSavedSounds;

  /// No description provided for @noFavoriteSounds.
  ///
  /// In en, this message translates to:
  /// **'No favorite sounds yet'**
  String get noFavoriteSounds;

  /// No description provided for @savedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get savedSuccess;

  /// No description provided for @removedFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved'**
  String get removedFromSaved;

  /// No description provided for @audioLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load audio. Please try another one.'**
  String get audioLoadError;

  /// No description provided for @soundOceanWaves.
  ///
  /// In en, this message translates to:
  /// **'Ocean Waves'**
  String get soundOceanWaves;

  /// No description provided for @soundForestRain.
  ///
  /// In en, this message translates to:
  /// **'Forest Rain'**
  String get soundForestRain;

  /// No description provided for @soundTibetanBowls.
  ///
  /// In en, this message translates to:
  /// **'Tibetan Bowls'**
  String get soundTibetanBowls;

  /// No description provided for @soundPeacefulPiano.
  ///
  /// In en, this message translates to:
  /// **'Peaceful Piano'**
  String get soundPeacefulPiano;

  /// No description provided for @soundMountainStream.
  ///
  /// In en, this message translates to:
  /// **'Mountain Stream'**
  String get soundMountainStream;

  /// No description provided for @soundWindChimes.
  ///
  /// In en, this message translates to:
  /// **'Wind Chimes'**
  String get soundWindChimes;

  /// No description provided for @soundGentleThunder.
  ///
  /// In en, this message translates to:
  /// **'Gentle Thunder'**
  String get soundGentleThunder;

  /// No description provided for @soundSingingBirds.
  ///
  /// In en, this message translates to:
  /// **'Singing Birds'**
  String get soundSingingBirds;

  /// No description provided for @categoryNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get categoryNature;

  /// No description provided for @categoryMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get categoryMeditation;

  /// No description provided for @categoryAmbient.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get categoryAmbient;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily 🔥'**
  String get daily;

  /// No description provided for @streakSummary.
  ///
  /// In en, this message translates to:
  /// **'Streak Summary'**
  String get streakSummary;

  /// No description provided for @weeklyActive.
  ///
  /// In en, this message translates to:
  /// **'Weekly Active Weeks'**
  String get weeklyActive;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated'**
  String get photoUpdated;

  /// No description provided for @photoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Profile image removed'**
  String get photoRemoved;

  /// No description provided for @photoFail.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get photoFail;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @experienceLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get experienceLevel;

  /// No description provided for @sessionLength.
  ///
  /// In en, this message translates to:
  /// **'Session Length'**
  String get sessionLength;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushEnabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Push notifications enabled! 🔔'**
  String get pushEnabledMsg;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Practice Reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderEnabled.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder Enabled!'**
  String get dailyReminderEnabled;

  /// No description provided for @dailyEnabledMsg.
  ///
  /// In en, this message translates to:
  /// **'We will remind you every day to practice. 🌞'**
  String get dailyEnabledMsg;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @dailyReminderNotification.
  ///
  /// In en, this message translates to:
  /// **'Daily Practice Reminder'**
  String get dailyReminderNotification;

  /// No description provided for @dailyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your daily session! 🏃‍♀️'**
  String get dailyReminderBody;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// No description provided for @appVolume.
  ///
  /// In en, this message translates to:
  /// **'App Volume'**
  String get appVolume;

  /// No description provided for @systemVolume.
  ///
  /// In en, this message translates to:
  /// **'System Volume'**
  String get systemVolume;

  /// No description provided for @appVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjusts volume for sounds in this app'**
  String get appVolumeDesc;

  /// No description provided for @systemVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjusts your device system volume'**
  String get systemVolumeDesc;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Name and age are required'**
  String get validationError;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @min5.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get min5;

  /// No description provided for @min10.
  ///
  /// In en, this message translates to:
  /// **'10 minutes'**
  String get min10;

  /// No description provided for @min15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get min15;

  /// No description provided for @min20.
  ///
  /// In en, this message translates to:
  /// **'20 minutes'**
  String get min20;

  /// No description provided for @min30.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get min30;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @mandarin.
  ///
  /// In en, this message translates to:
  /// **'Mandarin'**
  String get mandarin;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get sessionComplete;

  /// No description provided for @completedPosesCount.
  ///
  /// In en, this message translates to:
  /// **'You completed {count} poses!'**
  String completedPosesCount(int count);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'TOTAL TIME'**
  String get totalTime;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @aboutThisPose.
  ///
  /// In en, this message translates to:
  /// **'About this pose'**
  String get aboutThisPose;

  /// No description provided for @exitSession.
  ///
  /// In en, this message translates to:
  /// **'Exit Session?'**
  String get exitSession;

  /// No description provided for @exitSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress will not be saved if you exit now. Are you sure?'**
  String get exitSessionMessage;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

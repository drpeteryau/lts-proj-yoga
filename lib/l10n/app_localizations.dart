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
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
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

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link'**
  String get resetPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent! Check your email 📧'**
  String get resetLinkSent;

  /// No description provided for @resetLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset link: {error}'**
  String resetLinkFailed(String error);

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get invalidCredentials;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email before logging in. Check your inbox.'**
  String get emailNotVerified;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email. Please register first.'**
  String get accountNotFound;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many login attempts. Please try again later.'**
  String get tooManyAttempts;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unknownError;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please log in instead.'**
  String get emailAlreadyExists;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please follow the requirements.'**
  String get weakPassword;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

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

  /// No description provided for @navMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get navMeditation;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Find Your Inner Peace'**
  String get appTagline;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon!'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening!'**
  String get goodEvening;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @findYourPeace.
  ///
  /// In en, this message translates to:
  /// **'Find Your Peace'**
  String get findYourPeace;

  /// No description provided for @calmingSounds.
  ///
  /// In en, this message translates to:
  /// **'Calming sounds for your wellness'**
  String get calmingSounds;

  /// No description provided for @listenNow.
  ///
  /// In en, this message translates to:
  /// **'Listen Now'**
  String get listenNow;

  /// No description provided for @yogaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect for those just starting their yoga journey'**
  String get yogaSubtitle;

  /// No description provided for @joinNow.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get joinNow;

  /// No description provided for @wellnessOverview.
  ///
  /// In en, this message translates to:
  /// **'Wellness Overview'**
  String get wellnessOverview;

  /// No description provided for @haveANiceDay.
  ///
  /// In en, this message translates to:
  /// **'Have a nice day!'**
  String get haveANiceDay;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @todaysPractice.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Practice'**
  String get todaysPractice;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @ambient.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get ambient;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String daysCount(int count);

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesCount(int count);

  /// No description provided for @beginYour.
  ///
  /// In en, this message translates to:
  /// **'Begin Your'**
  String get beginYour;

  /// No description provided for @wellnessJourney.
  ///
  /// In en, this message translates to:
  /// **'Wellness Journey'**
  String get wellnessJourney;

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

  /// No description provided for @completeSessionsToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} more sessions to unlock'**
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

  /// No description provided for @enterPasscodeHint.
  ///
  /// In en, this message translates to:
  /// **'Admin Passcode 🔐'**
  String get enterPasscodeHint;

  /// No description provided for @moreInfo.
  ///
  /// In en, this message translates to:
  /// **'More Info'**
  String get moreInfo;

  /// No description provided for @enterPinCode.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN Code'**
  String get enterPinCode;

  /// No description provided for @pinInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit code to watch videos'**
  String get pinInstructions;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @backdoorAccess.
  ///
  /// In en, this message translates to:
  /// **'Backdoor Access'**
  String get backdoorAccess;

  /// No description provided for @backdoorAdminMsg.
  ///
  /// In en, this message translates to:
  /// **'You have admin access to change the video PIN.'**
  String get backdoorAdminMsg;

  /// No description provided for @backdoorPathInstructions.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Settings to change the PIN code.'**
  String get backdoorPathInstructions;

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

  /// No description provided for @yogaInstHeadNeck.
  ///
  /// In en, this message translates to:
  /// **'Tilt head up/down for 5–10 breaths each. Turn head right/left 3 rounds. Drop ear to shoulder with light hand support.'**
  String get yogaInstHeadNeck;

  /// No description provided for @yogaInstStraightArms.
  ///
  /// In en, this message translates to:
  /// **'Make fists, rotate straight arms 10 times forward and 10 times backward.'**
  String get yogaInstStraightArms;

  /// No description provided for @yogaInstBentArms.
  ///
  /// In en, this message translates to:
  /// **'Touch elbows in front, circle up behind head and back down. 10 rounds each direction.'**
  String get yogaInstBentArms;

  /// No description provided for @yogaInstShouldersLateral.
  ///
  /// In en, this message translates to:
  /// **'Drop right hand to chair, lift left arm overhead. Hold 5–10 breaths. Switch sides.'**
  String get yogaInstShouldersLateral;

  /// No description provided for @yogaInstShouldersTorsoTwist.
  ///
  /// In en, this message translates to:
  /// **'Lift arms, rotate torso right, hold chair for support. Hold 5–10 breaths each side.'**
  String get yogaInstShouldersTorsoTwist;

  /// No description provided for @yogaInstLegRaiseBent.
  ///
  /// In en, this message translates to:
  /// **'Lift bent leg with back straight. Hold, lower with control. Switch legs.'**
  String get yogaInstLegRaiseBent;

  /// No description provided for @yogaInstLegRaiseStraight.
  ///
  /// In en, this message translates to:
  /// **'Lift straightened leg, hold as long as possible. Release and switch legs.'**
  String get yogaInstLegRaiseStraight;

  /// No description provided for @yogaInstGoddessTwist.
  ///
  /// In en, this message translates to:
  /// **'Open knees wide, stretch torso to side. Hold 5–10 breaths, switch side.'**
  String get yogaInstGoddessTwist;

  /// No description provided for @yogaInstGoddessStrength.
  ///
  /// In en, this message translates to:
  /// **'Lift thighs off chair while in Goddess stance. Hold 5–10 breaths. Repeat.'**
  String get yogaInstGoddessStrength;

  /// No description provided for @yogaInstBackChestStretch.
  ///
  /// In en, this message translates to:
  /// **'Hold chair, hinge into L-shape, keep back flat. Hold 5–10 breaths.'**
  String get yogaInstBackChestStretch;

  /// No description provided for @yogaInstStandingCrunch.
  ///
  /// In en, this message translates to:
  /// **'From L-shape, extend leg back on inhale, crunch knee forward on exhale. Repeat.'**
  String get yogaInstStandingCrunch;

  /// No description provided for @yogaInstWarrior3.
  ///
  /// In en, this message translates to:
  /// **'Lift hand off chair, hold balance. Switch legs and repeat.'**
  String get yogaInstWarrior3;

  /// No description provided for @yogaInstWarrior1.
  ///
  /// In en, this message translates to:
  /// **'Step back, bend front knee, raise arms. Hold 5–10 breaths.'**
  String get yogaInstWarrior1;

  /// No description provided for @yogaInstWarrior2.
  ///
  /// In en, this message translates to:
  /// **'Turn toes outward, stretch arms, look forward. Hold.'**
  String get yogaInstWarrior2;

  /// No description provided for @yogaInstTriangle.
  ///
  /// In en, this message translates to:
  /// **'Straighten front leg, lower hand to ankle or block, reach upward.'**
  String get yogaInstTriangle;

  /// No description provided for @yogaInstReverseWarrior.
  ///
  /// In en, this message translates to:
  /// **'Sweep top arm overhead while leaning back. Hold.'**
  String get yogaInstReverseWarrior;

  /// No description provided for @yogaInstSideAngle.
  ///
  /// In en, this message translates to:
  /// **'Lower hand inside foot, stretch upper arm diagonally overhead.'**
  String get yogaInstSideAngle;

  /// No description provided for @yogaInstGentleBreathing.
  ///
  /// In en, this message translates to:
  /// **'Relax shoulders, place hands on lap, breathe slowly through the nose.'**
  String get yogaInstGentleBreathing;

  /// No description provided for @yogaInstDownwardDog.
  ///
  /// In en, this message translates to:
  /// **'Place hands shoulder-width apart, feet hip-width apart. Lift hips high, press chest towards thighs. Hold 5–10 breaths.'**
  String get yogaInstDownwardDog;

  /// No description provided for @yogaInstPlank.
  ///
  /// In en, this message translates to:
  /// **'Stack shoulders over wrists, engage core, lengthen from head to heels. Hold 5–10 breaths.'**
  String get yogaInstPlank;

  /// No description provided for @yogaInstEightPoint.
  ///
  /// In en, this message translates to:
  /// **'From tabletop, lower chest and chin to mat while hips stay lifted. Hold 5–10 breaths.'**
  String get yogaInstEightPoint;

  /// No description provided for @yogaInstBabyCobra.
  ///
  /// In en, this message translates to:
  /// **'From prone, press chest up lightly, keep elbows close and shoulders away from ears. Hold 5–10 breaths.'**
  String get yogaInstBabyCobra;

  /// No description provided for @yogaInstFullCobra.
  ///
  /// In en, this message translates to:
  /// **'Straighten elbows, lift chest higher without scrunching shoulders. Hold 5–10 breaths.'**
  String get yogaInstFullCobra;

  /// No description provided for @yogaInstGentleBreathingIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Place hands on belly or lap, relax shoulders, breathe through the nose slowly and naturally.'**
  String get yogaInstGentleBreathingIntermediate;

  /// No description provided for @yogaInstSunSalutation.
  ///
  /// In en, this message translates to:
  /// **'This flowing sequence repeats continuously — one breath per movement.\n 1. Inhale — Downward Dog\n Lift hips high, lengthen spine.\n 2. Exhale — Plank\n Shift forward into strong plank position.\n 3. Inhale — Knees-Chest-Chin (Eight-Point Pose)\n Lower down with control, hips lifted.\n 4. Exhale — Baby Cobra\n Lift chest gently, elbows close.\n 5. Inhale — Full Cobra\n Straighten arms slightly, open chest.\n 6. Exhale — Return to Downward Dog\n Press back into inverted V-shape.\n Repeat for 5–10 rounds or to your ability level.'**
  String get yogaInstSunSalutation;

  /// No description provided for @yogaGentleBreathingAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Breathe softly through the nose, lengthening exhales. Allow the entire body to settle and cool down.'**
  String get yogaGentleBreathingAdvanced;

  /// No description provided for @yogaModMoveSlowly.
  ///
  /// In en, this message translates to:
  /// **'Move slowly'**
  String get yogaModMoveSlowly;

  /// No description provided for @yogaModStopDizzy.
  ///
  /// In en, this message translates to:
  /// **'Stop if dizzy'**
  String get yogaModStopDizzy;

  /// No description provided for @yogaModChairSupport.
  ///
  /// In en, this message translates to:
  /// **'Use chair back for support'**
  String get yogaModChairSupport;

  /// No description provided for @yogaModElbowsStraight.
  ///
  /// In en, this message translates to:
  /// **'Keep elbows straight'**
  String get yogaModElbowsStraight;

  /// No description provided for @yogaModControlledMove.
  ///
  /// In en, this message translates to:
  /// **'Smooth controlled movement'**
  String get yogaModControlledMove;

  /// No description provided for @yogaModFingersShoulders.
  ///
  /// In en, this message translates to:
  /// **'Keep fingers on shoulders'**
  String get yogaModFingersShoulders;

  /// No description provided for @yogaModSlowRolls.
  ///
  /// In en, this message translates to:
  /// **'Slow controlled rolls'**
  String get yogaModSlowRolls;

  /// No description provided for @yogaModButtocksDown.
  ///
  /// In en, this message translates to:
  /// **'Keep buttocks down'**
  String get yogaModButtocksDown;

  /// No description provided for @yogaModFaceForward.
  ///
  /// In en, this message translates to:
  /// **'Face forward'**
  String get yogaModFaceForward;

  /// No description provided for @yogaModHipsStable.
  ///
  /// In en, this message translates to:
  /// **'Keep hips stable'**
  String get yogaModHipsStable;

  /// No description provided for @yogaModShouldersLevel.
  ///
  /// In en, this message translates to:
  /// **'Keep shoulders level'**
  String get yogaModShouldersLevel;

  /// No description provided for @yogaModBackStraight.
  ///
  /// In en, this message translates to:
  /// **'Keep back straight'**
  String get yogaModBackStraight;

  /// No description provided for @yogaModBeginBent.
  ///
  /// In en, this message translates to:
  /// **'Begin with bent-knee version'**
  String get yogaModBeginBent;

  /// No description provided for @yogaModUseChairForSupport.
  ///
  /// In en, this message translates to:
  /// **'Use chair for support'**
  String get yogaModUseChairForSupport;

  /// No description provided for @yogaModKneesToes.
  ///
  /// In en, this message translates to:
  /// **'Align knees with toes'**
  String get yogaModKneesToes;

  /// No description provided for @yogaModHipsGrounded.
  ///
  /// In en, this message translates to:
  /// **'Keep hips grounded'**
  String get yogaModHipsGrounded;

  /// No description provided for @yogaModTorsoUpright.
  ///
  /// In en, this message translates to:
  /// **'Keep torso upright'**
  String get yogaModTorsoUpright;

  /// No description provided for @yogaModChairBalance.
  ///
  /// In en, this message translates to:
  /// **'Use chair for balance'**
  String get yogaModChairBalance;

  /// No description provided for @yogaModArmsLegsStraight.
  ///
  /// In en, this message translates to:
  /// **'Keep arms and legs straight'**
  String get yogaModArmsLegsStraight;

  /// No description provided for @yogaModEngageCore.
  ///
  /// In en, this message translates to:
  /// **'Engage core'**
  String get yogaModEngageCore;

  /// No description provided for @yogaModAvoidPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Avoid during pregnancy'**
  String get yogaModAvoidPregnancy;

  /// No description provided for @yogaModOneHandChair.
  ///
  /// In en, this message translates to:
  /// **'Keep one hand on chair'**
  String get yogaModOneHandChair;

  /// No description provided for @yogaModStraightLine.
  ///
  /// In en, this message translates to:
  /// **'Maintain a straight line'**
  String get yogaModStraightLine;

  /// No description provided for @yogaModShortenStance.
  ///
  /// In en, this message translates to:
  /// **'Shorten stance'**
  String get yogaModShortenStance;

  /// No description provided for @yogaModSquareHips.
  ///
  /// In en, this message translates to:
  /// **'Square hips'**
  String get yogaModSquareHips;

  /// No description provided for @yogaModLevelShoulders.
  ///
  /// In en, this message translates to:
  /// **'Level shoulders'**
  String get yogaModLevelShoulders;

  /// No description provided for @yogaModUseBlock.
  ///
  /// In en, this message translates to:
  /// **'Use block'**
  String get yogaModUseBlock;

  /// No description provided for @yogaModHipsForward.
  ///
  /// In en, this message translates to:
  /// **'Keep hips forward'**
  String get yogaModHipsForward;

  /// No description provided for @yogaModFrontKneeBent.
  ///
  /// In en, this message translates to:
  /// **'Keep front knee bent'**
  String get yogaModFrontKneeBent;

  /// No description provided for @yogaModGazeDirection.
  ///
  /// In en, this message translates to:
  /// **'Choose gaze direction'**
  String get yogaModGazeDirection;

  /// No description provided for @yogaModTuckTailbone.
  ///
  /// In en, this message translates to:
  /// **'Tuck tailbone slightly'**
  String get yogaModTuckTailbone;

  /// No description provided for @yogaModSitOrLieDown.
  ///
  /// In en, this message translates to:
  /// **'Sit or lie down'**
  String get yogaModSitOrLieDown;

  /// No description provided for @yogaModCloseEyesIfComfortable.
  ///
  /// In en, this message translates to:
  /// **'Close eyes if comfortable'**
  String get yogaModCloseEyesIfComfortable;

  /// No description provided for @yogaModBendKnees.
  ///
  /// In en, this message translates to:
  /// **'Bend knees if hamstrings are tight'**
  String get yogaModBendKnees;

  /// No description provided for @yogaModHeelsLifted.
  ///
  /// In en, this message translates to:
  /// **'Practice with heels lifted'**
  String get yogaModHeelsLifted;

  /// No description provided for @yogaModLowerKnees.
  ///
  /// In en, this message translates to:
  /// **'Lower knees for a gentler version'**
  String get yogaModLowerKnees;

  /// No description provided for @yogaModFeetTogether.
  ///
  /// In en, this message translates to:
  /// **'Feet together for added challenge'**
  String get yogaModFeetTogether;

  /// No description provided for @yogaModSlowControl.
  ///
  /// In en, this message translates to:
  /// **'Lower with slow control to protect shoulders'**
  String get yogaModSlowControl;

  /// No description provided for @yogaModLiftPalms.
  ///
  /// In en, this message translates to:
  /// **'Lift palms for challenge'**
  String get yogaModLiftPalms;

  /// No description provided for @yogaModPressFeet.
  ///
  /// In en, this message translates to:
  /// **'Press feet down for stability'**
  String get yogaModPressFeet;

  /// No description provided for @yogaModNoLockElbows.
  ///
  /// In en, this message translates to:
  /// **'Do not lock elbows'**
  String get yogaModNoLockElbows;

  /// No description provided for @yogaModTuckStomach.
  ///
  /// In en, this message translates to:
  /// **'Tuck stomach slightly for spine support'**
  String get yogaModTuckStomach;

  /// No description provided for @yogaModRestChildPose.
  ///
  /// In en, this message translates to:
  /// **'Rest in Child’s Pose between rounds if needed'**
  String get yogaModRestChildPose;

  /// No description provided for @yogaModSlowTransitions.
  ///
  /// In en, this message translates to:
  /// **'Slow down transitions if breath becomes strained'**
  String get yogaModSlowTransitions;

  /// No description provided for @yogaModBendDownwardDog.
  ///
  /// In en, this message translates to:
  /// **'Bend knees in Downward Dog for comfort'**
  String get yogaModBendDownwardDog;

  /// No description provided for @yogaModSitOrLie.
  ///
  /// In en, this message translates to:
  /// **'Sit upright or lie flat'**
  String get yogaModSitOrLie;

  /// No description provided for @yogaModCushionUnderKnees.
  ///
  /// In en, this message translates to:
  /// **'Place cushion under knees'**
  String get yogaModCushionUnderKnees;

  /// No description provided for @sessionLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get sessionLevelLabel;

  /// No description provided for @sessionTotalTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get sessionTotalTimeLabel;

  /// No description provided for @sessionTotalPosesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Poses'**
  String get sessionTotalPosesLabel;

  /// No description provided for @aboutThisSession.
  ///
  /// In en, this message translates to:
  /// **'About this Session'**
  String get aboutThisSession;

  /// No description provided for @posesPreview.
  ///
  /// In en, this message translates to:
  /// **'Poses Preview'**
  String get posesPreview;

  /// No description provided for @posesCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} poses completed'**
  String posesCompletedCount(int completed, int total);

  /// No description provided for @practiceAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice Again'**
  String get practiceAgain;

  /// No description provided for @posesLabel.
  ///
  /// In en, this message translates to:
  /// **'poses'**
  String get posesLabel;

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

  /// No description provided for @completeCurrentPoseFirst.
  ///
  /// In en, this message translates to:
  /// **'Please complete the current pose first!'**
  String get completeCurrentPoseFirst;

  /// No description provided for @poseComplete.
  ///
  /// In en, this message translates to:
  /// **'Pose Complete!'**
  String get poseComplete;

  /// No description provided for @greatWorkChoice.
  ///
  /// In en, this message translates to:
  /// **'Great work! What would you like to do next?'**
  String get greatWorkChoice;

  /// No description provided for @retryPose.
  ///
  /// In en, this message translates to:
  /// **'Repeat Pose'**
  String get retryPose;

  /// No description provided for @nextPose.
  ///
  /// In en, this message translates to:
  /// **'Next Pose'**
  String get nextPose;

  /// No description provided for @finishSession.
  ///
  /// In en, this message translates to:
  /// **'Finish Session'**
  String get finishSession;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get sessionComplete;

  /// No description provided for @completedPoses.
  ///
  /// In en, this message translates to:
  /// **'{count} poses completed'**
  String completedPoses(int count);

  /// No description provided for @totalMinutesSpent.
  ///
  /// In en, this message translates to:
  /// **'You practiced for {value} {unit}'**
  String totalMinutesSpent(int value, String unit);

  /// No description provided for @totaltime.
  ///
  /// In en, this message translates to:
  /// **'Total Time:'**
  String get totaltime;

  /// No description provided for @howToPose.
  ///
  /// In en, this message translates to:
  /// **'How to do this pose'**
  String get howToPose;

  /// No description provided for @sessionPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Session Poses'**
  String get sessionPlaylist;

  /// No description provided for @playing.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playing;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @waitingForPin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for PIN...'**
  String get waitingForPin;

  /// No description provided for @exitSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Session?'**
  String get exitSessionTitle;

  /// No description provided for @posesCompletedInfo.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} poses completed'**
  String posesCompletedInfo(int completed, int total);

  /// No description provided for @progressSaved.
  ///
  /// In en, this message translates to:
  /// **'Progress saved ✓'**
  String get progressSaved;

  /// No description provided for @continueLater.
  ///
  /// In en, this message translates to:
  /// **'You can continue from where you left off anytime!'**
  String get continueLater;

  /// No description provided for @noPosesCompleted.
  ///
  /// In en, this message translates to:
  /// **'No poses completed yet'**
  String get noPosesCompleted;

  /// No description provided for @completeOneToSave.
  ///
  /// In en, this message translates to:
  /// **'Complete at least one pose to save your progress.'**
  String get completeOneToSave;

  /// No description provided for @stayButton.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stayButton;

  /// No description provided for @playbackNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get playbackNormal;

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

  /// No description provided for @poseDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Pose Details'**
  String get poseDetailTitle;

  /// No description provided for @howToDoTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Do This Pose'**
  String get howToDoTitle;

  /// No description provided for @learningNotice.
  ///
  /// In en, this message translates to:
  /// **'This is for learning only. To track progress, use \"Join Class\" from the session screen.'**
  String get learningNotice;

  /// No description provided for @poseCurrentCount.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String poseCurrentCount(int current, int total);

  /// No description provided for @durationFormat.
  ///
  /// In en, this message translates to:
  /// **'{minutes}:{seconds} min'**
  String durationFormat(int minutes, String seconds);

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @activitySummary.
  ///
  /// In en, this message translates to:
  /// **'Activity Summary'**
  String get activitySummary;

  /// No description provided for @totalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get totalMinutes;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @dailyMinutes.
  ///
  /// In en, this message translates to:
  /// **'Daily Minutes'**
  String get dailyMinutes;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @nothingTracked.
  ///
  /// In en, this message translates to:
  /// **'Nothing tracked yet'**
  String get nothingTracked;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @ofGoal.
  ///
  /// In en, this message translates to:
  /// **'of {goal} min'**
  String ofGoal(int goal);

  /// No description provided for @weeklyBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get weeklyBadges;

  /// No description provided for @wellnessCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Wellness Check-In'**
  String get wellnessCheckIn;

  /// No description provided for @checkedInThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Checked in this week ✓'**
  String get checkedInThisWeek;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @checkInButton.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkInButton;

  /// No description provided for @historyButton.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyButton;

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

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes: '**
  String get notes;

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

  /// No description provided for @meditationHeader.
  ///
  /// In en, this message translates to:
  /// **'Meditation & Sounds'**
  String get meditationHeader;

  /// No description provided for @quickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStart;

  /// No description provided for @guidedMeditationSection.
  ///
  /// In en, this message translates to:
  /// **'Guided Meditations'**
  String get guidedMeditationSection;

  /// No description provided for @ambientSoundsSection.
  ///
  /// In en, this message translates to:
  /// **'Ambient Sounds'**
  String get ambientSoundsSection;

  /// No description provided for @ambientSoundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real nature sounds to help you relax'**
  String get ambientSoundsSubtitle;

  /// No description provided for @morningClarityTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning Clarity'**
  String get morningClarityTitle;

  /// No description provided for @morningClarityDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your day with calm intention'**
  String get morningClarityDesc;

  /// No description provided for @deepBreathingTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Breathing'**
  String get deepBreathingTitle;

  /// No description provided for @deepBreathingDesc.
  ///
  /// In en, this message translates to:
  /// **'Reduce stress with focused breath'**
  String get deepBreathingDesc;

  /// No description provided for @eveningWindDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening Wind Down'**
  String get eveningWindDownTitle;

  /// No description provided for @eveningWindDownDesc.
  ///
  /// In en, this message translates to:
  /// **'Release the day and prepare for rest'**
  String get eveningWindDownDesc;

  /// No description provided for @oceanWavesTitle.
  ///
  /// In en, this message translates to:
  /// **'Ocean Waves'**
  String get oceanWavesTitle;

  /// No description provided for @oceanWavesDesc.
  ///
  /// In en, this message translates to:
  /// **'Gentle waves on the shore'**
  String get oceanWavesDesc;

  /// No description provided for @rainSoundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rain Sounds'**
  String get rainSoundsTitle;

  /// No description provided for @rainSoundsDesc.
  ///
  /// In en, this message translates to:
  /// **'Soft rain and thunder'**
  String get rainSoundsDesc;

  /// No description provided for @forestBirdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Forest Birds'**
  String get forestBirdsTitle;

  /// No description provided for @forestBirdsDesc.
  ///
  /// In en, this message translates to:
  /// **'Birds chirping in nature'**
  String get forestBirdsDesc;

  /// No description provided for @cracklingFireTitle.
  ///
  /// In en, this message translates to:
  /// **'Crackling Fire'**
  String get cracklingFireTitle;

  /// No description provided for @cracklingFireDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm fireplace sounds'**
  String get cracklingFireDesc;

  /// No description provided for @whiteNoiseTitle.
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get whiteNoiseTitle;

  /// No description provided for @whiteNoiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Pure white noise for focus'**
  String get whiteNoiseDesc;

  /// No description provided for @flowingWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Flowing Water'**
  String get flowingWaterTitle;

  /// No description provided for @flowingWaterDesc.
  ///
  /// In en, this message translates to:
  /// **'Gentle stream sounds'**
  String get flowingWaterDesc;

  /// No description provided for @windChimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Wind Chimes'**
  String get windChimesTitle;

  /// No description provided for @windChimesDesc.
  ///
  /// In en, this message translates to:
  /// **'Peaceful wind chimes'**
  String get windChimesDesc;

  /// No description provided for @nightCricketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Crickets'**
  String get nightCricketsTitle;

  /// No description provided for @nightCricketsDesc.
  ///
  /// In en, this message translates to:
  /// **'Evening cricket sounds'**
  String get nightCricketsDesc;

  /// No description provided for @meditationHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Meditation'**
  String get meditationHeaderTitle;

  /// No description provided for @meditationHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pause & Breathe'**
  String get meditationHeaderSubtitle;

  /// No description provided for @meditationQuickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start • 5-10 min'**
  String get meditationQuickStart;

  /// No description provided for @meditationAllSection.
  ///
  /// In en, this message translates to:
  /// **'All Meditations'**
  String get meditationAllSection;

  /// No description provided for @meditationCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditationCategoryLabel;

  /// No description provided for @meditationDurationMin.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String meditationDurationMin(int count);

  /// No description provided for @meditationSessionMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning Clarity'**
  String get meditationSessionMorningTitle;

  /// No description provided for @meditationSessionMorningDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your day with calm intention'**
  String get meditationSessionMorningDesc;

  /// No description provided for @meditationSessionBreathingTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Breathing'**
  String get meditationSessionBreathingTitle;

  /// No description provided for @meditationSessionBreathingDesc.
  ///
  /// In en, this message translates to:
  /// **'Reduce stress with focused breath'**
  String get meditationSessionBreathingDesc;

  /// No description provided for @meditationSessionEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening Wind Down'**
  String get meditationSessionEveningTitle;

  /// No description provided for @meditationSessionEveningDesc.
  ///
  /// In en, this message translates to:
  /// **'Release the day and prepare for rest'**
  String get meditationSessionEveningDesc;

  /// No description provided for @soundCategory.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get soundCategory;

  /// No description provided for @meditationPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your session...'**
  String get meditationPreparing;

  /// No description provided for @meditationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get meditationCancel;

  /// No description provided for @meditationEndSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get meditationEndSession;

  /// No description provided for @meditationComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get meditationComplete;

  /// No description provided for @meditationInhale.
  ///
  /// In en, this message translates to:
  /// **'Inhale...'**
  String get meditationInhale;

  /// No description provided for @meditationExhale.
  ///
  /// In en, this message translates to:
  /// **'Exhale...'**
  String get meditationExhale;

  /// No description provided for @meditationHold.
  ///
  /// In en, this message translates to:
  /// **'Hold...'**
  String get meditationHold;

  /// No description provided for @meditationEndTitle.
  ///
  /// In en, this message translates to:
  /// **'End Session?'**
  String get meditationEndTitle;

  /// No description provided for @meditationEndMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end your meditation session?'**
  String get meditationEndMessage;

  /// No description provided for @meditationConfirmEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get meditationConfirmEnd;

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

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
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

  /// No description provided for @signout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signout;

  /// No description provided for @aboutus.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutus;

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

  /// No description provided for @mandarinSimplified.
  ///
  /// In en, this message translates to:
  /// **'Mandarin (Simplified)'**
  String get mandarinSimplified;

  /// No description provided for @mandarinTraditional.
  ///
  /// In en, this message translates to:
  /// **'Mandarin (Traditional)'**
  String get mandarinTraditional;

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

  /// No description provided for @aboutUsTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Zencore'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get appVersion;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @missionStatement.
  ///
  /// In en, this message translates to:
  /// **'Making wellness accessible to everyone through gentle chair yoga, calming meditation, and mindful practice.'**
  String get missionStatement;

  /// No description provided for @projectTeam.
  ///
  /// In en, this message translates to:
  /// **'Project Team'**
  String get projectTeam;

  /// No description provided for @projectSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Project Supervisor'**
  String get projectSupervisor;

  /// No description provided for @developmentTeam.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get developmentTeam;

  /// No description provided for @yogaInstructor.
  ///
  /// In en, this message translates to:
  /// **'Yoga Instructor'**
  String get yogaInstructor;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @featureChairYoga.
  ///
  /// In en, this message translates to:
  /// **'Chair Yoga Sessions'**
  String get featureChairYoga;

  /// No description provided for @featureMeditation.
  ///
  /// In en, this message translates to:
  /// **'Guided Meditation'**
  String get featureMeditation;

  /// No description provided for @featureProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get featureProgress;

  /// No description provided for @featureSounds.
  ///
  /// In en, this message translates to:
  /// **'Calming Sounds'**
  String get featureSounds;

  /// No description provided for @licensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get licensesTitle;

  /// No description provided for @licenseDescription.
  ///
  /// In en, this message translates to:
  /// **'HealYoga is built with open-source software. You can view the full list of licenses below.'**
  String get licenseDescription;

  /// No description provided for @viewLicensesButton.
  ///
  /// In en, this message translates to:
  /// **'View All Licenses'**
  String get viewLicensesButton;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 ZENCORE'**
  String get copyright;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All Rights Reserved'**
  String get allRightsReserved;
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
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

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

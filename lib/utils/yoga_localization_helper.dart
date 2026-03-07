import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class YogaLocalizationHelper {
  // Translate a yoga pose name key to localized text
  static String getPoseName(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (key) {
      // Beginner Warmup - Sitting
      case 'yogaHeadNeckShoulders': return l10n.yogaHeadNeckShoulders;
      case 'yogaStraightArms': return l10n.yogaStraightArms;
      case 'yogaBentArms': return l10n.yogaBentArms;
      case 'yogaShouldersLateral': return l10n.yogaShouldersLateral;
      case 'yogaShouldersTorsoTwist': return l10n.yogaShouldersTorsoTwist;
      case 'yogaLegRaiseBent': return l10n.yogaLegRaiseBent;
      case 'yogaLegRaiseStraight': return l10n.yogaLegRaiseStraight;
      case 'yogaGoddessTwist': return l10n.yogaGoddessTwist;
      case 'yogaGoddessStrength': return l10n.yogaGoddessStrength;
        
      // Beginner Main - Standing
      case 'yogaBackChestStretch': return l10n.yogaBackChestStretch;
      case 'yogaStandingCrunch': return l10n.yogaStandingCrunch;
      case 'yogaWarrior3Supported': return l10n.yogaWarrior3Supported;
      case 'yogaWarrior1Supported': return l10n.yogaWarrior1Supported;
      case 'yogaWarrior2Supported': return l10n.yogaWarrior2Supported;
      case 'yogaTriangleSupported': return l10n.yogaTriangleSupported;
      case 'yogaReverseWarrior2': return l10n.yogaReverseWarrior2;
      case 'yogaSideAngleSupported': return l10n.yogaSideAngleSupported;
        
      // Cooldown
      case 'yogaGentleBreathing': return l10n.yogaGentleBreathing;
        
      // Intermediate
      case 'yogaDownwardDog': return l10n.yogaDownwardDog;
      case 'yogaPlank': return l10n.yogaPlank;
      case 'yogaEightPoint': return l10n.yogaEightPoint;
      case 'yogaBabyCobra': return l10n.yogaBabyCobra;
      case 'yogaFullCobra': return l10n.yogaFullCobra;
        
      // Advanced
      case 'yogaSunSalutation': return l10n.yogaSunSalutation;
        
      default: return key;
    }
  }
  
  // Translate a yoga session title key to localized text
  static String getSessionTitle(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (key) {
      case 'yogaSessionGentleChair': return l10n.yogaSessionGentleChair;
      case 'yogaSessionMorningMobility': return l10n.yogaSessionMorningMobility;
      case 'yogaSessionWarriorSeries': return l10n.yogaSessionWarriorSeries;
      case 'yogaSessionHathaFundamentals': return l10n.yogaSessionHathaFundamentals;
      case 'yogaSessionCoreStrength': return l10n.yogaSessionCoreStrength;
      case 'yogaSessionBackbendFlow': return l10n.yogaSessionBackbendFlow;
      case 'yogaSessionSunSalutation': return l10n.yogaSessionSunSalutation;
      case 'yogaSessionExtendedFlow': return l10n.yogaSessionExtendedFlow;
        
      default: return key;
    }
  }
  
  // Get pose description from key
  static String getPoseDescription(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (key) {
      case 'yogaDescHeadNeck': return l10n.yogaDescHeadNeck;
      case 'yogaDescStraightArms': return l10n.yogaDescStraightArms;
      case 'yogaDescBentArms': return l10n.yogaDescBentArms;
      case 'yogaDescShouldersLateral': return l10n.yogaDescShouldersLateral;
      case 'yogaDescShouldersTorsoTwist': return l10n.yogaDescShouldersTorsoTwist;
      case 'yogaDescLegRaiseBent': return l10n.yogaDescLegRaiseBent;
      case 'yogaDescLegRaiseStraight': return l10n.yogaDescLegRaiseStraight;
      case 'yogaDescGoddessTwist': return l10n.yogaDescGoddessTwist;
      case 'yogaDescGoddessStrength': return l10n.yogaDescGoddessStrength;
      case 'yogaDescBackChestStretch': return l10n.yogaDescBackChestStretch;
      case 'yogaDescStandingCrunch': return l10n.yogaDescStandingCrunch;
      case 'yogaDescWarrior3Supported': return l10n.yogaDescWarrior3Supported;
      case 'yogaDescWarrior1Supported': return l10n.yogaDescWarrior1Supported;
      case 'yogaDescWarrior2Supported': return l10n.yogaDescWarrior2Supported;
      case 'yogaDescTriangleSupported': return l10n.yogaDescTriangleSupported;
      case 'yogaDescReverseWarrior2': return l10n.yogaDescReverseWarrior2;
      case 'yogaDescSideAngleSupported': return l10n.yogaDescSideAngleSupported;
      case 'yogaDescGentleBreathing': return l10n.yogaDescGentleBreathing;
      case 'yogaDescDownwardDog': return l10n.yogaDescDownwardDog;
      case 'yogaDescPlank': return l10n.yogaDescPlank;
      case 'yogaDescEightPoint': return l10n.yogaDescEightPoint;
      case 'yogaDescBabyCobra': return l10n.yogaDescBabyCobra;
      case 'yogaDescFullCobra': return l10n.yogaDescFullCobra;
      case 'yogaDescSunSalutationSession': return l10n.yogaDescSunSalutationSession;

      default: return key;
    }
  }

  // Get session description from key
  static String getSessionDescription(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (key) {
      case 'yogaDescGentleChair': return l10n.yogaDescGentleChair;
      case 'yogaDescMorningMobility': return l10n.yogaDescMorningMobility;
      case 'yogaDescWarriorSeries': return l10n.yogaDescWarriorSeries;
      case 'yogaDescHathaFundamentals': return l10n.yogaDescHathaFundamentals;
      case 'yogaDescCoreStrength': return l10n.yogaDescCoreStrength;
      case 'yogaDescBackbendFlow': return l10n.yogaDescBackbendFlow;
      case 'yogaDescSunSalutationSession': return l10n.yogaDescSunSalutationSession;
      case 'yogaDescExtendedFlow': return l10n.yogaDescExtendedFlow;

      default: return key;
    }
  }

  // Get session level from key
  static String getSessionLevel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (key) {
      case 'Beginner': return l10n.beginner;
      case 'Intermediate': return l10n.intermediate;
      case 'Advanced': return l10n.advanced;

      default: return key;
    }
  }

  // Get pose instruction from key
  static String getPoseInstructions(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (key) {
      case 'yogaInstHeadNeck': return l10n.yogaInstHeadNeck;
      case 'yogaInstStraightArms': return l10n.yogaInstStraightArms;
      case 'yogaInstBentArms': return l10n.yogaInstBentArms;
      case 'yogaInstShouldersLateral': return l10n.yogaInstShouldersLateral;
      case 'yogaInstShouldersTorsoTwist': return l10n.yogaInstShouldersTorsoTwist;
      case 'yogaInstLegRaiseBent': return l10n.yogaInstLegRaiseBent;
      case 'yogaInstLegRaiseStraight': return l10n.yogaInstLegRaiseStraight;
      case 'yogaInstGoddessTwist': return l10n.yogaInstGoddessTwist;
      case 'yogaInstGoddessStrength': return l10n.yogaInstGoddessStrength;
      case 'yogaInstBackChestStretch': return l10n.yogaInstBackChestStretch;
      case 'yogaInstStandingCrunch': return l10n.yogaInstStandingCrunch;
      case 'yogaInstWarrior3': return l10n.yogaInstWarrior3;
      case 'yogaInstWarrior1': return l10n.yogaInstWarrior1;
      case 'yogaInstWarrior2': return l10n.yogaInstWarrior2;
      case 'yogaInstTriangle': return l10n.yogaInstTriangle;
      case 'yogaInstReverseWarrior': return l10n.yogaInstReverseWarrior;
      case 'yogaInstSideAngle': return l10n.yogaInstSideAngle;
      case 'yogaInstGentleBreathing': return l10n.yogaInstGentleBreathing;
      case 'yogaInstDownwardDog': return l10n.yogaInstDownwardDog;
      case 'yogaInstPlank': return l10n.yogaInstPlank;
      case 'yogaInstEightPoint': return l10n.yogaInstEightPoint;
      case 'yogaInstBabyCobra': return l10n.yogaInstBabyCobra;
      case 'yogaInstFullCobra': return l10n.yogaInstFullCobra;
      case 'yogaInstGentleBreathingIntermediate': return l10n.yogaInstGentleBreathingIntermediate;
      case 'yogaInstSunSalutation': return l10n.yogaInstSunSalutation;
      case 'yogaGentleBreathingAdvanced': return l10n.yogaGentleBreathingAdvanced;

      default: return key;
    }
  }

    // Get pose modification from key
  static String getPoseModifications(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (key) {
      case 'yogaModMoveSlowly': return l10n.yogaModMoveSlowly;
      case 'yogaModStopDizzy': return l10n.yogaModStopDizzy;
      case 'yogaModChairSupport': return l10n.yogaModChairSupport;
      case 'yogaModElbowsStraight': return l10n.yogaModElbowsStraight;
      case 'yogaModControlledMove': return l10n.yogaModControlledMove;
      case 'yogaModFingersShoulders': return l10n.yogaModFingersShoulders;
      case 'yogaModSlowRolls': return l10n.yogaModSlowRolls;
      case 'yogaModButtocksDown': return l10n.yogaModButtocksDown;
      case 'yogaModFaceForward': return l10n.yogaModFaceForward;
      case 'yogaModHipsStable': return l10n.yogaModHipsStable;
      case 'yogaModBackStraight': return l10n.yogaModBackStraight;
      case 'yogaModBeginBent': return l10n.yogaModBeginBent;
      case 'yogaModKneesToes': return l10n.yogaModKneesToes;
      case 'yogaModHipsGrounded': return l10n.yogaModHipsGrounded;
      case 'yogaModTorsoUpright': return l10n.yogaModTorsoUpright;
      case 'yogaModChairBalance': return l10n.yogaModChairBalance;
      case 'yogaModArmsLegsStraight': return l10n.yogaModArmsLegsStraight;
      case 'yogaModEngageCore': return l10n.yogaModEngageCore;
      case 'yogaModAvoidPregnancy': return l10n.yogaModAvoidPregnancy;
      case 'yogaModOneHandChair': return l10n.yogaModOneHandChair;
      case 'yogaModStraightLine': return l10n.yogaModStraightLine;
      case 'yogaModShortenStance': return l10n.yogaModShortenStance;
      case 'yogaModSquareHips': return l10n.yogaModSquareHips;
      case 'yogaModShouldersLevel': return l10n.yogaModShouldersLevel;
      case 'yogaModUseBlock': return l10n.yogaModUseBlock;
      case 'yogaModHipsForward': return l10n.yogaModHipsForward;
      case 'yogaModFrontKneeBent': return l10n.yogaModFrontKneeBent;
      case 'yogaModGazeDirection': return l10n.yogaModGazeDirection;
      case 'yogaModTuckTailbone': return l10n.yogaModTuckTailbone;
      case 'yogaModBendKnees': return l10n.yogaModBendKnees;
      case 'yogaModHeelsLifted': return l10n.yogaModHeelsLifted;
      case 'yogaModLowerKnees': return l10n.yogaModLowerKnees;
      case 'yogaModFeetTogether': return l10n.yogaModFeetTogether;
      case 'yogaModSlowControl': return l10n.yogaModSlowControl;
      case 'yogaModLiftPalms': return l10n.yogaModLiftPalms;
      case 'yogaModPressFeet': return l10n.yogaModPressFeet;
      case 'yogaModNoLockElbows': return l10n.yogaModNoLockElbows;
      case 'yogaModTuckStomach': return l10n.yogaModTuckStomach;
      case 'yogaModUseChairForSupport': return l10n.yogaModUseChairForSupport;
      case 'yogaModLevelShoulders': return l10n.yogaModLevelShoulders;
      case 'yogaModRestChildPose': return l10n.yogaModRestChildPose;
      case 'yogaModSlowTransitions': return l10n.yogaModSlowTransitions;
      case 'yogaModBendDownwardDog': return l10n.yogaModBendDownwardDog;
      case 'yogaModSitOrLie': return l10n.yogaModSitOrLie;
      case 'yogaModSitOrLieDown': return l10n.yogaModSitOrLieDown;
      case 'yogaModCushionUnderKnees': return l10n.yogaModCushionUnderKnees;
      case 'yogaModCloseEyesIfComfortable': return l10n.yogaModCloseEyesIfComfortable;

      default: return key;
    }
  }
}
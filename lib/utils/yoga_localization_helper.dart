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
    // return key;
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
}
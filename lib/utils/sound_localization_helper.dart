import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SoundLocalizationHelper {
  // Translate a sound title key to localized text
  static String getSoundTitle(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'soundOceanWaves': return l10n.soundOceanWaves;
      case 'soundForestRain': return l10n.soundForestRain;
      case 'soundTibetanBowls': return l10n.soundTibetanBowls;
      case 'soundPeacefulPiano': return l10n.soundPeacefulPiano;
      case 'soundMountainStream': return l10n.soundMountainStream;
      case 'soundWindChimes': return l10n.soundWindChimes;
      case 'soundGentleThunder': return l10n.soundGentleThunder;
      case 'soundSingingBirds': return l10n.soundSingingBirds;
      default: return key;
    }
  }

  static String getSoundCategory(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'categoryNature': return l10n.categoryNature;
      case 'categoryMeditation': return l10n.categoryMeditation;
      case 'categoryAmbient': return l10n.categoryAmbient;
      default: return key;
    }
  }

  // Helper method to reverse translate from title back to key
  static String getTitleKey(BuildContext context, String? title) {
    if (title == null) return '';
    
    final l10n = AppLocalizations.of(context)!;
    
    // Check each localized title and return the corresponding key
    if (title == l10n.soundOceanWaves) return 'soundOceanWaves';
    if (title == l10n.soundForestRain) return 'soundForestRain';
    if (title == l10n.soundTibetanBowls) return 'soundTibetanBowls';
    if (title == l10n.soundPeacefulPiano) return 'soundPeacefulPiano';
    if (title == l10n.soundMountainStream) return 'soundMountainStream';
    if (title == l10n.soundWindChimes) return 'soundWindChimes';
    if (title == l10n.soundGentleThunder) return 'soundGentleThunder';
    if (title == l10n.soundSingingBirds) return 'soundSingingBirds';
    
    // If no match, return the title as-is (fallback)
    return title;
  }

  static String getCategoryKey(BuildContext context, String? category) {
    if (category == null) return '';
    
    final l10n = AppLocalizations.of(context)!;
    
    // Check each localized category and return the corresponding key
    if (category == l10n.categoryNature) return 'categoryNature';
    if (category == l10n.categoryMeditation) return 'categoryMeditation';
    if (category == l10n.categoryAmbient) return 'categoryAmbient';
    
    // If no match, return the category as-is (fallback)
    return category;
  }
}

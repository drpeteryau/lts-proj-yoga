import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class MeditationLookup {
  final AppLocalizations l10n;

  MeditationLookup(BuildContext context) 
      : l10n = AppLocalizations.of(context)!;

  String getTitle(String key) {
    final Map<String, String> titles = {
      'morningClarity': l10n.morningClarityTitle,
      'deepBreathing': l10n.deepBreathingTitle,
      'eveningWindDown': l10n.eveningWindDownTitle,
      'oceanWaves': l10n.oceanWavesTitle,
      'rainSounds': l10n.rainSoundsTitle,
      'forestBirds': l10n.forestBirdsTitle,
      'cracklingFire': l10n.cracklingFireTitle,
      'whiteNoise': l10n.whiteNoiseTitle,
      'flowingWater': l10n.flowingWaterTitle,
      'windChimes': l10n.windChimesTitle,
      'nightCrickets': l10n.nightCricketsTitle,
    };
    return titles[key] ?? key;
  }

  String getDescription(String key) {
    final Map<String, String> descriptions = {
      'morningClarityDesc': l10n.morningClarityDesc,
      'deepBreathingDesc': l10n.deepBreathingDesc,
      'eveningWindDownDesc': l10n.eveningWindDownDesc,
      'oceanWavesDesc': l10n.oceanWavesDesc,
      'rainSoundsDesc': l10n.rainSoundsDesc,
      'forestBirdsDesc': l10n.forestBirdsDesc,
      'cracklingFireDesc': l10n.cracklingFireDesc,
      'whiteNoiseDesc': l10n.whiteNoiseDesc,
      'flowingWaterDesc': l10n.flowingWaterDesc,
      'windChimesDesc': l10n.windChimesDesc,
      'nightCricketsDesc': l10n.nightCricketsDesc,
    };
    return descriptions[key] ?? key;
  }
}
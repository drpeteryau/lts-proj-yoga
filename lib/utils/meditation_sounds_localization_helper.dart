import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class MeditationLookup {
  final AppLocalizations l10n;

  MeditationLookup(BuildContext context) : l10n = AppLocalizations.of(context)!;

  String _normalizeKey(String key) {
    return key.trim().toLowerCase();
  }

  String getTitle(String key) {
    final normalized = _normalizeKey(key);
    final Map<String, String> titles = {
      'morningclarity': l10n.morningClarityTitle,
      'deepbreathing': l10n.deepBreathingTitle,
      'eveningwinddown': l10n.eveningWindDownTitle,
      'oceanwaves': l10n.oceanWavesTitle,
      'rainsounds': l10n.rainSoundsTitle,
      'forestbirds': l10n.forestBirdsTitle,
      'cracklingfire': l10n.cracklingFireTitle,
      'whitenoise': l10n.whiteNoiseTitle,
      'flowingwater': l10n.flowingWaterTitle,
      'windchimes': l10n.windChimesTitle,
      'nightcrickets': l10n.nightCricketsTitle,
    };
    return titles[normalized] ?? key;
  }

  String getDescription(String key) {
    final normalized = _normalizeKey(key);
    final Map<String, String> descriptions = {
      'morningclaritydesc': l10n.morningClarityDesc,
      'deepbreathingdesc': l10n.deepBreathingDesc,
      'eveningwinddowndesc': l10n.eveningWindDownDesc,
      'oceanwavesdesc': l10n.oceanWavesDesc,
      'rainsoundsdesc': l10n.rainSoundsDesc,
      'forestbirdsdesc': l10n.forestBirdsDesc,
      'cracklingfiredesc': l10n.cracklingFireDesc,
      'whitenoisedesc': l10n.whiteNoiseDesc,
      'flowingwaterdesc': l10n.flowingWaterDesc,
      'windchimesdesc': l10n.windChimesDesc,
      'nightcricketsdesc': l10n.nightCricketsDesc,
    };
    return descriptions[normalized] ?? key;
  }

  String getCategory(String key) {
    final normalized = _normalizeKey(key);
    final Map<String, String> categories = {
      'ambient': l10n.soundCategory,
      'meditation': l10n.meditationCategoryLabel,
    };

    return categories[normalized] ?? _humanizeKey(key);
  }

  /// Converts a camelCase key like `forestBirds` into `Forest Birds`.
  String _humanizeKey(String key) {
    final trimmed = key.trim();
    if (trimmed.isEmpty) return trimmed;

    final spaced = trimmed.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    );

    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}

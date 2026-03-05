import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(String languageCode) {
    if (languageCode == 'Mandarin (Simplified)') {
      _locale = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    }
    else if (languageCode == 'Mandarin (Traditional)') {
      _locale = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    } 
    else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}
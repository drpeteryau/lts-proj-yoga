import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(String languageCode) {
    if (languageCode == 'Mandarin') {
      _locale = const Locale('zh');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}
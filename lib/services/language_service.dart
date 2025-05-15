import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'language';
  final SharedPreferences _prefs;

  LanguageService(this._prefs);

  Locale getLanguage(String userId) {
    final String? languageCode = _prefs.getString('${_languageKey}_$userId');
    return languageCode != null ? Locale(languageCode) : const Locale('en');
  }

  Future<void> setLanguage(String userId, Locale locale) async {
    await _prefs.setString('${_languageKey}_$userId', locale.languageCode);
  }

  static List<Locale> get supportedLocales => const [
    Locale('en'), // English
    Locale('ru'), // Russian
  ];

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return 'English';
    }
  }
} 
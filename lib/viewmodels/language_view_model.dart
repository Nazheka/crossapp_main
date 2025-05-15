import 'package:flutter/material.dart';
import 'package:read_the_label/services/language_service.dart';

class LanguageViewModel extends ChangeNotifier {
  final LanguageService _languageService;
  final String userId;
  Locale _locale;

  LanguageViewModel(this._languageService, this.userId)
      : _locale = _languageService.getLanguage(userId);

  Locale get locale => _locale;

  Future<void> setLanguage(Locale newLocale) async {
    if (LanguageService.supportedLocales.contains(newLocale)) {
      _locale = newLocale;
      await _languageService.setLanguage(userId, newLocale);
      notifyListeners();
    }
  }

  String getCurrentLanguageName() {
    return LanguageService.getLanguageName(_locale.languageCode);
  }

  // Add method to get all available languages
  List<Map<String, String>> get availableLanguages => [
    {'code': 'en', 'name': 'English'},
    {'code': 'ru', 'name': 'Русский'},
  ];
} 
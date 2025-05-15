import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'settings': 'Settings',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'notifications': 'Notifications',
      'profile': 'Profile',
      'privacy': 'Privacy',
      'version': 'Version',
      'termsOfService': 'Terms of Service',
      'privacyPolicy': 'Privacy Policy',
    },
    'ru': {
      'settings': 'Настройки',
      'darkMode': 'Темная тема',
      'language': 'Язык',
      'notifications': 'Уведомления',
      'profile': 'Профиль',
      'privacy': 'Конфиденциальность',
      'version': 'Версия',
      'termsOfService': 'Условия использования',
      'privacyPolicy': 'Политика конфиденциальности',
    },
  };

  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get privacy => _localizedValues[locale.languageCode]!['privacy']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get termsOfService => _localizedValues[locale.languageCode]!['termsOfService']!;
  String get privacyPolicy => _localizedValues[locale.languageCode]!['privacyPolicy']!;
} 
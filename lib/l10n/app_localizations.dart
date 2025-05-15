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
      'security': 'Security',
      'pinCode': 'PIN Code',
      'setPinCode': 'Set PIN Code',
      'enterPinCode': 'Enter PIN Code',
      'confirmPinCode': 'Confirm PIN Code',
      'pinMustBe4Digits': 'PIN must be 4 digits',
      'pinsDoNotMatch': 'PINs do not match',
      'invalidPin': 'Invalid PIN code',
      'pleaseEnter4Digits': 'Please enter 4 digits',
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
      'security': 'Безопасность',
      'pinCode': 'PIN-код',
      'setPinCode': 'Установить PIN-код',
      'enterPinCode': 'Введите PIN-код',
      'confirmPinCode': 'Подтвердите PIN-код',
      'pinMustBe4Digits': 'PIN-код должен содержать 4 цифры',
      'pinsDoNotMatch': 'PIN-коды не совпадают',
      'invalidPin': 'Неверный PIN-код',
      'pleaseEnter4Digits': 'Пожалуйста, введите 4 цифры',
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
  String get security => _localizedValues[locale.languageCode]!['security']!;
  String get pinCode => _localizedValues[locale.languageCode]!['pinCode']!;
  String get setPinCode => _localizedValues[locale.languageCode]!['setPinCode']!;
  String get enterPinCode => _localizedValues[locale.languageCode]!['enterPinCode']!;
  String get confirmPinCode => _localizedValues[locale.languageCode]!['confirmPinCode']!;
  String get pinMustBe4Digits => _localizedValues[locale.languageCode]!['pinMustBe4Digits']!;
  String get pinsDoNotMatch => _localizedValues[locale.languageCode]!['pinsDoNotMatch']!;
  String get invalidPin => _localizedValues[locale.languageCode]!['invalidPin']!;
  String get pleaseEnter4Digits => _localizedValues[locale.languageCode]!['pleaseEnter4Digits']!;
} 
import 'package:flutter/material.dart';
import 'package:read_the_label/models/user_settings.dart';
import 'package:read_the_label/services/user_settings_service.dart';

class UserSettingsViewModel extends ChangeNotifier {
  final UserSettingsService _service;
  final String userId;

  UserSettings _settings = UserSettings.defaultSettings();
  bool _loading = true;

  UserSettings get settings => _settings;
  bool get isDarkMode => _settings.isDarkMode;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get isPrivateAccount => _settings.isPrivateAccount;
  bool get loading => _loading;

  UserSettingsViewModel(this._service, this.userId) {
    load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _settings = await _service.loadSettings(userId);
    _loading = false;
    notifyListeners();
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    _settings = newSettings;
    await _service.saveSettings(userId, newSettings);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    await updateSettings(_settings.copyWith(isDarkMode: !_settings.isDarkMode));
  }

  Future<void> toggleNotifications() async {
    await updateSettings(_settings.copyWith(notificationsEnabled: !_settings.notificationsEnabled));
  }

  Future<void> togglePrivacy() async {
    await updateSettings(_settings.copyWith(isPrivateAccount: !_settings.isPrivateAccount));
  }
} 
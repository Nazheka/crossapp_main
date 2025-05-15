import 'package:flutter/material.dart';
import 'package:read_the_label/services/theme_service.dart';

class ThemeViewModel extends ChangeNotifier {
  final ThemeService _themeService;
  final String userId;
  ThemeMode _themeMode;

  ThemeViewModel(this._themeService, this.userId)
      : _themeMode = _themeService.getThemeMode(userId);

  ThemeMode get themeMode => _themeMode;

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _themeService.setThemeMode(userId, _themeMode);
    notifyListeners();
  }
} 
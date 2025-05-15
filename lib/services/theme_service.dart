import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeService(this._prefs);

  ThemeMode getThemeMode(String userId) {
    final String? themeString = _prefs.getString('${_themeKey}_$userId');
    return themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setThemeMode(String userId, ThemeMode mode) async {
    await _prefs.setString('${_themeKey}_$userId', mode == ThemeMode.dark ? 'dark' : 'light');
  }
} 
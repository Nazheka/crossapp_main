import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_the_label/models/user_settings.dart';

class UserSettingsService {
  static String _key(String userId) => 'user_settings_$userId';

  Future<UserSettings> loadSettings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key(userId));
    if (jsonString == null) {
      return UserSettings.defaultSettings();
    }
    return UserSettings.fromJson(json.decode(jsonString));
  }

  Future<void> saveSettings(String userId, UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(userId), json.encode(settings.toJson()));
  }
} 
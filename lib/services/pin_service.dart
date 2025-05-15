import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  static const String _pinKey = 'app_pin';
  final SharedPreferences _prefs;

  PinService(this._prefs);

  Future<void> setPin(String userId, String pin) async {
    await _prefs.setString('${_pinKey}_$userId', pin);
  }

  String? getPin(String userId) {
    return _prefs.getString('${_pinKey}_$userId');
  }

  Future<void> removePin(String userId) async {
    await _prefs.remove('${_pinKey}_$userId');
  }

  bool hasPin(String userId) {
    return _prefs.containsKey('${_pinKey}_$userId');
  }
} 
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_the_label/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(json.decode(userJson));
  }

  Future<List<User>> getRegisteredUsers() async {
    final usersJson = _prefs.getStringList(_usersKey) ?? [];
    return usersJson.map((json) => User.fromJson(jsonDecode(json))).toList();
  }

  Future<bool> register(String email, String password, String name) async {
    final users = await getRegisteredUsers();
    
    // Check if email already exists
    if (users.any((user) => user.email == email)) {
      return false;
    }

    final newUser = User(
      id: const Uuid().v4(),
      email: email,
      password: password,
      name: name,
    );

    users.add(newUser);
    await _prefs.setStringList(
      _usersKey,
      users.map((user) => jsonEncode(user.toJson())).toList(),
    );

    return true;
  }

  Future<bool> login(String email, String password) async {
    final users = await getRegisteredUsers();
    User? user;
    for (final u in users) {
      if (u.email == email && u.password == password) {
        user = u;
        break;
      }
    }
    if (user == null) return false;
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    return true;
  }

  Future<void> loginAsGuest() async {
    final guestUser = User(
      id: const Uuid().v4(),
      email: 'guest@example.com',
      name: 'Guest User',
      isGuest: true,
    );

    await _prefs.setString(_userKey, jsonEncode(guestUser.toJson()));
  }

  Future<void> logout() async {
    await _prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    return await getCurrentUser() != null;
  }
} 
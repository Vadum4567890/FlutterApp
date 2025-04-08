import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _usernameKey = 'username';
  static String? _currentUser;

  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(username) != null) return false;
    await prefs.setString(username, password);
    return true;
  }

  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedPassword = prefs.getString(username);
    if (storedPassword != null && storedPassword == password) {
      _currentUser = username;
      await prefs.setString(_usernameKey, username);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUser = null;
    await prefs.remove(_usernameKey);
  }

  static Future<String?> get currentUser async {
    if (_currentUser == null) {
      final prefs = await SharedPreferences.getInstance();
      _currentUser = prefs.getString(_usernameKey);
    }
    return _currentUser;
  }
}

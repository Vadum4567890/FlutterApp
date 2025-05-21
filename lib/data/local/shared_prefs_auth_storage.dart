import 'dart:convert';
import 'package:my_project/core/interfaces/auth_storage_interface.dart';
import 'package:my_project/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsAuthStorage implements IAuthStorage {
  static const _usernameKey = 'username';

  @override
  Future<bool> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userMap = user.toMap();

    // Перетворення Map в JSON рядок і збереження в SharedPreferences
    await prefs.setString(user.username, jsonEncode(userMap));  
    return true;
  }

  @override
  Future<User?> getUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final userMapString = prefs.getString(username);

    if (userMapString == null) return null;

    // Перетворення JSON рядка в Map<String, dynamic>
    final userMap = jsonDecode(userMapString) as Map<String, dynamic>;

    return User.fromMap(userMap);  // Викликаємо метод fromMap з правильно типізованим userMap
  }

  @override
  Future<void> saveCurrentUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  @override
  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
  }

  @override
  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }
}

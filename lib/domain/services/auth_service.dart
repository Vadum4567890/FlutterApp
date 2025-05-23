import 'package:my_project/core/interfaces/auth_storage_interface.dart';
import 'package:my_project/models/user.dart';

class AuthService {
  final IAuthStorage _authStorage;

  AuthService(this._authStorage);

  Future<bool> register(String username, String password, String email) async {
    final User user =
        User(username: username, password: password, email: email);
    return await _authStorage.saveUser(user);
  }

  Future<bool> login(String username, String password) async {
    final user = await _authStorage.getUser(username);
    if (user != null && user.password == password) {
      await _authStorage.saveCurrentUser(username);
      return true;
    }
    return false;
  }

  Future<bool> saveUser(User user) async {
    return await _authStorage.saveUser(user);
  }

  Future<void> logout() async {
    await _authStorage.clearCurrentUser();
  }

  Future<String?> getCurrentUser() async {
    return await _authStorage.getCurrentUser();
  }

  static Future<String?> currentUser(IAuthStorage authStorage) async {
    return await authStorage.getCurrentUser();
  }

  Future<User?> getCurrentUserDetails() async {
    final username = await _authStorage.getCurrentUser();
    if (username != null) {
      return await _authStorage.getUser(username);
    }
    return null;
  }

  // Метод для отримання email користувача
  Future<String?> getEmail(String username) async {
    final user = await _authStorage.getUser(username);
    return user?.email;
  }

  Future<bool> changePassword(
      String username, String currentPassword, String newPassword) async {
    final user = await _authStorage.getUser(username);
    if (user != null && user.password == currentPassword) {
      final updatedUser = User(
        username: user.username,
        password: newPassword,
        email: user.email,
      );
      return await _authStorage.saveUser(updatedUser);
    }
    return false;
  }
}

import 'package:my_project/core/interfaces/auth_storage_interface.dart';
import 'package:my_project/models/user.dart';

class AuthService {
  final IAuthStorage _authStorage;

  // Конструктор, що приймає інтерфейс для збереження даних
  AuthService(this._authStorage);

  // Метод для реєстрації користувача
  Future<bool> register(String username, String password, String email) async {
    final User user = User(username: username, password: password, email: email);
    return await _authStorage.saveUser(user);
  }

  // Метод для авторизації користувача
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

  // Метод для виходу користувача
  Future<void> logout() async {
    await _authStorage.clearCurrentUser();
  }

  // Метод для отримання поточного користувача
  Future<String?> getCurrentUser() async {
    return await _authStorage.getCurrentUser();
  }

  // Статичний метод для отримання поточного користувача без створення об'єкта AuthService
  static Future<String?> currentUser(IAuthStorage authStorage) async {
    return await authStorage.getCurrentUser();
  }

  Future<User?> getCurrentUserDetails() async {
    final username = await _authStorage.getCurrentUser();
    if (username != null) {
      return await _authStorage.getUser(username);
    }
    return null;  // Якщо користувач не знайдений
  }

  // Метод для отримання email користувача
  Future<String?> getEmail(String username) async {
    final user = await _authStorage.getUser(username);
    return user?.email;  // Повертає email, якщо користувач знайдений
  }
}

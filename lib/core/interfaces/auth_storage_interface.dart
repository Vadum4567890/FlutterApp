import 'package:my_project/models/user.dart';

abstract class IAuthStorage {
  Future<bool> saveUser(User user);
  Future<User?> getUser(String username);
  Future<void> saveCurrentUser(String username);
  Future<void> clearCurrentUser();
  Future<String?> getCurrentUser();
}

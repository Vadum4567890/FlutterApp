class AuthService {
  static final Map<String, String> _users = {};
  static String? _currentUser;

  static bool register(String username, String password) {
    if (_users.containsKey(username)) return false;
    _users[username] = password;
    return true;
  }

  static bool login(String username, String password) {
    if (_users[username] == password) {
      _currentUser = username;
      return true;
    }
    return false;
  }

  static void logout() {
    _currentUser = null;
  }

  static String? get currentUser => _currentUser;
}

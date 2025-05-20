import 'package:my_project/models/article.dart';
import 'package:my_project/models/device.dart';

class User {
  final String username;
  String password;
  final String email;
  final List<Article>? articles;
  final List<Device>? devices;

  User({
    required this.username,
    required this.password,
    required this.email,
    this.articles,
    this.devices,
  });

  void updatePassword(String newPassword) {
    password = newPassword;
  }

  static User fromMap(Map<String, dynamic> map) {
    final articlesList = (map['articles'] as List<dynamic>?)
        ?.map(
            (articleMap) => Article.fromMap(articleMap as Map<String, dynamic>))
        .toList();

    final devicesList = (map['devices'] as List<dynamic>?)
        ?.map((deviceMap) => Device.fromMap(deviceMap as Map<String, dynamic>))
        .toList();

    return User(
      username: map['username'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      articles: articlesList,
      devices: devicesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'articles': articles?.map((article) => article.toMap()).toList() ?? [],
      'devices': devices?.map((device) => device.toMap()).toList() ?? [],
    };
  }
}

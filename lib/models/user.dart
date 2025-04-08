import 'package:my_project/models/article.dart';

class User {
  final String username;
  String password;
  final String email;
  final List<Article>? articles;

  User({
    required this.username,
    required this.password,
    required this.email,
    this.articles,  
  });

  void updatePassword(String newPassword) {
    password = newPassword;
  }

  static User fromMap(Map<String, dynamic> map) {
    final articlesList = (map['articles'] as List<dynamic>?)?.map((articleMap) => Article.fromMap(articleMap as Map<String, dynamic>)).toList();

    return User(
      username: map['username'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      articles: articlesList,  
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'articles': articles?.map((article) => article.toMap()).toList() ?? [],
    };
  }
}

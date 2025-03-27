import 'package:flutter/material.dart';
import 'package:my_project/screens/article_list_screen.dart';
import 'package:my_project/screens/auth/login_screen.dart';
import 'package:my_project/screens/auth/register_screen.dart';
import 'package:my_project/screens/profile.screen.dart';

void main() {
  runApp(ArticleApp());
}

class ArticleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ArticleListScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => ArticleListScreen(),
      },
    );
  }
}

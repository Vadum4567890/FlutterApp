import 'package:flutter/material.dart';
import 'package:my_project/screens/article_list_screen.dart';
import 'package:my_project/screens/auth/login_screen.dart';
import 'package:my_project/screens/auth/register_screen.dart';
import 'package:my_project/screens/profile.screen.dart';
import 'package:my_project/services/auth_service.dart';

void main() {
  runApp(ArticleApp());
}

class ArticleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<String>(
        future: _getInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final String initialRoute = snapshot.data!;
              return initialRoute == '/login'
                  ? const LoginScreen()
                  : ArticleListScreen();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => ArticleListScreen(),
      },
    );
  }

  Future<String> _getInitialRoute() async {
    final currentUser = await AuthService.currentUser;
    return currentUser == null ? '/login' : '/home';
  }
}

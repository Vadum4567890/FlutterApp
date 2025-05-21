import 'package:flutter/material.dart';
import 'package:my_project/core/interfaces/auth_storage_interface.dart';
import 'package:my_project/data/local/shared_prefs_auth_storage.dart';
import 'package:my_project/domain/services/article_service.dart';
import 'package:my_project/domain/services/auth_service.dart';
import 'package:my_project/domain/services/usb_service.dart';
import 'package:my_project/screens/article_list_screen.dart';
import 'package:my_project/screens/auth/login_screen.dart';
import 'package:my_project/screens/auth/register_screen.dart';
import 'package:my_project/screens/non_found_screen.dart';
import 'package:my_project/screens/profile.screen.dart';
import 'package:my_project/screens/saved_qr_screen.dart';

void main() {
  final IAuthStorage authStorage = SharedPrefsAuthStorage();
  final AuthService authService = AuthService(authStorage);
  final ArticleService articleService = ArticleService();
  final UsbService usbService = UsbService();

  runApp(
    ArticleApp(
      authService: authService,
      articleService: articleService,
      usbService: usbService,
    ),
  );
}

class ArticleApp extends StatelessWidget {
  final AuthService authService;
  final ArticleService articleService;
  final UsbService usbService;
  const ArticleApp({
    required this.authService,
    required this.articleService,
    required this.usbService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<String>(
        future: _getInitialRoute(authService),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final String initialRoute = snapshot.data!;
              return initialRoute == '/login'
                  ? LoginScreen(authService: authService)
                  : ArticleListScreen(
                      authService: authService, articleService: articleService);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(authService: authService),
        '/register': (context) => RegisterScreen(authService: authService),
        '/profile': (context) => ProfileScreen(authService: authService),
        '/home': (context) => ArticleListScreen(
              authService: authService,
              articleService: articleService,
            ),
        '/saved_qr': (context) => SavedQrScreen(usbService: usbService),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const NotFoundScreen(),
      ),
    );
  }

  Future<String> _getInitialRoute(AuthService authService) async {
    final currentUser = await authService.getCurrentUser();
    return currentUser == null ? '/login' : '/home';
  }
}

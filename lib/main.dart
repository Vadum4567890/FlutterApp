import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/di/di.dart' as di;
import 'package:my_project/cubit/article_list/article_cubit.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/screens/article_list_screen.dart';
import 'package:my_project/screens/auth/login_screen.dart';
import 'package:my_project/screens/auth/register_screen.dart';
import 'package:my_project/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ArticleApp());
}

class ArticleApp extends StatelessWidget {
  const ArticleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) => di.sl<AuthCubit>()
              ..checkAuthStatus(),),
        BlocProvider<ArticleCubit>(create: (context) => di.sl<ArticleCubit>()),
        BlocProvider<ProfileCubit>(create: (context) => di.sl<ProfileCubit>()),
      ],
      child: MaterialApp(
        title: 'Articles App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthAuthenticated) {
              return const ArticleListScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/home': (context) => const ArticleListScreen(),
        },
      ),
    );
  }
}

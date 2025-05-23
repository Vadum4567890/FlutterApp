// lib/core/di/di.dart
import 'package:get_it/get_it.dart';
import 'package:my_project/core/interfaces/auth_storage_interface.dart';
import 'package:my_project/cubit/article_list/article_cubit.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/data/local/shared_prefs_auth_storage.dart';
import 'package:my_project/domain/services/article_service.dart';
import 'package:my_project/domain/services/auth_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<IAuthStorage>(SharedPrefsAuthStorage.new);
  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));
  sl.registerLazySingleton<ArticleService>(ArticleService.new);
  sl.registerFactory(() => AuthCubit(authService: sl()));
  sl.registerFactory(
      () => ArticleCubit(articleService: sl(), authService: sl()));
  sl.registerFactory(() => ProfileCubit(authService: sl()));
}

// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/domain/services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final user = await authService.getCurrentUserDetails();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    try {
      final success = await authService.login(username, password);
      if (success) {
        final user = await authService.getCurrentUserDetails();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError('Failed to retrieve user details after login.'));
        }
      } else {
        emit(const AuthError('Login failed. Invalid credentials.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String username, String password, String email) async {
    emit(AuthLoading());
    try {
      final success = await authService.register(username, password, email);
      if (success) {
        emit(AuthUnauthenticated()); // User needs to log in after registration
      } else {
        emit(const AuthError(
            'Registration failed. Username or email might already exist.',),);
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await authService.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> changePassword(
      String currentPassword, String newPassword,) async {
    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;
      emit(AuthLoading());
      try {
        final success = await authService.changePassword(
          currentUser.username,
          currentPassword,
          newPassword,
        );
        if (success) {
          emit(PasswordChangeSuccess(currentUser));
        } else {
          emit(PasswordChangeFailure(currentUser,
              'Failed to change password. Invalid current password or new password policy violation.',),);
        }
      } catch (e) {
        emit(PasswordChangeFailure(
            currentUser, 'Error changing password: ${e.toString()}',),);
      } finally {
        await Future.delayed(const Duration(seconds: 3));
        emit(AuthAuthenticated(currentUser));
      }
    } else {
      emit(const AuthError('User not authenticated. Cannot change password.'));
    }
  }
}

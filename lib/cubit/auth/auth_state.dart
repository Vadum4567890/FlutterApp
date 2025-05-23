import 'package:equatable/equatable.dart';
import 'package:my_project/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class PasswordChangeSuccess extends AuthAuthenticated {
  const PasswordChangeSuccess(super.user);
}

class PasswordChangeFailure extends AuthAuthenticated {
  final String errorMessage;
  const PasswordChangeFailure(super.user, this.errorMessage);
  @override
  List<Object?> get props => [user, errorMessage];
}

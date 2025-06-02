import 'package:equatable/equatable.dart';
import 'package:my_project/models/user.dart';

class ProfileState extends Equatable {
  final User? user;
  final String? passwordError;
  final bool isLoading;

  const ProfileState({
    this.user,
    this.passwordError,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [user, passwordError, isLoading];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial() : super(isLoading: false);
}

class ProfileLoading extends ProfileState {
  const ProfileLoading() : super(isLoading: true);
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(User user, {super.passwordError})
      : super(user: user, isLoading: false);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message) : super(isLoading: false);

  @override
  List<Object?> get props => [message, ...super.props];
}

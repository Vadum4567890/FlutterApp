import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/profile/profile_state.dart';
import 'package:my_project/domain/services/auth_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthService authService;

  ProfileCubit({required this.authService}) : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    try {
      final user = await authService.getCurrentUserDetails();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not logged in or profile not found.'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    emit(ProfileLoading());
    try {
      final user = await authService.getCurrentUserDetails();
      if (user == null) {
        emit(const ProfileError('User not logged in.'));
        return;
      }

      final success = await authService.changePassword(
        user.email,
        currentPassword,
        newPassword,
      );

      if (success) {
        final updatedUser = await authService.getCurrentUserDetails();
        emit(ProfileLoaded(updatedUser!));
      } else {
        emit(const ProfileError('Failed to change password.'));
      }
    } catch (e) {
      emit(ProfileError('Error changing password: ${e.toString()}'));
    }
  }
}

// lib/presentation/profile/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/profile/profile_state.dart';
import 'package:my_project/domain/services/auth_service.dart'; // Profile data comes from AuthService

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
}

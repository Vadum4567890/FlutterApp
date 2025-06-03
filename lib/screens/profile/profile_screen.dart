import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/cubit/profile/profile_state.dart';
import 'package:my_project/widgets/action_button.dart';
import 'package:my_project/widgets/change_password_dialog.dart';
import 'package:my_project/widgets/logout_dialog.dart';
import 'package:my_project/widgets/profile_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ProfileCubit>().loadUserProfile(),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is! ProfileLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  ProfileInfo(user: state.user),
                  const SizedBox(height: 20),
                  ActionButton(
                    text: 'Back to Home',
                    onPressed: () => Navigator.pop(context),
                  ),
                  ActionButton(
                    text: 'Change Password',
                    onPressed: () => _showChangePasswordDialog(context),
                  ),
                  ActionButton(
                    text: 'View Saved QR',
                    onPressed: () => Navigator.pushNamed(context, '/saved_qr'),
                  ),
                  ActionButton(
                    text: 'Logout',
                    isDestructive: true,
                    onPressed: () => showLogoutDialog(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => ChangePasswordDialog(
        onPasswordChange: (current, newPass) =>
            context.read<AuthCubit>().changePassword(current, newPass),
      ),
    );
  }
}

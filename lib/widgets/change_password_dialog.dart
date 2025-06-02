import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/cubit/profile/profile_state.dart';

class ChangePasswordDialog extends StatefulWidget {
  final void Function(String currentPassword, String newPassword)
      onPasswordChange;

  const ChangePasswordDialog({required this.onPasswordChange, super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().validateAndChangePassword(
            _currentPasswordController.text,
            _newPasswordController.text,
            _confirmNewPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded && state.passwordError == null) {
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: _currentPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Current Password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration:
                              const InputDecoration(labelText: 'New Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _confirmNewPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm New Password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        if (state is ProfileLoaded &&
                            state.passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              state.passwordError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state.isLoading
                    ? null
                    : () => _handleChangePassword(context),
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Change'),
              );
            },
          ),
        ],
      ),
    );
  }
}

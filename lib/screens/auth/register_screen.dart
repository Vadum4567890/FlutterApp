import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/widgets/auth_button.dart';
import 'package:my_project/widgets/auth_error_text.dart';
import 'package:my_project/widgets/auth_input_field.dart';
import 'package:my_project/widgets/auth_title.dart';
import 'package:my_project/widgets/gradient_background.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _controllers = {
    'username': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  final _validations = {
    'email': (String email) =>
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email),
    'username': (String username) =>
        RegExp(r'^[a-zA-Z0-9]{4,}$').hasMatch(username),
    'password': (String password) => password.length >= 6,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: _authListener,
        builder: (context, state) => GradientBackground(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuthTitle(text: 'Register'),
                  const SizedBox(height: 20),
                  AuthInputField(
                    controller: _controllers['username']!,
                    label: 'Username',
                  ),
                  const SizedBox(height: 10),
                  AuthInputField(
                    controller: _controllers['email']!,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  AuthInputField(
                    controller: _controllers['password']!,
                    label: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),
                  AuthInputField(
                    controller: _controllers['confirmPassword']!,
                    label: 'Confirm Password',
                    isPassword: true,
                  ),
                  if (state is AuthError) AuthErrorText(message: state.message),
                  const SizedBox(height: 20),
                  AuthButton(
                    text: 'Register',
                    onPressed: () => _handleRegister(context),
                    isLoading: state is AuthLoading,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      Navigator.pushNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please log in.'),
        ),
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  void _handleRegister(BuildContext context) {
    final values = {
      'username': _controllers['username']!.text.trim(),
      'email': _controllers['email']!.text.trim(),
      'password': _controllers['password']!.text,
      'confirmPassword': _controllers['confirmPassword']!.text,
    };

    final error = _validateInputs(values);
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    context.read<AuthCubit>().register(
          values['username']!,
          values['password']!,
          values['email']!,
        );
  }

  String? _validateInputs(Map<String, String> values) {
    if (!_validations['email']!(values['email']!)) {
      return 'Invalid email address';
    }
    if (!_validations['username']!(values['username']!)) {
      return 'Username must be at least 4 characters and contain no special characters';
    }
    if (!_validations['password']!(values['password']!)) {
      return 'Password must be at least 6 characters';
    }
    if (values['password'] != values['confirmPassword']) {
      return 'Passwords do not match';
    }
    return null;
  }
}

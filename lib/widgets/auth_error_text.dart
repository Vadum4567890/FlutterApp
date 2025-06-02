import 'package:flutter/material.dart';

class AuthErrorText extends StatelessWidget {
  final String message;

  const AuthErrorText({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

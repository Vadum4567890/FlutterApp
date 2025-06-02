import 'package:flutter/material.dart';

class AuthTitle extends StatelessWidget {
  final String text;
  final Color color;

  const AuthTitle({
    required this.text,
    super.key,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

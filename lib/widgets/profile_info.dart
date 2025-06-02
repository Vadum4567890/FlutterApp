import 'package:flutter/material.dart';
import 'package:my_project/models/user.dart';

class ProfileInfo extends StatelessWidget {
  final User? user;

  const ProfileInfo({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
        ),
        const SizedBox(height: 20),
        Text(
          'Email: ${user?.email}',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          'Username: ${user?.username}',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}

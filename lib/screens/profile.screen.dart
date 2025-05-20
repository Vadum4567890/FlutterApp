// ignore_for_file: library_private_types_in_public_api, inference_failure_on_instance_creation, inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:my_project/domain/services/auth_service.dart';
import 'package:my_project/models/user.dart';
import 'package:my_project/screens/additional/change_password_dialog.dart';
import 'package:my_project/screens/devices_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService;

  const ProfileScreen({required this.authService, super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final currentUser = await widget.authService.getCurrentUserDetails();
    setState(() {
      user = currentUser;
    });
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ChangePasswordDialog(authService: widget.authService);
      },
    );
  }

  // Function to show the logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to log out of your account?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.authService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person,
                              size: 50, color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 30),
                        if (user == null)
                          const CircularProgressIndicator()
                        else
                          Column(
                            children: [
                              _buildInfoCard('Email', user?.email),
                              _buildInfoCard('Username', user?.username),
                            ],
                          ),
                        const SizedBox(height: 40),

                        // Кнопка переходу на DevicesScreen
                        _buildActionButton(
                          text: 'My Devices',
                          color: Colors.tealAccent.shade700,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DevicesScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildActionButton(
                          text: 'Back to Home',
                          color: Colors.white,
                          textColor: Colors.blueAccent,
                          onPressed: () => Navigator.pop(context),
                        ),

                        const SizedBox(height: 16),

                        _buildActionButton(
                          text: 'Change Password',
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          onPressed: () => _showChangePasswordDialog(context),
                        ),

                        const SizedBox(height: 16),

                        _buildActionButton(
                          text: 'Logout',
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          onPressed: () =>
                              _showLogoutConfirmationDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String? value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'Not available',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: Colors.black26,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

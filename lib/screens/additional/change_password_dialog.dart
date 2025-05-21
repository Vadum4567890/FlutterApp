// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  final dynamic authService;

  const ChangePasswordDialog({required this.authService});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Old Password', oldPasswordController),
            const SizedBox(height: 12),
            _buildTextField('New Password', newPasswordController),
            const SizedBox(height: 12),
            _buildTextField('Confirm New Password', confirmPasswordController),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _handleChangePassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Change Password', style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom text field builder with consistent style
  TextField _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: Colors.black), // Text color inside the text field
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.2),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        hintText: 'Enter your $label',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  Future<void> _handleChangePassword(BuildContext context) async {
    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    final currentUser = await widget.authService.getCurrentUserDetails();
    if (currentUser != null) {
      if (currentUser.password != oldPassword) {
        setState(() {
          errorMessage = 'Old password is incorrect';
        });
        return;
      }

      if (newPassword != confirmPassword) {
        setState(() {
          errorMessage = 'New passwords do not match';
        });
        return;
      }

      if (newPassword.length < 6) {
        setState(() {
          errorMessage = 'New password must be at least 6 characters long';
        });
        return;
      }

      currentUser.updatePassword(newPassword);
      await widget.authService.saveUser(currentUser);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );
    }
  }
}

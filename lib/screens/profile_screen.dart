import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/cubit/profile/profile_state.dart';
import 'package:my_project/screens/additional/profile_dialogs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadUserProfile();
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF283593),
              Color(0xFF673AB7),
              Color(0xFF880E4F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, profileState) {
              if (profileState is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(profileState.message)),
                );
              }
            },
            builder: (context, profileState) {
              if (profileState is ProfileLoading || profileState is ProfileInitial) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              } else if (profileState is ProfileLoaded) {
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Color(0xFF283593),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Email:',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            profileState.user.email,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Username:',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            profileState.user.username,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildProfileButton(
                            context: context,
                            text: 'Back to Home',
                            onTap: () => Navigator.pop(context),
                            backgroundColor: Colors.white,
                            textColor: const Color(0xFF283593),
                            widthPercentage: 0.7,
                          ),
                          const SizedBox(height: 15),
                          _buildProfileButton(
                            context: context,
                            text: 'Change Password',
                            onTap: () => showChangePasswordDialog(context),
                            backgroundColor: Colors.white,
                            textColor: const Color(0xFF283593),
                            widthPercentage: 0.7,
                          ),
                          const SizedBox(height: 15),
                          _buildProfileButton(
                            context: context,
                            text: 'View Saved QR',
                            onTap: () => Navigator.pushNamed(context, '/saved_qr'),
                            backgroundColor: Colors.white,
                            textColor: const Color(0xFF283593),
                            widthPercentage: 0.7,
                          ),
                          const SizedBox(height: 30),
                          _buildProfileButton(
                            context: context,
                            text: 'Logout',
                            onTap: () => showLogoutConfirmationDialog(context),
                            backgroundColor: Colors.redAccent.shade700,
                            textColor: Colors.white,
                            boxShadowColor: Colors.black45,
                            widthPercentage: 0.8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (profileState is ProfileError) {
                return Center(
                  child: Text(
                    'Error: ${profileState.message}',
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 18),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
    Color boxShadowColor = Colors.black26,
    double widthPercentage = 1.0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * widthPercentage,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

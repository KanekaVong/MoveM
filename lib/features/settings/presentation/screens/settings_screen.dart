import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movem/features/auth/presentation/controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0D47A1); // Deep blue background tone

    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade400, Colors.deepPurpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'JY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'John Youlong',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'johnyoulong@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ACCOUNT Section
              const Text(
                'ACCOUNT',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      iconColor: Colors.blue.shade300,
                      iconBackgroundColor: Colors.blue.shade50,
                      title: 'User Information',
                      subtitle: 'Name, email, phone, location',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 70, endIndent: 16),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      iconColor: Colors.green.shade400,
                      iconBackgroundColor: Colors.green.shade50,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // PREFERENCES Section
              const Text(
                'PREFERENCES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.language,
                      iconColor: Colors.orange.shade400,
                      iconBackgroundColor: Colors.orange.shade50,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 70, endIndent: 16),
                    _buildSettingsTile(
                      icon: Icons.palette_outlined,
                      iconColor: Colors.blue.shade400,
                      iconBackgroundColor: Colors.blue.shade50,
                      title: 'Appearance',
                      subtitle: 'Light Mode',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SESSION Section
              const Text(
                'SESSION',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: _buildSettingsTile(
                  icon: Icons.logout,
                  iconColor: Colors.red.shade500,
                  iconBackgroundColor: Colors.red.shade50,
                  title: 'Log Out',
                  titleColor: Colors.red.shade500,
                  subtitle: 'Sign out of your account',
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Log Out',
                      middleText: 'Are you sure you want to log out?',
                      textConfirm: 'Log Out',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back(); // close the dialog first
                        final AuthController authController = Get.find<AuthController>();
                        authController.logout();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Version Footer
              const Center(
                child: Text(
                  'Version 2.4.1 · Build 2406',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent menu rows
  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
    Color? titleColor,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: titleColor ?? Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:movem/shared/widgets/glass_container.dart';
import 'package:movem/features/settings/presentation/screens/ProfileScreen.dart' hide GlassContainer;
import 'package:movem/features/auth/presentation/controllers/auth_controller.dart';
import 'package:movem/core/storage/user_manager.dart';
import 'package:movem/core/routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1021), // Deep dark background from design
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // --- SECTION 1: Account ---
                _buildSectionHeader('Account'),
                const SizedBox(height: 10),
                _buildGlassGroup([
                  _buildSettingItem(
                    title: 'Your Profile',
                    onTap: () => Get.to(() => const ProfileScreen()),
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: 'Change Password',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: 24),

                // --- SECTION 2: Preferences ---
                _buildSectionHeader('Preferences'),
                const SizedBox(height: 10),
                _buildGlassGroup([
                  _buildSettingItem(
                    title: 'Appearances',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: 'Languages',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: 'Privacy',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: 24),

                // --- SECTION 3: Sessions ---
                _buildSectionHeader('Sessions'),
                const SizedBox(height: 10),
                _buildGlassGroup([
                  _buildSettingItem(
                    title: 'Delete Your Account',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: 'Log Out',
                    onTap: () {
                      if (Get.isRegistered<AuthController>()) {
                        Get.find<AuthController>().logout();
                      } else {
                        UserManager().clearSession();
                        Get.offAllNamed(AppRoutes.login);
                      }
                    },
                  ),
                ]),

                // Extra bottom space so items aren't hidden behind the floating nav bar
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGlassGroup(List<Widget> children) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      opacity: 0.07, // Subtle transparent glass effect
      blur: 20.0,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.06),
    );
  }
}
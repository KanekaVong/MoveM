import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:movem/shared/widgets/glass_container.dart';
import 'package:movem/features/settings/presentation/screens/ProfileScreen.dart' hide GlassContainer;

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
                    onTap: () {},
                  ),
                ]),

                // Extra bottom space so items aren't hidden behind the floating nav bar
                const SizedBox(height: 100),
              ],
            ),
          ),

          // --- Bottom Floating Navigation Bar ---
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildFloatingNavBar(),
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

  Widget _buildFloatingNavBar() {
    return GlassContainer(
      borderRadius: BorderRadius.circular(35),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      opacity: 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.assignment_outlined, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.fitness_center, color: Colors.white70),
            onPressed: () {},
          ),
          // Active Settings Tab Icon with background bubble
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2640),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
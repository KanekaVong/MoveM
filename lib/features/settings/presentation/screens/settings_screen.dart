import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1021),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _buildSectionHeader(l10n?.accountSection ?? 'Account'),
                const SizedBox(height: 10),
                _buildGlassGroup([
                  _buildSettingItem(
                    title: l10n?.yourProfile ?? 'Your Profile',
                    onTap: controller.onProfileTap,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: l10n?.changePassword ?? 'Change Password',
                    onTap: controller.onChangePasswordTap,
                  ),
                ]),

                const SizedBox(height: 24),

                _buildSectionHeader(l10n?.preferencesSection ?? 'Preferences'),
                const SizedBox(height: 10),
                _buildGlassGroup([
                  _buildSettingItem(
                    title: l10n?.appearances ?? 'Appearances',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildToggleSettingItem(
                    title: l10n?.darkLightTheme ?? 'Dark/Light',
                    value: controller.isDarkMode,
                    onChanged: controller.onToggleTheme,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: l10n?.languages ?? 'Languages',
                    onTap: controller.onLanguagesTap,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: l10n?.notifications ?? 'Notifications',
                    onTap: controller.onNotificationsTap,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: l10n?.privacy ?? 'Privacy',
                    onTap: controller.onPrivacyTap,
                  ),
                ]),

                const SizedBox(height: 24),

                _buildSectionHeader(l10n?.sessionsSection ?? 'Sessions'),
                const SizedBox(height: 10),
                _buildGlassGroup([
                  _buildSettingItem(
                    title: l10n?.deleteAccount ?? 'Delete Your Account',
                    onTap: controller.onDeleteAccountTap,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: l10n?.logOut ?? 'Log Out',
                    onTap: () => _showLogoutDialog(context, controller),
                  ),
                ]),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, SettingsController controller) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1E293B),
          opacity: 0.5,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to log out of your account?',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.confirmLogout();
                      },
                      child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.6),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGlassGroup(List<Widget> children) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      opacity: 0.07,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSettingItem({
    required String title,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          Obx(() => Switch(
                value: value.value,
                onChanged: (val) {
                  value.value = val;
                  onChanged(val);
                },
                activeThumbColor: const Color(0xFF3B82F6),
                activeTrackColor: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                inactiveThumbColor: Colors.white70,
                inactiveTrackColor: Colors.white24,
              )),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withValues(alpha: 0.06),
    );
  }
}

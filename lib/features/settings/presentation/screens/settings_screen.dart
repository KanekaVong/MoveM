import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/settings_controller.dart';
import 'package:movem/features/settings/presentation/screens/change_password_screen.dart';


class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  static const double _rowHeight = 52;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SettingsController>()) {
      Get.put(SettingsController());
    }
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
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
                    onTap: () {
                      Get.to(
                        () => const ChangePasswordScreen(),
                      );
                    },
                  ),
                ]),

                const SizedBox(height: 24),

                _buildSectionHeader(l10n?.preferencesSection ?? 'Preferences'),
                const SizedBox(height: 10),
                _buildGlassGroup([
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
                ]),

                const SizedBox(height: 24),

                _buildSectionHeader(l10n?.sessionsSection ?? 'Sessions'),
                const SizedBox(height: 10),
                _buildGlassGroup([
                  _buildSettingItem(
                    title: l10n?.logOut ?? 'Log Out',
                    onTap: () => _showLogoutDialog(context, controller),
                  ),
                ]),

                const SizedBox(height: 160),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, SettingsController controller) {
    final dark = AppColors.isDark;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: dark ? AppColors.slate800 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: dark ? Colors.white.withValues(alpha: 0.15) : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.35 : 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withValues(alpha: 0.12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Log Out',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to log out of your account?',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      label: 'Cancel',
                      height: 46,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.danger(
                      label: 'Log Out',
                      height: 46,
                      onPressed: () {
                        Get.back();
                        controller.confirmLogout();
                      },
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
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGlassGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
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
        child: Container(
          height: _rowHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textCaption,
                size: 16,
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
    return Container(
      height: _rowHeight,
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          Obx(() {
            final isDark = AppColors.isDark;
            return Transform.scale(
              scale: 0.8,
              alignment: Alignment.centerRight,
              child: Switch(
                value: value.value,
                onChanged: (val) {
                  value.value = val;
                  onChanged(val);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF3C66C0),
                inactiveThumbColor: isDark ? AppColors.slate400 : Colors.white,
                inactiveTrackColor: isDark ? AppColors.slate700 : AppColors.slate300,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.borderLight,
    );
  }
}

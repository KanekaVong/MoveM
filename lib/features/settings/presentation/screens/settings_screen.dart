import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movem/shared/widgets/glass_container.dart';

import 'package:movem/features/settings/presentation/screens/change_password_screen.dart';
import 'package:movem/features/settings/presentation/screens/ProfileScreen.dart' hide GlassContainer;
import 'package:movem/features/auth/presentation/controllers/auth_controller.dart';
import 'package:movem/features/settings/presentation/screens/add_account_screen.dart';

import 'package:movem/core/storage/user_manager.dart';
import 'package:movem/features/auth/data/dto/response/user_response.dart';

import 'package:movem/features/auth/presentation/bindings/auth_binding.dart';
import 'package:movem/core/routes/app_routes.dart';
import 'package:movem/core/storage/saved_account.dart';


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
                    onTap: () {
                      Get.to(
                            () => const ChangePasswordScreen(),
                      );
                    },
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
                    title: 'Switch accounts',
                    trailingText: UserManager().userName,
                    trailingProfilePic: UserManager().getUser()?.profilePic,
                    onTap: _showAccountSwitcher,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: 'Log Out',
                    onTap: _showLogoutConfirmation,
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

  Future<void> _showAccountSwitcher() async {
    final userManager = UserManager();

    final activeUser = userManager.getUser();
    final savedAccounts = await userManager.getSavedAccounts();

    // Make sure the currently active account is also in the list.
    if (activeUser != null) {
      final activeAccessToken = await userManager.getToken();
      final activeTrustToken = await userManager.getTrustToken();

      if (activeAccessToken != null &&
          activeTrustToken != null &&
          !savedAccounts.any(
                (account) => account.user.id == activeUser.id,
          )) {
        await userManager.saveAccount(
          SavedAccount(
            accessToken: activeAccessToken,
            trustToken: activeTrustToken,
            user: activeUser,
          ),
        );

        savedAccounts.add(
          SavedAccount(
            accessToken: activeAccessToken,
            trustToken: activeTrustToken,
            user: activeUser,
          ),
        );
      }
    }

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF131D38),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Switch account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ...savedAccounts.map(
                      (account) => _buildSavedAccountTile(
                    account,
                    activeUser,
                  ),
                ),

                const SizedBox(height: 4),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white38,
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Add account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Get.back();

                    await userManager
                        .saveCurrentAccountToSavedAccounts();

                    Get.to(
                          () => const AddAccountScreen(),
                      binding: AuthBinding(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      enterBottomSheetDuration:
      const Duration(milliseconds: 180),
      exitBottomSheetDuration:
      const Duration(milliseconds: 150),
    );
  }

  Widget _buildAccountAvatar(UserResponse user) {
    final profilePic = user.profilePic;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF162341),
        image: profilePic != null && profilePic.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(profilePic),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: profilePic == null || profilePic.isEmpty
          ? const Icon(
        Icons.person_outline,
        color: Colors.white54,
        size: 24,
      )
          : null,
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

  Widget _buildSavedAccountTile(
      SavedAccount account,
      UserResponse? activeUser,
      ) {
    final isCurrentAccount =
        activeUser != null &&
            account.user.id == activeUser.id;

    return GestureDetector(
      onLongPress: isCurrentAccount
          ? null
          : () {
        _showRemoveAccountConfirmation(account);
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: _buildAccountAvatar(account.user),
        title: Text(
          account.user.username,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isCurrentAccount
            ? const Icon(
          Icons.check,
          color: Color(0xFF5394FF),
        )
            : null,
        onTap: isCurrentAccount
            ? null
            : () async {
          Get.back();

          await UserManager().activateAccount(account);

          Get.offAllNamed(AppRoutes.main);
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? trailingText,
    String? trailingProfilePic,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingText != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF162341),
                            image: trailingProfilePic != null &&
                                trailingProfilePic.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(trailingProfilePic),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: trailingProfilePic == null ||
                              trailingProfilePic.isEmpty
                              ? const Icon(
                            Icons.person_outline,
                            color: Colors.white54,
                            size: 17,
                          )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          trailingText,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            22,
            24,
            22,
            18,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF131D38),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 25,
                offset: const Offset(0, 12),
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

              const SizedBox(height: 18),

              const Text(
                'Log out?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Are you sure you want to log out of this account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        minimumSize: const Size(
                          double.infinity,
                          46,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();

                        if (Get.isRegistered<AuthController>()) {
                          Get.find<AuthController>().logout();
                        } else {
                          UserManager().clearSession();
                          Get.offAllNamed(AppRoutes.login,);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(
                          double.infinity,
                          46,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _showRemoveAccountConfirmation(SavedAccount account) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF131D38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Remove account?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Remove ${account.user.username} from this device?',
          style: const TextStyle(
            color: Colors.white70,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();

              await UserManager().removeSavedAccount(
                account.user.id,
              );

              if (Get.isBottomSheetOpen ?? false) {
                Get.back();
              }

              _showAccountSwitcher();
            },
            child: const Text(
              'Remove',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
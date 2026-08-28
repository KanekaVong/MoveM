import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movem/core/routes/app_routes.dart';
import 'package:movem/core/storage/user_manager.dart';
import 'package:movem/features/auth/data/dto/response/user_response.dart';
import 'package:movem/features/settings/presentation/models/contact_type.dart';
import 'package:movem/features/settings/presentation/screens/contact_info_overlay.dart';
import 'package:movem/features/settings/presentation/screens/change_contact_screen.dart';
import 'package:movem/features/settings/presentation/bindings/setting_binding.dart';
import 'package:movem/features/settings/presentation/controllers/setting_controller.dart';
import 'package:movem/features/settings/data/dto/request/update_profile_request.dart';
import 'package:movem/features/settings/data/services/setting_service.dart';
import 'package:movem/features/settings/data/repositories/setting_repository_impl.dart';

import 'package:movem/features/settings/presentation/screens/region_selection_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickDateOfBirth(
      BuildContext context,
      UserResponse? user,
      ) async {

    final SettingController settingController;

    if (Get.isRegistered<SettingController>()) {
      settingController = Get.find<SettingController>();
    } else {
      final settingService = SettingService();
      final settingRepository = SettingRepositoryImpl(
        settingService: settingService,
      );

      settingController = SettingController(
        repository: settingRepository,
      );
    }

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final lastAllowedDate = today.subtract(
      const Duration(days: 1),
    );

    DateTime initialDate = lastAllowedDate;

    final existingDob = user?.dateOfBirth;

    if (existingDob != null && existingDob.isNotEmpty) {
      final parsedDob = DateTime.tryParse(existingDob);

      if (parsedDob != null) {
        final existingDate = DateTime(
          parsedDob.year,
          parsedDob.month,
          parsedDob.day,
        );

        if (existingDate.isBefore(today)) {
          initialDate = existingDate;
        }
      }
    }

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: lastAllowedDate,
      initialDate: initialDate,
      helpText: 'Select Date Of Birth',
    );

    if (pickedDate == null) {
      return;
    }

    final formattedDate =
        '${pickedDate.year.toString().padLeft(4, '0')}-'
        '${pickedDate.month.toString().padLeft(2, '0')}-'
        '${pickedDate.day.toString().padLeft(2, '0')}';

    final updatedUser = await settingController.updateProfile(
      UpdateProfileRequest(
        dateOfBirth: formattedDate,
      ),
      goBack: false,
    );

    if (updatedUser == null) {
      return;
    }

    // Rebuild ProfileScreen with the updated UserManager data.
    Get.forceAppUpdate();
  }

  Future<void> _pickRegion(
      BuildContext context,
      UserResponse? user,
      ) async {
    String? selectedRegion;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131D38),
          title: const Text(
            'Select Region',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (selectedRegion == null ||
                    selectedRegion!.trim().isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  selectedRegion,
                );
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF5394FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((result) async {
      if (result == null) {
        return;
      }

      final region = result as String;

      final settingController = Get.isRegistered<SettingController>()
          ? Get.find<SettingController>()
          : SettingController(
        repository: SettingRepositoryImpl(
          settingService: SettingService(),
        ),
      );

      final updatedUser = await settingController.updateProfile(
        UpdateProfileRequest(
          cityProvince: region,
        ),
        goBack: false,
      );

      if (updatedUser == null) {
        return;
      }

      Get.forceAppUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserResponse? user = UserManager().getUser();
    print('ProfileScreen: Retrieved user from UserManager: ${user?.toJson() ?? "null"}');

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Your Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildProfileSection(context, user),
              const SizedBox(height: 32),
              _buildPersonalInformation(context, user),
              const SizedBox(height: 32),
              _buildMyActivities(),
              const SizedBox(height: 32),
              _buildAchievements(),
              const SizedBox(height: 32),
              _buildBottomStats(),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, UserResponse? user) {
    final fullName = [
      user?.firstName,
      user?.lastName,
    ].where((value) => value != null && value.trim().isNotEmpty).join(' ');

    final displayName =
        fullName.isNotEmpty ? fullName : (user?.username ?? 'Unknown User');

    return Row(
      children: [
        _buildProfileImage(user),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      displayName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GlassContainer(
                    borderRadius: 9.0, // <-- Pass a double here directly
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (user != null) {
                          Get.toNamed(AppRoutes.editProfile);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Edit',
                            style: TextStyle(
                              color: Color(0xFF5394FF),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.edit,
                            color: Color(0xFF5394FF),
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '@${user?.username ?? 'unknown'}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInformation(BuildContext context, UserResponse? user) {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Personal Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: _displayValue(user?.email),
            onTap: () {
              if (user?.email == null || user!.email!.isEmpty) {
                return;
              }

              Get.dialog(
                ContactInfoOverlay(
                  type: ContactType.email,
                  value: user.email!,
                  onChange: () {
                    Get.back();

                    Get.toNamed(
                      AppRoutes.changeContact,
                      arguments: ContactType.email,
                    );
                  },
                ),
              );
            },
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            subtitle: _displayValue(user?.phone),
            onTap: () {
              final phone = user?.phone;

              // User has no phone linked yet
              if (phone == null || phone.isEmpty) {
                Get.toNamed(
                  AppRoutes.changeContact,
                  arguments: ContactType.phone,
                );
                return;
              }

              // User already has a phone linked
              Get.dialog(
                ContactInfoOverlay(
                  type: ContactType.phone,
                  value: phone,
                  onChange: () {
                    Get.back();

                    Get.toNamed(
                      AppRoutes.changeContact,
                      arguments: ContactType.phone,
                    );
                  },
                  onUnlink: () {
                    Get.back();

                    Get.dialog(
                      AlertDialog(
                        backgroundColor: const Color(0xFF131D38),
                        title: const Text(
                          'Unlink phone number?',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Are you sure you want to unlink your phone number from your account?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.back();

                              final settingController =
                              Get.isRegistered<SettingController>()
                                  ? Get.find<SettingController>()
                                  : SettingController(
                                repository: SettingRepositoryImpl(
                                  settingService: SettingService(),
                                ),
                              );

                              final updatedUser =
                              await settingController.unlinkPhone();

                              if (updatedUser == null) {
                                return;
                              }

                              Get.forceAppUpdate();
                            },
                            child: const Text(
                              'Unlink',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.calendar_today_outlined,
            title: 'Date Of Birth',
            subtitle: _displayDateOfBirth(user?.dateOfBirth),
            onTap: () => _pickDateOfBirth(context, user),
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.location_on_outlined,
            title: 'Location',
            subtitle: _displayValue(user?.cityProvince),
            showDivider: false,
            onTap: () async {
              final selectedRegion = await Get.to<String>(
                    () => RegionSelectionScreen(
                  currentRegion: user?.cityProvince,
                ),
              );

              if (selectedRegion == null ||
                  selectedRegion.trim().isEmpty) {
                return;
              }

              final SettingController settingController;

              if (Get.isRegistered<SettingController>()) {
                settingController = Get.find<SettingController>();
              } else {
                final settingService = SettingService();

                final settingRepository = SettingRepositoryImpl(
                  settingService: settingService,
                );

                settingController = SettingController(
                  repository: settingRepository,
                );
              }

              final updatedUser = await settingController.updateProfile(
                UpdateProfileRequest(
                  cityProvince: selectedRegion,
                ),
                goBack: false,
              );

              if (updatedUser == null) {
                return;
              }

              Get.forceAppUpdate();
            },
          ),
        ],
      ),
    );
  }

  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not Set Up';
    }

    return value;
  }

  String _displayDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not Set Up';
    }

    try {
      final date = DateTime.parse(value);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return value;
    }
  }

  Widget _buildProfileImage(UserResponse? user) {
    final profilePic = user?.profilePic;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: profilePic != null && profilePic.isNotEmpty
            ? Image.network(
                profilePic,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  );
                },
              )
            : const Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showDivider = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Row(
          children: [
            GlassContainer(
              width: 32,
              height: 32,
              borderRadius: 16.0,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: const Color(0xFF3B82F6),
                size: 16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFA0AAB2),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 64.0, right: 16.0),
      child: Container(
        height: 1,
        color: const Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildMyActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'My Activities',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'View All >',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                icon: Icons.check,
                title: 'Task Completed',
                value: '0',
                total: '0',
                imageUrl:
                    'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?q=80&w=600&auto=format&fit=crop',
                // Desk laptop
                progress: 0.0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                icon: Icons.directions_run,
                // Close to running shoe
                title: 'Steps',
                value: '0',
                total: '5000',
                imageUrl:
                    'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=600&auto=format&fit=crop',
                // Running
                progress: 0.0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                icon: Icons.flight,
                title: 'Days Until Your Trip',
                value: '0',
                total: null,
                imageUrl:
                    'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop',
                // Travel mountain
                progress: 0.0,
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String value,
    String? total,
    required String imageUrl,
    required double progress,
  }) {
    return SizedBox(
      height: 160,
      child: SettingsCard(
        padding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              // Fit inside the glass card inner radius
              child: Image(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: const Color(0xFF0F172A)
                    .withValues(alpha: 0.6), // Darken the image
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                      // Light blue tint
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color:
                              const Color(0xFF3B82F6).withValues(alpha: 0.5)),
                    ),
                    child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (total != null) ...[
                        const Text(
                          ' / ',
                          style: TextStyle(
                            color: Color(0xFFA0AAB2),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          total,
                          style: const TextStyle(
                            color: Color(0xFFA0AAB2),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFA0AAB2),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      children: [
                        if (progress > 0)
                          Expanded(
                            flex: (progress * 100).toInt(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        if (progress < 1)
                          Expanded(
                            flex: 100 - (progress * 100).toInt(),
                            child: const SizedBox(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Achievements',
              style: TextStyle(
                color: Color(0xFFEAB308), // Yellow
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SettingsCard(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: const Center(
            child: Text(
              'No Achievements Yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomStats() {
    return SettingsCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn(Icons.assignment_outlined, '0', 'Task Completed'),
          _buildVerticalDivider(),
          _buildStatColumn(Icons.fitness_center, '0', 'Task Completed'),
          _buildVerticalDivider(),
          _buildStatColumn(Icons.beach_access_outlined, '0', 'Task Completed'),
          _buildVerticalDivider(),
          _buildStatColumn(Icons.star_outline, '0', 'Task Completed'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String title) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF3B82F6), size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA0AAB2),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFF1E293B),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SettingsCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0), // Frost 4
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.2), // Light reflection
                Colors.white.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.2), // Depth shadow
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0), // 3D edge depth
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), // 7 - 1 (padding)
                color: const Color(0xFF162341)
                    .withValues(alpha: 0.60), // Exact fill from Figma
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 9.0,
    this.padding,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.2),
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              padding: padding,
              alignment: alignment,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    borderRadius > 0 ? borderRadius - 1 : 0),
                color: const Color(0xFF3C66C0).withValues(alpha: 0.40),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

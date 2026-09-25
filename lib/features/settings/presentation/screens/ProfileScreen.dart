import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movem/core/routes/app_routes.dart';
import 'package:movem/core/config/app_config.dart';
import 'package:movem/core/storage/user_manager.dart';
import 'package:movem/core/theme/app_colors.dart';
import 'package:movem/l10n/app_localizations.dart';
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
import 'package:movem/features/fitness/data/models/achievement_model.dart';
import 'package:movem/features/settings/presentation/controllers/profile_overview_controller.dart';
import 'package:movem/shared/widgets/app_button.dart';
import 'package:movem/shared/widgets/auth_image.dart';
import 'package:movem/shared/widgets/no_data_component.dart';
import 'package:movem/shared/widgets/top_tool_bar.dart';


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
      helpText: AppLocalizations.of(context)!.selectDateOfBirth,
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
          title: Text(
            AppLocalizations.of(context)!.selectRegion,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: AppLocalizations.of(context)!.cancel,
                    height: 46,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: AppLocalizations.of(context)!.save,
                    height: 46,
                    onPressed: () async {
                      if (selectedRegion == null ||
                          selectedRegion!.trim().isEmpty) {
                        return;
                      }

                      Navigator.of(dialogContext).pop(
                        selectedRegion,
                      );
                    },
                  ),
                ),
              ],
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
    final overview = Get.isRegistered<ProfileOverviewController>()
        ? Get.find<ProfileOverviewController>()
        : Get.put(ProfileOverviewController());

    final l10n = AppLocalizations.of(context)!;
    final pageColor = AppColors.pageBackground;
    final onPage = AppColors.textPrimary;
    return Scaffold(
      backgroundColor: pageColor,
      appBar: TopToolBar(
        title: l10n.yourProfile,
        backgroundColor: pageColor,
        foregroundColor: onPage,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          clipBehavior: Clip.none,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned(
                top: 60,
                right: -140,
                child: _AmbientGlow(color: Color(0xFF3C66C0), size: 320),
              ),
              const Positioned(
                top: 420,
                left: -160,
                child: _AmbientGlow(color: Color(0xFF6D4AFF), size: 300),
              ),
              const Positioned(
                top: 820,
                right: -120,
                child: _AmbientGlow(color: Color(0xFF0EA5E9), size: 280),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              _buildProfileSection(context, user),
              const SizedBox(height: 32),
              _buildPersonalInformation(context, user),
              const SizedBox(height: 32),
              _buildMyActivities(context, overview),
              const SizedBox(height: 32),
              _buildAchievements(context, overview),
              const SizedBox(height: 32),
              _buildBottomStats(context, overview),
                  const SizedBox(height: 100)
                ],
              ),
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
        fullName.isNotEmpty ? fullName : (user?.username ?? AppLocalizations.of(context)!.unknownUser);

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
                      style: TextStyle(
                        color: AppColors.textPrimary,
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
                        children: [
                          Text(
                            AppLocalizations.of(context)!.editProfile,
                            style: TextStyle(
                              color: AppColors.isDark ? Colors.white : AppColors.accentBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit,
                            color: AppColors.isDark ? Colors.white : AppColors.accentBlue,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.personalInfo,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: AppLocalizations.of(context)!.email,
            subtitle: _displayValue(context, user?.email),
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
            title: AppLocalizations.of(context)!.phoneNumber,
            subtitle: _displayValue(context, user?.phone),
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
                        title: Text(
                          AppLocalizations.of(context)!.unlinkPhoneTitle,
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          AppLocalizations.of(context)!.unlinkPhoneConfirm,
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: AppButton.secondary(
                                  label: AppLocalizations.of(context)!.cancel,
                                  height: 46,
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppButton.danger(
                                  label: AppLocalizations.of(context)!.unlink,
                                  height: 46,
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
                                ),
                              ),
                            ],
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
            title: AppLocalizations.of(context)!.dateOfBirth,
            subtitle: _displayDateOfBirth(context, user?.dateOfBirth),
            onTap: () => _pickDateOfBirth(context, user),
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.location_on_outlined,
            title: AppLocalizations.of(context)!.location,
            subtitle: _displayValue(context, user?.cityProvince),
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

  String _displayValue(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.notSetUp;
    }

    return value;
  }

  String _displayDateOfBirth(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.notSetUp;
    }

    try {
      final date = DateTime.parse(value);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return value;
    }
  }

  Widget _buildProfileImage(UserResponse? user) {
    final stored = user?.profilePic;
    final profilePic = stored == null || stored.isEmpty ? null : AppConfig.resolveMediaUrl(stored);

    return GestureDetector(
      onTap: _changeProfilePhoto,
      child: Container(
      width: 84,
      height: 84,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8FB4FF), Color(0xFF3C66C0), Color(0xFF1B2A55)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3C66C0).withValues(alpha: 0.45),
            blurRadius: 22,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF162341),
        ),
        child: ClipOval(
        child: profilePic != null && profilePic.isNotEmpty
            ? AuthImage(
                url: profilePic,
                fallback: const Icon(Icons.person, color: Colors.white, size: 40),
              )
            : const Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
        ),
      ),
    ),
    );
  }

  Future<void> _changeProfilePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (picked == null) return;

    final setting = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : SettingController(
            repository: SettingRepositoryImpl(settingService: SettingService()),
          );
    final updated = await setting.uploadAndSaveProfilePicture(picked.path);
    if (updated != null) Get.forceAppUpdate();
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
                color: AppColors.accentBlue,
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
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
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
        color: AppColors.borderLight,
      ),
    );
  }

  Widget _buildMyActivities(BuildContext context, ProfileOverviewController overview) {
    return Obx(() {
      final days = overview.daysUntilTrip.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.myActivities,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.check,
                  title: AppLocalizations.of(context)!.taskCompleted,
                  value: '${overview.completedTasks}',
                  total: '${overview.taskTotal}',
                  imageUrl:
                      'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?q=80&w=600&auto=format&fit=crop',
                  progress: overview.taskProgress,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.directions_run,
                  title: AppLocalizations.of(context)!.steps,
                  value: '${overview.stepsToday}',
                  total: '${overview.stepGoal}',
                  imageUrl:
                      'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=600&auto=format&fit=crop',
                  progress: overview.stepProgress,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.flight,
                  title: AppLocalizations.of(context)!.daysUntilYourTrip,
                  value: days == null ? '—' : '$days',
                  total: null,
                  imageUrl:
                      'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop',
                  progress: days == null ? 0 : (days == 0 ? 1 : 0.35),
                ),
              ),
            ],
          ),
        ],
      );
    });
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
            Image(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F172A).withValues(alpha: 0.25),
                    const Color(0xFF0F172A).withValues(alpha: 0.55),
                    const Color(0xFF0B1224).withValues(alpha: 0.95),
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassContainer(
                    width: 36,
                    height: 36,
                    borderRadius: 11,
                    alignment: Alignment.center,
                    child: Icon(icon, color: Colors.white, size: 19),
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
                    height: 5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B86E5), Color(0xFF8FB4FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5B86E5).withValues(alpha: 0.6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildAchievements(BuildContext context, ProfileOverviewController overview) {
    return Obx(() {
      final items = overview.achievements;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.achievements,
                style: TextStyle(color: Color(0xFFEAB308), fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (items.length > 6)
                GestureDetector(
                  onTap: () => Get.to(() => _AllAchievementsScreen(items: items.toList())),
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (overview.isLoading.value && items.isEmpty)
            const SettingsCard(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(child: CircularProgressIndicator(color: Color(0xFF8FB4FF))),
            )
          else if (items.isEmpty)
            SettingsCard(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: NoDataComponent(compact: true, title: AppLocalizations.of(context)!.noAchievementsYet),
            )
          else
            SizedBox(
              height: 132,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length > 6 ? 6 : items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) => _AchievementTile(item: items[index]),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBottomStats(BuildContext context, ProfileOverviewController overview) {
    return Obx(() => SettingsCard(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn(Icons.assignment_outlined, '${overview.completedTasks}', AppLocalizations.of(context)!.tasksStat),
              _buildVerticalDivider(),
              _buildStatColumn(Icons.fitness_center, '${overview.totalWorkouts}', AppLocalizations.of(context)!.workoutsStat),
              _buildVerticalDivider(),
              _buildStatColumn(Icons.beach_access_outlined, '${overview.completedTrips.value}', AppLocalizations.of(context)!.tripsStat),
              _buildVerticalDivider(),
              _buildStatColumn(Icons.star_outline, '${overview.achievementCount.value}', AppLocalizations.of(context)!.badgesStat),
            ],
          ),
        ));
  }

  Widget _buildStatColumn(IconData icon, String value, String title) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.accentBlue, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
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
      color: AppColors.borderLight,
    );
  }
}

class SettingsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const SettingsCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final dark = AppColors.isDark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.35 : 0.08),
            offset: const Offset(0, 12),
            blurRadius: 28,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: CustomPaint(
            foregroundPainter: _GlassRimPainter(radius: radius, light: !dark),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dark
                      ? [
                          const Color(0xFF1E2C52).withValues(alpha: 0.72),
                          const Color(0xFF162341).withValues(alpha: 0.55),
                          const Color(0xFF101A33).withValues(alpha: 0.65),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.92),
                          const Color(0xFFF7F9FC).withValues(alpha: 0.88),
                          const Color(0xFFEEF3FA).withValues(alpha: 0.9),
                        ],
                ),
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
    final radius = BorderRadius.circular(borderRadius);
    final dark = AppColors.isDark;
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: CustomPaint(
          foregroundPainter: _GlassRimPainter(radius: borderRadius, strength: 1.2, light: !dark),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            alignment: alignment,
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? [
                        const Color(0xFF5B86E5).withValues(alpha: 0.45),
                        const Color(0xFF3C66C0).withValues(alpha: 0.28),
                      ]
                    : [
                        const Color(0xFF5B86E5).withValues(alpha: 0.18),
                        const Color(0xFF3C66C0).withValues(alpha: 0.08),
                      ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Light-catching rim plus a soft top sheen, so glass reads on flat backgrounds.
class _GlassRimPainter extends CustomPainter {
  const _GlassRimPainter({required this.radius, this.strength = 1, this.light = false});

  final double radius;
  final double strength;
  final bool light;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect.deflate(0.5), Radius.circular(radius));

    final sheen = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Colors.white.withValues(alpha: 0.10 * strength),
          Colors.white.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawRRect(rrect, sheen);

    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: light
            ? [
                const Color(0xFF3B6FE8).withValues(alpha: 0.28 * strength),
                const Color(0xFF111827).withValues(alpha: 0.08),
                const Color(0xFF3B6FE8).withValues(alpha: 0.16 * strength),
              ]
            : [
                Colors.white.withValues(alpha: (0.38 * strength).clamp(0, 1)),
                Colors.white.withValues(alpha: 0.06),
                const Color(0xFF5B86E5).withValues(alpha: 0.30 * strength),
              ],
        stops: const [0, 0.45, 1],
      ).createShader(rect);
    canvas.drawRRect(rrect, rim);
  }

  @override
  bool shouldRepaint(_GlassRimPainter old) =>
      old.radius != radius || old.strength != strength || old.light != light;
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: AppColors.isDark ? 0.35 : 0.16),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _achievementIcon(String name) {
  final key = name.toLowerCase();
  if (key.contains('step')) return Icons.directions_walk;
  if (key.contains('km') || key.contains('distance')) return Icons.route;
  if (key.contains('streak') || key.contains('day')) return Icons.local_fire_department;
  if (key.contains('challenge')) return Icons.flag;
  if (key.contains('kudos') ||
      key.contains('social') ||
      key.contains('cheer') ||
      key.contains('crowd') ||
      key.contains('community')) {
    return Icons.favorite;
  }
  if (key.contains('workout') || key.contains('fitness')) return Icons.fitness_center;
  return Icons.emoji_events;
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.item, this.wide = false});

  final AchievementModel item;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final progress = (item.progressPercentage > 1
            ? item.progressPercentage / 100
            : item.progressPercentage)
        .clamp(0.0, 1.0);
    final icon = item.icon.startsWith('http')
        ? ClipOval(
            child: Image.network(item.icon, width: 36, height: 36, fit: BoxFit.cover),
          )
        : Icon(
            _achievementIcon(item.icon),
            color: item.earned ? const Color(0xFFEAB308) : AppColors.textCaption,
            size: 28,
          );

    return SizedBox(
      width: wide ? double.infinity : 108,
      child: SettingsCard(
        padding: const EdgeInsets.all(10),
        radius: 14,
        child: Column(
          crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: wide ? TextAlign.start : TextAlign.center,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700),
            ),
            if (wide && item.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: item.earned ? 1 : progress,
              minHeight: 4,
              backgroundColor: AppColors.borderLight,
              color: const Color(0xFFEAB308),
              borderRadius: BorderRadius.circular(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllAchievementsScreen extends StatelessWidget {
  const _AllAchievementsScreen({required this.items});

  final List<AchievementModel> items;

  @override
  Widget build(BuildContext context) {
    final pageColor = AppColors.pageBackground;
    return Scaffold(
      backgroundColor: pageColor,
      appBar: TopToolBar(
        title: AppLocalizations.of(context)!.achievements,
        backgroundColor: pageColor,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => _AchievementTile(item: items[index], wide: true),
      ),
    );
  }
}

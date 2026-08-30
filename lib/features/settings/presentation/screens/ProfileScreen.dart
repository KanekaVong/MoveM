import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final l10n = AppLocalizations.of(context);

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
                    onTap: controller.onBackTap,
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n?.yourProfile ?? 'Your Profile',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildProfileSection(context, controller),
              const SizedBox(height: 32),
              _buildPersonalInformation(context, controller),
              const SizedBox(height: 32),
              _buildMyActivities(context),
              const SizedBox(height: 32),
              _buildAchievements(context),
              const SizedBox(height: 32),
              _buildBottomStats(),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, ProfileController controller) {
    return Obx(() {
      return Row(
        children: [
          _buildProfileImage(controller),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.displayName,
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
                      borderRadius: 9.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      child: GestureDetector(
                        onTap: controller.onEditProfileTap,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                  '@${controller.username}',
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
    });
  }

  Widget _buildPersonalInformation(BuildContext context, ProfileController controller) {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      return SettingsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n?.personalInfo ?? 'Personal Information',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildInfoTile(
              icon: Icons.email_outlined,
              title: l10n?.email ?? 'Email',
              subtitle: controller.email,
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.phone_outlined,
              title: l10n?.emailOrPhone ?? 'Phone Number',
              subtitle: controller.phone,
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.calendar_today_outlined,
              title: 'Date Of Birth',
              subtitle: controller.dateOfBirth,
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.location_on_outlined,
              title: 'Location',
              subtitle: controller.location,
              showDivider: false,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProfileImage(ProfileController controller) {
    return Obx(() {
      final profilePic = controller.profilePic;
      final initial = controller.initial;

      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFF334155),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: profilePic != null && profilePic.isNotEmpty
              ? (profilePic.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: profilePic,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Image.file(
                      File(profilePic),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
              : Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          GlassContainer(
            width: 32,
            height: 32,
            borderRadius: 16.0,
            alignment: Alignment.center,
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 16),
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
          const Icon(Icons.chevron_right, color: Colors.white, size: 24),
        ],
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

  Widget _buildMyActivities(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.myActivities ?? 'My Activities',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${l10n?.viewAll ?? 'View All'} >',
              style: const TextStyle(
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

                progress: 0.0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                icon: Icons.directions_run,

                title: 'Steps',
                value: '0',
                total: '5000',
                imageUrl:
                    'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=600&auto=format&fit=crop',

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

              child: Image(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: const Color(0xFF0F172A)
                    .withValues(alpha: 0.6),
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

  Widget _buildAchievements(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.achievements ?? 'Achievements',
              style: const TextStyle(
                color: Color(0xFFEAB308),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n?.viewAll ?? 'View All',
              style: const TextStyle(
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
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.2),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF162341)
                    .withValues(alpha: 0.60),
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

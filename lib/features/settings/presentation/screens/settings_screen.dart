import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 32),
              _buildPersonalInformation(),
              const SizedBox(height: 32),
              _buildMyActivities(),
              const SizedBox(height: 32),
              _buildAchievements(),
              const SizedBox(height: 32),
              _buildBottomStats(),
              const SizedBox(height: 100), // Padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF1E293B), width: 2),
            image: const DecorationImage(
              image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=200&auto=format&fit=crop'), // Placeholder leopard
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'John Youlong',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                GlassContainer(
                  borderRadius: 9.0,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      Icon(Icons.edit, color: Color(0xFF5394FF), size: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '@VK2305',
              style: TextStyle(
                color: Color(0xFF3B82F6), // Blue username
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalInformation() {
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
            subtitle: 'johnyoulong@gmail.com',
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            subtitle: 'Not Set Up',
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.calendar_today_outlined,
            title: 'Date Of Birth',
            subtitle: 'Not Set Up',
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.location_on_outlined,
            title: 'Location',
            subtitle: 'Not Set Up',
            showDivider: false,
          ),
        ],
      ),
    );
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
                imageUrl: 'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?q=80&w=600&auto=format&fit=crop', // Desk laptop
                progress: 0.0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                icon: Icons.directions_run, // Close to running shoe
                title: 'Steps',
                value: '0',
                total: '5000',
                imageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=600&auto=format&fit=crop', // Running
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
                imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop', // Travel mountain
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
              borderRadius: BorderRadius.circular(6), // Fit inside the glass card inner radius
              child: Image(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: const Color(0xFF0F172A).withValues(alpha: 0.6), // Darken the image
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
                color: const Color(0xFF3B82F6).withValues(alpha: 0.2), // Light blue tint
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.5)),
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
                color: const Color(0xFF162341).withValues(alpha: 0.60), // Exact fill from Figma
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
                borderRadius: BorderRadius.circular(borderRadius > 0 ? borderRadius - 1 : 0),
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
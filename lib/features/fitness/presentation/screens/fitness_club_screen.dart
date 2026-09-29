import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_club_controller.dart';
import '../../data/models/fitness_club_model.dart';
import 'club_detail_screen.dart';
import 'club_invitations_screen.dart';
import 'create_group_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FitnessClubScreen extends StatefulWidget {
  const FitnessClubScreen({super.key});

  @override
  State<FitnessClubScreen> createState() => _FitnessClubScreenState();
}

class _FitnessClubScreenState extends State<FitnessClubScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final FitnessClubController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());
    _controller.loadClubs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(
              title: AppLocalizations.of(context)?.movemClub ?? 'MoveM Club',
              actions: [
                TopToolBarAction(
                  icon: Icons.mail_outline_rounded,
                  onTap: () => Get.to(() => const ClubInvitationsScreen()),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                color: Colors.blueAccent,
                backgroundColor: AppColors.chipSurface,
                onRefresh: () => _controller.loadClubs(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                      _buildCreateClubCard(),
                      const SizedBox(height: 16),
                      _buildClubListSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDark = AppColors.isDark;
    final radius = BorderRadius.circular(12);
    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.6)
        : AppColors.textSecondary;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: 43,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: isDark
                ? const Color(0xFFE8E8E8).withValues(alpha: 0.2)
                : const Color(0xFF0F172A).withValues(alpha: 0.05),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : const Color(0xFF0F172A).withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: AppColors.textPrimary,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              isCollapsed: true,
              hintText: AppLocalizations.of(context)?.searchForClub ?? 'Search for Club',
              hintStyle: TextStyle(color: hintColor, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.textPrimary, size: 24),
              prefixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 43),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: hintColor, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : const SizedBox(width: 52),
              suffixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 43),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateClubCard() {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => Get.to(() => const CreateGroupScreen()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.isDark ? const Color(0xFF3A4459) : const Color(0xFF1B2436),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.createClub ?? 'Create Club',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n?.createClubSub ?? 'Create Your Own Community, Socialize with us',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.85),
                      fontSize: 12,
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

  Widget _buildClubListSection() {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final clubs = _controller.clubs;
      final query = _searchController.text.trim().toLowerCase();
      final displayClubs = query.isEmpty
          ? clubs.toList()
          : clubs.where((club) => club.name.toLowerCase().contains(query)).toList();

      if (_controller.isLoadingClubs.value && clubs.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: Colors.blueAccent),
          ),
        );
      }

      if (displayClubs.isEmpty) {
        return NoDataComponent(
          title: l10n?.noClubsFound ?? 'No clubs found',
          subtitle: query.isNotEmpty
              ? (l10n?.nothingMatchesSearch ?? 'Nothing matches "$query".')
              : (l10n?.haventJoinedClubsSub ??
                  'Join a club or start your own to train together.'),
        );
      }

      return Column(
        children: [
          for (final club in displayClubs)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _ClubCard(club: club),
            ),
        ],
      );
    });
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({required this.club});

  final FitnessClubModel club;

  static const double _bannerHeight = 92;
  static const double _bodyHeight = 82;
  static const double _badgeWidth = 74;
  static const double _badgeHeight = 84;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textPrimary.withValues(alpha: 0.75);

    return GestureDetector(
      onTap: () => Get.to(() => ClubDetailScreen(club: club)),
      child: Container(
        height: _bannerHeight + _bodyHeight,
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: _bannerHeight,
              child: _MovemBanner(),
            ),
            Positioned(
              left: 14,
              top: _bannerHeight - _badgeHeight / 2,
              child: _HexBadge(
                letter: club.name.isNotEmpty ? club.name[0].toUpperCase() : 'M',
                width: _badgeWidth,
                height: _badgeHeight,
              ),
            ),
            Positioned(
              left: 14 + _badgeWidth + 10,
              right: 16,
              top: _bannerHeight + 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${club.memberCount} Members',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.group_outlined, color: muted, size: 15),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 8,
              child: Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: AppColors.textPrimary,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovemBanner extends StatelessWidget {
  const _MovemBanner();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE6E6E6), Color(0xFFD2D2D2)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: CustomPaint(painter: _SparklePainter(color: Color(0xFFB08A55))),
          ),
          SizedBox(height: 6),
          Text(
            'MOVEM',
            style: TextStyle(
              color: Color(0xFF2A2F3A),
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 14,
              height: 1,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'MOVE MORE . BECOME MORE',
            style: TextStyle(
              color: Color(0xFF9A9A9A),
              fontSize: 6,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.shortestSide / 2;
    final waist = r * 0.14;
    final path = Path()
      ..moveTo(cx, cy - r)
      ..quadraticBezierTo(cx + waist, cy - waist, cx + r, cy)
      ..quadraticBezierTo(cx + waist, cy + waist, cx, cy + r)
      ..quadraticBezierTo(cx - waist, cy + waist, cx - r, cy)
      ..quadraticBezierTo(cx - waist, cy - waist, cx, cy - r)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) => oldDelegate.color != color;
}

class _HexBadge extends StatelessWidget {
  const _HexBadge({required this.letter, required this.width, required this.height});

  final String letter;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipPath(
        clipper: HexagonClipper(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF4F4F4), Color(0xFFD6D6D6)],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              color: Color(0xFF6B6B6B),
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

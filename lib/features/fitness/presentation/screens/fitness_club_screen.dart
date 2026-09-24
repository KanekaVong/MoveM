import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_club_controller.dart';
import '../../data/models/fitness_club_model.dart';
import 'club_detail_screen.dart';
import 'club_explore_screen.dart';
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
                      _buildActionCards(),
                      const SizedBox(height: 24),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.isDark ? const Color(0xFF1E283D) : const Color(0xFF3E4A5C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.searchForClub ?? 'Search for Club',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.6),
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.textCaption, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildActionCards() {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => const ClubExploreScreen());
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B2436),
                      shape: BoxShape.circle,
                    ),
                      child: Icon(
                      Icons.login_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    l10n?.joinClub ?? 'Join Club',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    l10n?.joinClubSub ?? 'Find an active club',
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(() => const CreateGroupScreen());
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B2436),
                      shape: BoxShape.circle,
                    ),
                      child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    l10n?.createClub ?? 'Create Club',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    l10n?.createClubSub ?? 'Create Your Own Community',
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClubListSection() {
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final myClubs = _controller.myClubs;
      final query = _searchController.text.trim().toLowerCase();
      final displayClubs = query.isEmpty
          ? myClubs.toList()
          : myClubs
              .where((club) => club.name.toLowerCase().contains(query))
              .toList();

      if (_controller.isLoadingMyClubs.value && myClubs.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: Colors.blueAccent),
          ),
        );
      }

      if (displayClubs.isEmpty) {
        return NoDataComponent(
          title: query.isNotEmpty
              ? (l10n?.noClubsFound ?? 'No clubs found')
              : (l10n?.haventJoinedClubs ?? "You haven't joined a club yet"),
          subtitle: query.isNotEmpty
              ? (l10n?.nothingMatchesSearch ?? 'Nothing matches "$query".')
              : (l10n?.haventJoinedClubsSub ??
                  'Join a club or start your own to train together.'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n?.yourClubs ?? 'Your Clubs',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ClubExploreScreen());
                },
                child: Text(
                  l10n?.exploreAll ?? 'Explore all »',
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.65),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...displayClubs.map((club) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildMoveMClubCard(club),
            );
          }),
        ],
      );
    });
  }

  Widget _buildMoveMClubCard(FitnessClubModel club) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ClubDetailScreen(club: club));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.borderLight,
            width: 1.2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top half: MoveM metallic banner with star and branding
            Container(
              width: double.infinity,
              height: 84,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8F939D),
                    Color(0xFFA5A9B4),
                    Color(0xFF8F939D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFB38F4D),
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'M  O  V  E  M',
                          style: TextStyle(
                            color: Color(0xFF1B2333),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 6,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'MOVE MORE. BECOME MORE.',
                          style: TextStyle(
                            color: Color(0xFF8C6D33),
                            fontSize: 7.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom section: Hexagon avatar, title, members, double chevron
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  ClipPath(
                    clipper: HexagonClipper(),
                    child: Container(
                      width: 52,
                      height: 56,
                      color: const Color(0xFFE2E8F0),
                      alignment: Alignment.center,
                      child: Text(
                        club.name.isNotEmpty ? club.name[0].toUpperCase() : 'M',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${club.memberCount} Members',
                              style: TextStyle(
                                color: AppColors.textPrimary.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.group_outlined,
                              color: AppColors.textPrimary.withValues(alpha: 0.7),
                              size: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_club_controller.dart';
import '../../data/models/fitness_club_model.dart';
import 'club_detail_screen.dart';
import 'club_explore_screen.dart';
import 'create_group_screen.dart';
import '../../../../core/theme/app_colors.dart';

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
            _buildHeader(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textPrimary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.textPrimary.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textPrimary,
                size: 26,
              ),
            ),
          ),
          const Text(
            'MOVEM CLUB',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textPrimary.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () {
                Get.to(() => const ClubExploreScreen());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E283D).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => _controller.searchClubs(val),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search for Club',
          hintStyle: TextStyle(
            color: AppColors.textPrimary.withValues(alpha: 0.45),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
            size: 22,
          ),
          suffixIcon: Obx(() {
            if (_controller.isSearching.value) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
                ),
              );
            }
            if (_searchController.text.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textCaption, size: 18),
                onPressed: () {
                  _searchController.clear();
                  _controller.searchClubs('');
                },
              );
            }
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildActionCards() {
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
                  color: const Color(0xFF1E2E4A),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF192C54),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textPrimary.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.login_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Join Club',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find an active club',
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
        const SizedBox(width: 14),
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
                  color: const Color(0xFF1E2E4A),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF192C54),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textPrimary.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Create Club',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create Your Own Community',
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
    return Obx(() {
      if (_controller.isSearching.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: Colors.blueAccent),
          ),
        );
      }

      // If user typed in search bar
      if (_searchController.text.trim().isNotEmpty) {
        final results = _controller.searchResults;
        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'No clubs found for "${_searchController.text}"',
                style: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.6)),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Results (${results.length})',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            ...results.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: _buildMoveMClubCard(c),
            )),
          ],
        );
      }

      // Default: Display user's joined clubs first, or public clubs
      final myClubs = _controller.myClubs;
      final publicClubs = _controller.publicClubs;

      if (_controller.isLoadingMyClubs.value && myClubs.isEmpty && publicClubs.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: Colors.blueAccent),
          ),
        );
      }

      final displayClubs = myClubs.isNotEmpty ? myClubs : publicClubs;

      if (displayClubs.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1E2E4A)),
          ),
          child: Column(
            children: [
              const Icon(Icons.group_off_rounded, color: AppColors.textCaption, size: 48),
              const SizedBox(height: 14),
              const Text(
                'No clubs available yet',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Create your own club or explore public clubs to connect with fellow athletes.',
                style: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.6), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                myClubs.isNotEmpty ? 'My Clubs' : 'Discover Clubs',
                style: const TextStyle(
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
                  'Explore all »',
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
            color: const Color(0xFF1E2E4A),
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
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
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
                            const SizedBox(width: 5),
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
                  const Icon(
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

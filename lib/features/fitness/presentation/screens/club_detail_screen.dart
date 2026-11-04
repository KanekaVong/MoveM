import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/storage/user_manager.dart';
import '../controllers/fitness_club_controller.dart';
import '../../data/models/fitness_club_model.dart';
import '../../data/models/group_challenge_model.dart';
import 'club_challenge_detail_screen.dart';
import 'club_members_screen.dart';
import 'club_overview_screen.dart';
import 'create_club_challenge_screen.dart';
import 'invite_people_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/auth_image.dart';
import '../../../../shared/widgets/no_data_component.dart';
import 'package:movem/core/utils/app_snack.dart';
import 'package:movem/shared/widgets/skeletons.dart';
import 'package:movem/core/utils/l10n.dart';

class ClubDetailScreen extends StatefulWidget {
  final FitnessClubModel club;

  const ClubDetailScreen({super.key, required this.club});

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  late final FitnessClubController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());

    _controller.loadClubDetails(widget.club.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Obx(() {
        final currentClub = _controller.selectedClub.value ?? widget.club;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroHeader(currentClub),
              _buildClubIdentity(currentClub),
              const SizedBox(height: 28),
              _buildCustomizeChallengeSection(currentClub),
              const SizedBox(height: 24),
              _buildFeaturedChallengesSection(currentClub),
              const SizedBox(height: 48),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDefaultHero() {
    return Image.asset(
      'assets/images/club_hero_banner.jpg',
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }

  Widget _buildHeroHeader(FitnessClubModel club) {
    final coverUrl = club.coverUrl;
    return Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: coverUrl != null
              // Uploaded covers are protected, so load them with the token.
              ? AuthImage(
                  url: coverUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  fallback: _buildDefaultHero(),
                )
              : _buildDefaultHero(),
        ),
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.35),
                Colors.transparent,
                AppColors.pageBackground.withValues(alpha: 0.8),
                AppColors.pageBackground,
              ],
              stops: const [0.0, 0.4, 0.85, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      color: Colors.black.withValues(alpha: 0.35),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (club.isOwner) ...[
                      GestureDetector(
                        onTap: () => _changeCover(club),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                          child: Obx(
                            () => _controller.isUploadingCover.value
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.photo_camera_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    GestureDetector(
                      onTap: () => Get.to(() => ClubOverviewScreen(club: club)),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.35),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (coverUrl == null)
          Positioned(
            top: 64,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFC8A265),
                  size: 28,
                ),
                const SizedBox(height: 8),
                const Text(
                  'M O V E M',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 9,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tr.clubSlogan,
                  style: TextStyle(
                    color: Color(0xFFC8A265),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildClubIdentity(FitnessClubModel club) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              width: 80,
              height: 86,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipPath(
                clipper: HexagonClipper(),
                child: Image.asset(
                  'assets/images/club_badge_m.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        club.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Get.to(() => ClubMembersScreen(club: club)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${club.memberCount}',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            club.isPrivate ? Icons.lock_outline : Icons.people_outline,
                            color: AppColors.textPrimary,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    if (club.isOwner) ...[
                      GestureDetector(
                        onTap: () => _inviteMembers(club),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.chipSurface,
                            border: Border.all(
                              color: AppColors.textPrimary.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.person_add_alt_outlined,
                            color: AppColors.textPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                    GestureDetector(
                      onTap: () {
                        final shareText = club.joinToken.isNotEmpty
                            ? tr.clubShareWithCode(club.name, club.joinToken)
                            : tr.clubShare(club.name);
                        Share.share(shareText);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.chipSurface,
                          border: Border.all(
                            color: AppColors.textPrimary.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.file_upload_outlined,
                          color: AppColors.textPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_canJoin(club)) ...[
                  SizedBox(height: 12),
                  AppButton(
                    height: 40,
                    width: null,
                    onPressed: () async {
                      if (club.isPrivate) {
                        await _controller.requestToJoin(club);
                      } else {
                        await _controller.joinClub(club);
                        // Reload members so the join button disappears.
                        await _controller.loadClubDetails(club.id);
                      }
                    },
                    label: club.isPrivate ? tr.requestJoin : tr.joinClub,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changeCover(FitnessClubModel club) async {
    if (!club.isOwner) return;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return;
    await _controller.uploadClubCover(club, picked);
  }

  Future<void> _inviteMembers(FitnessClubModel club) async {
    if (!club.isOwner) return;
    final existingIds = _controller.clubMembers.map((m) => m.userId).toSet();
    final result = await Get.to(
      () => InvitePeopleScreen(lockedIds: existingIds),
    );
    if (result is! List<int>) return;

    final newIds = result.where((id) => !existingIds.contains(id)).toList();
    if (newIds.isEmpty) return;

    var added = 0;
    for (final userId in newIds) {
      if (await _controller.addMember(club.id, userId)) added++;
    }

    await _controller.loadClubDetails(club.id);

    final l10n = AppLocalizations.of(Get.context!);
    AppSnack.show(
      added > 0 ? (l10n?.invited ?? 'Invited') : (l10n?.errorTitle ?? 'Error'),
      added > 0
          ? (l10n?.membersAdded(added, club.name) ?? '$added added to ${club.name}.')
          : (l10n?.couldNotAddMembers ?? 'Could not add members. Please try again.'),
      backgroundColor: added > 0 ? const Color(0xFF48A45B) : const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _prettyWorkout(String type) {
    if (type.isEmpty) return tr.activityWorkout;
    return workoutTypeLabel(type);
  }

  String _formatCardDate(DateTime? value) {
    if (value == null) return '';
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day / $month / ${value.year}';
  }

  String _formatCardDateRange(DateTime? start, DateTime? end) {
    if (start == null) return '';
    String part(DateTime value) {
      final day = value.day.toString().padLeft(2, '0');
      final month = value.month.toString().padLeft(2, '0');
      return '$day / $month';
    }

    if (end == null) return part(start);
    return '${part(start)} - ${part(end)}';
  }

  String _formatCardTime(DateTime value) {
    return DateFormat(timePattern('h:mma')).format(value);
  }

  String _formatCardTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return '';
    if (end == null) return _formatCardTime(start);
    return '${_formatCardTime(start)} - ${_formatCardTime(end)}';
  }

  Widget _buildCustomizeChallengeSection(FitnessClubModel club) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: club.isOwner ? () => _openCreateChallenge(club) : null,
            behavior: HitTestBehavior.opaque,
            child: Text(
              // Only the owner can create challenges, so drop the "+" for others.
              club.isOwner
                  ? tr.customizeOwnChallenge
                  : tr.customizeOwnChallenge.replaceAll('+', '').trim(),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final challenges = _controller.customClubChallenges;
          if (challenges.isEmpty && _controller.isLoadingClubDetails.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SkeletonMediaCard(mediaSize: 72, lines: 3),
            );
          }
          if (challenges.isEmpty) return const SizedBox.shrink();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: challenges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final c = challenges[index];
              return _buildChallengeCard(
                title: c.name,
                lines: [
                  _formatCardDate(c.startAt ?? c.endAt),
                  _formatCardTimeRange(c.startAt, c.endAt),
                  _prettyWorkout(c.workoutType),
                ],
                onGetStarted: () => _handleChallengeTap(c),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildFeaturedChallengesSection(FitnessClubModel club) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            tr.featuredChallenges,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final l10n = AppLocalizations.of(Get.context!);
          final recommended = _controller.recommendedClubChallenges;
          final catalog = _controller.catalogChallenges;

          if (_controller.isLoadingClubDetails.value &&
              recommended.isEmpty &&
              catalog.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SkeletonMediaCard(mediaSize: 72, lines: 3),
                  SizedBox(height: 14),
                  SkeletonMediaCard(mediaSize: 72, lines: 3),
                ],
              ),
            );
          }

          if (recommended.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommended.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final c = recommended[index];
                return _buildChallengeCard(
                  title: c.name,
                  lines: [
                    _formatCardDateRange(c.startAt, c.endAt),
                    c.description.isNotEmpty
                        ? c.description
                        : _prettyWorkout(c.workoutType),
                  ],
                  onGetStarted: () => _handleChallengeTap(c),
                );
              },
            );
          }

          if (catalog.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: NoDataComponent(
                compact: true,
                title: l10n?.noClubChallenges ?? 'No featured challenges yet',
                subtitle: l10n?.createOneToStart ?? 'Check back soon for recommended challenges.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: catalog.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final c = catalog[index];
              return _buildChallengeCard(
                title: c.name,
                lines: [
                  '${c.targetValue.toInt()} ${c.targetUnit}',
                  c.description.isNotEmpty
                      ? c.description
                      : _prettyWorkout(c.workoutType),
                ],
                onGetStarted: club.isOwner
                    ? () => _startCatalogChallenge(club, c)
                    : null,
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required List<String> lines,
    required VoidCallback? onGetStarted,
  }) {
    final meta = lines.where((line) => line.trim().isNotEmpty).toList();
    return Container(
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/featured_challenge_runner.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.78),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  for (final line in meta) ...[
                    const SizedBox(height: 3),
                    Text(
                      line,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFFD1D5DB),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  if (onGetStarted != null) ...[
                    const SizedBox(height: 14),
                    AppButton(
                      label: tr.getStarted,
                      onPressed: onGetStarted,
                      width: null,
                      height: 40,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startCatalogChallenge(
    FitnessClubModel club,
    GroupChallengeCatalogModel catalog,
  ) async {
    final created = await _controller.startCatalogChallenge(
      clubId: club.id,
      catalog: catalog,
    );
    if (created != null) {
      _handleChallengeTap(created);
    }
  }

  void _handleChallengeTap(GroupFitnessChallengeModel challenge) {
    Get.to(() => ClubChallengeDetailScreen(challenge: challenge));
  }

  /// `FitnessClubResponse` has no membership flag, so the caller is a member
  /// if they own the club or appear in the loaded member list.
  bool _canJoin(FitnessClubModel club) {
    if (_controller.isLoadingClubDetails.value) return false;
    if (club.isOwner || club.isMember) return false;
    final userId = int.tryParse(UserManager().userId ?? '');
    return !_controller.clubMembers.any((m) => m.userId == userId);
  }

  Future<void> _openCreateChallenge(FitnessClubModel club) async {
    if (!club.isOwner) return;
    final created = await Get.to(() => CreateClubChallengeScreen(club: club));
    if (created == true) {
      await _controller.loadClubDetails(club.id);
    }
  }
}

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

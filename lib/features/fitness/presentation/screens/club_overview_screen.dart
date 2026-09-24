import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/fitness_club_model.dart';
import '../../data/models/group_challenge_model.dart';
import '../controllers/fitness_club_controller.dart';
import 'club_challenge_detail_screen.dart';
import 'club_members_screen.dart';

class ClubOverviewScreen extends StatefulWidget {
  final FitnessClubModel club;

  const ClubOverviewScreen({super.key, required this.club});

  @override
  State<ClubOverviewScreen> createState() => _ClubOverviewScreenState();
}

class _ClubOverviewScreenState extends State<ClubOverviewScreen> {
  late final FitnessClubController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());
    _controller.loadClubDetails(widget.club.id);
  }

  void _showClubInfo() {
    final club = _controller.selectedClub.value ?? widget.club;
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(club.name, style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          [
            club.isPrivate ? 'PRIVATE' : 'PUBLIC',
            if (club.description.isNotEmpty) club.description,
          ].join('\n\n'),
          style: TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close', style: TextStyle(color: AppColors.accentBlue)),
          ),
        ],
      ),
    );
  }

  String _joinedSince(FitnessClubMemberModel member) {
    final year = member.joinedAt?.year;
    return year != null ? 'Joined since $year' : member.role;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '--';
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day / $month / ${value.year}';
  }

  String _formatTime(DateTime value) {
    final period = value.hour >= 12 ? 'PM' : 'AM';
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    return '$hour:${value.minute.toString().padLeft(2, '0')}$period';
  }

  String _formatTimeRange(GroupFitnessChallengeModel challenge) {
    if (challenge.startAt == null) return '';
    if (challenge.endAt == null) return _formatTime(challenge.startAt!);
    return '${_formatTime(challenge.startAt!)} - ${_formatTime(challenge.endAt!)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(
              title: AppLocalizations.of(context)?.clubOverview ?? 'Overview',
              actions: [
                TopToolBarAction(icon: Icons.info_outline, onTap: _showClubInfo),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (_controller.isLoadingClubDetails.value &&
                    _controller.clubMembers.isEmpty &&
                    _controller.clubChallenges.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.accentBlue),
                  );
                }

                final members = _controller.clubMembers;
                final completed = _controller.completedChallenges;

                return RefreshIndicator(
                  color: AppColors.accentBlue,
                  backgroundColor: AppColors.chipSurface,
                  onRefresh: () => _controller.loadClubDetails(widget.club.id),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)?.clubMembers ?? 'MEMBERS',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Get.to(
                              () => ClubMembersScreen(club: widget.club),
                            ),
                            child: Text(
                              AppLocalizations.of(context)?.viewAllArrow ?? 'View All>>',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (members.isEmpty)
                        NoDataComponent(
                          compact: true,
                          title: AppLocalizations.of(context)?.noMembersYet ?? 'No members yet',
                        )
                      else
                        ...members.take(6).map(_memberRow),
                      const SizedBox(height: 28),
                      Text(
                        AppLocalizations.of(context)?.completedChallengesLabel ?? 'COMPLETED CHALLENGES',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (completed.isEmpty)
                        NoDataComponent(
                          compact: true,
                          title: AppLocalizations.of(context)?.noCompletedChallenges ?? 'No completed challenges yet',
                        )
                      else
                        ...completed.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _completedCard(c),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberRow(FitnessClubMemberModel member) {
    final name = member.userName ?? 'Member #${member.userId}';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.chipSurface,
            backgroundImage: (member.avatarUrl != null && member.avatarUrl!.isNotEmpty)
                ? NetworkImage(member.avatarUrl!)
                : null,
            child: (member.avatarUrl == null || member.avatarUrl!.isEmpty)
                ? Text(
                    initial,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _joinedSince(member),
                  style: TextStyle(color: AppColors.textCaption, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _completedCard(GroupFitnessChallengeModel challenge) {
    return GestureDetector(
      onTap: () => Get.to(() => ClubChallengeDetailScreen(challenge: challenge)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 148,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: Image.asset(
                  'assets/images/featured_challenge_runner.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      challenge.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(challenge.startAt ?? challenge.endAt),
                      style: const TextStyle(color: Colors.white, fontSize: 12.5),
                    ),
                    Text(
                      _formatTimeRange(challenge),
                      style: const TextStyle(color: Colors.white, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              const Positioned(
                right: 12,
                bottom: 12,
                child: Text(
                  'CHALLENGE ENDED',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

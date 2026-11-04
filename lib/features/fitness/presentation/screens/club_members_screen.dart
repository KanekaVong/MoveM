import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/fitness_club_model.dart';
import '../controllers/fitness_club_controller.dart';
import 'invite_people_screen.dart';
import 'package:movem/core/utils/app_snack.dart';
import 'package:movem/shared/widgets/skeletons.dart';
import 'package:movem/core/utils/l10n.dart';

class ClubMembersScreen extends StatefulWidget {
  final FitnessClubModel club;

  const ClubMembersScreen({super.key, required this.club});

  @override
  State<ClubMembersScreen> createState() => _ClubMembersScreenState();
}

class _ClubMembersScreenState extends State<ClubMembersScreen> {
  late final FitnessClubController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());

    if (_controller.clubMembers.isEmpty) {
      _controller.loadClubDetails(widget.club.id);
    }
  }

  int? get _currentUserId => int.tryParse(UserManager().userId ?? '');

  bool _canRemove(FitnessClubMemberModel member) {
    if (member.role.toUpperCase() == 'OWNER') return false;
    if (member.userId == _currentUserId) return false;
    return widget.club.isOwner;
  }

  /// Full join date, e.g. "November 10, 2026". Null when the API sent none.
  String? _joinedLabel(FitnessClubMemberModel member) {
    final joinedAt = member.joinedAt;
    if (joinedAt == null) return null;
    return tr.joinedOn(DateFormat.yMMMMd().format(joinedAt.toLocal()));
  }

  static const _ownerGold = Color(0xFFB45309);
  static const _ownerGoldDark = Color(0xFFFBBF24);

  static int _roleRank(String role) => switch (role.toUpperCase()) {
        'OWNER' => 0,
        'ADMIN' => 1,
        _ => 2,
      };

  /// Owner first, then admins, then members by name.
  List<FitnessClubMemberModel> _sorted(List<FitnessClubMemberModel> members) {
    return [...members]..sort((a, b) {
        final byRole = _roleRank(a.role).compareTo(_roleRank(b.role));
        if (byRole != 0) return byRole;
        return (a.userName ?? '').toLowerCase().compareTo((b.userName ?? '').toLowerCase());
      });
  }

  Widget _roleBadge(String role) {
    final upper = role.toUpperCase();
    final (Color background, Color foreground, IconData? icon) = switch (upper) {
      'OWNER' => (
          AppColors.amber.withValues(alpha: AppColors.isDark ? 0.18 : 0.14),
          AppColors.isDark ? _ownerGoldDark : _ownerGold,
          Icons.workspace_premium_rounded,
        ),
      'ADMIN' => (
          AppColors.accentBlue.withValues(alpha: 0.14),
          AppColors.accentBlue,
          Icons.shield_outlined,
        ),
      _ => (AppColors.pageBackground, AppColors.textSecondary, null),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: upper == 'OWNER' || upper == 'ADMIN'
            ? null
            : Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            memberRoleLabel(role),
            style: TextStyle(
              color: foreground,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _invite() async {
    if (!widget.club.isOwner) return;
    final existingIds = _controller.clubMembers.map((m) => m.userId).toSet();
    final result = await Get.to(
      () => InvitePeopleScreen(lockedIds: existingIds),
    );
    if (result is! List<int>) return;

    final newIds = result.where((id) => !existingIds.contains(id)).toList();
    if (newIds.isEmpty) return;

    var added = 0;
    for (final userId in newIds) {
      if (await _controller.addMember(widget.club.id, userId)) added++;
    }
    await _controller.loadClubDetails(widget.club.id);

    final l10n = AppLocalizations.of(Get.context!);
    AppSnack.show(
      added > 0 ? (l10n?.invited ?? 'Invited') : (l10n?.errorTitle ?? 'Error'),
      added > 0
          ? (l10n?.membersAdded(added, widget.club.name) ?? '$added added to ${widget.club.name}.')
          : (l10n?.couldNotAddMembers ?? 'Could not add members. Please try again.'),
      backgroundColor: added > 0 ? const Color(0xFF48A45B) : const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _confirmRemove(FitnessClubMemberModel member) async {
    final l10n = AppLocalizations.of(Get.context!);
    final name = member.userName ?? (l10n?.thisMember ?? 'this member');
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(l10n?.removeMemberTitle ?? 'Remove member', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          l10n?.removeMemberConfirm(name, widget.club.name) ?? 'Remove $name from ${widget.club.name}?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: l10n?.cancel ?? 'Cancel',
                  onPressed: () => Get.back(result: false),
                  height: 46,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.danger(
                  label: l10n?.remove ?? 'Remove',
                  onPressed: () => Get.back(result: true),
                  height: 46,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final removed = await _controller.removeMember(widget.club.id, member.userId);
    if (removed) {
      AppSnack.show(
        l10n?.removedTitle ?? 'Removed',
        l10n?.memberRemoved(name, widget.club.name) ?? '$name was removed from ${widget.club.name}.',
        backgroundColor: const Color(0xFF48A45B),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(
              title: AppLocalizations.of(context)?.clubMembers ?? 'Members',
              actions: [
                if (widget.club.isOwner)
                  TopToolBarAction(icon: Icons.person_add_alt, onTap: _invite),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (_controller.isLoadingClubDetails.value &&
                    _controller.clubMembers.isEmpty) {
                  return SkeletonListView.tiles(itemCount: 7, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8));
                }

                final members = _controller.clubMembers;
                if (members.isEmpty) {
                  return NoDataComponent(
                    title: AppLocalizations.of(context)?.noMembersYet ?? 'No members yet',
                    subtitle: AppLocalizations.of(context)?.inviteToGrowClub ??
                        'Invite people to grow this club.',
                  );
                }

                final sorted = _sorted(members);
                return RefreshIndicator(
                  color: AppColors.accentBlue,
                  backgroundColor: AppColors.chipSurface,
                  onRefresh: () => _controller.loadClubDetails(widget.club.id),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: sorted.length + 1,
                    separatorBuilder: (_, index) =>
                        SizedBox(height: index == 0 ? 12 : 10),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            tr.membersCount(sorted.length).toUpperCase(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        );
                      }
                      return _memberTile(sorted[index - 1]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberTile(FitnessClubMemberModel member) {
    final name = member.userName ?? tr.member;
    final isMe = member.userId == _currentUserId;
    final isOwner = member.role.toUpperCase() == 'OWNER';
    final joined = _joinedLabel(member);
    final hasUsername = member.username != null && member.username!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? AppColors.accentBlue.withValues(alpha: 0.35)
              : AppColors.borderLight,
        ),
        boxShadow: AppColors.isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        children: [
          UserAvatar(
            name: name,
            imageUrl: member.avatarUrl,
            seed: member.userId,
            radius: 22,
            ringColor: isOwner
                ? (AppColors.isDark ? _ownerGoldDark : AppColors.amber)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: name,
                    children: [
                      if (isMe)
                        TextSpan(
                          text: '  (${tr.you})',
                          style: TextStyle(
                            color: AppColors.accentBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hasUsername) ...[
                  const SizedBox(height: 2),
                  Text(
                    '@${member.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                  ),
                ],
                if (joined != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textCaption),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          joined,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.textCaption, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _roleBadge(member.role),
              if (_canRemove(member)) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _confirmRemove(member),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.redError.withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.person_remove_outlined,
                      color: AppColors.redError,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/fitness_club_model.dart';
import '../controllers/fitness_club_controller.dart';
import 'invite_people_screen.dart';

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

  String _subtitleFor(FitnessClubMemberModel member) {
    final year = member.joinedAt?.year;
    if (year != null) return 'Joined since $year';
    switch (member.role.toUpperCase()) {
      case 'OWNER':
        return 'Club owner';
      case 'ADMIN':
        return 'Admin';
      default:
        return 'Member';
    }
  }

  Future<void> _invite() async {
    final existingIds = _controller.clubMembers.map((m) => m.userId).toSet();
    final result = await Get.to(
      () => InvitePeopleScreen(initialSelectedIds: existingIds),
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
    Get.snackbar(
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
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(l10n?.cancel ?? 'Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(l10n?.remove ?? 'Remove', style: const TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final removed = await _controller.removeMember(widget.club.id, member.userId);
    if (removed) {
      Get.snackbar(
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
                TopToolBarAction(icon: Icons.person_add_alt, onTap: _invite),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (_controller.isLoadingClubDetails.value &&
                    _controller.clubMembers.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.accentBlue),
                  );
                }

                final members = _controller.clubMembers;
                if (members.isEmpty) {
                  return NoDataComponent(
                    title: AppLocalizations.of(context)?.noMembersYet ?? 'No members yet',
                    subtitle: AppLocalizations.of(context)?.inviteToGrowClub ??
                        'Invite people to grow this club.',
                  );
                }

                return RefreshIndicator(
                  color: AppColors.accentBlue,
                  backgroundColor: AppColors.chipSurface,
                  onRefresh: () => _controller.loadClubDetails(widget.club.id),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 32),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: members.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) => _memberTile(members[index]),
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
    final name = member.userName ?? 'Member';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: AppColors.chipSurface,
            backgroundImage: (member.avatarUrl != null && member.avatarUrl!.isNotEmpty)
                ? NetworkImage(member.avatarUrl!)
                : null,
            child: (member.avatarUrl == null || member.avatarUrl!.isEmpty)
                ? Text(
                    initial,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitleFor(member),
                  style: TextStyle(color: AppColors.textCaption, fontSize: 12),
                ),
              ],
            ),
          ),
          if (_canRemove(member))
            GestureDetector(
              onTap: () => _confirmRemove(member),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEF4444).withValues(alpha: 0.16),
                ),
                child: const Icon(Icons.remove, color: Color(0xFFEF4444), size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

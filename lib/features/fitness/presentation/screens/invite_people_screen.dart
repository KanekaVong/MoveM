import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../friends/data/dto/response/friend_response.dart';
import '../../../friends/data/repositories/friends_repository_impl.dart';
import '../../../friends/data/services/friends_service.dart';
import '../../../friends/domain/repositories/friends_repository.dart';
import '../../../friends/presentation/controllers/friends_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../shared/widgets/user_avatar.dart';
import 'package:movem/shared/widgets/skeletons.dart';
import 'package:movem/core/utils/l10n.dart';

/// Picks friends to invite. Returns the selected user ids via `Get.back`.
///
/// [initialSelectedIds] start selected and can be unselected (e.g. a group
/// being created). [lockedIds] are people who are already members: they are
/// shown as such and cannot be picked again or removed from here.
class InvitePeopleScreen extends StatefulWidget {
  final Set<int>? initialSelectedIds;
  final Set<int>? lockedIds;

  const InvitePeopleScreen({super.key, this.initialSelectedIds, this.lockedIds});

  @override
  State<InvitePeopleScreen> createState() => _InvitePeopleScreenState();
}

class _InvitePeopleScreenState extends State<InvitePeopleScreen> {
  late final FriendsController _friendsController;
  final Set<int> selectedIds = {};
  final _searchController = TextEditingController();
  String _query = '';

  Set<int> get _lockedIds => widget.lockedIds ?? const {};

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedIds != null) {
      selectedIds.addAll(widget.initialSelectedIds!.where((id) => !_lockedIds.contains(id)));
    }
    if (Get.isRegistered<FriendsController>()) {
      _friendsController = Get.find<FriendsController>();
    } else {
      if (!Get.isRegistered<FriendsService>()) {
        Get.lazyPut<FriendsService>(() => FriendsService());
      }
      if (!Get.isRegistered<FriendsRepository>()) {
        Get.lazyPut<FriendsRepository>(
            () => FriendsRepositoryImpl(friendsService: Get.find()));
      }
      _friendsController = Get.put(FriendsController(repository: Get.find()));
    }

    if (_friendsController.friends.isEmpty) {
      _friendsController.getFriends();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _displayName(FriendResponse person) {
    final full = '${person.firstname} ${person.lastname}'.trim();
    return full.isNotEmpty ? full : person.username;
  }

  bool _matches(FriendResponse person) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return _displayName(person).toLowerCase().contains(q) ||
        person.username.toLowerCase().contains(q);
  }

  void _toggle(FriendResponse person) {
    if (_lockedIds.contains(person.userId)) return;
    setState(() {
      if (!selectedIds.remove(person.userId)) selectedIds.add(person.userId);
    });
  }

  void _finish() => Get.back(result: selectedIds.toList());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: TopToolBar(title: l10n?.invitePeople ?? 'Invite people'),
      body: SafeArea(
        child: Obx(() {
          final allPeople = _friendsController.friends;
          final selectedFriends =
              allPeople.where((p) => selectedIds.contains(p.userId)).toList();
          final visible = allPeople.where(_matches).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _buildSearchField(),
              ),
              if (selectedFriends.isNotEmpty) ...[
                const SizedBox(height: 20),
                _sectionLabel(tr.selectedCountCaps(selectedFriends.length)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 84,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedFriends.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (_, index) => _selectedChip(selectedFriends[index]),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              _sectionLabel(tr.suggested.toUpperCase()),
              const SizedBox(height: 10),
              Expanded(
                child: _friendsController.isLoadingFriends.value && allPeople.isEmpty
                    ? SkeletonListView.tiles(
                        itemCount: 6,
                        trailing: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      )
                    : allPeople.isEmpty
                        ? NoDataComponent(
                            title: l10n?.noFriendsFoundInvite ?? 'No friends found',
                            subtitle: l10n?.addFriendsThenInvite ??
                                'Add friends first, then invite them to this club.',
                          )
                        : visible.isEmpty
                            ? NoDataComponent(title: tr.noUsersFound)
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                itemCount: visible.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (_, index) => _personTile(visible[index]),
                              ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: AppButton(
                  label: selectedIds.isEmpty ? tr.done : tr.inviteCount(selectedIds.length),
                  icon: selectedIds.isEmpty ? null : Icons.person_add_alt_1_rounded,
                  onPressed: _finish,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value.trim()),
      style: TextStyle(color: AppColors.textPrimary),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: tr.searchPeopleOnMovem,
        hintStyle: TextStyle(color: AppColors.textCaption),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textCaption),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: Icon(Icons.close_rounded, color: AppColors.textCaption, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
        filled: true,
        fillColor: AppColors.cardSurface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.accentBlue, width: 1.4),
        ),
      ),
    );
  }

  Widget _selectedChip(FriendResponse person) {
    final name = _displayName(person);
    return GestureDetector(
      onTap: () => _toggle(person),
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                UserAvatar(
                  name: name,
                  imageUrl: person.profilePic,
                  seed: person.userId,
                  radius: 26,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.pageBackground, width: 2),
                    ),
                    child: Icon(Icons.close_rounded, size: 10, color: AppColors.pageBackground),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personTile(FriendResponse person) {
    final name = _displayName(person);
    final isLocked = _lockedIds.contains(person.userId);
    final isSelected = selectedIds.contains(person.userId);
    final hasUsername = person.username.isNotEmpty && person.username != name;

    return GestureDetector(
      onTap: isLocked ? null : () => _toggle(person),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentBlue.withValues(alpha: AppColors.isDark ? 0.16 : 0.07)
              : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.accentBlue.withValues(alpha: 0.55)
                : AppColors.borderLight,
          ),
        ),
        child: Opacity(
          opacity: isLocked ? 0.6 : 1,
          child: Row(
            children: [
              UserAvatar(
                name: name,
                imageUrl: person.profilePic,
                seed: person.userId,
                radius: 21,
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isLocked || hasUsername) ...[
                      const SizedBox(height: 2),
                      Text(
                        isLocked ? tr.alreadyMemberTitle : '@${person.username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (isLocked)
                Icon(Icons.how_to_reg_rounded, color: AppColors.emerald, size: 22)
              else
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.accentBlue : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.accentBlue : AppColors.borderMuted,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

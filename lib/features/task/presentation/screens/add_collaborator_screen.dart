import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/add_collaborator_controller.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class AddCollaboratorScreen extends GetView<AddCollaboratorController> {
  const AddCollaboratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddCollaboratorController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopToolBar(
              title: AppLocalizations.of(context)?.addCollaborator ?? 'Add Collaborator',
              actions: [
                TopToolBarAction(
                  icon: Icons.check_rounded,
                  onTap: () => controller.inviteSelected(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: _buildSearchBar(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                l10n?.suggested ?? 'Suggested',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: Color(0xFF4B9D62)),
                  );
                }

                final users = controller.displayedUsers;
                final query = controller.searchQuery.value;

                if (users.isEmpty && query.isNotEmpty) {
                  return _buildCustomUserOption(query);
                }

                if (users.isEmpty) {
                  return NoDataComponent(
                    title: l10n?.noFriendsFoundInvite ?? 'No friends found',
                    subtitle: l10n?.addFriendsForTask ?? 'Add friends so you can invite them to this task.',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final friend = users[index];
                    final displayName = '${friend.firstname} ${friend.lastname}'.trim();
                    final name = displayName.isNotEmpty ? displayName : friend.username;
                    final username = '@${friend.username}';
                    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

                    return Obx(() {
                      final isSelected = controller.selectedFriends.contains(friend);
                      final isMember = controller.isAlreadyMember(friend);
                      final isInvited = controller.isAlreadyInvited(friend);
                      final isUnavailable = isMember || isInvited;

                      return Opacity(
                        opacity: isUnavailable ? 0.65 : 1.0,
                        child: GestureDetector(
                          onTap: isUnavailable ? null : () => controller.toggleSelection(friend),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.cardSurface : AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Color(0xFF4B9D62) : AppColors.textPrimary.withOpacity(0.06),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (friend.profilePic.isNotEmpty)
                                  ClipOval(
                                    child: Image.network(
                                      friend.profilePic,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(initial),
                                    ),
                                  )
                                else
                                  _buildAvatarPlaceholder(initial),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        username,
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isMember)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4B9D62).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF4B9D62).withOpacity(0.3)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle_outline, size: 13, color: Color(0xFF4B9D62)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Member',
                                          style: TextStyle(
                                            color: Color(0xFF4B9D62),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (isInvited)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAB308).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFEAB308).withOpacity(0.3)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.schedule, size: 13, color: Color(0xFFEAB308)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Invited',
                                          style: TextStyle(
                                            color: Color(0xFFEAB308),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? const Color(0xFF4B9D62) : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected ? Color(0xFF4B9D62) : AppColors.textCaption,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(Icons.check, size: 14, color: AppColors.textPrimary)
                                        : null,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String initial) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.cardSurface,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.06)),
      ),
      child: TextField(
        controller: controller.searchController,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          hintText: l10n?.searchCollaboratorsHint ?? 'Search for Collaborator',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildCustomUserOption(String query) {
    return Obx(() {
      final isMember = controller.isCustomAlreadyMember(query);
      final isInvited = controller.isCustomAlreadyInvited(query);
      final isUnavailable = isMember || isInvited;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Opacity(
          opacity: isUnavailable ? 0.65 : 1.0,
          child: GestureDetector(
            onTap: isUnavailable ? null : () => controller.inviteCustom(query),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.textPrimary.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.cardSurface,
                    child: Text(
                      query.isNotEmpty ? query[0].toUpperCase() : '?',
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Invite "$query"',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (isMember)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B9D62).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF4B9D62).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, size: 13, color: Color(0xFF4B9D62)),
                          SizedBox(width: 4),
                          Text(
                            'Member',
                            style: TextStyle(
                              color: Color(0xFF4B9D62),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isInvited)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAB308).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEAB308).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule, size: 13, color: Color(0xFFEAB308)),
                          SizedBox(width: 4),
                          Text(
                            'Invited',
                            style: TextStyle(
                              color: Color(0xFFEAB308),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Icon(Icons.person_add_alt_1, color: Color(0xFF4B9D62), size: 20),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

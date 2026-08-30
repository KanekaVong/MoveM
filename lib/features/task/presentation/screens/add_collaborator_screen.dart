import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/add_collaborator_controller.dart';

class AddCollaboratorScreen extends GetView<AddCollaboratorController> {
  const AddCollaboratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddCollaboratorController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.taskDarkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.taskDetailBackground,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.35),
                    AppColors.taskDarkBackground.withOpacity(0.65),
                    AppColors.taskDarkBackground.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: _buildSearchBar(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Text(
                    l10n?.suggested ?? 'Suggested',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.taskBluePrimary),
                      );
                    }

                    final users = controller.displayedUsers;
                    final query = controller.searchQuery.value;

                    if (users.isEmpty && query.isNotEmpty) {
                      return _buildCustomUserOption(query);
                    }

                    if (users.isEmpty) {
                      return const Center(
                        child: Text(
                          'No friends found',
                          style: TextStyle(
                            color: AppColors.taskTextMuted,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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
                          return GestureDetector(
                            onTap: () => controller.toggleSelection(friend),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.taskFigmaCard.withOpacity(0.25)
                                    : AppColors.taskFigmaCard.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.taskGreenAccent : Colors.transparent,
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
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          username,
                                          style: const TextStyle(
                                            color: AppColors.taskTextMuted,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? AppColors.taskGreenAccent : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected ? AppColors.taskGreenAccent : AppColors.taskTextSecondary,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 14, color: Colors.black)
                                        : null,
                                  ),
                                ],
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
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String initial) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.taskAvatarBg,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
                color: const Color(0x33000000),
                border: Border.all(color: Colors.white.withOpacity(0.24), width: 1),
              ),
              child: const Center(
                child: Icon(Icons.chevron_left, color: Colors.white, size: 22),
              ),
            ),
          ),
          Text(
            l10n?.addCollaborator ?? 'Add Collaborator',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          GestureDetector(
            onTap: () => controller.inviteSelected(),
            child: Text(
              l10n?.invite ?? 'Invite',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.taskFigmaCard.withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller.searchController,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.white70, size: 20),
          hintText: l10n?.searchCollaboratorsHint ?? 'Search for Collaborator',
          hintStyle: const TextStyle(
            color: AppColors.taskTextMuted,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () => controller.inviteCustom(query),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.taskFigmaCard.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.taskAvatarBg,
                child: Text(
                  query.isNotEmpty ? query[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Invite "$query"',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.person_add_alt_1, color: AppColors.taskGreenAccent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

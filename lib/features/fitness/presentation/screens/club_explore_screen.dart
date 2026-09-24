import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_club_controller.dart';
import '../../data/models/fitness_club_model.dart';
import 'club_detail_screen.dart';
import 'create_group_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../l10n/app_localizations.dart';

class ClubExploreScreen extends StatelessWidget {
  const ClubExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());

    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: TopToolBar(
          title: l10n?.movemClubs ?? 'MoveM Clubs',
          actions: [
            TopToolBarAction(
              icon: Icons.add_circle_outline,
              iconSize: 22,
              onTap: () => Get.to(() => const CreateGroupScreen()),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: AppColors.textCaption,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: l10n?.discoverClubs ?? 'Discover Clubs'),
              Tab(text: l10n?.yourClubs ?? 'My Clubs'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: (val) => controller.searchClubs(val),
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: l10n?.searchClubsHint ?? 'Search clubs by name...',
                  hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: AppColors.textCaption),
                  filled: true,
                  fillColor: AppColors.chipSurface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDiscoverTab(controller),
                  _buildMyClubsTab(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverTab(FitnessClubController controller) {
    final l10n = AppLocalizations.of(Get.context!);
    return Obx(() {
      if (controller.isSearching.value) {
        return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      }

      final list = controller.searchResults.isNotEmpty
          ? controller.searchResults
          : controller.publicClubs;

      if (controller.isLoadingPublicClubs.value && list.isEmpty) {
        return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      }

      if (list.isEmpty) {
        return NoDataComponent(
          title: l10n?.noClubsFound ?? 'No clubs found',
          subtitle: l10n?.beFirstClub ?? 'Be the first to create a fitness community!',
          actionLabel: l10n?.createClub ?? 'Create Club',
          onAction: () => Get.to(() => const CreateGroupScreen()),
        );
      }

      return RefreshIndicator(
        color: Colors.blueAccent,
        backgroundColor: AppColors.chipSurface,
        onRefresh: () => controller.fetchPublicClubs(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final club = list[index];
            return _buildClubCard(club, controller);
          },
        ),
      );
    });
  }

  Widget _buildMyClubsTab(FitnessClubController controller) {
    final l10n = AppLocalizations.of(Get.context!);
    return Obx(() {
      if (controller.isLoadingMyClubs.value && controller.myClubs.isEmpty) {
        return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      }

      if (controller.myClubs.isEmpty) {
        return NoDataComponent(
          title: l10n?.haventJoinedClubs ?? "You haven't joined any clubs yet",
          subtitle: l10n?.haventJoinedClubsSub ??
              'Join a club or start your own to workout together!',
          actionLabel: l10n?.createClub ?? 'Create Your Club',
          onAction: () => Get.to(() => const CreateGroupScreen()),
        );
      }

      return RefreshIndicator(
        color: Colors.blueAccent,
        backgroundColor: AppColors.chipSurface,
        onRefresh: () => controller.fetchMyClubs(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.myClubs.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final club = controller.myClubs[index];
            return _buildClubCard(club, controller, isMyClub: true);
          },
        ),
      );
    });
  }

  Widget _buildClubCard(FitnessClubModel club, FitnessClubController controller, {bool isMyClub = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chipSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(() => ClubDetailScreen(club: club));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      club.name.isNotEmpty ? club.name[0].toUpperCase() : 'C',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              club.name,
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: club.isPrivate ? Colors.amber.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              club.isPrivate ? 'PRIVATE' : 'PUBLIC',
                              style: TextStyle(
                                color: club.isPrivate ? Colors.amber : Colors.greenAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        club.description.isNotEmpty ? club.description : 'Move together, reach goals faster.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.people_outline, color: Colors.blueAccent, size: 14),
                          SizedBox(width: 4),
                          Text('${club.memberCount} members', style: TextStyle(color: AppColors.textCaption, fontSize: 11)),
                          if (club.isOwner) ...[
                            SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('OWNER', style: TextStyle(color: Colors.purpleAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                if (isMyClub || club.isMember)
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: AppColors.textCaption, size: 16),
                    onPressed: () => Get.to(() => ClubDetailScreen(club: club)),
                  )
                else
                  AppButton(
                    width: null,
                    height: 40,
                    onPressed: () {
                      if (club.isPrivate) {
                        controller.requestToJoin(club);
                      } else {
                        controller.joinClub(club);
                      }
                    },
                    label: club.isPrivate
                        ? (AppLocalizations.of(Get.context!)?.requestJoin ?? 'Request')
                        : (AppLocalizations.of(Get.context!)?.join ?? 'Join'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

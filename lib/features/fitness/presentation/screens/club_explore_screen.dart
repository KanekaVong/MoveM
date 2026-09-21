import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_club_controller.dart';
import '../../data/models/fitness_club_model.dart';
import 'club_detail_screen.dart';
import 'create_group_screen.dart';
import '../../../../core/theme/app_colors.dart';

class ClubExploreScreen extends StatelessWidget {
  const ClubExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FitnessClubController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: AppBar(
          backgroundColor: AppColors.pageBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'MoveM Clubs',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent, size: 26),
              tooltip: 'Create Club',
              onPressed: () {
                Get.to(() => const CreateGroupScreen());
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: AppColors.textCaption,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Discover Clubs'),
              Tab(text: 'My Clubs'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: (val) => controller.searchClubs(val),
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search clubs by name...',
                  hintStyle: const TextStyle(color: AppColors.textCaption, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textCaption),
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
    return Obx(() {
      if (controller.isSearching.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      }

      final list = controller.searchResults.isNotEmpty
          ? controller.searchResults
          : controller.publicClubs;

      if (controller.isLoadingPublicClubs.value && list.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      }

      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.groups_outlined, color: AppColors.textCaption, size: 64),
              const SizedBox(height: 16),
              const Text('No clubs found', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Be the first to create a fitness community!', style: TextStyle(color: AppColors.textCaption, fontSize: 12)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Get.to(() => const CreateGroupScreen()),
                icon: const Icon(Icons.add, color: AppColors.textPrimary),
                label: const Text('Create Club', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
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
    return Obx(() {
      if (controller.isLoadingMyClubs.value && controller.myClubs.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      }

      if (controller.myClubs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fitness_center, color: AppColors.textCaption, size: 64),
              const SizedBox(height: 16),
              const Text("You haven't joined any clubs yet", style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Join a club or start your own to workout together!', style: TextStyle(color: AppColors.textCaption, fontSize: 12)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Get.to(() => const CreateGroupScreen()),
                child: const Text('Create Your Club', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: Colors.blueAccent,
        backgroundColor: AppColors.chipSurface,
        onRefresh: () => controller.fetchMyClubs(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.myClubs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              club.name,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
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
                      const SizedBox(height: 4),
                      Text(
                        club.description.isNotEmpty ? club.description : 'Move together, reach goals faster.',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people_outline, color: Colors.blueAccent, size: 14),
                          const SizedBox(width: 4),
                          Text('${club.memberCount} members', style: const TextStyle(color: AppColors.textCaption, fontSize: 11)),
                          if (club.isOwner) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('OWNER', style: TextStyle(color: Colors.purpleAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isMyClub || club.isMember)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textCaption, size: 16),
                    onPressed: () => Get.to(() => ClubDetailScreen(club: club)),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (club.isPrivate) {
                        controller.requestToJoin(club);
                      } else {
                        controller.joinClub(club);
                      }
                    },
                    child: Text(
                      club.isPrivate ? 'Request' : 'Join',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

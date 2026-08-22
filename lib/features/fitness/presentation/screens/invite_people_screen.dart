import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../friends/data/repositories/friends_repository_impl.dart';
import '../../../friends/data/services/friends_service.dart';
import '../../../friends/domain/repositories/friends_repository.dart';
import '../../../friends/presentation/controllers/friends_controller.dart';


class InvitePeopleScreen extends StatefulWidget {
  const InvitePeopleScreen({super.key});

  @override
  State<InvitePeopleScreen> createState() => _InvitePeopleScreenState();
}

class _InvitePeopleScreenState extends State<InvitePeopleScreen> {
  late final FriendsController _friendsController;
  final Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
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

    // Fetch friends if empty
    if (_friendsController.friends.isEmpty) {
      _friendsController.getFriends();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
        centerTitle: true,
        title: const Text('Invite people',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              // Pass selected user ids back or proceed
              Get.back();
            },
            child: const Text('Invite',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() {
            final allPeople = _friendsController.friends;

            // Get selected friends objects
            final selectedFriends =
                allPeople.where((p) => selectedIds.contains(p.userId)).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search for people on strava',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (selectedFriends.isNotEmpty) ...[
                  Text('MEMBERS (${selectedFriends.length})',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedFriends.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final person = selectedFriends[index];
                        return Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  child: Text(
                                      person.firstname.isNotEmpty
                                          ? person.firstname[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIds.remove(person.userId);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          size: 10, color: Colors.black),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(person.firstname,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                const Text('Suggested',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: _friendsController.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Colors.blueAccent))
                      : allPeople.isEmpty
                          ? const Center(
                              child: Text('No friends found.',
                                  style: TextStyle(color: Colors.white54)))
                          : ListView.separated(
                              itemCount: allPeople.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final person = allPeople[index];
                                final isSelected =
                                    selectedIds.contains(person.userId);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIds.remove(person.userId);
                                      } else {
                                        selectedIds.add(person.userId);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0B2B6A),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.2),
                                          child: Text(
                                              person.firstname.isNotEmpty
                                                  ? person.firstname[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                            '${person.firstname} ${person.lastname}'
                                                .trim(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? Colors.blueAccent
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.blueAccent
                                                  : Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Icon(Icons.check,
                                                  color: Colors.white, size: 16)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

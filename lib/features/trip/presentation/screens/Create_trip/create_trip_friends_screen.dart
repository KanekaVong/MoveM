import 'package:flutter/material.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import 'create_trip_packing_screen.dart';

import '../../controllers/trip_controller.dart';

class CreateTripFriendsScreen extends StatefulWidget {
  final CreateTripDraft draft;
  final TripController tripController;

  const CreateTripFriendsScreen({
    super.key,
    required this.draft,
    required this.tripController,
  });

  @override
  State<CreateTripFriendsScreen> createState() =>
      _CreateTripFriendsScreenState();
}

class _CreateTripFriendsScreenState
    extends State<CreateTripFriendsScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  bool _showFriends = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _continue() {
    setState(() {
      _showFriends = false;
    });
  }

  void _goToPacking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTripPackingScreen(
          draft: widget.draft,
          tripController: widget.tripController,
        )
      ),
    );
  }

  void _addFriend() {
    final name = _searchController.text.trim();

    if (name.isEmpty) {
      return;
    }

    setState(() {
      widget.draft.friends.add(name);
      _searchController.clear();
    });
  }

  void _removeFriend(int index) {
    setState(() {
      widget.draft.friends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: _showFriends
                  ? _buildFriendsContent()
                  : _buildPackingIntro(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        8,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (!_showFriends) {
                setState(() {
                  _showFriends = true;
                });
              } else {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Create New Trip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
          const SizedBox(width: 6),
          _buildStep(true),
        ],
      ),
    );
  }

  Widget _buildStep(bool active) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildFriendsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTripHeader(),

          const SizedBox(height: 28),

          const Text(
            "Who's Coming?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Invite friends to join your trip',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      color: Colors.white30,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white54,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF171E2D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _addFriend,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (widget.draft.friends.isEmpty)
            _buildEmptyFriends()
          else
            _buildFriendsList(),

          const SizedBox(height: 30),

          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyFriends() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF171E2D),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'No friends added yet.',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildFriendsList() {
    return Column(
      children: [
        for (int i = 0;
        i < widget.draft.friends.length;
        i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF171E2D),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.draft.friends[i].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeFriend(i),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPackingIntro() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTripHeader(),

          const SizedBox(height: 28),

          const Text(
            'Need help with what to pack?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Check what you and your friends need to pack!',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF171E2D),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white12,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.backpack_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Trip Essentials+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white54,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _goToPacking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.draft.activityName ?? 'Your Trip',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.draft.locationName ??
                widget.draft.destination ??
                'Location',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.draft.durationDays} '
                '${widget.draft.durationDays == 1 ? 'day' : 'days'}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'CONTINUE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
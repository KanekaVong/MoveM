import 'package:flutter/material.dart';
import 'package:movem/l10n/app_localizations.dart';

import 'create_trip_packing_screen.dart';
import 'package:movem/features/trip/presentation/widgets/create_trip_component.dart';
import '../../controllers/create_trip_controller.dart';
import 'package:get/get.dart';
import 'package:movem/features/friends/data/dto/response/friend_response.dart';
import 'package:movem/features/friends/domain/repositories/friends_repository.dart';
import '../../../../../core/network/api_result.dart';



class CreateTripFriendsScreen extends StatefulWidget {

  const CreateTripFriendsScreen({
    super.key,
  });

  @override
  State<CreateTripFriendsScreen> createState() =>
      _CreateTripFriendsScreenState();
}

class _CreateTripFriendsScreenState
    extends State<CreateTripFriendsScreen> {

  final CreateTripController controller = Get.find<CreateTripController>();

  late final FriendsRepository _friendsRepository;


  final TextEditingController _searchController = TextEditingController();


  List<FriendResponse> _friends = [];
  bool _isLoadingFriends = true;
  String? _friendsError;


  Future<void> _searchFriends(String keyword) async {
    final query = keyword.trim();

    if (query.isEmpty) {
      await _loadSuggestions();
      return;
    }

    setState(() {
      _isLoadingFriends = true;
      _friendsError = null;
    });

    final result =
    await _friendsRepository.searchFriends(query);

    if (!mounted) return;

    if (result is ApiSuccess<List<FriendResponse>>) {
      setState(() {
        _friends = result.data;
        _isLoadingFriends = false;
      });
    } else if (result is ApiError<List<FriendResponse>>) {
      setState(() {
        _friends = [];
        _isLoadingFriends = false;
        _friendsError = result.exception.message;
      });
    }
  }

  void _toggleFriend(FriendResponse friend) {
    setState(() {
      final alreadySelected =
      controller.currentDraft.friends.any(
            (item) => item.userId == friend.userId,
      );

      if (alreadySelected) {
        controller.currentDraft.friends.removeWhere(
              (item) => item.userId == friend.userId,
        );
      } else {
        controller.currentDraft.friends.add(friend);
      }
    });
  }

  Future<void> _loadSuggestions() async {
    setState(() {
      _isLoadingFriends = true;
      _friendsError = null;
    });

    final result =
    await _friendsRepository.getSuggestions();

    if (!mounted) return;

    if (result is ApiSuccess<List<FriendResponse>>) {
      setState(() {
        _friends = result.data;
        _isLoadingFriends = false;
      });
    } else if (result is ApiError<List<FriendResponse>>) {
      setState(() {
        _friends = [];
        _isLoadingFriends = false;
        _friendsError = result.exception.message;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _friendsRepository = Get.find<FriendsRepository>();

    _loadSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _continue() {
    Get.to(
          () => const CreateTripPackingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageHeight = screenHeight * 0.50;

    final panelTop = keyboardOpen
        ? screenHeight * 0.15
        : screenHeight * 0.43;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark
          ? CreateTripColors.darkBackground
          : CreateTripColors.lightBackground,
      body: Stack(
        children: [

          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/create_new_trip_bg.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent,
                          Colors.black.withOpacity(0.15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreateTripHeader(
                    title: l10n.createNewTrip,
                    onBack: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 8),

                  CreateTripStepIndicator(
                    activeIndex: 4,
                  ),
                ],
              ),
            ),
          ),

          // Friends form panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: panelTop,
            left: 0,
            right: 0,
            bottom: keyboardOpen
                ? keyboardHeight
                : 0,
            child: Obx(
                  () => _buildFriendsContent(l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsContent(AppLocalizations l10n) {

    final selectedFriends = controller.currentDraft.friends;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark
        ? Colors.white
        : CreateTripColors.lightText;

    final secondaryColor = isDark
        ? Colors.white54
        : CreateTripColors.lightText.withValues(
      alpha: 0.5,
    );

    final query = _searchController.text.trim();
    final friends = _friends;

    return CreateTripFormPanel(
      bottomAction: CreateTripBottomButton(
        text: l10n.continueButton,
        onPressed: _continue,
      ),
      children: [
      SliverToBoxAdapter(
        child: Text(
          l10n.tripFriendsTitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback: CreateTripFonts.khmerFallback,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
      ),

      const SliverToBoxAdapter(
        child: SizedBox(height: 8),
      ),

      SliverToBoxAdapter(
        child: Text(
          l10n.tripFriendsSubtitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback: CreateTripFonts.khmerFallback,
            fontSize: 13,
            color: secondaryColor,
          ),
        ),
      ),

      const SliverToBoxAdapter(
        child: SizedBox(height: 22),
      ),

      SliverToBoxAdapter(
        child: TextField(
          controller: _searchController,
          onChanged: _searchFriends,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback: CreateTripFonts.khmerFallback,
            color: titleColor,
          ),
          decoration: InputDecoration(
            hintText: l10n.tripFriendsSearchHint,
            hintStyle: TextStyle(
              fontFamily: CreateTripFonts.condensed,
              fontFamilyFallback: CreateTripFonts.khmerFallback,
              color: secondaryColor,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: secondaryColor,
            ),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF171E2D)
                : const Color(0xFFF2F2F2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
          ),
        ),
      ),

      if (selectedFriends.isNotEmpty) ...[
        const SliverToBoxAdapter(
          child: SizedBox(height: 28),
        ),

        SliverToBoxAdapter(
          child: Text(
            l10n.tripFriendsInvitedTitle,
            style: TextStyle(
              fontFamily: CreateTripFonts.condensed,
              fontFamilyFallback: CreateTripFonts.khmerFallback,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 14),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedFriends.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final friend = selectedFriends[index];

                return CreateTripAvatarChip(
                  name:
                  '${friend.firstname} ${friend.lastname}'.trim(),
                  imageUrl: friend.profilePic,
                  onRemove: () {
                    setState(() {
                      selectedFriends.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],

      const SliverToBoxAdapter(
        child: SizedBox(height: 28),
      ),

      SliverToBoxAdapter(
        child: Text(
          query.isEmpty
              ? l10n.tripFriendsSuggestedTitle
              : l10n.tripFriendsSearchResultsTitle,
          style: TextStyle(
            fontFamily: CreateTripFonts.condensed,
            fontFamilyFallback: CreateTripFonts.khmerFallback,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
      ),

      const SliverToBoxAdapter(
        child: SizedBox(height: 8),
      ),

      if (friends.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
            ),
            child: Center(
              child: Text(
                l10n.tripFriendsNoFriendsFound,
                style: TextStyle(
                  fontFamily: CreateTripFonts.condensed,
                  fontFamilyFallback:
                  CreateTripFonts.khmerFallback,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final friend = friends[index];

              return CreateTripSelectableFriendTile(
                name:
                '${friend.firstname} ${friend.lastname}'.trim(),
                username: friend.username,
                imageUrl: friend.profilePic,
                selected: selectedFriends.any(
                      (item) => item.userId == friend.userId,
                ),
                onTap: () => _toggleFriend(friend),
              );
            },
            childCount: friends.length,
          ),
        ),
      ],
    );
  }

}
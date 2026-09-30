import 'package:flutter/material.dart';
import '../../data/dto/response/trip_response.dart';
import '../controllers/edit_trip_controller.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/edit_trip_components.dart';
import 'trip_route_screen.dart';
import 'package:movem/features/groups/data/services/group_service.dart';
import 'package:movem/features/groups/data/dto/response/group_search_user_response.dart';
import 'trip_budget_screen.dart';
import '../controllers/trip_budget_controller.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../../data/services/trip_service.dart';

class TripDetailScreen extends StatefulWidget {
  final String activityId;
  final EditTripController editTripController;

  const TripDetailScreen({
    super.key,
    required this.activityId,
    required this.editTripController
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.editTripController.loadEditTripData();
    });
  }

  String _formatDate(DateTime? date) {
    final l10n = AppLocalizations.of(context);
    if (date == null) return l10n?.editTripDatesNotSet ?? 'Not set';

    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatDateRange(TripResponse trip) {
    final l10n = AppLocalizations.of(context);

    if (trip.startActivity == null) {
      return l10n?.editTripDatesNotSet ?? 'Dates not set';
    }

    if (trip.deadline == null) {
      return _formatDate(trip.startActivity);
    }

    return '${_formatDate(trip.startActivity)} - '
        '${_formatDate(trip.deadline)}';
  }

  void _showInviteFriendSheet(TripResponse trip) {
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF151B2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return _InviteFriendSheet(
          activityId: trip.activityId,
          searchController: searchController,
        );
      },
    );
  }


 // trip detail build
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;
    final bottomInset = mediaQuery.padding.bottom;

    final formTop = keyboardOpen
        ? screenHeight * 0.15
        : screenHeight * 0.53;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0B132B),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/trip_detail_bg.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withValues(alpha: 0.35),
              ),
            ),
          ),

          // Header + Trip Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(context),

                Expanded(
                  child: Obx(() {
                    final trip =
                        widget.editTripController.trip.value;

                    if (trip == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final isEditing =
                        widget.editTripController.isEditing.value;

                    if (!isEditing) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom: bottomInset,
                          ),
                          child: _buildContent(trip),
                        ),
                      );
                    }

                    // Trip detail content while editing
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 24,
                      ),
                      child: _buildContent(trip),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Edit Panel
          Obx(() {
            if (!widget.editTripController.isEditing.value) {
              return const SizedBox.shrink();
            }

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              top: formTop,
              left: 0,
              right: 0,
              bottom: keyboardHeight,
              child: _buildEditPanel(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(TripResponse trip) {

    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Large Main Title ("SUMMER BOYS")
          GestureDetector(
            onTap: () => widget.editTripController.selectEditSection(
              'tripName',
            ),
            child: Text(
            (trip.activityName ??l10n?.trip ??'Trip').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
          ),

          const SizedBox(height: 20),

          // Two-Column Grid Info Tiles
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoTile(
                      label: l10n?.editTripDestination ?? 'DESTINATION',
                      value: trip.locationName ?? trip.destination ?? l10n?.editTripNotSelected ?? 'Not selected',
                      icon: Icons.location_pin,
                      iconColor: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      label: l10n?.editTripBudget ?? 'BUDGET',
                      value: '\$${(trip.totalBudget ?? 0).toStringAsFixed(0)}',
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: Colors.amber,
                      showArrow: true,
                      onTap: () {
                        final budgetController = TripBudgetController(
                          repository: TripRepositoryImpl(
                            tripService: TripService(),
                          ),
                          activityId: trip.activityId,
                        );

                        Get.to(
                              () => TripBudgetScreen(
                            budgetController: budgetController,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      label: l10n?.editTripFriends ?? 'FRIENDS',
                      value: '${trip.memberCount ?? 0}',
                      icon: Icons.people_rounded,
                      iconColor: Colors.lightBlueAccent,
                      onTap: () => widget.editTripController.selectEditSection(
                        'members',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      label: l10n?.editTripStops ?? 'STOPS',
                      value: '${trip.stops.length} ${l10n?.places ?? 'Places'}',
                      icon: Icons.map_rounded,
                      iconColor: Colors.cyanAccent,
                      onTap: () => widget.editTripController.selectEditSection(
                        'stops',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoTile(
                      label: l10n?.editTripDurations ?? 'DURATIONS',
                      value: _formatDateRange(trip),
                      icon: Icons.hourglass_bottom_rounded,
                      iconColor: Colors.orangeAccent,
                      onTap: () => widget.editTripController.selectEditSection(
                        'duration',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Checklists row
                    _buildInfoTile(
                      label: l10n?.editTripChecklists ?? 'CHECKLISTS',
                      value: '${trip.checklists?.length ?? 0} '
                          '${(trip.checklists?.length ?? 0) == 1
                          ? (l10n?.editTripItem ?? 'Item')
                          : (l10n?.editTripItems ?? 'Items')} '
                          '${l10n?.editTripToBePrepared ?? 'to be prepared'}',
                      icon: Icons.checklist_rounded,
                      iconColor: Colors.greenAccent,
                      onTap: () => widget.editTripController.selectEditSection(
                        'checklist',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      label: l10n?.editTripEssentials ?? 'ESSENTIALS',
                      value: '${widget.editTripController.packingItems.length} ${l10n?.editTripItemsToBePacked ?? 'Items to be packed'}',
                      icon: Icons.backpack_rounded,
                      iconColor: Colors.brown,
                      onTap: () => widget.editTripController.selectEditSection(
                        'packing',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      label: l10n?.editTripAttachments ?? 'ATTACHMENTS',
                      value:
                      '${widget.editTripController.attachments.length} ${l10n?.editTripAttachments ?? 'Attachments'}',
                      icon: Icons.attach_file_rounded,
                      iconColor: Colors.blueGrey,
                      onTap: () => widget.editTripController.selectEditSection(
                        'attachments',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Routes Header
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TripRouteScreen(
                    activityId: trip.activityId,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  l10n?.editTripRoutes ?? 'ROUTES',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.map_outlined,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Stops Timeline
          _buildTimelineStops(trip),
        ],
      ),
    );
  }

  Widget _buildEditPanel() {
    final section =
        widget.editTripController.selectedEditSection.value;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      child: _buildSelectedEditPanel(section),
    );
  }

  Widget _buildSelectedEditPanel(String section) {
    switch (section) {
      case 'tripName':
        return _buildTripNameEditPanel();

      case 'duration':
        return _buildDurationEditPanel();

      case 'members':
        return MembersEditPanel(
          controller: widget.editTripController,
          onInviteFriend: () {
            final trip = widget.editTripController.trip.value;

            if (trip != null) {
              _showInviteFriendSheet(trip);
            }
          },
        );

      case 'stops':
        return _buildStopsEditPanel();

      case 'packing':
        return _buildPackingEditPanel();

      case 'checklist':
        return _buildChecklistEditPanel();

      case 'attachments':
        return _buildAttachmentsEditPanel();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTripNameEditPanel() {
    return TripNameEditPanel(
      key: const ValueKey('tripName'),
      controller: widget.editTripController,
    );
  }

  Widget _buildDurationEditPanel() {
    return DurationEditPanel(
      key: const ValueKey('duration'),
      controller: widget.editTripController,
    );
  }

  Widget _buildStopsEditPanel() {
    return StopsEditPanel(
      key: const ValueKey('stops'),
      controller: widget.editTripController,
    );
  }

  Widget _buildPackingEditPanel() {
    return PackingEditPanel(
      key: const ValueKey('packing'),
      controller: widget.editTripController,
    );
  }

  Widget _buildChecklistEditPanel() {
    return ChecklistEditPanel(
      key: const ValueKey('checklist'),
      controller: widget.editTripController,
    );
  }

  Widget _buildAttachmentsEditPanel() {
    return AttachmentsEditPanel(
      key: const ValueKey('attachments'),
      controller: widget.editTripController,
    );
  }

  Widget _buildHeader(BuildContext context) {

    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => Get.back(),
            ),
          ),

          Text(
            l10n?.editTripDetails ?? 'Trip Details',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Obx(
                  () => IconButton(
                icon: Icon(
                  widget.editTripController.isEditing.value
                      ? Icons.close_rounded
                      : Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: widget.editTripController.toggleEditing,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white70,
                size: 14,
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
        ),
    );
  }

  Widget _buildTimelineStops(TripResponse trip) {
    final l10n = AppLocalizations.of(context);
    final stops = trip.stops;

    if (stops.isEmpty) {
      return Text(
        l10n?.editTripNoStopsAdded ?? 'No stops added',
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
        ),
      );
    }

    return Column(
      children: List.generate(
        stops.length,
            (index) {
          final stop = stops[index];
          final isLast = index == stops.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white70, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    CustomPaint(
                      size: const Size(1, 22),
                      painter: DashedLinePainter(),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    (stop.locationName ?? l10n?.editTripUnnamedStop ?? 'Unnamed stop').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3;
    double dashSpace = 3;
    double startY = 0;

    final paint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _InviteFriendSheet extends StatefulWidget {
  final String activityId;
  final TextEditingController searchController;

  const _InviteFriendSheet({
    required this.activityId,
    required this.searchController,
  });

  @override
  State<_InviteFriendSheet> createState() => _InviteFriendSheetState();
}

class _InviteFriendSheetState extends State<_InviteFriendSheet> {
  final GroupService _groupService = GroupService();

  List<GroupSearchUserResponse> _users = [];

  bool _isSearching = false;
  bool _isInviting = false;

  Future<void> _searchUsers(String keyword) async {
    if (keyword.trim().isEmpty) {
      setState(() {
        _users = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final response = await _groupService.searchUsers(
        keyword.trim(),
      );

      final data = response.data;

      List<dynamic> rawUsers = [];

      if (data is List) {
        rawUsers = data;
      } else if (data is Map<String, dynamic>) {
        final users = data['data'] ?? data['users'];

        if (users is List) {
          rawUsers = users;
        }
      }

      final users = rawUsers
          .whereType<Map>()
          .map(
            (json) => GroupSearchUserResponse.fromJson(
          Map<String, dynamic>.from(json),
        ),
      )
          .toList();

      if (!mounted) return;

      setState(() {
        _users = users;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _users = [];
        _isSearching = false;
      });

      Get.snackbar(
        'Error',
        'Failed to search users',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _inviteUser(
      GroupSearchUserResponse user,
      ) async {
    if (_isInviting) return;

    setState(() {
      _isInviting = true;
    });

    try {
      await _groupService.inviteMember(
        widget.activityId,
        user.username,
      );

      if (!mounted) return;

      Get.back();

      Get.snackbar(
        'Invitation Sent',
        'Invitation sent to ${user.displayName}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (!mounted) return;

      Get.snackbar(
        'Invitation Failed',
        'Could not invite ${user.displayName}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isInviting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n?.searchFriends ?? 'Search friends',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n?.searchFriendsHint ??
                    'Search by username or email',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: widget.searchController,
              autofocus: true,
              onChanged: _searchUsers,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: l10n?.searchFriendsHint ??
                    'Search by username or email',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_isSearching)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              )
            else if (_users.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n?.searchToFindFriends ??
                      'Search to find friends',
                  style: const TextStyle(
                    color: Colors.white38,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _users.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = _users[index];

                    return _buildUserTile(user);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(
      GroupSearchUserResponse user,
      ) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.lightBlueAccent.withValues(
              alpha: 0.15,
            ),
            child: Text(
              user.displayName.isNotEmpty
                  ? user.displayName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: _isInviting
                ? null
                : () => _inviteUser(user),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n?.invite ?? 'Invite',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:movem/core/routes/app_routes.dart';
import 'package:movem/features/groups/data/repositories/group_repository_impl.dart';
import 'package:movem/features/groups/data/services/group_service.dart';
import 'package:movem/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:movem/features/trip/data/services/trip_service.dart';
import 'package:movem/features/trip/presentation/bindings/create_trip_binding.dart';
import 'package:movem/features/trip/presentation/controllers/trip_controller.dart';
import 'package:movem/features/trip/presentation/controllers/trip_invitation_controller.dart';
import 'package:movem/features/trip/presentation/screens/Create_trip/create_trip_name_screen.dart';
import 'package:movem/features/trip/presentation/screens/recent_trips_screen.dart';
import 'package:movem/features/trip/presentation/screens/trip_welcome_screen.dart';
import 'package:movem/features/trip/presentation/widgets/recent_trip_card_stack.dart';
import 'package:movem/features/trip/presentation/widgets/trip_hero_section.dart';
import 'package:movem/l10n/app_localizations.dart';
import 'package:movem/shared/widgets/no_data_component.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  late final TripController _tripController;
  late final TripInvitationController _invitationController;

  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();

    _tripController = TripController(
      repository: TripRepositoryImpl(
        tripService: TripService(),
      ),
    );

    if (Get.isRegistered<TripInvitationController>()) {
      _invitationController = Get.find<TripInvitationController>();
    } else {
      _invitationController = Get.put(
        TripInvitationController(
          groupRepository: GroupRepositoryImpl(
            groupService: GroupService(),
          ),
        ),
      );
    }

    _invitationController.loadInvitations();

    _checkTripWelcome();
  }

  Future<void> _checkTripWelcome() async {
    final shouldShow = await _tripController.shouldShowWelcome();

    if (!mounted) return;

    if (shouldShow) {
      setState(() {
        _showWelcome = true;
      });
      return;
    }

    await _loadTrips();
  }

  Future<void> _loadTrips({
    bool showLoading = true,
  }) async {
    await _tripController.getMyTrips(
      showLoading: showLoading,
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _completeWelcome() async {
    await _tripController.markWelcomeSeen();

    if (!mounted) return;

    setState(() {
      _showWelcome = false;
    });

    await _loadTrips();
  }

  void _openTripInvitations() {
    Get.toNamed(AppRoutes.tripInvitations);
  }

  Future<void> _openRecentTrips() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecentTripScreen(
          tripController: _tripController,
        ),
      ),
    );

    if (!mounted) return;

    await _loadTrips();
  }

  Future<void> _openCreateTrip() async {
    await Get.to(
      () => const CreateTripNameScreen(),
      binding: CreateTripBinding(),
    );

    if (!mounted) return;

    await _loadTrips();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    if (_showWelcome) {
      return TripWelcomeScreen(
        onCompleted: _completeWelcome,
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: RefreshIndicator(
              color: theme.colorScheme.primary,
              displacement: 80,
              onRefresh: () => _loadTrips(
                showLoading: false,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        TripHeroSection(
                          onCreateTrip: _openCreateTrip,
                        ),
                        if (!isDark)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: -2,
                            height: 130,
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                                      theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
                                      theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
                                      theme.scaffoldBackgroundColor,
                                      theme.scaffoldBackgroundColor,
                                    ],
                                    stops: const [0.0, 0.35, 0.65, 0.85, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Obx(
                      () {
                        final trips = _tripController.recentTrips;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _openRecentTrips,
                                child: Text(
                                  '${l10n.recentTrips.toUpperCase()} »',
                                  style: TextStyle(
                                    color: onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (trips.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: NoDataComponent(
                                    title: l10n.noRecentTripsYet,
                                    compact: true,
                                  ),
                                )
                              else
                                RecentTripCardStack(
                                  trips: List.from(trips),
                                  tripController: _tripController,
                                  onTripDeleted: _loadTrips,
                                  onTripUpdated: () {
                                    _loadTrips(
                                      showLoading: false,
                                    );
                                  },
                                ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 20,
              child: GestureDetector(
                onTap: _openTripInvitations,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.28)
                                : Colors.white.withValues(alpha: 0.35),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.35)
                                  : Colors.white.withValues(alpha: 0.60),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.18 : 0.10,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mail_outline_rounded,
                            color:
                                isDark ? Colors.white : const Color(0xFF1E293B),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    if (_invitationController.invitations.isNotEmpty)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            _invitationController.invitations.length > 99
                                ? '99+'
                                : _invitationController.invitations.length
                                    .toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

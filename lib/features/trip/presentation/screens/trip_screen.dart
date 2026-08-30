import 'package:flutter/material.dart';

import 'package:movem/features/trip/presentation/screens/trip_welcome_screen.dart';
import 'package:movem/features/trip/presentation/controllers/trip_controller.dart';
import 'package:movem/features/trip/data/services/trip_service.dart';
import 'package:movem/features/trip/data/repositories/trip_repository_impl.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import 'package:movem/features/trip/presentation/screens/create_trip/create_trip_name_screen.dart';

import '../../../../core/storage/user_manager.dart';
import '../../data/dto/response/trip_summary_response.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  late final TripController _tripController;

  bool _isLoading = true;
  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();

    _tripController = TripController(
      repository: TripRepositoryImpl(
        tripService: TripService(),
      ),
    );

    _checkTripWelcome();
  }

  Future<void> _checkTripWelcome() async {
    final shouldShow =
    await _tripController.shouldShowWelcome();

    if (!mounted) return;

    if (shouldShow) {
      setState(() {
        _showWelcome = true;
        _isLoading = false;
      });

      return;
    }

    await _loadTrips();
  }

  Future<void> _loadTrips() async {
    await _tripController.getMyTrips();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _completeWelcome() async {
    await _tripController.markWelcomeSeen();

    if (!mounted) return;

    setState(() {
      _showWelcome = false;
      _isLoading = true;
    });

    await _loadTrips();
  }

  Future<void> _openCreateTrip() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTripNameScreen(
          draft: CreateTripDraft(),
          tripController: _tripController,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    await _loadTrips();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B101D),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_showWelcome) {
      return TripWelcomeScreen(
        onCompleted: _completeWelcome,
      );
    }

    final user = UserManager().getUser();
    final trips = _tripController.recentTrips;

    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HERO / TOP IMAGE SECTION
              // ==================================================
              SizedBox(
                height:
                MediaQuery.of(context).size.height * 0.68,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(42),
                    bottomRight: Radius.circular(42),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background image
                      Image.asset(
                        'assets/images/everest_bg.png',
                        fit: BoxFit.cover,
                      ),

                      // Dark overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.black.withOpacity(0.15),
                              const Color(0xFF0B101D)
                                  .withOpacity(0.35),
                            ],
                            stops: const [
                              0.0,
                              0.45,
                              1.0,
                            ],
                          ),
                        ),
                      ),

                      // Hero content
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            24,
                            20,
                            24,
                            32,
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // ----------------------------------
                              // HEADER
                              // ----------------------------------
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Hi, ',
                                        ),
                                        TextSpan(
                                          text: user?.firstName
                                              ?.isNotEmpty ==
                                              true
                                              ? user!.firstName!
                                              : user?.username ??
                                              'User',
                                          style:
                                          const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                    Colors.grey.shade700,
                                    backgroundImage:
                                    user?.profilePic !=
                                        null &&
                                        user!.profilePic!
                                            .isNotEmpty
                                        ? NetworkImage(
                                      user.profilePic!,
                                    )
                                        : null,
                                    child: user?.profilePic ==
                                        null ||
                                        user!.profilePic!
                                            .isEmpty
                                        ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                        : null,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 80),

                              // ----------------------------------
                              // MAIN TITLE
                              // ----------------------------------
                              const Text(
                                'WHAT’S\nYOUR\nNEXT\nPLAN?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  height: 1.02,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              const SizedBox(height: 60),

                              // ----------------------------------
                              // SUBTITLE + BUTTON
                              // ----------------------------------
                              Align(
                                alignment:
                                Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'ENHANCE YOUR\n'
                                          'JOURNEY WITH US.',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.bold,
                                        letterSpacing: 0.8,
                                        height: 1.2,
                                      ),
                                    ),

                                    const SizedBox(height: 22),

                                    Center(
                                      child: OutlinedButton(
                                        onPressed:
                                        _openCreateTrip,
                                        style: OutlinedButton
                                            .styleFrom(
                                          backgroundColor:
                                          const Color(
                                            0xFF1E2638,
                                          ).withOpacity(0.85),
                                          side:
                                          const BorderSide(
                                            color: Color(
                                              0xFF384358,
                                            ),
                                          ),
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                            horizontal: 24,
                                            vertical: 14,
                                          ),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'PLAN YOUR JOURNEY',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // SPACE BETWEEN HERO AND RECENT TRIPS
              // ==================================================
              const SizedBox(height: 28),

              // ==================================================
              // RECENT TRIPS
              // ==================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RECENT TRIPS »',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (trips.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 40,
                        ),
                        child: Center(
                          child: Text(
                            'No recent trips yet.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      _buildTripStack(trips),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TRIP STACK
  // ============================================================

  Widget _buildTripStack(
      List<TripSummaryResponse> trips,
      ) {
    final visibleTrips = trips.take(5).toList();

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          for (int i = 0;
          i < visibleTrips.length;
          i++)
            _buildDynamicTripCard(
              trip: visibleTrips[i],
              index: i,
              total: visibleTrips.length,
            ),
        ],
      ),
    );
  }

  Widget _buildDynamicTripCard({
    required TripSummaryResponse trip,
    required int index,
    required int total,
  }) {
    final isActive = index == total - 1;
    final top = index * 35.0;

    if (!isActive) {
      return Positioned(
        top: top,
        left: 0,
        right: 0,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade800.withOpacity(
              0.45 + (index * 0.08),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Text(
            trip.activityName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      );
    }

    return _buildActiveTripCard(
      top: top,
      trip: trip,
    );
  }

  Widget _buildActiveTripCard({
    required double top,
    required TripSummaryResponse trip,
  }) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1E2638),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.activityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      if (trip.startActivity != null)
                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .calendar_today_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatDate(
                                trip.startActivity!,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            '${trip.memberCount ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.people_outline,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Total Spent: '
                            '${trip.totalSpent ?? 0}\$',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
              child: IconButton(
                onPressed: () {
                  // TODO:
                  // Open trip details using trip.activityId
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_monthName(date.month)}, '
        '${date.day}, '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month];
  }
}
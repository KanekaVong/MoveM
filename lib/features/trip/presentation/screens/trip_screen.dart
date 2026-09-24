import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

import 'package:movem/features/trip/presentation/screens/trip_welcome_screen.dart';
import 'package:movem/features/trip/presentation/controllers/trip_controller.dart';
import 'package:movem/features/trip/data/services/trip_service.dart';
import 'package:movem/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:movem/features/trip/presentation/bindings/create_trip_binding.dart';
import 'package:movem/features/trip/presentation/screens/Create_trip/create_trip_name_screen.dart';

import 'package:movem/features/trip/presentation/screens/trip_detail_screen.dart';
import '../../data/dto/response/trip_summary_response.dart';
import 'recent_trips_screen.dart';
import '../controllers/edit_trip_controller.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  late final TripController _tripController;
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
    if (_showWelcome) {
      return TripWelcomeScreen(
        onCompleted: _completeWelcome,
      );
    }

    return Scaffold(
        backgroundColor: const Color(0xFF0B101D),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            displacement: 80,
            onRefresh: () => _loadTrips(showLoading: false),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HERO / TOP IMAGE SECTION
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.58,
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
                                  const Color(0xFF0B101D).withOpacity(0.35),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 45),

                                  // main title
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

                                  const SizedBox(height: 35),

                                  // Ssubtitle + btn
                                  Align(
                                    alignment: Alignment.centerRight,
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
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.8,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 22),
                                        Center(
                                          child: OutlinedButton(
                                            onPressed: _openCreateTrip,
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF1E2638,
                                              ).withOpacity(0.85),
                                              side: const BorderSide(
                                                color: Color(
                                                  0xFF384358,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 14,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'PLAN YOUR JOURNEY',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
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

                  // RECENT TRIPS
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
                              child: const Text(
                                'RECENT TRIPS »',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (trips.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // TRIP STACK
  Widget _buildTripStack(
    List<TripSummaryResponse> trips,
  ) {
    return RecentTripCardStack(
      trips: List<TripSummaryResponse>.from(trips),
      tripController: _tripController,
      onTripDeleted: _loadTrips,
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

class RecentTripCardStack extends StatefulWidget {
  final List<TripSummaryResponse> trips;
  final TripController tripController;
  final VoidCallback onTripDeleted;

  const RecentTripCardStack({
    super.key,
    required this.trips,
    required this.tripController,
    required this.onTripDeleted,
  });

  @override
  State<RecentTripCardStack> createState() => _RecentTripCardStackState();
}

class _RecentTripCardStackState extends State<RecentTripCardStack>
    with SingleTickerProviderStateMixin {
  late List<TripSummaryResponse> _trips;
  late final AnimationController _animationController;

  double _dragOffset = 0;

  bool _isAnimating = false;

  // Index of the trip currently shown on the front.
// The newest trip is shown first.
  int _currentIndex = 0;

  static const double _cardHeight = 175; // all cards same height
  static const double _peek =
      14; // how much each back card peeks above the one in front
  static const int _maxVisibleCards = 3;

  @override
  void initState() {
    super.initState();

    _trips = List<TripSummaryResponse>.from(widget.trips);

    if (_trips.isNotEmpty) {
      _currentIndex = _trips.length - 1;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(() {
        setState(() {});
      });
  }

  List<Widget> _buildVisibleCards() {
    if (_trips.isEmpty) {
      return [];
    }

    final visibleCount = math.min(
      _maxVisibleCards,
      _trips.length,
    );

    final cards = <Widget>[];

    for (int distance = visibleCount - 1; distance >= 0; distance--) {
      final index = (_currentIndex - distance + _trips.length) % _trips.length;

      cards.add(
        _buildTripCard(
          _trips[index],
          distance == 0,
        ),
      );
    }

    return cards;
  }

  Future<bool> _showDeleteConfirmationDialog(
    BuildContext context,
    TripSummaryResponse trip,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 44,
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2F),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF1E293B),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF450A0A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Delete Trip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to delete '
                  '"${trip.activityName}"? '
                  'This action cannot be undone.',
                  style: const TextStyle(
                    color: Color(0xFFA0AAB2),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 32,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(false);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFFA0AAB2),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(true);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  Widget _buildSwipeDeleteBackground() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  @override
  void didUpdateWidget(
    covariant RecentTripCardStack oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trips.length != widget.trips.length ||
        !_sameTrips(oldWidget.trips, widget.trips)) {
      _trips = List<TripSummaryResponse>.from(widget.trips);

      if (_trips.isNotEmpty) {
        _currentIndex = _trips.length - 1;
      } else {
        _currentIndex = 0;
      }

      _dragOffset = 0;
    }
  }

  bool _sameTrips(
    List<TripSummaryResponse> a,
    List<TripSummaryResponse> b,
  ) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i].activityId != b[i].activityId ||
          a[i].activityName != b[i].activityName) {
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;

    setState(() {
      _dragOffset += details.delta.dy;

      // Prevent dragging too far.
      _dragOffset = _dragOffset.clamp(-180.0, 180.0).toDouble();
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isAnimating || _trips.length <= 1) {
      _resetPosition();
      return;
    }

    final velocity = details.primaryVelocity ?? 0;

    final shouldSwipeUp = _dragOffset < -60 || velocity < -500;

    final shouldSwipeDown = _dragOffset > 60 || velocity > 500;

    if (shouldSwipeUp) {
      _swipeNext();
    } else if (shouldSwipeDown) {
      _swipePrevious();
    } else {
      _resetPosition();
    }
  }

  Future<void> _swipeNext() async {
    if (_isAnimating || _trips.length <= 1) return;

    _isAnimating = true;

    final start = _dragOffset;

    final animation = Tween<double>(
      begin: start,
      end: -220,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    void listener() {
      setState(() {
        _dragOffset = animation.value;
      });
    }

    animation.addListener(listener);

    await _animationController.forward(from: 0);

    animation.removeListener(listener);

    setState(() {
      // Swipe up = previous trip
      _currentIndex--;

      // Wrap around to the newest trip.
      if (_currentIndex < 0) {
        _currentIndex = _trips.length - 1;
      }

      _dragOffset = 0;
    });

    _animationController.reset();

    _isAnimating = false;
  }

  Future<void> _swipePrevious() async {
    if (_isAnimating || _trips.length <= 1) return;

    _isAnimating = true;

    final start = _dragOffset;

    final animation = Tween<double>(
      begin: start,
      end: 220,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    void listener() {
      setState(() {
        _dragOffset = animation.value;
      });
    }

    animation.addListener(listener);

    await _animationController.forward(from: 0);

    animation.removeListener(listener);

    setState(() {
      // Swipe down = next trip
      _currentIndex++;

      // Wrap around to the oldest trip.
      if (_currentIndex >= _trips.length) {
        _currentIndex = 0;
      }

      _dragOffset = 0;
    });

    _animationController.reset();

    _isAnimating = false;
  }

  Future<void> _resetPosition() async {
    if (_isAnimating || _dragOffset == 0) return;

    _isAnimating = true;

    final start = _dragOffset;

    final animation = Tween<double>(
      begin: start,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    void listener() {
      setState(() {
        _dragOffset = animation.value;
      });
    }

    animation.addListener(listener);

    await _animationController.forward(from: 0);

    animation.removeListener(listener);

    setState(() {
      _dragOffset = 0;
    });

    _animationController.reset();

    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_trips.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: SizedBox(
        width: double.infinity,
        height: _cardHeight + _peek * (_maxVisibleCards - 1), // 175 + 28 = 203
        child: Flow(
          delegate: _TripCardFlowDelegate(
            dragOffset: _dragOffset,
            cardHeight: _cardHeight,
            peek: _peek,
          ),
          children: _buildVisibleCards(),
        ),
      ),
    );
  }

  Widget _buildTripCard(
    TripSummaryResponse trip,
    bool isFront,
  ) {
    final card = Container(
      height: _cardHeight,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1E2638),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (trip.startActivity != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
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
              onPressed: () async {
                await Get.to(
                  () => TripDetailScreen(
                    activityId: trip.activityId,
                    editTripController: EditTripController(
                      tripRepository: TripRepositoryImpl(
                        tripService: TripService(),
                      ),
                      tripController: widget.tripController,
                      activityId: trip.activityId,
                    ),
                  ),
                );
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
    );

    // Only the front card can be dismissed.
    if (!isFront) {
      return card;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Dismissible(
        key: Key('trip_${trip.activityId}'),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {
          DismissDirection.endToStart: 0.25,
        },
        confirmDismiss: (direction) async {
          final confirmed = await _showDeleteConfirmationDialog(
            context,
            trip,
          );

          if (!confirmed) {
            return false;
          }

          final success = await widget.tripController.deleteTrip(
            trip.activityId,
          );

          return success;
        },
        onDismissed: (direction) {
          setState(() {
            _trips.removeWhere(
              (item) => item.activityId == trip.activityId,
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Trip deleted successfully.'),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // defer to next frame instead of calling immediately
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onTripDeleted();
          });
        },
        background: Container(
          height: _cardHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        child: card,
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

class _TripCardFlowDelegate extends FlowDelegate {
  final double dragOffset;
  final double cardHeight;
  final double peek;

  const _TripCardFlowDelegate({
    required this.dragOffset,
    required this.cardHeight,
    required this.peek,
  });

  @override
  void paintChildren(FlowPaintingContext context) {
    final childCount = context.childCount;
    if (childCount == 0) return;

    final dragProgress = (dragOffset / 180).clamp(-1.0, 1.0);

    final frontTop = peek * (childCount - 1);

    for (int i = 0; i < childCount; i++) {
      final isFront = i == childCount - 1;
      final distanceFromFront = childCount - 1 - i;
      final childSize = context.getChildSize(i)!;

      double top;
      if (isFront) {
        top = frontTop + dragOffset;
      } else {
        top = frontTop - peek * distanceFromFront;
        // subtle sympathetic movement while dragging
        top += dragProgress * peek * 0.4 * (1 - distanceFromFront / childCount);
      }

      // Front card is full scale; back cards shrink a touch so the
      final scale = isFront ? 1.0 : 1.0 - (distanceFromFront * 0.045);

      final opacity =
          isFront ? 1.0 : (1.0 - (distanceFromFront * 0.15)).clamp(0.55, 1.0);

      final rotation = isFront ? dragProgress * (math.pi / 180) * 2.0 : 0.0;

      final x = (context.size.width - childSize.width) / 2;

      // Scale/rotate around the card's own center, then move into place.
      final transform = Matrix4.identity()
        ..translate(x + childSize.width / 2, top + childSize.height / 2)
        ..rotateZ(rotation)
        ..scale(scale)
        ..translate(-childSize.width / 2, -childSize.height / 2);

      context.paintChild(i, transform: transform, opacity: opacity);
    }
  }

  @override
  bool shouldRepaint(covariant _TripCardFlowDelegate oldDelegate) {
    return oldDelegate.dragOffset != dragOffset;
  }
}

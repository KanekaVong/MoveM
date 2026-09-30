import 'dart:math' as math;
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movem/features/trip/data/dto/response/trip_summary_response.dart';
import 'package:movem/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:movem/features/trip/data/services/trip_service.dart';
import 'package:movem/features/trip/presentation/controllers/edit_trip_controller.dart';
import 'package:movem/features/trip/presentation/controllers/trip_controller.dart';
import 'package:movem/features/trip/presentation/screens/trip_detail_screen.dart';
import '../../../../l10n/app_localizations.dart';

class RecentTripCardStack extends StatefulWidget {
  final List<TripSummaryResponse> trips;
  final TripController tripController;
  final VoidCallback onTripDeleted;
  final VoidCallback onTripUpdated;

  const RecentTripCardStack({
    super.key,
    required this.trips,
    required this.tripController,
    required this.onTripDeleted,
    required this.onTripUpdated,
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

  int _currentIndex = 0;

  static const double _cardHeight = 175;
  static const double _peek = 14;
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
    if (a.length != b.length) {
      return false;
    }

    for (var i = 0; i < a.length; i++) {
      if (a[i].activityId != b[i].activityId ||
          a[i].activityName != b[i].activityName ||
          a[i].memberCount != b[i].memberCount ||
          a[i].totalSpent != b[i].totalSpent ||
          a[i].coverPhoto?.filePath != b[i].coverPhoto?.filePath) {
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

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;

    setState(() {
      _dragOffset += details.delta.dy;
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

    final animation = Tween<double>(
      begin: _dragOffset,
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
      _currentIndex--;

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

    final animation = Tween<double>(
      begin: _dragOffset,
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
      _currentIndex++;

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

    final animation = Tween<double>(
      begin: _dragOffset,
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

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context,
      TripSummaryResponse trip,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 44),
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
                  color: Colors.black.withValues(alpha: 0.6),
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
                        child: Text(
                          l10n.cancel,
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

  void _showCoverPhotoMenu(TripSummaryResponse trip) {

    final l10n = AppLocalizations.of(context)!;

    final hasCoverPhoto =
        trip.coverPhoto?.filePath != null &&
            trip.coverPhoto!.filePath!.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131B2F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  hasCoverPhoto
                      ? l10n.changeTripCover
                      : l10n.addTripCover,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    hasCoverPhoto
                        ? Icons.image_outlined
                        : Icons.add_photo_alternate_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    hasCoverPhoto
                        ? l10n.changeCurrentImage
                        : l10n.addTripCoverImage,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _addCoverPhoto(trip);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFFA0AAB2),
                  ),
                  title:  Text(
                    l10n.cancel,
                    style: TextStyle(
                      color: Color(0xFFA0AAB2),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addCoverPhoto(
      TripSummaryResponse trip,
      ) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return;
    }

    final multipartFile = await dio.MultipartFile.fromFile(
      pickedFile.path,
      filename: pickedFile.name,
    );

    final success = await widget.tripController.uploadCoverPhoto(
      trip.activityId,
      multipartFile,
    );

    if (!mounted || !success) {
      return;
    }

    await widget.tripController.getMyTrips(
      showLoading: false,
    );

    if (!mounted) return;

    setState(() {
      _trips = List<TripSummaryResponse>.from(
        widget.tripController.recentTrips,
      );
    });
  }

  Widget _buildTripCard(
      TripSummaryResponse trip,
      bool isFront,
      ) {

    final l10n = AppLocalizations.of(context)!;

    final hasCoverPhoto =
        trip.coverPhoto?.filePath != null &&
            trip.coverPhoto!.filePath!.isNotEmpty;

    final card = GestureDetector(
      onLongPress: () {
        _showCoverPhotoMenu(trip);
      },
      child: Container(
        height: _cardHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1E2638),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // background
              Positioned.fill(
                child: hasCoverPhoto
                    ? Image.network(
                  trip.coverPhoto!.filePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const ColoredBox(
                      color: Color(0xFF1E2638),
                    );
                  },
                )
                    : const ColoredBox(
                  color: Color(0xFF1E2638),
                ),
              ),

              if (hasCoverPhoto)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.70),
                        ],
                      ),
                    ),
                  ),
                ),


              //  CARD CONTENT
              Padding(
                padding: const EdgeInsets.all(16),
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
                                    l10n.membersCount(
                                      trip.memberCount ?? 0,
                                    ),
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
                                l10n.totalSpent(
                                  trip.totalSpent ?? 0,
                                ),
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
                        color: Colors.white.withValues(alpha: 0.3),
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

                          if (!mounted) return;

                          widget.onTripUpdated();
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
            ],
          ),
        ),
      ),
    );

    if (!isFront) {
      return card;
    }


    // front card — delete/swipe logic
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

          return widget.tripController.deleteTrip(
            trip.activityId,
          );
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

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    if (_trips.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: SizedBox(
        width: double.infinity,
        height: _cardHeight + _peek * (_maxVisibleCards - 1),
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

        top += dragProgress * peek * 0.4 * (1 - distanceFromFront / childCount);
      }

      final scale = isFront ? 1.0 : 1.0 - (distanceFromFront * 0.045);

      final opacity =
          isFront ? 1.0 : (1.0 - (distanceFromFront * 0.15)).clamp(0.55, 1.0);

      final rotation = isFront ? dragProgress * (math.pi / 180) * 2.0 : 0.0;

      final x = (context.size.width - childSize.width) / 2;

      final transform = Matrix4.identity()
        ..translate(
          x + childSize.width / 2,
          top + childSize.height / 2,
        )
        ..rotateZ(rotation)
        ..scale(scale)
        ..translate(
          -childSize.width / 2,
          -childSize.height / 2,
        );

      context.paintChild(
        i,
        transform: transform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _TripCardFlowDelegate oldDelegate,
  ) {
    return oldDelegate.dragOffset != dragOffset;
  }
}

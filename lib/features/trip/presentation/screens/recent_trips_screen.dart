import 'package:flutter/material.dart';

import 'package:movem/features/trip/presentation/controllers/trip_controller.dart';
import '../../data/dto/response/trip_summary_response.dart';

enum TripSortOption { dateNewest, dateOldest, highestSpent }

class RecentTripScreen extends StatefulWidget {
  final TripController tripController;

  const RecentTripScreen({
    super.key,
    required this.tripController,
  });

  @override
  State<RecentTripScreen> createState() => _RecentTripScreenState();
}

class _RecentTripScreenState extends State<RecentTripScreen> {
  List<TripSummaryResponse> _trips = [];
  TripSortOption _currentSort = TripSortOption.dateNewest;
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTrips();
    });
  }

  Future<void> _loadTrips({
    bool showLoading = true,
  }) async {
    await widget.tripController.getMyTrips(
      showLoading: showLoading,
    );

    if (!mounted) return;

    setState(() {
      _trips = List.from(widget.tripController.recentTrips);
      _sortTrips(_currentSort);
      _hasLoadedOnce = true;
    });
  }

  void _sortTrips(TripSortOption option) {
    setState(() {
      _currentSort = option;
      switch (option) {
        case TripSortOption.dateNewest:
          _trips.sort((a, b) => (b.startActivity ?? DateTime(0))
              .compareTo(a.startActivity ?? DateTime(0)));
          break;
        case TripSortOption.dateOldest:
          _trips.sort((a, b) => (a.startActivity ?? DateTime(0))
              .compareTo(b.startActivity ?? DateTime(0)));
          break;
        case TripSortOption.highestSpent:
          _trips.sort(
              (a, b) => (b.totalSpent ?? 0.0).compareTo(a.totalSpent ?? 0.0));
          break;
      }
    });
  }

  String _formatCustomDate(DateTime? date) {
    if (date == null) return 'N/A';
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
      'December'
    ];
    return '${months[date.month]} | ${date.day.toString().padLeft(2, '0')} | ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------
            // CUSTOM APP BAR & SORT FILTER
            // ----------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Title
                  const Text(
                    'RECENT TRIPS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  // Sort Dropdown Button
                  PopupMenuButton<TripSortOption>(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Sort By',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ],
                    ),
                    color: const Color(0xFF1E2638),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: _sortTrips,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: TripSortOption.dateNewest,
                        child: Text(
                          'Newest Date',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      const PopupMenuItem(
                        value: TripSortOption.dateOldest,
                        child: Text(
                          'Oldest Date',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      const PopupMenuItem(
                        value: TripSortOption.highestSpent,
                        child: Text(
                          'Highest Spent',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // list body
            Expanded(
              child: !_hasLoadedOnce
                  ? const SizedBox.shrink()
                  : _trips.isEmpty
                      ? const Center(
                          child: Text(
                            'No trips yet.',
                            style:
                                TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _loadTrips(showLoading: false),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            itemCount: _trips.length,
                            itemBuilder: (context, index) {
                              final trip = _trips[index];
                              return _TripCardItem(
                                trip: trip,
                                formatDate: _formatCustomDate,
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripCardItem extends StatelessWidget {
  final TripSummaryResponse trip;
  final String Function(DateTime?) formatDate;

  const _TripCardItem({
    required this.trip,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    // Background asset placeholder layout matching design style
    const bgImage = 'assets/images/everest_bg.png';

    return Container(
      height: 145,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              bgImage,
              fit: BoxFit.cover,
            ),

            // Dark Gradient Overlay for optimal text legibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.2),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),

            // Card Content Layout
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Trip Name
                        Text(
                          trip.activityName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),

                        // Details Stack
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date row
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.white70,
                                  size: 13,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  formatDate(trip.startActivity),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),

                            // Members count row
                            Row(
                              children: [
                                Text(
                                  '${trip.memberCount ?? 0}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),

                            // Total Spent row
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Total Spent: ${trip.totalSpent ?? 0}\$',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Forward Action Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.25),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement navigation to detail screen using trip.activityId
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

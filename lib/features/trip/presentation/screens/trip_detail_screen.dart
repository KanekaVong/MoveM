import 'package:flutter/material.dart';

import '../../data/dto/request/create_trip_request.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import '../controllers/trip_controller.dart';



class TripDetailScreen extends StatelessWidget {
  final CreateTripDraft draft;
  final TripController tripController;


  const TripDetailScreen({
    super.key,
    required this.draft,
    required this.tripController,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';

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

    return '${months[date.month]} ${date.day}, ${date.year}';
  }

  String _formatDateRange() {
    if (draft.startDate == null) {
      return 'Dates not set';
    }

    if (draft.endDate == null) {
      return _formatDate(draft.startDate);
    }

    return '${_formatDate(draft.startDate)} - '
        '${_formatDate(draft.endDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Ready?',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildMainTripCard(),

                    const SizedBox(height: 18),

                    _buildSection(
                      title: 'Location',
                      icon: Icons.location_on_outlined,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _detailText(
                            draft.locationName ??
                                draft.destination ??
                                'Not selected',
                          ),
                          if (draft.locationAddress != null &&
                              draft.locationAddress!.isNotEmpty)
                            _detailText(
                              draft.locationAddress!,
                              secondary: true,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildSection(
                      title: 'Duration',
                      icon: Icons.calendar_month_outlined,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _detailText(_formatDateRange()),
                          const SizedBox(height: 5),
                          _detailText(
                            '${draft.durationDays} '
                                '${draft.durationDays == 1 ? 'day' : 'days'}',
                            secondary: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildSection(
                      title: 'Budget',
                      icon: Icons.attach_money_rounded,
                      child: _detailText(
                        '\$${draft.budget.toStringAsFixed(0)}',
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildSection(
                      title: 'Stops',
                      icon: Icons.route_outlined,
                      child: _buildStops(),
                    ),

                    const SizedBox(height: 14),

                    _buildSection(
                      title: 'Friends',
                      icon: Icons.people_outline,
                      child: _buildFriends(),
                    ),

                    const SizedBox(height: 14),

                    _buildSection(
                      title: 'Packing',
                      icon: Icons.backpack_outlined,
                      child: _buildPacking(),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          final request = CreateTripRequest(
                            activityName: draft.activityName!,
                            startActivity: draft.startDate!
                                .toIso8601String()
                                .split('.')
                                .first,
                            deadline: draft.endDate
                                ?.toIso8601String()
                                .split('.')
                                .first,
                            locationName: draft.locationName,
                            locationAddress: draft.locationAddress,
                            lat: draft.lat,
                            lng: draft.lng,
                            googlePlaceId: draft.googlePlaceId,
                            destination: draft.destination,
                          );

                          await tripController.createTrip(request);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'READY',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            onTap: () => Navigator.pop(context),
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

  Widget _buildMainTripCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171E2D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            draft.activityName ?? 'Your Trip',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            draft.locationName ??
                draft.destination ??
                'No destination',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStops() {
    if (draft.stops.isEmpty) {
      return _detailText(
        'No stops added',
        secondary: true,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < draft.stops.length; i++)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 6,
            ),
            child: Text(
              '${i + 1}. '
                  '${draft.stops[i].locationName ?? 'Unnamed stop'}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFriends() {
    if (draft.friends.isEmpty) {
      return _detailText(
        'No friends added',
        secondary: true,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final friend in draft.friends)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 6,
            ),
            child: Text(
              friend.toString(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPacking() {
    if (draft.packingItems.isEmpty) {
      return _detailText(
        'No packing items added',
        secondary: true,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in draft.packingItems)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 6,
            ),
            child: Text(
              '• $item',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _detailText(
      String text, {
        bool secondary = false,
      }) {
    return Text(
      text,
      style: TextStyle(
        color: secondary
            ? Colors.white54
            : Colors.white70,
        fontSize: 13,
        height: 1.4,
      ),
    );
  }
}
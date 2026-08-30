import 'package:flutter/material.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import 'package:movem/features/trip/presentation/models/create_trip_stop_draft.dart';
import 'create_trip_friends_screen.dart';
import '../../controllers/trip_controller.dart';

class CreateTripStopScreen extends StatefulWidget {
  final CreateTripDraft draft;
  final TripController tripController;

  const CreateTripStopScreen({
    super.key,
    required this.draft,
    required this.tripController,
  });

  @override
  State<CreateTripStopScreen> createState() =>
      _CreateTripStopScreenState();
}

class _CreateTripStopScreenState
    extends State<CreateTripStopScreen> {
  void _addStop() {
    setState(() {
      widget.draft.stops.add(
        CreateTripStopDraft(
          locationName: 'New Stop',
        ),
      );
    });
  }

  void _removeStop(int index) {
    setState(() {
      widget.draft.stops.removeAt(index);
    });
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTripFriendsScreen(
          draft: widget.draft,
          tripController: widget.tripController,
        ),
      ),
    );
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  32,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildTripHeader(),

                    const SizedBox(height: 28),

                    const Text(
                      'Plan your stop?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Add Checkpoints - first stop, second stop, final destination',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Search / map button
                    GestureDetector(
                      onTap: _openStopMap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF171E2D),
                          borderRadius:
                          BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white12,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Search location',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.map_outlined,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (widget.draft.stops.isEmpty)
                      _buildEmptyStop()
                    else
                      _buildStops(),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _continue,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openStopMap() {
    // Next we will connect the fullscreen Google Map here.
    //
    // Flow:
    // Search location OR pin a location
    //        ↓
    // Select location
    //        ↓
    // SET STOP
    //        ↓
    // Return here with the selected stop
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
          _buildStep(false),
        ],
      ),
    );
  }

  Widget _buildStep(bool active) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: active
              ? Colors.white
              : Colors.white24,
          borderRadius:
          BorderRadius.circular(10),
        ),
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
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            widget.draft.activityName ??
                'Your Trip',
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

  Widget _buildEmptyStop() {
    return InkWell(
      onTap: _addStop,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white12,
          ),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF222B3D),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Add a stop',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStops() {
    return Column(
      children: [
        for (int i = 0;
        i < widget.draft.stops.length;
        i++) ...[
          _buildStopItem(i),

          if (i !=
              widget.draft.stops.length - 1)
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
              child: SizedBox(
                height: 28,
                child: VerticalDivider(
                  color: Colors.white24,
                  thickness: 1,
                ),
              ),
            ),
        ],

        const SizedBox(height: 12),

        InkWell(
          onTap: _addStop,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white12,
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor:
                  Color(0xFF222B3D),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Add another stop',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStopItem(int index) {
    final stop = widget.draft.stops[index];

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF171E2D),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    stop.locationName ?? 'Unnamed stop',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white54,
                  ),
                  onSelected: (value) {
                    if (value == 'remove') {
                      _removeStop(index);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

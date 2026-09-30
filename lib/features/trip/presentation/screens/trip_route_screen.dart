import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/dto/response/trip_response.dart';
import '../../data/dto/response/trip_stop_response.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../../data/services/trip_service.dart';
import '../controllers/trip_route_controller.dart';
import '../../../../core/config/google_map_style.dart';

class TripRouteScreen extends StatefulWidget {
  final String activityId;

  const TripRouteScreen({
    super.key,
    required this.activityId,
  });

  @override
  State<TripRouteScreen> createState() => _TripRouteScreenState();
}

class _TripRouteScreenState extends State<TripRouteScreen> {
  late final TripRouteController controller;
  GoogleMapController? mapController;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      TripRouteController(
        tripRepository: TripRepositoryImpl(
          tripService: TripService(),
        ),
        activityId: widget.activityId,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadRoute();
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    Get.delete<TripRouteController>();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      body: Stack(
        children: [
          _buildMap(),
          _buildRouteLoadingIndicator(),
          _buildTopControls(),
          _buildZoomControls(),
          _buildCollapsibleGlassCard(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Obx(() {
      final currentLocation = controller.currentLocation.value;
      final trip = controller.trip.value;

      final initialPosition =
          currentLocation ?? _getDestinationPosition(trip);

      if (controller.polylines.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fitRouteToScreen();
        });
      }

      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        markers: controller.markers,
        polylines: controller.polylines,
        style: GoogleMapStyle.darkMapStyle,
        myLocationEnabled: currentLocation != null,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: (googleMapController) async {
          mapController = googleMapController;
          await _fitRouteToScreen();
        },
      );
    });
  }

  Widget _buildRouteLoadingIndicator() {
    return Obx(() {
      if (!controller.isRouteLoading.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: 80,
        left: 0,
        right: 0,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.38),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      controller.travelMode.value == 'CYCLING'
                          ? 'Building cycling route...'
                          : 'Building route...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  LatLng _getDestinationPosition(TripResponse? trip) {
    if (trip != null && trip.lat != null && trip.lng != null) {
      return LatLng(trip.lat!, trip.lng!);
    }
    return const LatLng(11.5564, 104.9282);
  }

  Future<void> _fitRouteToScreen() async {
    final map = mapController;
    if (map == null) return;

    final points = <LatLng>[];
    final currentLocation = controller.currentLocation.value;
    if (currentLocation != null) points.add(currentLocation);

    final trip = controller.trip.value;
    if (trip != null) {
      for (final stop in trip.stops) {
        if (stop.lat != null && stop.lng != null) {
          points.add(LatLng(stop.lat!, stop.lng!));
        }
      }
      if (trip.lat != null && trip.lng != null) {
        points.add(LatLng(trip.lat!, trip.lng!));
      }
    }

    if (points.isEmpty) return;

    if (points.length == 1) {
      await map.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 14),
        ),
      );
      return;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await map.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  Widget _buildTopControls() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildCircleButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.38),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      top: 90,
      child: Column(
        children: [
          _buildCircleButton(
            icon: Icons.add,
            onTap: _zoomIn,
          ),
          const SizedBox(height: 8),
          _buildCircleButton(
            icon: Icons.remove,
            onTap: _zoomOut,
          ),
        ],
      ),
    );
  }

  Future<void> _zoomIn() async {
    await mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    await mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  Widget _buildCollapsibleGlassCard() {
    final mediaQuery = MediaQuery.of(context);
    final double maxCardHeight = mediaQuery.size.height * 0.65;
    final double minCardHeight = 72.0;

    return Positioned(
      left: 16,
      right: 16,
      bottom: mediaQuery.padding.bottom + 12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 380),
        curve: Curves.fastOutSlowIn,
        height: _isExpanded ? maxCardHeight : minCardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isExpanded ? 28 : 24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_isExpanded ? 28 : 24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.38),
                borderRadius: BorderRadius.circular(_isExpanded ? 28 : 24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: Obx(() {
                final trip = controller.trip.value;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _toggleCard,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSheetHandle(),
                          const SizedBox(height: 6),
                          _buildCardHeader(),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    if (_isExpanded)
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 12, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (trip != null) ...[
                                _buildRouteSummary(),
                                const SizedBox(height: 18),
                                _buildTravelMode(),
                                const SizedBox(height: 18),
                                _buildStopsTimeline(trip),
                              ],
                              if (controller.isLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 38,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      children: [
        const Icon(
          Icons.alt_route_rounded,
          color: Color(0xFF93C5FD),
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ROUTE DETAILS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              if (!_isExpanded)
                Text(
                  '${controller.totalDistanceKm.value.toStringAsFixed(1)} km • ${_formatDuration(controller.estimatedTravelTimeMinutes.value)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        Icon(
          _isExpanded
              ? Icons.keyboard_arrow_down_rounded
              : Icons.keyboard_arrow_up_rounded,
          color: Colors.white,
          size: 24,
        ),
      ],
    );
  }

  Widget _buildRouteSummary() {
    return Obx(() {
      final hasRouteError = controller.routeErrorMessage.value.isNotEmpty;

      if (hasRouteError) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFF87171),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  controller.routeErrorMessage.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.navigation_rounded,
              iconColor: const Color(0xFF2DD4BF),
              badgeBgColor: const Color(0xFF0D9488).withValues(alpha: 0.35),
              label: 'DISTANCE',
              value:
              '${controller.totalDistanceKm.value.toStringAsFixed(1)} km',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.access_time_filled_rounded,
              iconColor: const Color(0xFFFBBF24),
              badgeBgColor: const Color(0xFFD97706).withValues(alpha: 0.35),
              label: 'EST. TIME',
              value: _formatDuration(
                controller.estimatedTravelTimeMinutes.value,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconColor,
    required Color badgeBgColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TRAVEL MODE',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
              () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTravelModeButton(
                  label: 'Driving',
                  icon: Icons.directions_car_rounded,
                  value: 'DRIVING',
                ),
                const SizedBox(width: 8),
                _buildTravelModeButton(
                  label: 'Walking',
                  icon: Icons.directions_walk_rounded,
                  value: 'WALKING',
                ),
                const SizedBox(width: 8),
                _buildTravelModeButton(
                  label: 'Cycling',
                  icon: Icons.directions_bike_rounded,
                  value: 'CYCLING',
                ),
                const SizedBox(width: 8),
                _buildTravelModeButton(
                  label: 'Riding',
                  icon: Icons.two_wheeler_rounded,
                  value: 'RIDING',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelModeButton({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final selected = controller.travelMode.value == value;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        controller.changeTravelMode(value);
      },
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2563EB).withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF60A5FA)
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white70,
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopsTimeline(TripResponse trip) {
    final stops = trip.stops;

    if (stops.isEmpty) {
      return const Text(
        'No stops available.',
        style: TextStyle(color: Colors.white70),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STOPS',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        ...stops.asMap().entries.map(
              (entry) {
            final index = entry.key;
            final stop = entry.value;

            return _buildStopItem(
              stop,
              index,
              stops.length,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStopItem(
      TripStopResponse stop,
      int index,
      int totalStops,
      ) {
    final isLast = index == totalStops - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.45),
                  border: Border.all(
                    color: const Color(0xFF93C5FD),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 45,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.locationName ?? 'Unnamed stop',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (stop.lat != null && stop.lng != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'Route stop',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours hr';
    }

    return '$hours hr $remainingMinutes min';
  }
}
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/config/google_map_style.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/trip_response.dart';
import '../../data/services/google_routes_service.dart';
import '../../domain/repositories/trip_repository.dart';
import 'package:flutter/foundation.dart';

class TripRouteController extends BaseController {
  final TripRepository tripRepository;
  final String activityId;

  TripRouteController({
    required this.tripRepository,
    required this.activityId,
  });

  final Rx<TripResponse?> trip = Rx<TripResponse?>(null);

  final RxString travelMode = 'DRIVING'.obs;

  final RxSet<Marker> markers = <Marker>{}.obs;

  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);

  final RxDouble totalDistanceKm = 0.0.obs;

  final RxInt estimatedTravelTimeMinutes = 0.obs;

  final RxString routeErrorMessage = ''.obs;

  final RxBool isRouteLoading = false.obs;

  final GoogleRoutesService _routesService =
  GoogleRoutesService();

  // loadRoute
  Future<void> loadRoute() async {
    isRouteLoading.value = true;

    try {
      await executeApi<TripResponse>(
        apiCall: () =>
            tripRepository.getTripDetail(activityId),
        onSuccess: (data) async {
          trip.value = data;

          await _getCurrentLocation();
        },
      );
    } finally {
      isRouteLoading.value = false;
    }
  }

  // current location
  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          'Location services are disabled.',
        );
      }

      var permission =
      await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission ==
          LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is required to show the route.',
        );
      }

      final position =
      await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      currentLocation.value = LatLng(
        position.latitude,
        position.longitude,
      );

      _buildMarkers();

      await _calculateRoute();
    } catch (e) {
      state.value = ViewState.error;
      errorMessage.value = e.toString();

      if (e is DioException) {
        errorMessage.value =
            e.message ?? 'Unable to get location.';
      }
    }
  }

  // google route
  Future<void> _calculateRoute() async {
    final current = currentLocation.value;
    final currentTrip = trip.value;

    if (current == null || currentTrip == null) {
      return;
    }

    final destinationLat = currentTrip.lat;
    final destinationLng = currentTrip.lng;

    if (destinationLat == null || destinationLng == null) {
      routeErrorMessage.value =
      'Trip destination coordinates are missing.';
      return;
    }

    final destination = LatLng(
      destinationLat,
      destinationLng,
    );

    final stops = travelMode.value == 'CYCLING'
        ? <LatLng>[]
        : currentTrip.stops
        .where(
          (stop) =>
      stop.lat != null &&
          stop.lng != null,
    )
        .map(
          (stop) => LatLng(
        stop.lat!,
        stop.lng!,
      ),
    )
        .toList();

    debugPrint('========== CALCULATE ROUTE ==========');
    debugPrint('Travel mode: ${travelMode.value}');
    debugPrint('Current location: $current');
    debugPrint('Trip: ${currentTrip.activityName}');
    debugPrint('Stops count: ${stops.length}');
    debugPrint('Destination: $destination');

    routeErrorMessage.value = '';

    try {
      final result = await _routesService.calculateRoute(
        origin: current,
        destination: destination,
        intermediates: stops,
        travelMode: travelMode.value,
      );

      debugPrint('========== GOOGLE ROUTE RESULT ==========');
      debugPrint('Distance: ${result.distanceMeters}');
      debugPrint('Duration: ${result.duration}');
      debugPrint('Polyline points: ${result.points.length}');

      totalDistanceKm.value =
          result.distanceMeters / 1000.0;

      estimatedTravelTimeMinutes.value =
          _durationToMinutes(result.duration);

      polylines.value = {
        Polyline(
          polylineId: const PolylineId('trip_route'),
          points: result.points,
          width: 6,
          color: routeColor.routeGlow,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      };

      debugPrint('Polyline set: ${polylines.length}');
    } catch (e) {
      debugPrint('========== ROUTE FAILED ==========');
      debugPrint('Travel mode: ${travelMode.value}');
      debugPrint('Error: $e');

      if (travelMode.value == 'CYCLING') {
        routeErrorMessage.value =
        'No cycling route available for this trip.';
      } else {
        routeErrorMessage.value =
        'No ${travelMode.value.toLowerCase()} route available for this trip.';
      }
    }
  }


  // markers
  void _buildMarkers() {
    final currentTrip = trip.value;

    if (currentTrip == null) {
      return;
    }

    final newMarkers = <Marker>{};

    // current user location
    final current = currentLocation.value;

    if (current != null) {
      newMarkers.add(
        Marker(
          markerId:
          const MarkerId('current-location'),
          position: current,
          icon:
          BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(
            title: 'Your location',
          ),
        ),
      );
    }

    // Trip stops
    for (int i = 0;
    i < currentTrip.stops.length;
    i++) {
      final stop = currentTrip.stops[i];

      if (stop.lat == null ||
          stop.lng == null) {
        continue;
      }

      newMarkers.add(
        Marker(
          markerId: MarkerId(
            'trip-stop-$i',
          ),
          position: LatLng(
            stop.lat!,
            stop.lng!,
          ),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: 'Stop ${i + 1}',
            snippet: stop.locationName,
          ),
        ),
      );
    }

    // Destination
    if (currentTrip.lat != null &&
        currentTrip.lng != null) {
      newMarkers.add(
        Marker(
          markerId:
          const MarkerId('trip-destination'),
          position: LatLng(
            currentTrip.lat!,
            currentTrip.lng!,
          ),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title:
            currentTrip.locationName ??
                currentTrip.destination ??
                'Destination',
          ),
        ),
      );
    }

    markers.value = newMarkers;
  }

  // travel Mode

  Future<void> changeTravelMode(String mode) async {
    if (travelMode.value == mode) {
      return;
    }

    travelMode.value = mode;

    isRouteLoading.value = true;

    try {
      await _calculateRoute();
    } finally {
      isRouteLoading.value = false;
    }
  }

  // helper
  int _durationToMinutes(String duration) {
    if (duration.isEmpty) {
      return 0;
    }

    final secondsMatch = RegExp(
      r'([\d.]+)s',
    ).firstMatch(duration);

    if (secondsMatch == null) {
      return 0;
    }

    final seconds =
        double.tryParse(secondsMatch.group(1) ?? '0') ??
            0;

    return (seconds / 60).ceil();
  }
}
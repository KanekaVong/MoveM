import 'dart:async';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:movem/core/config/google_map_style.dart';

import 'package:movem/features/trip/data/services/google_places_service.dart';
import 'package:movem/features/trip/data/services/google_routes_service.dart';

import 'package:movem/features/trip/domain/trip_route_calculator.dart';
import '../../controllers/create_trip_controller.dart';
import 'package:movem/features/trip/presentation/models/create_trip_stop_draft.dart';

class CreateTripStopMapScreen extends StatefulWidget {
  final CreateTripStopDraft? existingStop;

  const CreateTripStopMapScreen({
    super.key,
    this.existingStop,
  });

  @override
  State<CreateTripStopMapScreen> createState() =>
      _CreateTripStopMapScreenState();
}

class CreateTripStopMapResult {
  final CreateTripStopDraft stop;
  final int insertionIndex;

  const CreateTripStopMapResult({
    required this.stop,
    required this.insertionIndex,
  });
}

class _CreateTripStopMapScreenState
    extends State<CreateTripStopMapScreen> {

  final CreateTripController controller = Get.find<CreateTripController>();

  static const double _routeToleranceMeters = 100.0;

  final GooglePlacesService _placesService =
  GooglePlacesService();

  final TextEditingController _searchController =
  TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  final TripRouteCalculator _routeCalculator = TripRouteCalculator();

  final GoogleRoutesService _routesService = GoogleRoutesService();
  List<LatLng> _routePoints = [];

  List<LatLng> _displayRoutePoints = [];

  GoogleMapController? _mapController;

  LatLng? _currentLocation;
  LatLng? _selectedStop;

  String? _selectedStopName;
  String? _selectedStopAddress;
  String? _selectedStopPlaceId;

  List<GooglePlacePrediction> _suggestions = [];

  Timer? _searchDebounce;

  //only the latest tap can update the selected stop
  int _mapTapRequestId = 0;

  int _routeRequestId = 0;

  bool _isLoadingRoute = false;
  bool _isLoadingLocation = true;
  bool _isSearching = false;
  bool _isZooming = false;
  bool _isMovingCamera = false;
  bool _isSettingStop = false;

  Future<void> _fitRouteToScreen() async {
    if (_mapController == null) return;

    final points = <LatLng>[];

    // Current GPS location
    if (_currentLocation != null) {
      points.add(_currentLocation!);
    }

    // Existing stops
    for (final stop in controller.currentDraft.stops) {
      if (stop.lat != null && stop.lng != null) {
        points.add(
          LatLng(
            stop.lat!,
            stop.lng!,
          ),
        );
      }
    }

    // Currently selected stop
    if (_selectedStop != null) {
      points.add(_selectedStop!);
    }

    // Destination
    if (controller.currentDraft.lat != null &&
        controller.currentDraft.lng != null) {
      points.add(
        LatLng(
          controller.currentDraft.lat!,
          controller.currentDraft.lng!,
        ),
      );
    }

    if (points.length < 2) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          80,
        ),
      );
    } catch (e) {
      debugPrint(
        'Failed to fit route on screen: $e',
      );
    }
  }

  @override
  void initState() {
    super.initState();

    final existingStop = widget.existingStop;

    if (existingStop != null &&
        existingStop.lat != null &&
        existingStop.lng != null) {
      _selectedStop = LatLng(
        existingStop.lat!,
        existingStop.lng!,
      );

      _selectedStopName = existingStop.locationName;
      _selectedStopAddress = existingStop.locationAddress;
      _selectedStopPlaceId = existingStop.googlePlaceId;
    }

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }


  Future<void> _zoomIn() async {
    if (_mapController == null || _isZooming) return;

    _isZooming = true;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.zoomIn(),
      );
    } finally {
      _isZooming = false;
    }
  }

  Future<void> _zoomOut() async {
    if (_mapController == null || _isZooming) return;

    _isZooming = true;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.zoomOut(),
      );
    } finally {
      _isZooming = false;
    }
  }

  Future<void> _getCurrentLocation() async {

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      var permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      final position =
      await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;
      });

      final isEditing = widget.existingStop != null;

      if (!isEditing) {
        await _moveCamera(location);
      }

      await _updateRoute(
        fitCamera: !isEditing,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingLocation = false;
      });

      debugPrint(
        'Failed to get current location: $e',
      );
    }
  }

  Future<void> _moveCamera(LatLng location) async {
    if (_mapController == null || _isMovingCamera) return;

    _isMovingCamera = true;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          location,
          14.0,
        ),
      );
    } finally {
      _isMovingCamera = false;
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _searchDebounce = Timer(
      const Duration(milliseconds: 400),
          () async {
        setState(() {
          _isSearching = true;
        });

        try {
          final results =
          await _placesService.autocomplete(query);

          if (!mounted) return;

          setState(() {
            _suggestions = results;
            _isSearching = false;
          });
        } catch (e) {
          if (!mounted) return;

          setState(() {
            _suggestions = [];
            _isSearching = false;
          });

          debugPrint(
            'Places autocomplete error: $e',
          );
        }
      },
    );
  }

  Future<void> _selectSuggestion(
      GooglePlacePrediction prediction,
      ) async {
    debugPrint('========== SELECT SUGGESTION ==========');
    debugPrint('Place ID: ${prediction.placeId}');
    debugPrint('Place Name: ${prediction.primaryText}');

    FocusScope.of(context).unfocus();

    setState(() {
      _isSearching = true;
      _suggestions = [];
    });

    try {
      debugPrint('Calling getPlaceDetails...');

      final details = await _placesService.getPlaceDetails(
        prediction.placeId,
      );

      debugPrint('Place details received!');
      debugPrint('Name: ${details.name}');
      debugPrint('Address: ${details.address}');
      debugPrint('Latitude: ${details.latitude}');
      debugPrint('Longitude: ${details.longitude}');
      debugPrint('Place ID: ${details.placeId}');

      final location = LatLng(
        details.latitude,
        details.longitude,
      );

      if (!mounted) return;

      setState(() {
        _selectedStop = location;
        _selectedStopName = details.name;
        _selectedStopAddress = details.address;
        _selectedStopPlaceId = details.placeId;
        _isSearching = false;

        _searchController.text = details.name;
      });

      debugPrint('Selected stop updated.');
      debugPrint('Moving camera to: $location');

      await _moveCamera(location);

      debugPrint('Camera moved successfully.');
      debugPrint('========================================');
    } catch (e) {
      debugPrint('!!! PLACE DETAILS ERROR !!!');
      debugPrint('$e');

      if (!mounted) return;

      setState(() {
        _isSearching = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to get this location.',
          ),
        ),
      );
    }
  }

  Future<void> _onMapTap(LatLng location) async {
    FocusScope.of(context).unfocus();

    final requestId = ++_mapTapRequestId;

    setState(() {
      _selectedStop = location;
      _selectedStopName = null;
      _selectedStopAddress = null;
      _selectedStopPlaceId = null;

      _searchController.clear();
      _suggestions = [];
      _isSearching = true;
    });

    try {
      final result = await _placesService.reverseGeocode(
        location.latitude,
        location.longitude,
      );

      if (!mounted || requestId != _mapTapRequestId) {
        return;
      }

      setState(() {
        _selectedStopName = result.name;
        _selectedStopAddress = result.address;
        _selectedStopPlaceId = result.placeId;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted || requestId != _mapTapRequestId) {
        return;
      }

      setState(() {
        _selectedStopName = 'Selected location';
        _selectedStopAddress = null;
        _selectedStopPlaceId = null;
        _isSearching = false;
      });

      debugPrint(
        'Reverse geocoding error: $e',
      );
    }
  }

  Future<void> _setStop() async {
    if (_isSettingStop) return;

    _isSettingStop = true;

    try {
      final location = _selectedStop;

      if (location == null) {
        return;
      }

      // edit existing stop
      if (widget.existingStop != null) {
        final stop = CreateTripStopDraft(
          locationName:
          _selectedStopName ?? 'Selected location',
          locationAddress: _selectedStopAddress,
          lat: location.latitude,
          lng: location.longitude,
          googlePlaceId: _selectedStopPlaceId,
        );

        if (!mounted) return;

        Get.back(
          result: CreateTripStopMapResult(
            stop: stop,
            insertionIndex: 0,
          ),
        );

        return;
      }

      // adding a new stop
      final insertionIndex =
      _routeCalculator.findBestStopIndex(
        newStop: location,
        stops: controller.currentDraft.stops,
        routePoints: _routePoints,
      );

      debugPrint(
        'New stop insertion index: $insertionIndex',
      );

      final stop = CreateTripStopDraft(
        locationName:
        _selectedStopName ?? 'Selected location',
        locationAddress: _selectedStopAddress,
        lat: location.latitude,
        lng: location.longitude,
        googlePlaceId: _selectedStopPlaceId,
      );

      if (!mounted) return;

      Get.back(
        result: CreateTripStopMapResult(
          stop: stop,
          insertionIndex: insertionIndex,
        ),
      );

    } finally {
      _isSettingStop = false;
    }
  }

  Future<void> _recalculateRouteWithNewStop(
      LatLng newStop,
      int insertionIndex,
      ) async {
    final currentLocation = _currentLocation;

    final destinationLat = controller.currentDraft.lat;
    final destinationLng = controller.currentDraft.lng;

    if (currentLocation == null ||
        destinationLat == null ||
        destinationLng == null) {
      return;
    }

    try {
      final destination = LatLng(
        destinationLat,
        destinationLng,
      );

      final intermediates = <LatLng>[];

      if (widget.existingStop != null) {
        // Editing an existing stop.
        for (final stop in controller.currentDraft.stops) {
          if (stop.lat == null || stop.lng == null) {
            continue;
          }

          if (identical(stop, widget.existingStop)) {
            intermediates.add(newStop);
          } else {
            intermediates.add(
              LatLng(
                stop.lat!,
                stop.lng!,
              ),
            );
          }
        }
      } else {
        // Adding a new stop.
        // Insert it into the calculated position.
        for (int i = 0;
        i < controller.currentDraft.stops.length;
        i++) {
          if (i == insertionIndex) {
            intermediates.add(newStop);
          }

          final stop = controller.currentDraft.stops[i];

          if (stop.lat == null || stop.lng == null) {
            continue;
          }

          intermediates.add(
            LatLng(
              stop.lat!,
              stop.lng!,
            ),
          );
        }

        // Insert at the end if insertionIndex == stops.length.
        if (insertionIndex >= controller.currentDraft.stops.length) {
          intermediates.add(newStop);
        }
      }

      final result =
      await _routesService.calculateRoute(
        origin: currentLocation,
        destination: destination,
        intermediates: intermediates,
      );

      debugPrint(
        'Route points: ${result.points.length}',
      );

      debugPrint(
        'Route recalculated successfully.',
      );
    } on DioException catch (e) {
      debugPrint(
        'Routes API status: ${e.response?.statusCode}',
      );

      debugPrint(
        'Routes API response: ${e.response?.data}',
      );

      debugPrint(
        'Routes API error: ${e.message}',
      );
    } catch (e) {
      debugPrint(
        'Route recalculation error: $e',
      );
    }
  }

  Future<void> _updateRoute({
    bool fitCamera = true,
  }) async {
    final requestId = ++_routeRequestId;
    final currentLocation = _currentLocation;

    final destinationLat = controller.currentDraft.lat;
    final destinationLng = controller.currentDraft.lng;

    if (currentLocation == null ||
        destinationLat == null ||
        destinationLng == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoadingRoute = true;
    });

    try {
      final destination = LatLng(
        destinationLat,
        destinationLng,
      );

      final stops = controller.currentDraft.stops
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

      final result =
      await _routesService.calculateRoute(
        origin: currentLocation,
        destination: destination,
        intermediates: stops,
      );

      final fullRoutePoints = result.points;

      final displayRoutePoints =
      _routeCalculator.simplifyRoute(
        fullRoutePoints,
        toleranceMeters: 20.0,
      );

      debugPrint(
        'Full route points: ${fullRoutePoints.length}, '
            'Display route points: ${displayRoutePoints.length}',
      );

      if (!mounted || requestId != _routeRequestId) {
        return;
      }

      setState(() {
        _routePoints = fullRoutePoints;
        _displayRoutePoints = displayRoutePoints;
        _isLoadingRoute = false;
      });

      if (fitCamera) {
        await _fitRouteToScreen();
      }
    } on DioException catch (e) {

      if (!mounted || requestId != _routeRequestId) {
        return;
      }

      setState(() {
        _routePoints = [];
        _displayRoutePoints = [];
        _isLoadingRoute = false;
      });

      debugPrint('Routes API status: ${e.response?.statusCode}',);
      debugPrint('Routes API response: ${e.response?.data}',);
      debugPrint('Routes API error: ${e.message}',);

    } catch (e) {
      if (!mounted) return;

      setState(() {
        _routePoints = [];
        _displayRoutePoints = [];
        _isLoadingRoute = false;
      });

      debugPrint(
        'Routes API unexpected error: $e',
      );
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    // Current trip destination
    final destinationLat = controller.currentDraft.lat;
    final destinationLng = controller.currentDraft.lng;

    if (destinationLat != null && destinationLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('trip-destination'),
          position: LatLng(
            destinationLat,
            destinationLng,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title:
            controller.currentDraft.locationName ??
                controller.currentDraft.destination ??
                'Destination',
          ),
        ),
      );
    }

    // Existing saved stops
    for (int i = 0; i < controller.currentDraft.stops.length; i++) {
      final stop = controller.currentDraft.stops[i];

      if (stop.lat == null || stop.lng == null) {
        continue;
      }

      markers.add(
        Marker(
          markerId: MarkerId('trip-stop-$i'),
          position: LatLng(
            stop.lat!,
            stop.lng!,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: 'Stop ${i + 1}',
            snippet: stop.locationName,
          ),
        ),
      );
    }

    // Currently selected stop that has not been saved yet
    if (_selectedStop != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('selected-stop'),
          position: _selectedStop!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          infoWindow: InfoWindow(
            title: _selectedStopName ?? 'Selected stop',
          ),
        ),
      );
    }

    return markers;
  }

  CameraPosition _initialCameraPosition() {
    if (widget.existingStop != null &&
        widget.existingStop!.lat != null &&
        widget.existingStop!.lng != null) {
      return CameraPosition(
        target: LatLng(
          widget.existingStop!.lat!,
          widget.existingStop!.lng!,
        ),
        zoom: 14.0,
      );
    }

    if (_currentLocation != null) {
      return CameraPosition(
        target: _currentLocation!,
        zoom: 14.0,
      );
    }

    if (controller.currentDraft.lat != null &&
        controller.currentDraft.lng != null) {
      return CameraPosition(
        target: LatLng(
          controller.currentDraft.lat!,
          controller.currentDraft.lng!,
        ),
        zoom: 12.0,
      );
    }

    return const CameraPosition(
      target: LatLng(
        11.5564,
        104.9282,
      ),
      zoom: 12.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasStop = _selectedStop != null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            _initialCameraPosition(),
            onMapCreated: (controller) async {
              _mapController = controller;
              await controller.setMapStyle(
                GoogleMapStyle.darkMapStyle,
              );

              if (widget.existingStop != null &&
                  widget.existingStop!.lat != null &&
                  widget.existingStop!.lng != null) {
                _moveCamera(
                  LatLng(
                    widget.existingStop!.lat!,
                    widget.existingStop!.lng!,
                  ),
                );
              } else if (_currentLocation != null) {
                _moveCamera(
                  _currentLocation!,
                );
              }
            },
            onTap: _onMapTap,
            myLocationEnabled:
            _currentLocation != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: _buildMarkers(),
            polylines: {
              if (_displayRoutePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('trip-route'),
                  color: routeColor.routeGlow,
                  points: _displayRoutePoints,
                  width: 6,
                ),
            },
          ),

          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildCircleButton(
                        icon: Icons.arrow_back,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSearchBar(),
                      ),
                    ],
                  ),

                  if (_suggestions.isNotEmpty)
                    _buildSuggestions(),
                ],
              ),
            ),
          ),

          if (_isLoadingLocation)
            const Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          if (hasStop)
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: SafeArea(
                child: _buildSetStopButton(),
              ),
            ),

          Positioned(
            right: 20,
            bottom: hasStop ? 152 : 84,
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
          ),

          Positioned(
            right: 20,
            bottom: hasStop ? 92 : 24,
            child: _buildCircleButton(
              icon: Icons.my_location,
              onTap: () async {
                if (_currentLocation != null) {
                  await _moveCamera(_currentLocation!);
                } else {
                  await _getCurrentLocation();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF171E2D),
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search_rounded,
            color: Colors.white70,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller:
              _searchController,
              focusNode:
              _searchFocusNode,
              onChanged:
              _onSearchChanged,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
              const InputDecoration(
                hintText:
                'Search for a stop',
                hintStyle: TextStyle(
                  color: Colors.white54,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_isSearching)
            const Padding(
              padding:
              EdgeInsets.only(right: 14),
              child:
              SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          else if (_searchController
              .text
              .isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white54,
              ),
              onPressed: () {
                _searchController.clear();

                setState(() {
                  _suggestions = [];
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF171E2D),
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding:
        const EdgeInsets.symmetric(
          vertical: 8,
        ),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) =>
        const Divider(
          color: Colors.white10,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final suggestion =
          _suggestions[index];

          return ListTile(
            leading: const Icon(
              Icons.location_on_outlined,
              color: Colors.white70,
            ),
            title: Text(
              suggestion.primaryText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                FontWeight.w500,
              ),
            ),
            subtitle:
            suggestion.secondaryText == null
                ? null
                : Text(
              suggestion.secondaryText!,
              style:
              const TextStyle(
                color: Colors.white54,
              ),
            ),
            onTap: () {
              _selectSuggestion(
                suggestion,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSetStopButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isSettingStop ? null : _setStop,
        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF4C7DFF),
          foregroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'SET STOP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF171E2D),
      borderRadius:
      BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
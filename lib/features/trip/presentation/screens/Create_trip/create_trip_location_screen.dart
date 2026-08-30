import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

import 'package:movem/features/trip/presentation/models/create_trip_draft.dart';
import 'create_trip_duration_screen.dart';
import '../../controllers/trip_controller.dart';


class CreateTripLocationScreen extends StatefulWidget {
  final CreateTripDraft draft;
  final TripController tripController;

  const CreateTripLocationScreen({
    super.key,
    required this.draft,
    required this.tripController,
  });

  @override
  State<CreateTripLocationScreen> createState() =>
      _CreateTripLocationScreenState();
}

class _CreateTripLocationScreenState
    extends State<CreateTripLocationScreen> {
  late final TextEditingController _searchController;

  final Geocoding _geocoding = Geocoding();

  GoogleMapController? _mapController;

  bool _hasPermission = false;
  bool _isGettingLocation = false;

  static const LatLng _defaultLocation = LatLng(
    11.5564,
    104.9282,
  );

  LatLng? _selectedLocation;

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(
      text: widget.draft.locationName ?? '',
    );

    _loadExistingLocation();
    _checkLocationPermission();
  }

  void _loadExistingLocation() {
    if (widget.draft.lat != null &&
        widget.draft.lng != null) {
      final position = LatLng(
        widget.draft.lat!,
        widget.draft.lng!,
      );

      _selectedLocation = position;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ============================================================
  // LOCATION PERMISSION
  // ============================================================

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();

    if (!mounted) return;

    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });

      await _getCurrentLocation();
    }
  }

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Future<void> _getCurrentLocation() async {
    final serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    if (mounted) {
      setState(() {
        _isGettingLocation = true;
      });
    }

    try {
      final position =
      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      final currentLatLng = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        if (_selectedLocation == null) {
          _selectedLocation = currentLatLng;
        }
      });

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          currentLatLng,
          15.0,
        ),
      );
    } catch (_) {
      // Ignore GPS errors.
    } finally {
      if (!mounted) return;

      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  // ============================================================
  // MAP
  // ============================================================

  void _onMapCreated(
      GoogleMapController controller,
      ) {
    _mapController = controller;

    final target =
        _selectedLocation ?? _defaultLocation;

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        target,
        _selectedLocation != null ? 15.0 : 12.0,
      ),
    );
  }

  void _onMapTap(LatLng position) {
    _selectLocation(position);
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _showMessage('Please enter a location.');
      return;
    }

    FocusScope.of(context).unfocus();

    try {
      final locations = await _geocoding.locationFromAddress(
        query,
      );

      if (locations.isEmpty) {
        _showMessage('Location not found.');
        return;
      }

      final location = locations.first;

      final latLng = LatLng(
        location.latitude,
        location.longitude,
      );

      await _selectLocation(
        latLng,
        locationName: query,
      );
    } catch (e) {
      _showMessage(
        'Could not find "$query". Please try another location.',
      );
    }
  }

  Future<void> _selectLocation(
      LatLng location, {
        String? locationName,
      }) async {
    setState(() {
      _selectedLocation = location;

      widget.draft.lat = location.latitude;
      widget.draft.lng = location.longitude;

      if (locationName != null &&
          locationName.trim().isNotEmpty) {
        widget.draft.locationName = locationName.trim();
        widget.draft.destination = locationName.trim();
      }
    });

    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        location,
        14.0,
      ),
    );
  }

  // ============================================================
  // CONTINUE
  // ============================================================

  void _continue() {
    final locationName =
    widget.draft.locationName?.trim();

    if (locationName == null ||
        locationName.isEmpty ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select your destination.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTripDurationScreen(
          draft: widget.draft,
          tripController: widget.tripController,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.of(context).size.height;

    final imageHeight = screenHeight * 0.50;

    // Panel overlaps image by approximately 7%.
    final panelTop = screenHeight * 0.43;

    // Space available inside the panel.
    final panelHeight =
        screenHeight - panelTop;

    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: Stack(
        children: [
          // ======================================================
          // BACKGROUND IMAGE
          // ======================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/create_new_trip_bg.png',
                    fit: BoxFit.cover,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent,
                          Colors.black.withOpacity(0.15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // HEADER + STEP INDICATOR
          // ======================================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.pop(context),
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

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      _buildStep(active: true),
                      const SizedBox(width: 6),
                      _buildStep(active: true),
                      const SizedBox(width: 6),
                      _buildStep(active: false),
                      const SizedBox(width: 6),
                      _buildStep(active: false),
                      const SizedBox(width: 6),
                      _buildStep(active: false),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LOCATION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // TRIP NAME
          // OUTSIDE THE ROUNDED PANEL
          // ======================================================
          Positioned(
            top: panelTop - 250,
            left: 24,
            right: 24,
            child: Text(
              widget.draft.activityName ?? 'Your Trip',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          // ======================================================
          // FORM PANEL
          // ======================================================
          Positioned(
            top: panelTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: panelHeight,
              decoration: const BoxDecoration(
                color: Color(0xFF0B101D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 18,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  16,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // Question
                    const Text(
                      'Where are you going?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Select your destination',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Search
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _searchLocation(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search location',
                              hintStyle: const TextStyle(
                                color: Colors.white30,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Colors.white54,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF171E2D),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        GestureDetector(
                          onTap: _searchLocation,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Current Location
                    const Text(
                      'Current Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // ==================================================
                    // MAP
                    // ==================================================
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                        child: Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _selectedLocation ?? _defaultLocation,
                                zoom: 12.0,
                              ),

                              onMapCreated: _onMapCreated,

                              onTap: (LatLng location) {
                                _selectLocation(location);
                              },

                              myLocationEnabled: _hasPermission,

                              myLocationButtonEnabled: false,

                              markers: _selectedLocation == null
                                  ? {}
                                  : {
                                Marker(
                                  markerId: const MarkerId('selected-location'),
                                  position: _selectedLocation!,
                                ),
                              },
                            ),

                            // Current location button
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child:
                              GestureDetector(
                                onTap:
                                _getCurrentLocation,
                                child:
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Colors.white,
                                    shape:
                                    BoxShape.circle,
                                  ),
                                  child:
                                  _isGettingLocation
                                      ? const Padding(
                                    padding:
                                    EdgeInsets.all(
                                      12,
                                    ),
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth:
                                      2,
                                      color:
                                      Colors.black,
                                    ),
                                  )
                                      : const Icon(
                                    Icons
                                        .my_location,
                                    color:
                                    Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Selected location
                    if (_selectedLocation != null)
                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(0xFF171E2D),
                          borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons
                                  .location_on_outlined,
                              color:
                              Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.draft
                                    .locationName ??
                                    'Selected location',
                                maxLines: 1,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Continue
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.white,
                          foregroundColor:
                          Colors.black,
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              26,
                            ),
                          ),
                        ),
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w800,
                            letterSpacing: 1.2,
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

  Widget _buildStep({
    required bool active,
  }) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: active
              ? Colors.white
              : Colors.white24,
        ),
      ),
    );
  }
}
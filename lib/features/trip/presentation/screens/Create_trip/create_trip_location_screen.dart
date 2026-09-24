import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/create_trip_controller.dart';
import 'package:movem/l10n/app_localizations.dart';
import 'package:movem/features/trip/data/services/google_places_service.dart';

import 'package:movem/core/config/google_map_style.dart';
import '../../widgets/create_trip_component.dart';
import 'create_trip_duration_screen.dart';

class CreateTripLocationScreen extends StatefulWidget {
  const CreateTripLocationScreen({
    super.key,
  });

  @override
  State<CreateTripLocationScreen> createState() =>
      _CreateTripLocationScreenState();
}

class _CreateTripLocationScreenState extends State<CreateTripLocationScreen> {

  final GooglePlacesService _placesService = GooglePlacesService();

  final CreateTripController controller = Get.find<CreateTripController>();

  late final TextEditingController _searchController;

  GoogleMapController? _mapController;

  Timer? _autocompleteTimer;

  bool _hasPermission = false;
  bool _isGettingLocation = false;
  bool _isSearching = false;
  bool _isResolvingLocation = false;

  List<GooglePlacePrediction> _suggestions = [];

  static const LatLng _defaultLocation = LatLng(
    11.5564,
    104.9282,
  );

  LatLng _initialPosition = _defaultLocation;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(
      text: controller.currentDraft.locationName ?? '',
    );

    _loadExistingLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  void _loadExistingLocation() {
    final draft = controller.currentDraft;

    if (draft.lat != null && draft.lng != null) {
      _selectedLocation = LatLng(
        draft.lat!,
        draft.lng!,
      );
    }
  }

  @override
  void dispose() {
    _autocompleteTimer?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<bool> _ensureLocationPermission() async {
    var status = await Permission.location.status;

    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    if (!status.isGranted) {
      final l10n = AppLocalizations.of(context)!;

      _showMessage(
        l10n.tripLocationPermissionDenied,
      );

      return false;
    }

    if (mounted) {
      setState(() {
        _hasPermission = true;
      });
    }

    return true;
  }

  Future<void> _checkLocationPermission() async {
    final granted = await _ensureLocationPermission();

    if (!granted) return;

    await _getCurrentLocation(
      selectLocation: false,
    );
  }

  Future<void> _getCurrentLocation({
    required bool selectLocation,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _showMessage(
        l10n.tripLocationServiceDisabled,
      );
      return;
    }

    final granted = await _ensureLocationPermission();

    if (!granted) return;

    if (mounted) {
      setState(() {
        _isGettingLocation = true;
      });
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      final currentLatLng = LatLng(
        position.latitude,
        position.longitude,
      );

      _initialPosition = currentLatLng;

      if (mounted) {
        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            currentLatLng,
            15.0,
          ),
        );
      }

      if (selectLocation) {
        await _resolveCoordinates(
          currentLatLng,
        );
      }
    } catch (_) {
      // GPS failure is handled  here.
    } finally {
      if (!mounted) return;

      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  // map
  void _onMapCreated(

      GoogleMapController controller,) {

    _mapController = controller;

    controller.setMapStyle(
      GoogleMapStyle.darkMapStyle,
    );

    final target = _selectedLocation ?? _initialPosition;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        target,
        _selectedLocation != null
            ? 15.0
            : 12.0,
      ),
    );
  }

  void _onMapTap(LatLng position) {
    _resolveCoordinates(position);
  }

  // reverse geocode
  Future<void> _resolveCoordinates(
    LatLng location,
  ) async {
    if (_isResolvingLocation) return;

    if (mounted) {
      setState(() {
        _isResolvingLocation = true;
      });
    }

    try {
      final result = await _placesService.reverseGeocode(
        location.latitude,
        location.longitude,
      );

      if (!mounted) return;

      setState(() {
        _selectedLocation = LatLng(
          result.latitude,
          result.longitude,
        );

        _searchController.text = result.name.trim();
        _suggestions = [];
      });

      controller.setDestination(
        locationName: result.name.trim(),
        locationAddress: result.address,
        lat: result.latitude,
        lng: result.longitude,
        googlePlaceId: result.placeId,
      );

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            result.latitude,
            result.longitude,
          ),
          14.0,
        ),
      );
    } catch (_) {
      final l10n = AppLocalizations.of(context)!;

      _showMessage(
        l10n.tripLocationNotFound,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isResolvingLocation = false;
      });
    }
  }

  // auto complete
  void _onSearchChanged(String value) {
    _autocompleteTimer?.cancel();

    final query = value.trim();

    if (query.isEmpty) {
      _placesService.resetSession();

      setState(() {
        _suggestions = [];
        _isSearching = false;
      });

      return;
    }

    if (query.length < 3) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });

      return;
    }

    setState(() {
      _isSearching = true;
    });

    _autocompleteTimer = Timer(
      const Duration(milliseconds: 400),
      () {
        _loadSuggestions(query);
      },
    );
  }

  Future<void> _loadSuggestions(
    String query,
  ) async {
    try {
      final results = await _placesService.autocomplete(
        query,
      );

      if (!mounted) return;

      // Ignore results if the user changed the text
      if (_searchController.text.trim() != query) {
        return;
      }

      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
    }
  }

  // select autocomplete prediction
  Future<void> _selectPrediction(
    GooglePlacePrediction prediction,
  ) async {
    FocusScope.of(context).unfocus();

    _autocompleteTimer?.cancel();

    if (mounted) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
    }

    try {
      final details = await _placesService.getPlaceDetails(
        prediction.placeId,
      );

      if (!mounted) return;

      final location = LatLng(
        details.latitude,
        details.longitude,
      );

      setState(() {
        _selectedLocation = location;
        _searchController.text = details.name.trim();
      });

      controller.setDestination(
        locationName: details.name.trim(),
        locationAddress: details.address,
        lat: details.latitude,
        lng: details.longitude,
        googlePlaceId: details.placeId,
      );

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          location,
          14.0,
        ),
      );
    } catch (_) {
      final l10n = AppLocalizations.of(context)!;

      _showMessage(
        l10n.tripLocationSearchFailed,
      );
    }
  }

  // continue
  void _continue() {
    final l10n = AppLocalizations.of(context)!;
    final draft = controller.currentDraft;

    if (draft.locationName == null ||
        draft.locationName!.trim().isEmpty ||
        draft.lat == null ||
        draft.lng == null) {
      _showMessage(
        l10n.tripLocationRequired,
      );
      return;
    }

    Get.to(
          () => const CreateTripDurationScreen(),
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  // search ui
  Widget _buildSearchOverlay(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          color: const Color(0xE6151D2D),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: l10n.tripLocationSearchHint,
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                  ),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : (_searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();

                                setState(() {
                                  _suggestions = [];
                                  _isSearching = false;
                                });

                                _placesService.resetSession();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                              ),
                            )
                          : null),
                  filled: true,
                  fillColor: const Color(0x99171E2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              if (_suggestions.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 250,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xF2171E2D),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.white.withValues(
                        alpha: 0.08,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final prediction = _suggestions[index];

                      return ListTile(
                        onTap: () => _selectPrediction(
                          prediction,
                        ),
                        leading: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                          size: 21,
                        ),
                        title: Text(
                          prediction.primaryText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: prediction.secondaryText == null
                            ? null
                            : Text(
                                prediction.secondaryText!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // build
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardHeight > 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageHeight = screenHeight * 0.50;

    // expand
    final formTop = keyboardOpen
        ? screenHeight * 0.15
        : screenHeight * 0.43;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark
          ? CreateTripColors.darkBackground
          : CreateTripColors.lightBackground,
      body: Stack(
        children: [
          // Background image
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

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  14,
                  20,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CreateTripHeader(
                      title: l10n.createNewTrip,
                      onBack: () => Get.back(),
                    ),

                    const SizedBox(height: 8),

                    const CreateTripStepIndicator(
                      activeIndex: 1,
                    ),

                    const SizedBox(height: 10),

                    Obx(
                          () => Text(
                        controller.draft.value.activityName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: CreateTripFonts.condensed,
                          fontFamilyFallback:
                          CreateTripFonts.khmerFallback,
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Location panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: formTop,
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? CreateTripColors.darkBackground
                    : CreateTripColors.lightBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 22,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tripLocationTitle,
                      style: TextStyle(
                        fontFamily: CreateTripFonts.condensed,
                        fontFamilyFallback:
                        CreateTripFonts.khmerFallback,
                        color: isDark
                            ? Colors.white
                            : CreateTripColors.lightText,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      l10n.tripLocationSubtitle,
                      style: TextStyle(
                        fontFamily: CreateTripFonts.condensed,
                        fontFamilyFallback:
                        CreateTripFonts.khmerFallback,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Google Map
                            GoogleMap(
                              initialCameraPosition:
                              CameraPosition(
                                target: _initialPosition,
                                zoom: 12.0,
                              ),
                              onMapCreated: _onMapCreated,
                              onTap: _onMapTap,
                              myLocationEnabled: _hasPermission,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              compassEnabled: false,
                              markers: _selectedLocation == null
                                  ? {}
                                  : {
                                Marker(
                                  markerId: const MarkerId(
                                    'selected-location',
                                  ),
                                  position: _selectedLocation!,
                                ),
                              },
                            ),

                            // Search on map
                            Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: _buildSearchOverlay(
                                context,
                                l10n,
                              ),
                            ),

                            // Map controls
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: Column(
                                children: [
                                  _buildMapControl(
                                    icon: Icons.add,
                                    onTap: () async {
                                      await _mapController
                                          ?.animateCamera(
                                        CameraUpdate.zoomIn(),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 8),

                                  _buildMapControl(
                                    icon: Icons.remove,
                                    onTap: () async {
                                      await _mapController
                                          ?.animateCamera(
                                        CameraUpdate.zoomOut(),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 10),

                                  _buildMapControl(
                                    icon: Icons.my_location,
                                    onTap: () =>
                                        _getCurrentLocation(
                                          selectLocation: true,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            // Resolving location loading
                            if (_isResolvingLocation)
                              Positioned.fill(
                                child: Container(
                                  color:
                                  Colors.black.withOpacity(0.15),
                                  child: const Center(
                                    child:
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Continue button
                    Obx(
                          () {
                        final draft = controller.draft.value;

                        final hasLocation =
                            draft.locationName != null &&
                                draft.locationName!
                                    .trim()
                                    .isNotEmpty &&
                                draft.lat != null &&
                                draft.lng != null;

                        return CreateTripBottomButton(
                          text: l10n.continueButton,
                          onPressed:
                          hasLocation ? _continue : null,
                        );
                      },
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


}

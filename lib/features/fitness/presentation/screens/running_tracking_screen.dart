import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../domain/pace_calculator.dart';
import '../controllers/tracking_controller.dart';
import '../../data/models/run_session.dart';
import '../../data/models/solo_challenge_model.dart';
import 'run_summary_screen.dart';
import '../../../../l10n/app_localizations.dart';

class RunningTrackingScreen extends StatefulWidget {
  final SoloChallengeModel? challenge;

  const RunningTrackingScreen({
    super.key,
    this.challenge,
  });

  @override
  State<RunningTrackingScreen> createState() => _RunningTrackingScreenState();
}

class _RunningTrackingScreenState extends State<RunningTrackingScreen>
    with SingleTickerProviderStateMixin {
  late final TrackingController controller;
  GoogleMapController? _mapController;
  bool _isProgrammaticMove = false;
  final isFinishing = false.obs;
  Worker? _routeWorker;
  Worker? _initialPosWorker;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<TrackingController>()) {
      controller = Get.find<TrackingController>();
    } else {
      controller = Get.put(TrackingController(challenge: widget.challenge));
    }

    _initialPosWorker = ever<LatLng?>(controller.initialPosition, (pos) {
      if (pos != null && controller.route.isEmpty) {
        _animateToLocation(pos, zoom: 16.5);
      }
    });

    _routeWorker = ever<List<LatLng>>(controller.route, (points) {
      if (points.isNotEmpty && controller.autoFollow.value) {
        _animateToLocation(points.last);
      }
    });
  }

  @override
  void dispose() {
    _routeWorker?.dispose();
    _initialPosWorker?.dispose();
    super.dispose();
  }

  void _animateToLocation(LatLng target, {double? zoom}) {
    if (_mapController == null) return;
    _isProgrammaticMove = true;
    final update = zoom != null
        ? CameraUpdate.newLatLngZoom(target, zoom)
        : CameraUpdate.newLatLng(target);
    _mapController!.animateCamera(update).then((_) {
      _isProgrammaticMove = false;
    }).catchError((_) {
      _isProgrammaticMove = false;
    });
  }

  static const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#0d1527"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#8c9db5"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#09101f"}, {"weight": 3}]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#c8d6ea"}]
  },
  {
    "featureType": "poi",
    "stylers": [{"visibility": "off"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [{"color": "#112638"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#5b8296"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [{"color": "#223552"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#152338"}, {"weight": 1}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#9cb1ce"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#0d1527"}, {"weight": 2.5}]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [{"color": "#2e466d"}]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#1b2c45"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#3f5f94"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#273d61"}, {"weight": 1.5}]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#dbeafe"}]
  },
  {
    "featureType": "transit",
    "stylers": [{"visibility": "off"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#070d1a"}]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#2c4568"}]
  }
]
''';

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
      canPop: !isFinishing.value,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1329),
        body: Stack(
          children: [
          Obx(() {
            final route = controller.route;
            final startLatLng = controller.initialPosition.value;

            if (startLatLng == null) {
              return const ColoredBox(
                color: Color(0xFF0A1329),
                child: SizedBox.expand(),
              );
            }

            final polylines = <Polyline>{};
            final circles = <Circle>{};

            if (route.isNotEmpty) {
              polylines.add(
                Polyline(
                  polylineId: const PolylineId('route_glow'),
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                  width: 10,
                  points: route,
                  jointType: JointType.round,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                ),
              );

              polylines.add(
                Polyline(
                  polylineId: const PolylineId('route_core'),
                  color: const Color(0xFF00E5FF),
                  width: 5,
                  points: route,
                  jointType: JointType.round,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                ),
              );

              circles.add(
                Circle(
                  circleId: const CircleId('start_glow'),
                  center: route.first,
                  radius: 16,
                  fillColor: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                  strokeColor: Colors.transparent,
                ),
              );
              circles.add(
                Circle(
                  circleId: const CircleId('start_core'),
                  center: route.first,
                  radius: 7,
                  fillColor: const Color(0xFF38BDF8),
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              );

              circles.add(
                Circle(
                  circleId: const CircleId('curr_glow'),
                  center: route.last,
                  radius: 20,
                  fillColor: const Color(0xFF00E676).withValues(alpha: 0.45),
                  strokeColor: Colors.transparent,
                ),
              );
              circles.add(
                Circle(
                  circleId: const CircleId('curr_core'),
                  center: route.last,
                  radius: 8,
                  fillColor: const Color(0xFF00E676),
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              );
            }

            return Listener(
              onPointerDown: (_) {
                if (controller.autoFollow.value) {
                  controller.setAutoFollow(false);
                }
              },
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: startLatLng,
                  zoom: 16.5,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                style: _darkMapStyle,
                polylines: polylines,
                circles: circles,
                onMapCreated: (mapController) {
                  _mapController = mapController;
                  final target = controller.route.isNotEmpty
                      ? controller.route.last
                      : controller.initialPosition.value;
                  if (target != null) {
                    _animateToLocation(target, zoom: 16.5);
                  }
                },
                onCameraMoveStarted: () {
                  if (!_isProgrammaticMove) {
                    controller.setAutoFollow(false);
                  }
                },
              ),
            );
          }),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: _handleBackPress,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0C1938).withValues(alpha: 0.75),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 180,
            child: Obx(() {
              if (controller.autoFollow.value) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  controller.setAutoFollow(true);
                  final target = controller.route.isNotEmpty
                      ? controller.route.last
                      : controller.initialPosition.value;
                  if (target != null) {
                    _animateToLocation(target, zoom: 16.5);
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0C1938).withValues(alpha: 0.85),
                    border: Border.all(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.my_location_rounded, color: Color(0xFF38BDF8), size: 22),
                  ),
                ),
              );
            }),
          ),

          Obx(() {
            if (controller.isAcquiringGps.value || controller.gpsFailed.value) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.isAcquiringGps.value)
                      const CircularProgressIndicator(color: Color(0xFF38BDF8)),
                    if (controller.isAcquiringGps.value) const SizedBox(height: 18),
                    Text(
                      controller.gpsFailed.value
                          ? 'Waiting for GPS'
                          : 'Getting your location',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.gpsFailed.value
                          ? 'Move outdoors and try again'
                          : 'Run starts after GPS lock',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    if (controller.gpsFailed.value) ...[
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Retry GPS',
                        onPressed: controller.retryGpsLock,
                        width: null,
                        height: 40,
                      ),
                    ],
                  ],
                ),
              );
            }

            if (!controller.isCountingDown.value) return const SizedBox.shrink();

            return Center(
              child: GestureDetector(
                onTap: controller.skipCountdown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF8A99B5).withValues(alpha: 0.50),
                        border: Border.all(
                          color: const Color(0xFFB0BACD).withValues(alpha: 0.85),
                          width: 8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${controller.countdown.value}',
                          style: const TextStyle(
                            color: Color(0xFF0B1736),
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: const Text(
                        'Tap circle to start now',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: SafeArea(
              child: GlassContainer(
                width: double.infinity,
                blur: 24.0,
                opacity: 0.25,
                color: const Color(0xFF0A152E),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'STEP',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(() => Text(
                                '${controller.steps}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              )),
                              const SizedBox(height: 12),
                              Obx(() => Text(
                                PaceCalculator.formatPace(controller.averagePaceMinPerKm),
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                            ],
                          ),
                        ),

                        Container(
                          width: 1.0,
                          height: 60,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),

                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'DURATION',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(() => Text(
                                controller.formattedDuration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              )),
                              const SizedBox(height: 12),
                              Obx(() => _buildControlButtons()),
                            ],
                          ),
                        ),

                        Container(
                          width: 1.0,
                          height: 60,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),

                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'CALORIES',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(() => Text(
                                '${controller.calories}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              )),
                              const SizedBox(height: 12),
                              const SizedBox(height: 38),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Obx(() {
                      final s = controller.session.value.status;
                      if (s == RunStatus.idle) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: _buildEndWorkoutButton(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Full-screen finishing overlay – blocks all interaction
          if (isFinishing.value)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.72),
                  child: Center(
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
        ),
      ),
    ));
  }

  Widget _buildControlButtons() {
    final status = controller.session.value.status;

    if (status == RunStatus.running) {
      return GestureDetector(
        onTap: controller.pauseRun,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.pause_rounded,
              color: Color(0xFF0F172A),
              size: 22,
            ),
          ),
        ),
      );
    } else if (status == RunStatus.paused) {
      return GestureDetector(
        onTap: controller.resumeRun,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF10B981),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: controller.isCountingDown.value ? controller.skipCountdown : controller.startRun,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF38BDF8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildEndWorkoutButton() {
    return Obx(() {
      return AppButton.danger(
        label: 'End',
        icon: Icons.stop_rounded,
        isLoading: isFinishing.value,
        onPressed: () async {
          isFinishing.value = true;
          final summary = await controller.finishRun();
          Get.off(() => RunSummaryScreen(
            session: controller.session.value,
            summary: summary,
            challenge: widget.challenge,
          ));
        },
      );
    });
  }

  void _handleBackPress() {
    if (controller.session.value.status == RunStatus.running) {
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF0F1B36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(AppLocalizations.of(Get.context!)?.exitRun ?? 'Exit Run?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            'Your active running challenge will be paused. Do you want to leave?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: AppLocalizations.of(Get.context!)?.cancel ?? 'Cancel',
                    onPressed: () => Get.back(),
                    height: 46,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton.danger(
                    label: 'Exit',
                    onPressed: () {
                      controller.pauseRun();
                      Get.back();
                      Get.back();
                    },
                    height: 46,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      Get.back();
    }
  }
}

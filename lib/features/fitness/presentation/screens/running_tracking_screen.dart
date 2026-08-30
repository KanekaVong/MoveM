import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/tracking_controller.dart';
import '../../data/models/run_session.dart';
import '../../domain/pace_calculator.dart';
import 'run_summary_screen.dart';
import 'run_history_screen.dart';

class RunningTrackingScreen extends StatefulWidget {
  const RunningTrackingScreen({super.key});

  @override
  State<RunningTrackingScreen> createState() => _RunningTrackingScreenState();
}

class _RunningTrackingScreenState extends State<RunningTrackingScreen> {
  final TrackingController controller = Get.put(TrackingController());
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.liveTracking ?? 'Live Tracking', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Get.to(() => const RunHistoryScreen());
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            final route = controller.route;
            final polyline = Polyline(
              polylineId: const PolylineId('route'),
              color: Colors.blueAccent,
              width: 5,
              points: route,
            );

            if (controller.autoFollow.value && route.isNotEmpty) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(route.last),
              );
            }

            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 16.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              polylines: {polyline},
              onMapCreated: (mapController) {
                _mapController = mapController;
              },
              onCameraMoveStarted: () {

                controller.setAutoFollow(false);
              },
            );
          }),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Obx(() {
              final session = controller.session.value;
              final currentPace = controller.currentPace.value;

              final distanceKm = session.totalDistanceMeters / 1000.0;
              final durationStr = session.elapsedDuration.toString().split('.').first;

              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Time', durationStr.padLeft(8, '0')),
                      _buildStatColumn('Distance', '${distanceKm.toStringAsFixed(2)} km'),
                      _buildStatColumn('Pace', PaceCalculator.formatPace(currentPace)),
                    ],
                  ),
                ),
              );
            }),
          ),

          Positioned(
            right: 16,
            bottom: 100,
            child: Obx(() {
              if (controller.autoFollow.value) return const SizedBox.shrink();
              return FloatingActionButton(
                mini: true,
                onPressed: () {
                  controller.setAutoFollow(true);
                  if (controller.route.isNotEmpty) {
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(controller.route.last, 16),
                    );
                  }
                },
                child: const Icon(Icons.my_location),
              );
            }),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Obx(() {
              final status = controller.session.value.status;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildControls(status),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  List<Widget> _buildControls(RunStatus status) {
    if (status == RunStatus.idle) {
      return [
        FloatingActionButton.extended(
          onPressed: controller.startRun,
          label: const Text('START'),
          icon: const Icon(Icons.play_arrow),
          backgroundColor: Colors.green,
        )
      ];
    } else if (status == RunStatus.running) {
      return [
        FloatingActionButton.extended(
          onPressed: controller.pauseRun,
          label: const Text('PAUSE'),
          icon: const Icon(Icons.pause),
          backgroundColor: Colors.orange,
        )
      ];
    } else if (status == RunStatus.paused) {
      return [
        FloatingActionButton.extended(
          onPressed: controller.resumeRun,
          label: const Text('RESUME'),
          icon: const Icon(Icons.play_arrow),
          backgroundColor: Colors.green,
        ),
        const SizedBox(width: 16),
        FloatingActionButton.extended(
          onPressed: () async {
            await controller.finishRun();
            Get.to(() => RunSummaryScreen(session: controller.session.value));
          },
          label: const Text('FINISH'),
          icon: const Icon(Icons.stop),
          backgroundColor: Colors.red,
        )
      ];
    }
    return [
      FloatingActionButton.extended(
        onPressed: () {

          controller.session.value = RunSession();
        },
        label: const Text('NEW RUN'),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      )
    ];
  }
}

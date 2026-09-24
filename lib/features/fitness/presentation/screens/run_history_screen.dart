import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/run_session.dart';
import '../../data/models/workout_model.dart';
import '../../domain/pace_calculator.dart';
import '../controllers/run_history_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class RunHistoryScreen extends StatelessWidget {
  const RunHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = Get.put(RunHistoryController());

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: TopToolBar(title: l10n?.runHistory ?? 'Workout History'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.accentBlue));
        }

        if (controller.totalCount == 0) {
          return NoDataComponent(
            title: l10n?.noWorkoutSessionsYet ?? 'No workout sessions yet',
            subtitle: l10n?.noWorkoutSessionsYetSub ??
                'Complete a run or push-up workout to see it here!',
          );
        }

        final hasRemote = controller.hasRemote;
        return RefreshIndicator(
          color: AppColors.accentBlue,
          backgroundColor: AppColors.chipSurface,
          onRefresh: controller.loadAllHistory,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.totalCount,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (hasRemote) {
                return _RemoteWorkoutTile(workout: controller.remoteWorkouts[index]);
              }
              return _LocalSessionTile(session: controller.sessions[index]);
            },
          ),
        );
      }),
    );
  }
}

class _RemoteWorkoutTile extends StatelessWidget {
  final WorkoutHistoryItemModel workout;
  const _RemoteWorkoutTile({required this.workout});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMd().add_jm().format(workout.startedAt);
    final durationMins = workout.durationSeconds ~/ 60;
    final durationSecs = workout.durationSeconds % 60;
    final timeFormatted = '${durationMins}m ${durationSecs}s';
    final isPushUp = workout.workoutType.toUpperCase().contains('PUSH');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.chipSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isPushUp ? Colors.orange : Colors.blueAccent).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPushUp ? Icons.fitness_center : Icons.directions_run,
            color: isPushUp ? Colors.orangeAccent : Colors.blueAccent,
            size: 22,
          ),
        ),
        title: Text(
          workout.workoutType.replaceAll('_', ' '),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          '$dateStr\n${workout.distance > 0 ? '${workout.distance.toStringAsFixed(2)} km • ' : ''}$timeFormatted • ${workout.caloriesBurned.toInt()} kcal',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            workout.status,
            style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _LocalSessionTile extends StatelessWidget {
  final RunSession session;
  const _LocalSessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final distanceKm = session.totalDistanceMeters / 1000.0;
    final avgPace = PaceCalculator.paceMinPerKm(session.totalDistanceMeters, session.elapsedDuration);
    final dateStr = DateFormat.yMMMd().add_jm().format(session.startedAt);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.chipSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.directions_run, color: Colors.blueAccent, size: 22),
        ),
        title: Text(
          dateStr,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          '${distanceKm.toStringAsFixed(2)} km • ${PaceCalculator.formatPace(avgPace)}',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textCaption),
        onTap: () {
          Get.to(() => RunDetailScreen(session: session));
        },
      ),
    );
  }
}

class RunDetailScreen extends StatelessWidget {
  final RunSession session;
  const RunDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final route = session.points.map((p) => LatLng(p.latitude, p.longitude)).toList();

    LatLng target = const LatLng(0, 0);
    if (route.isNotEmpty) {
      target = route.first;
    }

    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blueAccent,
      width: 5,
      points: route,
    );

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: TopToolBar(title: l10n?.runDetails ?? 'Run Details'),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: target,
          zoom: 15.0,
        ),
        polylines: {polyline},
        myLocationButtonEnabled: false,
        onMapCreated: (controller) {
          if (route.isNotEmpty) {
            _zoomToFit(controller, route);
          }
        },
      ),
    );
  }

  void _zoomToFit(GoogleMapController controller, List<LatLng> route) {
    double minLat = route.first.latitude;
    double minLong = route.first.longitude;
    double maxLat = route.first.latitude;
    double maxLong = route.first.longitude;

    for (var point in route) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLong) minLong = point.longitude;
      if (point.longitude > maxLong) maxLong = point.longitude;
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLong),
          northeast: LatLng(maxLat, maxLong),
        ),
        50.0,
      ),
    );
  }
}

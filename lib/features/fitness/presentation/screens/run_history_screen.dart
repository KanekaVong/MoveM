import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/run_session.dart';
import '../../data/models/workout_model.dart';
import '../../data/local/run_session_repository.dart';
import '../../data/repositories/fitness_workout_repository.dart';
import '../../domain/pace_calculator.dart';
import '../../../../core/theme/app_colors.dart';

class RunHistoryScreen extends StatefulWidget {
  const RunHistoryScreen({super.key});

  @override
  State<RunHistoryScreen> createState() => _RunHistoryScreenState();
}

class _RunHistoryScreenState extends State<RunHistoryScreen> {
  final RunSessionRepository _repository = RunSessionRepository();
  final FitnessWorkoutRepository _workoutRepo = FitnessWorkoutRepository();

  List<RunSession> _sessions = [];
  List<WorkoutHistoryItemModel> _remoteWorkouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllHistory();
  }

  Future<void> _loadAllHistory() async {
    setState(() => _isLoading = true);

    await _repository.init();
    final localSessions = await _repository.getAllSessions();
    localSessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));

    final remoteRes = await _workoutRepo.getWorkoutHistory();
    List<WorkoutHistoryItemModel> remotes = [];
    if (remoteRes.isSuccess && remoteRes.data != null) {
      remotes = remoteRes.data!;
      remotes.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    }

    if (mounted) {
      setState(() {
        _sessions = localSessions;
        _remoteWorkouts = remotes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final bool hasRemote = _remoteWorkouts.isNotEmpty;
    final int totalCount = hasRemote ? _remoteWorkouts.length : _sessions.length;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(
          l10n?.runHistory ?? 'Workout History',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : totalCount == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.history, color: AppColors.textCaption, size: 56),
                      SizedBox(height: 16),
                      Text('No workout sessions yet.', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      SizedBox(height: 6),
                      Text('Complete a run or push-up workout to see it here!', style: TextStyle(fontSize: 12, color: AppColors.textCaption)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: Colors.blueAccent,
                  backgroundColor: AppColors.chipSurface,
                  onRefresh: _loadAllHistory,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: totalCount,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (hasRemote) {
                        final workout = _remoteWorkouts[index];
                        return _buildRemoteWorkoutTile(workout);
                      } else {
                        final session = _sessions[index];
                        return _buildLocalSessionTile(session);
                      }
                    },
                  ),
                ),
    );
  }

  Widget _buildRemoteWorkoutTile(WorkoutHistoryItemModel workout) {
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          '$dateStr\n${workout.distance > 0 ? '${workout.distance.toStringAsFixed(2)} km • ' : ''}$timeFormatted • ${workout.caloriesBurned.toInt()} kcal',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            workout.status,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLocalSessionTile(RunSession session) {
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
          child: const Icon(Icons.directions_run, color: Colors.blueAccent, size: 22),
        ),
        title: Text(
          dateStr,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          '${distanceKm.toStringAsFixed(2)} km • ${PaceCalculator.formatPace(avgPace)}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textCaption),
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
      appBar: AppBar(
        title: const Text('Run Details', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
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

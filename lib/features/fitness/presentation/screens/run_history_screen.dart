import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/run_session.dart';
import '../../data/local/run_session_repository.dart';
import '../../domain/pace_calculator.dart';

class RunHistoryScreen extends StatefulWidget {
  const RunHistoryScreen({super.key});

  @override
  State<RunHistoryScreen> createState() => _RunHistoryScreenState();
}

class _RunHistoryScreenState extends State<RunHistoryScreen> {
  final RunSessionRepository _repository = RunSessionRepository();
  List<RunSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    await _repository.init();
    final sessions = await _repository.getAllSessions();

    sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));

    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.runHistory ?? 'Run History', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? const Center(child: Text('No saved runs yet.', style: TextStyle(fontSize: 12, color: Colors.white70)))
              : ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final session = _sessions[index];
                    final distanceKm = session.totalDistanceMeters / 1000.0;
                    final avgPace = PaceCalculator.paceMinPerKm(session.totalDistanceMeters, session.elapsedDuration);
                    final dateStr = DateFormat.yMMMd().add_jm().format(session.startedAt);

                    return ListTile(
                      leading: const Icon(Icons.directions_run, color: Colors.blueAccent),
                      title: Text(dateStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text('${distanceKm.toStringAsFixed(2)} km • ${PaceCalculator.formatPace(avgPace)}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                      onTap: () {
                        Get.to(() => RunDetailScreen(session: session));
                      },
                    );
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
      appBar: AppBar(
        title: const Text('Run Details', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
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

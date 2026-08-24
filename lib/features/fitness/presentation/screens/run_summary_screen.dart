import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/run_session.dart';
import '../../domain/pace_calculator.dart';
import '../controllers/tracking_controller.dart';

class RunSummaryScreen extends StatelessWidget {
  final RunSession session;
  const RunSummaryScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final distanceKm = session.totalDistanceMeters / 1000.0;
    final durationStr = session.elapsedDuration.toString().split('.').first;
    final avgPace = PaceCalculator.paceMinPerKm(session.totalDistanceMeters, session.elapsedDuration);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Summary'),
        automaticallyImplyLeading: false, // Force user to save/discard
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Time', durationStr.padLeft(8, '0')),
                      _buildStatColumn('Distance', '${distanceKm.toStringAsFixed(2)} km'),
                      _buildStatColumn('Avg Pace', PaceCalculator.formatPace(avgPace)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pace over time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (session.points.length > 2)
                SizedBox(
                  height: 200,
                  child: LineChart(
                    _buildPaceChart(),
                  ),
                )
              else
                const SizedBox(
                  height: 200,
                  child: Center(child: Text('Not enough data for chart')),
                ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      // Session is discarded by starting a new one later
                      final controller = Get.find<TrackingController>();
                      controller.session.value = RunSession();
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Discard', style: TextStyle(color: Colors.red)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final controller = Get.find<TrackingController>();
                      await controller.saveRun();
                      Get.back();
                      Get.snackbar('Saved', 'Your run has been saved.');
                      controller.session.value = RunSession();
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Run'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  LineChartData _buildPaceChart() {
    // A simple chart plotting speed (m/s) over time for demonstration
    // Since pacing is inverse of speed, charting speed is easier
    final points = session.points;
    final spots = <FlSpot>[];
    
    final startTime = points.first.timestamp;
    
    for (var p in points) {
      if (p.speed != null) {
        final elapsedSeconds = p.timestamp.difference(startTime).inSeconds.toDouble();
        spots.add(FlSpot(elapsedSeconds, p.speed!));
      }
    }

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blueAccent,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blueAccent.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}

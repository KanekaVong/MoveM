import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'running_tracking_screen.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.to(() => const RunningTrackingScreen());
              },
              icon: const Icon(Icons.directions_run, size: 32),
              label: const Text(
                'Running Activity',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.snackbar(
                  'Coming Soon',
                  'Push-ups and other exercises will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.fitness_center, size: 32),
              label: const Text(
                'Push-ups / More',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/main_nav_controller.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../task/presentation/screens/task_screen.dart';
import '../../../fitness/presentation/screens/fitness_screen.dart';
import '../../../trip/presentation/screens/trip_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class BottomNavScreen extends GetView<MainNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final localize = AppLocalizations.of(context)!;

    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeScreen(),
            TaskScreen(),
            FitnessScreen(),
            TripScreen(),
            SettingsScreen(),
          ],
        );
      }),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(() {
          return BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: localize.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.assignment),
                label: localize.task,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.fitness_center),
                label: localize.fitness,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.map),
                label: localize.trip,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: localize.settings,
              ),
            ],
          );
        }),
      ),
    );
  }
}

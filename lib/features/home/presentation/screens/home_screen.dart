import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/todays_progress_card.dart';
import '../widgets/ongoing_section.dart';
import '../widgets/upcoming_section.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/dashboard_summary_grid.dart';
import '../widgets/reminders_section.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading && controller.dashboardData.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.dashboardData.value;
          if (data == null) {
            return const Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: 32),
                TodaysProgressCard(fitnessStats: data.fitnessStatistics),
                const SizedBox(height: 32),
                OngoingSection(tasks: data.dueToday, fitnessStats: data.fitnessStatistics),
                const SizedBox(height: 32),
                UpcomingSection(tasks: data.upcomingTasks, fitnessStats: data.fitnessStatistics),
                const SizedBox(height: 32),
                if (data.upcomingReminders != null && data.upcomingReminders!.isNotEmpty) ...[
                  RemindersSection(reminders: data.upcomingReminders!),
                  const SizedBox(height: 32),
                ],
                const QuickActionsGrid(),
                const SizedBox(height: 32),
                DashboardSummaryGrid(taskStats: data.statistics),
                const SizedBox(height: 120),
              ],
            ),
          );
        }),
      ),
    );
  }
}

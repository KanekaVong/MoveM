import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/todays_progress_card.dart';
import '../widgets/ongoing_section.dart';
import '../widgets/upcoming_section.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/dashboard_summary_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark navy background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 32),
              const TodaysProgressCard(),
              const SizedBox(height: 32),
              const OngoingSection(),
              const SizedBox(height: 32),
              const UpcomingSection(),
              const SizedBox(height: 32),
              const QuickActionsGrid(),
              const SizedBox(height: 32),
              const DashboardSummaryGrid(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

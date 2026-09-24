import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_news_feed.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchDashboard,
          color: AppColors.accentBlue,
          backgroundColor: AppColors.cardSurface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HomeHeader(),
                SizedBox(height: 18),
                HomeHeroBanner(),
                SizedBox(height: 22),
                HomeQuickActions(),
                SizedBox(height: 22),
                HomeNewsFeed(),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

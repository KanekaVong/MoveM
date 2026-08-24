import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/dto/response/dashboard_response.dart';

class HomeHeader extends StatelessWidget {
  final List<RecentActivityItem>? recentActivities;

  const HomeHeader({super.key, this.recentActivities});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Greetings',
              style: TextStyle(
                color: Color(0xFFA0AAB2),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'ForRiel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              recentActivities != null && recentActivities!.isNotEmpty
                  ? (recentActivities!.first.message ?? 'Stay Active Today!')
                  : 'Stay Active Today!',
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),

            const SizedBox(width: 8),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzYHgqociFLKFTZGayjmtyok4nwEp04pf_Vk3Nf7uosg&s=10', // placeholder leopard
                  ),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: const Color(0xFF1E293B), width: 2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

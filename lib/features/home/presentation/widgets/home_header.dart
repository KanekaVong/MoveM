import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
            const Text(
              'Stay Active Today!',
              style: TextStyle(
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
            IconButton(
              icon: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=200&auto=format&fit=crop', // placeholder leopard
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

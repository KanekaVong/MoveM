import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OngoingSection extends StatelessWidget {
  const OngoingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ongoing',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text('View All', style: TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildOngoingCard(
                'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=600&auto=format&fit=crop', // laptop
                const Color(0xFF4C8DB3),
                Icons.check_box,
                'Task',
                'Create A New Task',
                '',
                'No Due Date',
              ),
              const SizedBox(width: 16),
              _buildOngoingCard(
                'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=600&auto=format&fit=crop', // runner
                const Color(0xFFE28743),
                Icons.directions_run,
                'Fitness',
                'Set Up Your Goals',
                '0 / 5000',
                'Steps',
              ),
              const SizedBox(width: 16),
              _buildOngoingCard(
                'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?q=80&w=600&auto=format&fit=crop', // Valid placeholder
                const Color(0xFF9B5DE5),
                Icons.flight,
                'Trip Plans',
                'Set Up Your Trip Plans',
                '0 Days left',
                'Until Your Next Trip',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOngoingCard(String imageUrl, Color tintColor, IconData icon, String type, String title, String mainStat, String subStat) {
    return Container(
      width: 160,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tintColor.withValues(alpha: 0.6),
              tintColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            if (mainStat.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(mainStat, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
            if (subStat.isNotEmpty)
              Text(subStat, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text('Start', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                  ],
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Center(
                    child: Text('0%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

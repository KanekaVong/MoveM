import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/dto/response/dashboard_response.dart';

class DashboardSummaryGrid extends StatelessWidget {
  final TaskStatistics? taskStats;

  const DashboardSummaryGrid({super.key, this.taskStats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildFriendsActivityCard(),
                  const SizedBox(height: 16),
                  _buildTripPlansCard(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  _buildScoreboardCard(),
                  const SizedBox(height: 16),
                  _buildMyTasksCard(),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildCardBase({required Widget child}) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B), width: 1),
      ),
      child: child,
    );
  }

  Widget _buildFriendsActivityCard() {
    return _buildCardBase(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Friends Activity', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.person_add_alt_1, color: Colors.white, size: 14),
              ],
            ),
            const Spacer(),
            const Center(
              child: Text('No Friends', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 14)),
            ),
            const Spacer(),
            const Divider(color: Color(0xFF1E293B)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('See More Activity', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFA0AAB2), size: 10),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTripPlansCard() {
    return _buildCardBase(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trip Plans', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&auto=format&fit=crop'), // Travel landscape
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('0 Days left', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        const Text('Until Your Next Trip', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 8)),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(4, (index) => Align(
                            widthFactor: 0.7,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFCBD5E1),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Itinerary', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10), overflow: TextOverflow.ellipsis),
                      Text('0 / - activities planned', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 8), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFA0AAB2), size: 10),
              ],
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  height: 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                Container(
                  height: 3,
                  width: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B5DE5),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreboardCard() {
    return _buildCardBase(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scoreboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 12),
                const SizedBox(width: 4),
                const Expanded(child: Text('No Team Yet', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 16),
            _buildScoreItem('1', const Color(0xFFFFD700)),
            _buildScoreItem('2', const Color(0xFFC0C0C0)),
            _buildScoreItem('3', const Color(0xFFCD7F32)),
            _buildScoreItem('4', const Color(0xFFA0AAB2)),
            _buildScoreItem('5', const Color(0xFFA0AAB2)),
            const Spacer(),
            const Divider(color: Color(0xFF1E293B)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('See full leaderboard', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFA0AAB2), size: 10),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String rank, Color rankColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: rankColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(rank, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 2,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTasksCard() {
    return _buildCardBase(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Tasks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFA0AAB2)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tasks Overview', style: TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis),
                      Text('${taskStats?.activeTasks ?? 0} Active, ${taskStats?.completedTasks ?? 0} Completed', style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 10), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Divider(color: Color(0xFF1E293B)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('Create Your Tasks', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 10), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFA0AAB2), size: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}

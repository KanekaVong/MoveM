import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FriendRequestTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String username;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.username,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholder(initial),
                errorWidget: (context, url, error) => _buildPlaceholder(initial),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  username,
                  style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onReject,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Color(0xFF3B82F6), size: 16),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onAccept,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String initial) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFF334155),
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

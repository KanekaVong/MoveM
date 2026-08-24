import 'package:flutter/material.dart';

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double topR = 8.0;   // Small enough to never intersect the active floating button
    final double bottomR = 32.0; // Large pill shape for the bottom

    // Start above the top-left corner
    path.moveTo(topR, -100);
    // Go across to above the top-right corner
    path.lineTo(size.width - topR, -100);
    // Go down to the top-right corner start
    path.lineTo(size.width - topR, 0);
    // Arc down-right to form the top-right corner
    path.arcToPoint(Offset(size.width, topR), radius: Radius.circular(topR));
    // Go down to the bottom-right corner
    path.lineTo(size.width, size.height - bottomR);
    // Arc down-left to form the bottom-right pill corner
    path.arcToPoint(Offset(size.width - bottomR, size.height), radius: Radius.circular(bottomR));
    // Go left to the bottom-left corner
    path.lineTo(bottomR, size.height);
    // Arc up-left to form the bottom-left pill corner
    path.arcToPoint(Offset(0, size.height - bottomR), radius: Radius.circular(bottomR));
    // Go up to the top-left corner
    path.lineTo(0, topR);
    // Arc up-right to form the top-left corner
    path.arcToPoint(Offset(topR, 0), radius: Radius.circular(topR));
    // Close the path by going straight up
    path.lineTo(topR, -100);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

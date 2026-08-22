import 'package:flutter/material.dart';

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double r = 35.0; // Corner radius
    
    // Start at top-left, just below the rounded corner
    path.moveTo(0, r);
    
    // Top-left rounded corner
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    
    // Expand left, up, right, and down to give plenty of room for the floating button without clipping it
    path.lineTo(-50, 0);
    path.lineTo(-50, -100);
    path.lineTo(size.width + 50, -100);
    path.lineTo(size.width + 50, 0);
    path.lineTo(size.width - r, 0);
    
    // Top-right rounded corner
    path.arcToPoint(Offset(size.width, r), radius: Radius.circular(r));
    
    // Right edge
    path.lineTo(size.width, size.height - r);
    
    // Bottom-right rounded corner
    path.arcToPoint(Offset(size.width - r, size.height), radius: Radius.circular(r));
    
    // Bottom edge
    path.lineTo(r, size.height);
    
    // Bottom-left rounded corner
    path.arcToPoint(Offset(0, size.height - r), radius: Radius.circular(r));
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

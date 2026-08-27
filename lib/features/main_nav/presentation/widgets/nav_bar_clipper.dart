import 'package:flutter/material.dart';

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double topR = 8.0;
    final double bottomR = 32.0;

    path.moveTo(topR, -100);

    path.lineTo(size.width - topR, -100);

    path.lineTo(size.width - topR, 0);

    path.arcToPoint(Offset(size.width, topR), radius: Radius.circular(topR));

    path.lineTo(size.width, size.height - bottomR);

    path.arcToPoint(Offset(size.width - bottomR, size.height), radius: Radius.circular(bottomR));

    path.lineTo(bottomR, size.height);

    path.arcToPoint(Offset(0, size.height - bottomR), radius: Radius.circular(bottomR));

    path.lineTo(0, topR);

    path.arcToPoint(Offset(topR, 0), radius: Radius.circular(topR));

    path.lineTo(topR, -100);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

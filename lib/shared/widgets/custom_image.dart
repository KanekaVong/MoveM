import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'skeletons.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => AppShimmer(
        child: SkeletonBox(width: width, height: height ?? 120, radius: 0),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

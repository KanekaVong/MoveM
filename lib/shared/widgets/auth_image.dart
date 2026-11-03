import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/network/dio_client.dart';
import '../../core/storage/profile_image_store.dart';

/// Loads a protected image through Dio so the bearer token is attached.
class AuthImage extends StatefulWidget {
  const AuthImage({
    super.key,
    required this.url,
    required this.fallback,
    this.fit = BoxFit.cover,
  });

  final String url;
  final Widget fallback;
  final BoxFit fit;

  @override
  State<AuthImage> createState() => _AuthImageState();
}

class _AuthImageState extends State<AuthImage> {
  ImageProvider? _image;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AuthImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) _load();
  }

  Future<void> _load() async {
    final local = ProfileImageStore.localFor(widget.url);
    if (local != null) {
      if (!mounted) return;
      setState(() => _image = FileImage(File(local)));
      return;
    }
    try {
      final response = await DioClient().dio.get<List<int>>(
        widget.url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (!mounted || bytes == null || bytes.isEmpty) return;
      setState(() => _image = MemoryImage(Uint8List.fromList(bytes)));
    } catch (_) {
      if (mounted) setState(() => _image = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    if (image == null) return widget.fallback;
    return Image(image: image, fit: widget.fit, width: double.infinity, height: double.infinity);
  }
}

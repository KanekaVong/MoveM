import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/qr_scan_controller.dart';

class QrScanScreen extends GetView<QrScanController> {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(QrScanController());

    return Scaffold(
      backgroundColor: const Color(0xFF070A13),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isCameraInitialized.value && controller.cameraController != null) {
              return Positioned.fill(
                child: CameraPreview(controller.cameraController!),
              );
            }
            return Positioned.fill(
              child: Container(
                color: const Color(0xFF070A13),
                child: Center(
                  child: Text(
                    controller.scanStatus.value.isNotEmpty
                        ? controller.scanStatus.value
                        : 'Starting Camera...',
                    style: const TextStyle(color: AppColors.taskTextMuted, fontSize: 14),
                  ),
                ),
              ),
            );
          }),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildScannerViewfinder(),
                const Spacer(),
                _buildBottomControls(),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
            child: const Center(
              child: Icon(Icons.chevron_left, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScannerViewfinder() {
    const double boxSize = 250.0;
    const double cornerLength = 46.0;
    const double cornerThickness = 7.0;
    const double cornerRadius = 14.0;
    const Color cornerColor = Color(0xFF3B82F6);

    return Center(
      child: SizedBox(
        width: boxSize,
        height: boxSize,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: _buildCorner(
                cornerLength: cornerLength,
                cornerThickness: cornerThickness,
                radius: cornerRadius,
                isTop: true,
                isLeft: true,
                color: cornerColor,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _buildCorner(
                cornerLength: cornerLength,
                cornerThickness: cornerThickness,
                radius: cornerRadius,
                isTop: true,
                isLeft: false,
                color: cornerColor,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildCorner(
                cornerLength: cornerLength,
                cornerThickness: cornerThickness,
                radius: cornerRadius,
                isTop: false,
                isLeft: true,
                color: cornerColor,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildCorner(
                cornerLength: cornerLength,
                cornerThickness: cornerThickness,
                radius: cornerRadius,
                isTop: false,
                isLeft: false,
                color: cornerColor,
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: _AnimatedScanBar(boxSize: boxSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({
    required double cornerLength,
    required double cornerThickness,
    required double radius,
    required bool isTop,
    required bool isLeft,
    required Color color,
  }) {
    return Container(
      width: cornerLength,
      height: cornerLength,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: color, width: cornerThickness) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: color, width: cornerThickness) : BorderSide.none,
          left: isLeft ? BorderSide(color: color, width: cornerThickness) : BorderSide.none,
          right: !isLeft ? BorderSide(color: color, width: cornerThickness) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? Radius.circular(radius) : Radius.zero,
          topRight: isTop && !isLeft ? Radius.circular(radius) : Radius.zero,
          bottomLeft: !isTop && isLeft ? Radius.circular(radius) : Radius.zero,
          bottomRight: !isTop && !isLeft ? Radius.circular(radius) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => controller.pickImageFromGallery(),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.35),
            ),
            child: const Center(
              child: Icon(Icons.photo_library_outlined, color: Colors.white, size: 30),
            ),
          ),
        ),
        const SizedBox(width: 48),
        Obx(() {
          final isTorchOn = controller.isTorchOn.value;
          return GestureDetector(
            onTap: () => controller.toggleTorch(),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTorchOn ? const Color(0xFF3B82F6).withOpacity(0.35) : Colors.black.withOpacity(0.35),
              ),
              child: Center(
                child: Icon(
                  isTorchOn ? Icons.flash_on : Icons.flash_off,
                  color: isTorchOn ? const Color(0xFFFACC15) : Colors.white,
                  size: 30,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _AnimatedScanBar extends StatefulWidget {
  final double boxSize;

  const _AnimatedScanBar({required this.boxSize});

  @override
  State<_AnimatedScanBar> createState() => _AnimatedScanBarState();
}

class _AnimatedScanBarState extends State<_AnimatedScanBar> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -widget.boxSize / 2 + 20,
      end: widget.boxSize / 2 - 20,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: widget.boxSize - 16,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

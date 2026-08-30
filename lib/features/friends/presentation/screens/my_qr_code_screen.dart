import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/my_qr_code_controller.dart';

class MyQrCodeScreen extends GetView<MyQrCodeController> {
  const MyQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyQrCodeController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF070A13),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const Spacer(),
            _buildQrCard(),
            const Spacer(),
            _buildActionButtons(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.35),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Center(
                child: Icon(Icons.chevron_left, color: Colors.white, size: 26),
              ),
            ),
          ),
          Text(
            l10n?.myQrCode ?? 'My QR Code',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildQrCard() {
    return Obx(() {
      final username = controller.username;
      final profilePic = controller.profilePic;
      final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';

      return Center(
        child: RepaintBoundary(
          key: controller.qrCardKey,
          child: Container(
            color: Colors.transparent,
            child: SizedBox(
              width: 300,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 42),
                    padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QrImageView(
                          data: controller.qrData,
                          version: QrVersions.auto,
                          size: 210.0,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF0B1B3D),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF0B1B3D),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '@${username.toUpperCase()}',
                          style: const TextStyle(
                            color: Color(0xFF0B1B3D),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF070A13),
                        border: Border.all(color: const Color(0xFF070A13), width: 4),
                      ),
                      child: ClipOval(
                        child: (profilePic != null && profilePic.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: profilePic,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => _buildAvatarPlaceholder(initial),
                                errorWidget: (_, __, ___) => _buildAvatarPlaceholder(initial),
                              )
                            : _buildAvatarPlaceholder(initial),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAvatarPlaceholder(String initial) {
    return Container(
      color: AppColors.taskAvatarBg,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final isSaving = controller.isSaving.value;
              return ElevatedButton.icon(
                onPressed: isSaving ? null : () => controller.downloadQr(),
                icon: isSaving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.download, color: Colors.white, size: 20),
                label: Text(
                  isSaving ? 'Saving...' : (l10n?.saveQr ?? 'Save'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.white.withOpacity(0.15)),
                  ),
                  elevation: 0,
                ),
              );
            }),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.shareQr(),
              icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
              label: Text(
                l10n?.shareQr ?? 'Share',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.taskBluePrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

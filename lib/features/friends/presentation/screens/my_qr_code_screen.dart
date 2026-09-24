import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/my_qr_code_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class MyQrCodeScreen extends GetView<MyQrCodeController> {
  const MyQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyQrCodeController());

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(title: AppLocalizations.of(context)?.myQrCode ?? 'My QR Code'),
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
                      color: AppColors.taskFigmaCard,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
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
                            color: AppColors.qrDarkNavy,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: AppColors.qrDarkNavy,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '@${username.toUpperCase()}',
                          style: TextStyle(
                            color: AppColors.qrDarkNavy,
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
                        color: AppColors.pageBackground,
                        border: Border.all(color: AppColors.pageBackground, width: 4),
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
            child: Obx(() => AppButton.secondary(
                  label: l10n?.saveQr ?? 'Save',
                  icon: Icons.download,
                  onPressed: () => controller.downloadQr(),
                  isLoading: controller.isSaving.value,
                )),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AppButton(
              label: l10n?.shareQr ?? 'Share',
              icon: Icons.share_outlined,
              onPressed: () => controller.shareQr(),
            ),
          ),
        ],
      ),
    );
  }
}

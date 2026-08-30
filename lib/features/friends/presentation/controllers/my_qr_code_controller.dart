import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';

class MyQrCodeController extends BaseController {
  final GlobalKey qrCardKey = GlobalKey();
  final Rx<UserResponse?> user = Rx<UserResponse?>(null);
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    user.value = UserManager().getUser();
  }

  String get username => user.value?.username.isNotEmpty == true ? user.value!.username : 'user';

  String get displayName {
    final u = user.value;
    final fullName = [u?.firstName, u?.lastName]
        .where((v) => v != null && v.trim().isNotEmpty)
        .join(' ');
    if (fullName.isNotEmpty) return fullName;
    return username;
  }

  String get userId => user.value?.id.isNotEmpty == true ? user.value!.id : '0';

  String? get profilePic => user.value?.profilePic;

  String get qrData => 'movem://user/$userId';

  Future<void> downloadQr() async {
    try {
      isSaving.value = true;
      final boundary = qrCardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        isSaving.value = false;
        Get.snackbar('Error', 'Unable to capture QR code image');
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        isSaving.value = false;
        Get.snackbar('Error', 'Failed to convert QR code to image');
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          isSaving.value = false;
          Get.snackbar('Permission Denied', 'Please allow photo access to save the QR code');
          return;
        }
      }

      await Gal.putImageBytes(pngBytes, name: 'MoveM_QR_$username');

      isSaving.value = false;
      Get.rawSnackbar(
        message: 'QR code saved',
        backgroundColor: const Color(0xFF48A45B),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      isSaving.value = false;
      Get.snackbar('Error', 'Failed to save QR code to Photos');
    }
  }

  void shareQr() {
    Clipboard.setData(ClipboardData(text: qrData));
    Get.snackbar(
      'Shared',
      'Profile link copied to clipboard: $qrData',
      backgroundColor: const Color(0xFF3B82F6),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}

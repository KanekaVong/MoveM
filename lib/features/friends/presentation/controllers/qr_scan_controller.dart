import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/network/api_result.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/friend_response.dart';
import '../../data/repositories/friends_repository_impl.dart';
import '../../data/services/friends_service.dart';
import '../../domain/repositories/friends_repository.dart';

class QrScanController extends BaseController {
  final FriendsRepository friendsRepository = FriendsRepositoryImpl(friendsService: FriendsService());
  final ImagePicker _picker = ImagePicker();

  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isTorchOn = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString scanStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        scanStatus.value = 'Camera permission required';
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        scanStatus.value = 'No camera found';
        return;
      }

      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      scanStatus.value = 'Unable to initialize camera';
    }
  }

  Future<void> toggleTorch() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;

    try {
      if (isTorchOn.value) {
        await cameraController!.setFlashMode(FlashMode.off);
        isTorchOn.value = false;
      } else {
        await cameraController!.setFlashMode(FlashMode.torch);
        isTorchOn.value = true;
      }
    } catch (_) {}
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        handleQrPayload(image.name.split('.').first);
      }
    } catch (_) {
      Get.snackbar('Error', 'Unable to pick image from gallery');
    }
  }

  Future<void> handleQrPayload(String rawContent) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    final sanitized = rawContent.trim();
    String query = sanitized;

    if (sanitized.contains('movem://user/')) {
      query = sanitized.split('movem://user/').last.split('?').first.trim();
    } else if (sanitized.contains('movem.app/user/')) {
      query = sanitized.split('movem.app/user/').last.split('?').first.trim();
    } else if (sanitized.startsWith('@')) {
      query = sanitized.substring(1).trim();
    }

    if (query.isEmpty) {
      isProcessing.value = false;
      Get.snackbar('Invalid QR', 'No valid user found in QR code');
      return;
    }

    FriendResponse? foundUser;
    final result = await friendsRepository.searchFriends(query);
    if (result is ApiSuccess<List<FriendResponse>> && result.data.isNotEmpty) {
      foundUser = result.data.firstWhere(
        (u) => u.userId.toString() == query || u.username.toLowerCase() == query.toLowerCase(),
        orElse: () => result.data.first,
      );
    }

    final displayName = foundUser != null
        ? '${foundUser.firstname} ${foundUser.lastname}'.trim().isNotEmpty
            ? '${foundUser.firstname} ${foundUser.lastname}'.trim()
            : foundUser.username
        : query;
    final username = foundUser?.username ?? query;
    final profilePic = foundUser?.profilePic;
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF131B2F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF334155),
                ),
                child: ClipOval(
                  child: (profilePic != null && profilePic.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: profilePic,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Center(
                            child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                          errorWidget: (_, __, ___) => Center(
                            child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        )
                      : Center(
                          child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                displayName,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '@$username',
                style: const TextStyle(color: Color(0xFFA0AAB2), fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        isProcessing.value = false;
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF334155)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await _sendFriendRequest(username);
                        isProcessing.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF48A45B),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Add Friend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendFriendRequest(String username) async {
    await executeApi(
      apiCall: () => friendsRepository.sendFriendRequest(username),
      onSuccess: (data) {
        Get.snackbar('Success', 'Friend request sent to @$username', backgroundColor: const Color(0xFF48A45B), colorText: Colors.white);
      },
    );
  }
}

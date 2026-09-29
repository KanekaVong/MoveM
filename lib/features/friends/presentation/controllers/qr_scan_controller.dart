import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zxing2/qrcode.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/repositories/friends_repository_impl.dart';
import '../../data/services/friends_service.dart';
import '../../domain/repositories/friends_repository.dart';
import 'public_user_profile_controller.dart';
import '../screens/public_user_profile_screen.dart';
import 'package:movem/core/utils/app_snack.dart';

class QrScanController extends BaseController {
  final FriendsRepository friendsRepository = FriendsRepositoryImpl(friendsService: FriendsService());
  final ImagePicker _picker = ImagePicker();

  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isTorchOn = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString scanStatus = ''.obs;
  bool _isProcessingFrame = false;
  bool _pauseScanning = false;
  bool _isClosed = false;
  Timer? _liveScanTimer;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    _isClosed = true;
    _pauseScanning = true;
    _stopLiveScan();
    final controller = cameraController;
    cameraController = null;
    isCameraInitialized.value = false;
    unawaited(_disposeCamera(controller));
    super.onClose();
  }

  Future<void> _disposeCamera(CameraController? controller) async {
    var waited = 0;
    while (_isProcessingFrame && waited < 30) {
      await Future.delayed(const Duration(milliseconds: 50));
      waited++;
    }
    if (controller == null) return;
    try {
      await controller.dispose();
    } catch (_) {}
  }

  bool get _canUseCamera {
    final controller = cameraController;
    return !_isClosed &&
        controller != null &&
        controller.value.isInitialized &&
        !controller.value.isTakingPicture;
  }

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (_isClosed) return;
      if (!status.isGranted) {
        scanStatus.value = 'Camera permission required';
        return;
      }

      final cameras = await availableCameras();
      if (_isClosed) return;
      if (cameras.isEmpty) {
        scanStatus.value = 'No camera found';
        return;
      }

      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      cameraController = controller;

      await controller.initialize();
      if (_isClosed) {
        cameraController = null;
        await _disposeCamera(controller);
        return;
      }
      isCameraInitialized.value = true;
      _startLiveScan();
    } catch (_) {
      if (_isClosed) return;
      scanStatus.value = 'Unable to initialize camera';
    }
  }

  void _startLiveScan() {
    if (_isClosed || _pauseScanning) return;
    _liveScanTimer?.cancel();
    _liveScanTimer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (_isClosed || _pauseScanning) return;
      _captureAndDecode();
    });
  }

  void _stopLiveScan() {
    _liveScanTimer?.cancel();
    _liveScanTimer = null;
  }

  Future<void> toggleTorch() async {
    if (!_canUseCamera) return;

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
    if (isProcessing.value || _pauseScanning) {
      return;
    }

    _pauseScanning = true;
    _stopLiveScan();

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final file = File(image.path);
      final exists = await file.exists();
      if (!exists) {
        AppSnack.show('Error', 'Could not open the selected image');
        return;
      }

      final payload = await _decodeQrFromFile(file);
      if (payload == null || payload.isEmpty) {
        AppSnack.show('Invalid QR', 'No valid QR code found in this image');
        return;
      }

      await handleQrPayload(payload);
    } catch (_) {
      AppSnack.show('Error', 'Unable to scan QR from gallery');
    } finally {
      if (!_isClosed && !isProcessing.value) {
        _pauseScanning = false;
        _startLiveScan();
      }
    }
  }

  Future<void> _captureAndDecode() async {
    if (_isClosed || isProcessing.value || _isProcessingFrame || _pauseScanning) return;
    final controller = cameraController;
    if (controller == null || !controller.value.isInitialized || controller.value.isTakingPicture) {
      return;
    }

    _isProcessingFrame = true;
    try {
      if (_isClosed || cameraController != controller) return;
      final shot = await controller.takePicture();
      if (_isClosed) {
        try {
          await File(shot.path).delete();
        } catch (_) {}
        return;
      }
      final payload = await _decodeQrFromFile(File(shot.path));
      try {
        await File(shot.path).delete();
      } catch (_) {}
      if (_isClosed) return;
      if (payload != null && payload.isNotEmpty) {
        await handleQrPayload(payload);
      }
    } catch (e) {
      if (_isClosed) return;
    } finally {
      _isProcessingFrame = false;
    }
  }

  Future<String?> _decodeQrFromFile(File file) async {
    final bytes = await file.readAsBytes();
    return _decodeQrFromBytes(bytes);
  }

  String? _decodeQrFromBytes(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return null;
    }

    var image = decoded;
    const maxSide = 1200;
    if (image.width > maxSide || image.height > maxSide) {
      image = img.copyResize(
        image,
        width: image.width >= image.height ? maxSide : null,
        height: image.height > image.width ? maxSide : null,
      );
    }

    final source = RGBLuminanceSource(
      image.width,
      image.height,
      image.convert(numChannels: 4).getBytes(order: img.ChannelOrder.abgr).buffer.asInt32List(),
    );
    final reader = QRCodeReader();

    try {
      final result = reader.decode(BinaryBitmap(HybridBinarizer(source)));
      return result.text;
    } catch (_) {
      try {
        final inverted = reader.decode(BinaryBitmap(HybridBinarizer(InvertedLuminanceSource(source))));
        return inverted.text;
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> handleQrPayload(String rawContent) async {
    if (_isClosed || isProcessing.value) {
      return;
    }
    isProcessing.value = true;
    _pauseScanning = true;
    _stopLiveScan();

    final userId = _extractUserId(rawContent);
    if (userId == null || userId.isEmpty) {
      isProcessing.value = false;
      if (!_isClosed) {
        _pauseScanning = false;
        _startLiveScan();
      }
      AppSnack.show('Invalid QR', 'No valid user found in QR code');
      return;
    }

    await executeApi(
      apiCall: () => friendsRepository.getUserById(userId),
      onSuccess: (profile) async {
        Get.off(
          () => const PublicUserProfileScreen(),
          binding: BindingsBuilder(() {
            Get.put(PublicUserProfileController(
              repository: friendsRepository,
              userId: profile.id.isNotEmpty ? profile.id : userId,
              initialProfile: profile,
            ));
          }),
        );
        Future.microtask(() {
          if (Get.isRegistered<QrScanController>()) {
            Get.delete<QrScanController>(force: true);
          }
        });
      },
      onError: (e) async {
        isProcessing.value = false;
        if (!_isClosed) {
          _pauseScanning = false;
          _startLiveScan();
        }
      },
    );
  }

  String? _extractUserId(String rawContent) {
    final sanitized = rawContent.trim();
    if (sanitized.isEmpty) return null;

    String query = sanitized;
    if (sanitized.contains('movem://user/')) {
      query = sanitized.split('movem://user/').last.split('?').first.trim();
    } else if (sanitized.contains('movem.app/user/')) {
      query = sanitized.split('movem.app/user/').last.split('?').first.trim();
    } else if (sanitized.contains('/user/')) {
      query = sanitized.split('/user/').last.split('?').first.split('/').first.trim();
    } else if (sanitized.startsWith('@')) {
      query = sanitized.substring(1).trim();
    }

    query = query.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
    return query.isEmpty ? null : query;
  }
}

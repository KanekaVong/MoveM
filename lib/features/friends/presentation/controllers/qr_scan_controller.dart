import 'dart:async';
import 'dart:developer';
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
  Timer? _liveScanTimer;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    _liveScanTimer?.cancel();
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
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
      _startLiveScan();
    } catch (e, stack) {
      log('camera init failed: $e', name: 'QR-SCAN', error: e, stackTrace: stack);
      scanStatus.value = 'Unable to initialize camera';
    }
  }

  void _startLiveScan() {
    _liveScanTimer?.cancel();
    _liveScanTimer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      _captureAndDecode();
    });
  }

  void _stopLiveScan() {
    _liveScanTimer?.cancel();
    _liveScanTimer = null;
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
    log('gallery scan started isProcessing=${isProcessing.value} pause=$_pauseScanning', name: 'QR-SCAN');
    if (isProcessing.value || _pauseScanning) {
      log('gallery scan skipped because already busy', name: 'QR-SCAN');
      return;
    }

    _pauseScanning = true;
    _stopLiveScan();

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        log('gallery pick cancelled', name: 'QR-SCAN');
        return;
      }

      final file = File(image.path);
      final exists = await file.exists();
      final size = exists ? await file.length() : 0;
      log('gallery image path=${image.path} mime=${image.mimeType} exists=$exists bytes=$size', name: 'QR-SCAN');
      if (!exists) {
        Get.snackbar('Error', 'Could not open the selected image');
        return;
      }

      final payload = await _decodeQrFromFile(file, verbose: true);
      if (payload == null || payload.isEmpty) {
        log('gallery image has no QR payload', name: 'QR-SCAN');
        Get.snackbar('Invalid QR', 'No valid QR code found in this image');
        return;
      }

      log('gallery QR payload=$payload', name: 'QR-SCAN');
      await handleQrPayload(payload);
    } catch (e, stack) {
      log('gallery scan failed: $e', name: 'QR-SCAN', error: e, stackTrace: stack);
      Get.snackbar('Error', 'Unable to scan QR from gallery');
    } finally {
      if (!isProcessing.value) {
        _pauseScanning = false;
        _startLiveScan();
        log('live scan resumed after gallery scan', name: 'QR-SCAN');
      }
    }
  }

  Future<void> _captureAndDecode() async {
    if (isProcessing.value || _isProcessingFrame || _pauseScanning) return;
    final controller = cameraController;
    if (controller == null || !controller.value.isInitialized || controller.value.isTakingPicture) {
      return;
    }

    _isProcessingFrame = true;
    try {
      final shot = await controller.takePicture();
      final payload = await _decodeQrFromFile(File(shot.path), verbose: false);
      try {
        await File(shot.path).delete();
      } catch (_) {}
      if (payload != null && payload.isNotEmpty) {
        log('live camera QR payload=$payload', name: 'QR-SCAN');
        await handleQrPayload(payload);
      }
    } catch (e, stack) {
      log('live camera capture decode failed: $e', name: 'QR-SCAN', error: e, stackTrace: stack);
    } finally {
      _isProcessingFrame = false;
    }
  }

  Future<String?> _decodeQrFromFile(File file, {bool verbose = false}) async {
    final bytes = await file.readAsBytes();
    if (verbose) {
      log('decoding QR bytes=${bytes.length}', name: 'QR-SCAN');
    }
    return _decodeQrFromBytes(bytes, verbose: verbose);
  }

  String? _decodeQrFromBytes(Uint8List bytes, {bool verbose = false}) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      if (verbose) log('image decode returned null', name: 'QR-SCAN');
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
      if (verbose) log('zxing decoded text=${result.text}', name: 'QR-SCAN');
      return result.text;
    } catch (e) {
      try {
        final inverted = reader.decode(BinaryBitmap(HybridBinarizer(InvertedLuminanceSource(source))));
        if (verbose) log('zxing inverted decoded text=${inverted.text}', name: 'QR-SCAN');
        return inverted.text;
      } catch (inner) {
        if (verbose) log('zxing decode not found: $e / $inner', name: 'QR-SCAN');
        return null;
      }
    }
  }

  Future<void> handleQrPayload(String rawContent) async {
    log('handleQrPayload raw=$rawContent isProcessing=${isProcessing.value}', name: 'QR-SCAN');
    if (isProcessing.value) {
      log('handleQrPayload skipped already processing', name: 'QR-SCAN');
      return;
    }
    isProcessing.value = true;
    _stopLiveScan();

    final userId = _extractUserId(rawContent);
    log('extracted userId=$userId from raw=$rawContent', name: 'QR-SCAN');
    if (userId == null || userId.isEmpty) {
      isProcessing.value = false;
      _startLiveScan();
      Get.snackbar('Invalid QR', 'No valid user found in QR code');
      return;
    }

    await executeApi(
      apiCall: () => friendsRepository.getUserById(userId),
      onSuccess: (profile) async {
        log('user fetch success id=${profile.id} username=${profile.username}', name: 'QR-SCAN');
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
        log('user fetch failed status=${e.statusCode} message=${e.message}', name: 'QR-SCAN');
        isProcessing.value = false;
        _pauseScanning = false;
        _startLiveScan();
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

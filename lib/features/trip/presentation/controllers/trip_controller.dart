import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../shared/base/base_controller.dart';

class TripController extends BaseController {
  GoogleMapController? mapController;
  final RxBool hasPermission = false.obs;
  final Rx<LatLng> initialPosition = const LatLng(37.422, -122.084).obs;

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      hasPermission.value = true;
      await getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );

      final currentLatLng = LatLng(position.latitude, position.longitude);
      initialPosition.value = currentLatLng;
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 15.0));
    } catch (_) {}
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (hasPermission.value) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(initialPosition.value, 15.0),
      );
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}

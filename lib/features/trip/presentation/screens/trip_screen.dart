import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/trip_controller.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips Map'),
      ),
      body: Obx(() {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: controller.initialPosition.value,
            zoom: 12.0,
          ),
          myLocationEnabled: controller.hasPermission.value,
          myLocationButtonEnabled: controller.hasPermission.value,
          onMapCreated: controller.onMapCreated,
        );
      }),
    );
  }
}

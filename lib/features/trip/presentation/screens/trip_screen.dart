import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/trip_controller.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.tripsMap ?? 'Trips Map',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
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

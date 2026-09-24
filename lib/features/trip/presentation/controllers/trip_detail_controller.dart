import 'package:get/get.dart';

import '../../data/dto/response/trip_response.dart';
import 'trip_controller.dart';

class TripDetailController extends GetxController {
  final TripController tripController;
  final String activityId;

  TripDetailController({
    required this.tripController,
    required this.activityId,
  });

  final Rx<TripResponse?> trip = Rx<TripResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTripDetail();
  }

  Future<void> loadTripDetail() async {
    if (isLoading.value) return;

    isLoading.value = true;
    hasError.value = false;

    final success = await tripController.getTripDetail(
      activityId,
    );

    if (success) {
      trip.value = tripController.selectedTrip;
    } else {
      trip.value = null;
      hasError.value = true;
    }

    isLoading.value = false;
  }

  void goBack() {
    Get.back();
  }
}
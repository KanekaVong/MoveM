import 'package:get/get.dart';

import '../../data/repositories/trip_repository_impl.dart';
import '../../data/services/trip_service.dart';
import '../../domain/repositories/trip_repository.dart';
import '../controllers/create_trip_controller.dart';

class CreateTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripService>(
          () => TripService(),
    );

    Get.lazyPut<TripRepository>(
          () => TripRepositoryImpl(
        tripService: Get.find<TripService>(),
      ),
    );

    Get.lazyPut<CreateTripController>(
          () => CreateTripController(
        tripRepository: Get.find<TripRepository>(),
      ),
    );
  }
}
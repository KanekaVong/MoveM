import 'package:get/get.dart';
import '../../data/services/friends_service.dart';
import '../../data/repositories/friends_repository_impl.dart';
import '../../domain/repositories/friends_repository.dart';
import '../controllers/friends_controller.dart';

class FriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendsService>(() => FriendsService());
    Get.lazyPut<FriendsRepository>(() => FriendsRepositoryImpl(friendsService: Get.find()));
    Get.lazyPut<FriendsController>(() => FriendsController(repository: Get.find()));
  }
}

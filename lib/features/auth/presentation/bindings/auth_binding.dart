import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(authService: Get.find()), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(repository: Get.find()), fenix: true);
  }
}

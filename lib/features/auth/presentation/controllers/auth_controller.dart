import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/dto/response/user_response.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;

  AuthController({required this.repository});

  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);

  Future<void> login(String email, String password) async {
    Get.offAllNamed(AppRoutes.main);
  }

  void logout() {
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/dto/request/login_request.dart';
import '../../data/dto/response/user_response.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;
  final _logger = Logger();

  AuthController({required this.repository});

  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<void> login(String email, String password) async {
    Get.offAllNamed(AppRoutes.main);
    // try {
    //   isLoading.value = true;
    //   final user = await repository.login(
    //       LoginRequest(email: email, password: password)
    //   );
    //
    //   currentUser.value = user;
    //   Get.offAllNamed(AppRoutes.main);
    // } on ApiException catch (e) {
    //   _logger.e("Login failed", error: e);
    // } finally {
    //
    // }
  }

  void logout() {
    repository.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}

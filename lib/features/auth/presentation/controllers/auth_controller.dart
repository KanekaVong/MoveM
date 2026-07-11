import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/request/login_request.dart';
import '../../data/dto/response/user_response.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends BaseController {
  final AuthRepository repository;

  AuthController({required this.repository});

  final Rxn<UserResponse> currentUser = Rxn<UserResponse>();

  Future<void> login(String email, String password) async {
    // await executeApi(
    //   apiCall: () => repository.login(
    //     LoginRequest(email: "emilys", password: "emilyspassi"),
    //   ),
    //   showLoading: true,
    //   showErrorDialog: true,
    //   onSuccess: (data) {
    //     currentUser.value = data;
    //     Get.offAllNamed(AppRoutes.main);
    //   },
    // );
    Get.offAllNamed(AppRoutes.main);
  }

  void logout() {
    repository.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}

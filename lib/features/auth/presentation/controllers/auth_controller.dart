import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/request/login_request.dart';
import '../../data/dto/request/register_request.dart';
import '../../data/dto/request/otp_request.dart';
import '../../data/dto/request/forgot_password_request.dart';
import '../../data/dto/request/reset_password_request.dart';
import '../../data/dto/response/user_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/app_dialogs.dart';

class AuthController extends BaseController {
  final AuthRepository repository;

  AuthController({required this.repository});

  final Rxn<UserResponse> currentUser = Rxn<UserResponse>();

  Future<void> login(String username, String password) async {
    await executeApi(
      apiCall: () => repository.login(
        LoginRequest(username: username, password: password),
      ),
      onSuccess: (data) {
        // Success means user is authenticated and verified. Go to main dashboard.
        Get.offAllNamed(AppRoutes.main);
      },
      showErrorDialog: false,
      onError: (e) {
        // If the backend says the email is unverified (403), skip dialog/toast and go straight to OTP screen.
        if (e.statusCode == 403 && e.message.toLowerCase().contains('verify')) {
          Get.toNamed(AppRoutes.verifyOtp, arguments: username);
        } else {
          // Standard error dialog for other errors (like wrong password)
          AppDialogs.showError(e.message);
        }
      },
    );
  }

  Future<void> verifyOtp(String username, String otp) async {
    await executeApi(
      apiCall: () => repository.verifyOtp(
        OtpRequest(username: username, otp: otp),
      ),
      onSuccess: (data) {
        currentUser.value = data;
        AppDialogs.showSingleActionDialog(
          title: 'Verified',
          message: 'OTP Verified Successfully!',
          onConfirm: () => Get.offAllNamed(AppRoutes.main),
        );
      },
    );
  }

  Future<void> register(String email, String username, String password, String firstname, String lastname) async {
    await executeApi(
      apiCall: () => repository.register(
        RegisterRequest(
          email: email, 
          username: username, 
          passwordHash: password,
          firstname: firstname,
          lastname: lastname,
        ),
      ),
      onSuccess: (data) {
        Get.back(); // Go back to login screen
      },
    );
  }

  void logout() {
    repository.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> forgotPassword(String email) async {
    await executeApi(
      apiCall: () => repository.forgotPassword(
        ForgotPasswordRequest(email: email),
      ),
      onSuccess: (data) {
        AppDialogs.showSingleActionDialog(
          title: 'OTP Sent',
          message: 'An OTP has been sent to $email.',
        );
      },
    );
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    await executeApi(
      apiCall: () => repository.resetPassword(
        ResetPasswordRequest(email: email, otp: otp, newPassword: newPassword),
      ),
      onSuccess: (data) {
        AppDialogs.showSingleActionDialog(
          title: 'Password Reset',
          message: 'Your password has been reset successfully.',
          onConfirm: () {
            Get.back();
            Get.offAllNamed(AppRoutes.login);
          },
        );
      },
    );
  }
}

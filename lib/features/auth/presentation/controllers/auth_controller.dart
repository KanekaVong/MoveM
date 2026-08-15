import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/request/login_request.dart';
import '../../data/dto/request/register_request.dart';
import '../../data/dto/request/otp_request.dart';
import '../../data/dto/request/email_verify_request.dart';
import '../../data/dto/request/forgot_password_request.dart';
import '../../data/dto/request/reset_password_request.dart';
import '../../data/dto/response/user_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/app_dialogs.dart';
import '/../core/storage/user_manager.dart';


class AuthController extends BaseController {
  final AuthRepository repository;

  AuthController({required this.repository});

  final Rxn<UserResponse> currentUser = Rxn<UserResponse>();

  Future<void> login(String username, String password) async {
    final deviceId = await UserManager().getOrCreateDeviceId();
    final savedTrustToken = await UserManager().getTrustToken();

    await executeApi(
      apiCall: () => repository.login(
        LoginRequest(
            username: username,
            password: password,
            deviceId: deviceId,
            trustToken: savedTrustToken,
        ),
      ),
      onSuccess: (data) async {
        if (data.isFullyLoggedIn) {
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
          Get.offAllNamed(AppRoutes.main);
        } else {
          Get.offNamed(AppRoutes.verifyOtp, arguments: {'mode': 'otp', 'identifier': username});
        }
      },
      showErrorDialog: false,
      onError: (e) {
        if (e.statusCode == 403 && e.message.toLowerCase().contains('verify')) {
          Get.offNamed(AppRoutes.verifyOtp, arguments: {'mode': 'email', 'identifier': e.email});
        } else {
          AppDialogs.showError(e.message);
        }
      },
    );
  }

  Future<void> verifyOtp(String username, String otp) async {
    final deviceId = await UserManager().getOrCreateDeviceId();

    await executeApi(
      apiCall: () => repository.verifyOtp(
        OtpRequest(username: username, otp: otp, deviceId: deviceId),
      ),
      onSuccess: (data) async{
        currentUser.value = data;

        if (data.accessToken != null && data.accessToken!.isNotEmpty) {
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
        }

        AppDialogs.showSingleActionDialog(
          title: 'Verified',
          message: 'OTP Verified Successfully!',
          onConfirm: () => Get.offAllNamed(AppRoutes.main),
        );
      },
    );
  }

  Future<void> resendLoginOtp(String username) async {
    await executeApi(
      apiCall: () => repository.resendLoginOtp(username),
      onSuccess: (data) {
        AppDialogs.showSingleActionDialog(
          title: 'Code Sent',
          message: 'A new code has been sent to your email.',
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
        Get.offNamed(AppRoutes.verifyOtp, arguments: {'mode': 'email', 'identifier': email});
      },
    );
  }

  Future<void> verifyEmail(String email, String code) async {
    final deviceId = await UserManager().getOrCreateDeviceId();

    await executeApi(
      apiCall: () => repository.verifyEmail(
        EmailVerifyRequest(email: email, code: code, deviceId: deviceId),
      ),
      onSuccess: (data) async {
        currentUser.value = data;

        if (data.accessToken != null && data.accessToken!.isNotEmpty) {
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
        }

        AppDialogs.showSingleActionDialog(
          title: 'Verified',
          message: 'Email Verified Successfully!',
          onConfirm: () => Get.offAllNamed(AppRoutes.main),
        );
      },
    );
  }

  Future<void> resendVerificationCode(String email) async {
    await executeApi(
      apiCall: () => repository.resendVerification(email),
      onSuccess: (data) {
        AppDialogs.showSingleActionDialog(
          title: 'Code Sent',
          message: 'A new verification code has been sent to your email.',
        );
      },
    );
  }

  void logout() async {
    await repository.logout();
    await UserManager().clearSession();
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
    final deviceId = await UserManager().getOrCreateDeviceId();

    await executeApi(
      apiCall: () => repository.resetPassword(
        ResetPasswordRequest(
          email: email,
          otp: otp,
          newPassword: newPassword,
          deviceId: deviceId,
        ),
      ),
      onSuccess: (data) async {
        if (data.accessToken != null && data.accessToken!.isNotEmpty) {
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
        }

        AppDialogs.showSingleActionDialog(
          title: 'Password Reset',
          message: 'Your password has been reset successfully.',
          onConfirm: () {
            Get.back();
            Get.offAllNamed(AppRoutes.main); // auto-logged in, go straight to home
          },
        );
      },
    );
  }
}

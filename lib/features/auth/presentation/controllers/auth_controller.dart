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
    final trimmedUsername = username.trim();

    await executeApi(
      apiCall: () => repository.login(
        LoginRequest(
          username: trimmedUsername,
          password: password,
          deviceId: deviceId,
          trustToken: savedTrustToken,
        ),
      ),
      onSuccess: (data) async {

        if (data.isFullyLoggedIn) {
          if (data.user != null) {
            currentUser.value = data.user;
            await UserManager().saveUser(data.user!);
          }

          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
          await UserManager().setLogged(true);

          Get.offAllNamed(AppRoutes.main);
          return;
        }

        if (data.message != null &&
            data.message!.toLowerCase().contains('otp')) {
          Get.offNamed(
            AppRoutes.verifyOtp,
            arguments: {
              'mode': 'otp',
              'identifier': trimmedUsername,
            },
          );
          return;
        }

        AppDialogs.showError(
          data.message ?? 'Unexpected login response from server.',
        );
      },
      showErrorDialog: false,
      onError: (e) {
        if (e.statusCode == 403 &&
            e.message.toLowerCase().contains('verify')) {
          Get.offNamed(
            AppRoutes.verifyOtp,
            arguments: {
              'mode': 'email',
              'identifier': e.email ?? trimmedUsername,
            },
          );
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
        OtpRequest(username: username.trim(), otp: otp.trim(), deviceId: deviceId),
      ),
      onSuccess: (data) async {
        currentUser.value = data.user;
        if (data.user != null) {
          await UserManager().saveUser(data.user!);
        }

        if (data.accessToken != null && data.accessToken!.isNotEmpty) {
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
          await UserManager().setLogged(true);
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
      apiCall: () => repository.resendLoginOtp(username.trim()),
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
          email: email.trim(),
          username: username.trim(),
          passwordHash: password,
          firstname: firstname.trim(),
          lastname: lastname.trim(),
        ),
      ),
      onSuccess: (data) {
        Get.offNamed(AppRoutes.verifyOtp, arguments: {'mode': 'email', 'identifier': email.trim()});
      },
    );
  }

  Future<void> verifyEmail(String email, String code) async {
    final deviceId = await UserManager().getOrCreateDeviceId();

    await executeApi(
      apiCall: () => repository.verifyEmail(
        EmailVerifyRequest(email: email.trim(), code: code.trim(), deviceId: deviceId),
      ),
      onSuccess: (data) async {
        currentUser.value = data.user;
        if (data.user != null) {
          await UserManager().saveUser(data.user!);
        }

        if (data.accessToken != null && data.accessToken!.isNotEmpty) {
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
          await UserManager().setLogged(true);
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
        currentUser.value = data.user;
        if (data.user != null) {
          await UserManager().saveUser(data.user!);
        }

        if (data.accessToken != null && data.accessToken!.isNotEmpty) {
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
          await UserManager().setLogged(true);
        }

        AppDialogs.showSingleActionDialog(
          title: 'Password Reset',
          message: 'Your password has been reset successfully.',
          onConfirm: () {
            Get.back();
            Get.offAllNamed(AppRoutes.main);
          },
        );
      },
    );
  }
}

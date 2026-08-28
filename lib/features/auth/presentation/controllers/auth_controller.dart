
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
import 'package:movem/features/settings/presentation/screens/add_account_verify_otp_screen.dart';

import '../../../../core/utils/app_dialogs.dart';
import '/../core/storage/user_manager.dart';
import '../../../../core/storage/saved_account.dart';
import '../bindings/auth_binding.dart';

class AuthController extends BaseController {
  final AuthRepository repository;

  AuthController({required this.repository});

  final Rxn<UserResponse> currentUser = Rxn<UserResponse>();

  Future<void> login(String username, String password, {bool isAddingAccount = false,}) async {
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
        // Full login: accessToken + trustToken + user
        if (data.isFullyLoggedIn) {
          if (data.user == null ||
              data.accessToken == null ||
              data.trustToken == null) {
            AppDialogs.showError(
              'Invalid login response from server.',
            );
            return;
          }

          //duplicate-account ADD check
          if (isAddingAccount) {
            final alreadySaved = await UserManager().isAccountSaved(
              data.user!.id,
            );

            if (alreadySaved) {
              AppDialogs.showError(
                'This account is already added to this device.',
              );
              return;
            }
          }

          await UserManager().saveUser(data.user!);
          await UserManager().saveToken(data.accessToken!);
          await UserManager().saveTrustToken(data.trustToken!);
          await UserManager().setLogged(true);

          await UserManager().saveUserId(
            data.user!.id.toString(),
          );

          await UserManager().saveUserName(
            data.user!.username,
          );

          // Save the newly added account.
          if (isAddingAccount) {
            await UserManager().saveAccount(
              SavedAccount(
                accessToken: data.accessToken!,
                trustToken: data.trustToken!,
                user: data.user!,
              ),
            );
          }

          Get.offAllNamed(AppRoutes.main);
          return;
        }

        // Login OTP required
        if (data.message != null &&
            data.message!.toLowerCase().contains('otp')) {
          if (isAddingAccount) {
            Get.to(
                  () => const AddAccountVerifyOtpScreen(),
              binding: AuthBinding(),
              arguments: {
                'mode': 'otp',
                'identifier': username,
                'isAddingAccount': true,
              },
            );
          } else {
            Get.offNamed(
              AppRoutes.verifyOtp,
              arguments: {
                'mode': 'otp',
                'identifier': username,
                'isAddingAccount': false,
              },
            );
          }
          return;
        }

        // Unexpected successful response
        AppDialogs.showError(
          data.message ?? 'Unexpected login response from server.',
        );
      },
      showErrorDialog: false,
      onError: (e) {
        if (e.statusCode == 403 &&
            e.message.toLowerCase().contains('verify')) {
          if (isAddingAccount) {
            Get.to(
                  () => const AddAccountVerifyOtpScreen(),
              binding: AuthBinding(),
              arguments: {
                'mode': 'email',
                'identifier': e.email,
                'isAddingAccount': true,
              },
            );
          } else {
            Get.offNamed(
              AppRoutes.verifyOtp,
              arguments: {
                'mode': 'email',
                'identifier': e.email,
                'isAddingAccount': false,
              },
            );
          }
        } else {
          AppDialogs.showError(e.message);
        }
      },
    );
  }

  Future<void> verifyOtp(String username, String otp, {bool isAddingAccount = false,}) async {

    final deviceId = await UserManager().getOrCreateDeviceId();

    await executeApi(
      apiCall: () => repository.verifyOtp(
        OtpRequest(username: username, otp: otp, deviceId: deviceId),
      ),
      onSuccess: (data) async {
        currentUser.value = data.user;

        if (data.user == null || data.accessToken == null || data.trustToken == null) {
          AppDialogs.showError(
            'Invalid OTP verification response from server.',
          );
          return;
        }

        //duplicate-account ADD check
        if (isAddingAccount) {
          final alreadySaved = await UserManager().isAccountSaved(
            data.user!.id,
          );

          if (alreadySaved) {
            AppDialogs.showError(
              'This account is already added to this device.',
            );
            return;
          }
        }

        // Save the newly verified account as the active account.
        await UserManager().saveUser(data.user!);
        await UserManager().saveToken(data.accessToken!);
        await UserManager().saveTrustToken(data.trustToken!);
        await UserManager().setLogged(true);
        await UserManager().saveUserId(data.user!.id.toString(),);
        await UserManager().saveUserName(data.user!.username,);

        // If this is Add Account, save the newly authenticated
        // account into the saved-account list.
        if (isAddingAccount) {
          await UserManager().saveAccount(
            SavedAccount(
              accessToken: data.accessToken!,
              trustToken: data.trustToken!,
              user: data.user!,
            ),
          );
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

  Future<void> register(
      String email,
      String username,
      String password,
      String firstname,
      String lastname, {
        bool isAddingAccount = false,
      }) async {
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
        if (isAddingAccount) {
          Get.to(
                () => const AddAccountVerifyOtpScreen(),
            binding: AuthBinding(),
            arguments: {
              'mode': 'email',
              'identifier': email,
              'isAddingAccount': true,
            },
          );
        } else {
          Get.offNamed(
            AppRoutes.verifyOtp,
            arguments: {
              'mode': 'email',
              'identifier': email,
              'isAddingAccount': false,
            },
          );
        }
      },
    );
  }

  Future<void> verifyEmail(String email, String code, {bool isAddingAccount = false,}) async {
    final deviceId = await UserManager().getOrCreateDeviceId();

    await executeApi(
      apiCall: () => repository.verifyEmail(
        EmailVerifyRequest(email: email, code: code, deviceId: deviceId),
      ),
      onSuccess: (data) async {
        currentUser.value = data.user;

        if (data.user == null ||
            data.accessToken == null ||
            data.trustToken == null) {
          AppDialogs.showError(
            'Invalid email verification response from server.',
          );
          return;
        }

        //duplicate-account ADD check
        if (isAddingAccount) {
          final alreadySaved = await UserManager().isAccountSaved(
            data.user!.id,
          );

          if (alreadySaved) {
            AppDialogs.showError(
              'This account is already added to this device.',
            );
            return;
          }
        }

        // Make the verified account the active account.
        await UserManager().saveUser(data.user!);
        await UserManager().saveToken(data.accessToken!);
        await UserManager().saveTrustToken(data.trustToken!);
        await UserManager().setLogged(true);

        await UserManager().saveUserId(
          data.user!.id.toString(),
        );

        await UserManager().saveUserName(
          data.user!.username,
        );

        // When registration comes from Add Account,
        // also store the new account in saved_accounts.
        if (isAddingAccount) {
          await UserManager().saveAccount(
            SavedAccount(
              accessToken: data.accessToken!,
              trustToken: data.trustToken!,
              user: data.user!,
            ),
          );
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
            Get.offAllNamed(AppRoutes.main); // auto-logged in, go straight to home
          },
        );
      },
    );
  }
}

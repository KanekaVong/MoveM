import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../../core/storage/user_manager.dart';

import '../../data/dto/request/update_profile_picture_request.dart';
import '../../data/dto/request/change_password_request.dart';
import '../../data/dto/request/update_profile_request.dart';
import '../../domain/repositories/setting_repository.dart';
import '../../../auth/data/dto/response/user_response.dart';

import 'package:movem/features/auth/data/dto/response/auth_response.dart';
import 'package:movem/core/storage/user_manager.dart';

class SettingController extends BaseController {
  final SettingRepository repository;

  SettingController({required this.repository});

  Future<UserResponse?> updateProfile(
      UpdateProfileRequest request, {
        bool goBack = true,
      }) async {
    UserResponse? updatedUser;

    await executeApi(
      apiCall: () => repository.updateProfile(request),
      onSuccess: (data) async {
        updatedUser = data;

        await UserManager().saveUser(data);

        if (goBack) {
          Get.back();
        }
      },
    );

    return updatedUser;
  }

  Future<UserResponse?> updateProfilePicture(
      UpdateProfilePictureRequest request,
      ) async {
    UserResponse? updatedUser;

    await executeApi(
      apiCall: () => repository.updateProfilePicture(request),
      onSuccess: (data) async {
        updatedUser = data;
        await UserManager().saveUser(data);
      },
    );

    return updatedUser;
  }

  Future<UserResponse?> unlinkPhone() async {
    UserResponse? updatedUser;

    await executeApi(
      apiCall: () => repository.unlinkPhone(),
      onSuccess: (data) async {
        updatedUser = data;
        await UserManager().saveUser(data);
      },
    );

    return updatedUser;
  }

  Future<bool> requestEmailChange(String email) async {
    bool success = false;

    await executeApi(
      apiCall: () => repository.requestEmailChange(email),
      onSuccess: (message) {
        success = true;
      },
    );

    return success;
  }

  Future<UserResponse?> verifyEmailChange(String code) async {
    UserResponse? updatedUser;

    await executeApi(
      apiCall: () => repository.verifyEmailChange(code),
      onSuccess: (data) async {
        updatedUser = data;
        await UserManager().saveUser(data);
      },
    );

    return updatedUser;
  }

  Future<bool> resendEmailChangeCode() async {
    bool success = false;

    await executeApi(
      apiCall: () => repository.resendEmailChangeCode(),
      onSuccess: (message) {
        success = true;
      },
    );

    return success;
  }

  Future<UserResponse?> verifyPhone(
      String firebaseIdToken,
      ) async {
    UserResponse? updatedUser;

    await executeApi(
      apiCall: () => repository.verifyPhone(firebaseIdToken),
      onSuccess: (user) {
        updatedUser = user;
      },
    );

    if (updatedUser != null) {
      await UserManager().saveUser(updatedUser!);
    }

    return updatedUser;
  }

  Future<AuthResponse?> changePassword(
      ChangePasswordRequest request,
      ) async {
    AuthResponse? authResponse;

    await executeApi(
      apiCall: () => repository.changePassword(request),
      onSuccess: (data) async {
        authResponse = data;

        if (data.accessToken != null &&
            data.accessToken!.isNotEmpty) {
          await UserManager().saveToken(
            data.accessToken!,
          );
        }

        if (data.trustToken != null &&
            data.trustToken!.isNotEmpty) {
          await UserManager().saveTrustToken(
            data.trustToken!,
          );
        }

        if (data.user != null) {
          await UserManager().saveUser(
            data.user!,
          );
        }
      },
    );

    return authResponse;
  }


}
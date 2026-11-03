import 'package:get/get.dart';
import '../../../../core/storage/profile_image_store.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../../core/storage/user_manager.dart';

import '../../data/dto/request/update_profile_picture_request.dart';
import '../../data/dto/request/change_password_request.dart';
import '../../data/dto/request/update_profile_request.dart';
import '../../domain/repositories/setting_repository.dart';
import '../../../auth/data/dto/response/user_response.dart';

import 'package:movem/features/auth/data/dto/response/auth_response.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import 'settings_controller.dart';
import 'profile_controller.dart';

class SettingController extends BaseController {
  final SettingRepository repository;

  SettingController({required this.repository});

  Future<void> _notifyUserUpdated(UserResponse data) async {
    await UserManager().saveUser(data);

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().currentUser.value = data;
    }
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().currentUser.value = data;
    }
    if (Get.isRegistered<SettingsController>()) {
      Get.find<SettingsController>().user.value = data;
    }
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().user.value = data;
    }
  }

  Future<UserResponse?> updateProfile(
      UpdateProfileRequest request, {
        bool goBack = true,
        bool showLoading = true,
        bool showErrorDialog = true,
      }) async {
    UserResponse? updatedUser;

    await executeApi(
      showLoading: showLoading,
      showErrorDialog: showErrorDialog,
      apiCall: () => repository.updateProfile(request),
      onSuccess: (data) async {
        updatedUser = data;

        await _notifyUserUpdated(data);

        if (goBack) {
          Get.back();
        }
      },
    );

    return updatedUser;
  }

  /// Uploads [filePath] with POST /api/user/me/profile-picture.
  /// The response is the updated user, so no second profile update is sent.
  Future<UserResponse?> uploadAndSaveProfilePicture(
    String filePath, {
    bool showLoading = true,
  }) async {
    UserResponse? updatedUser;

    await executeApi(
      showLoading: showLoading,
      showErrorDialog: showLoading,
      apiCall: () => repository.uploadProfilePictureFile(filePath),
      onSuccess: (data) async {
        updatedUser = data;
        final pic = data.profilePic;
        if (pic != null && pic.isNotEmpty) {
          await ProfileImageStore.remember(pic, filePath);
        }
        await _notifyUserUpdated(data);
      },
    );

    return updatedUser;
  }

  Future<UserResponse?> updateProfilePicture(
      UpdateProfilePictureRequest request, {
        bool showLoading = true,
        bool showErrorDialog = true,
      }) async {
    UserResponse? updatedUser;

    await executeApi(
      showLoading: showLoading,
      showErrorDialog: showErrorDialog,
      apiCall: () => repository.updateProfilePicture(request),
      onSuccess: (data) async {
        updatedUser = data;
        await _notifyUserUpdated(data);
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
        await _notifyUserUpdated(data);
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
        await _notifyUserUpdated(data);
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
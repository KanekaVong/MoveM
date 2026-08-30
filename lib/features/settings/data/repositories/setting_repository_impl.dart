import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/setting_repository.dart';

import '../dto/request/update_profile_picture_request.dart';
import '../dto/request/change_password_request.dart';
import '../dto/request/update_profile_request.dart';
import '../services/setting_service.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../../auth/data/dto/response/auth_response.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingService settingService;

  SettingRepositoryImpl({required this.settingService});

  UserResponse? _parseUserResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return UserResponse.fromJson(data);
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          return UserResponse.fromJson(decoded);
        }
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<ApiResult<UserResponse>> updateProfile(
      UpdateProfileRequest request,
      ) async {
    try {
      final response = await settingService.updateProfile(request);

      final user = _parseUserResponse(response.data);

      if (user != null) {
        return ApiSuccess(user);
      }

      return ApiError(
        ApiException(
          message: 'Invalid update profile response from server.',
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<UserResponse>> updateProfilePicture(
      UpdateProfilePictureRequest request,
      ) async {
    try {
      final response =
      await settingService.updateProfilePicture(request);

      final user = _parseUserResponse(response.data);

      if (user != null) {
        return ApiSuccess(user);
      }

      return ApiError(
        ApiException(
          message:
          'Invalid profile picture response from server.',
        ),
      );
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<UserResponse>> unlinkPhone() async {
    try {
      final response = await settingService.unlinkPhone();

      final user = _parseUserResponse(response.data);

      if (user != null) {
        return ApiSuccess(user);
      }

      return ApiError(
        ApiException(
          message: 'Invalid unlink phone response from server.',
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<String>> requestEmailChange(String email) async {
    try {
      final response = await settingService.requestEmailChange(email);

      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'];

        if (message is String) {
          return ApiSuccess(message);
        }
      }

      return ApiError(
        ApiException(
          message: 'Invalid email change response from server.',
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<UserResponse>> verifyEmailChange(String code) async {
    try {
      final response = await settingService.verifyEmailChange(code);

      final user = _parseUserResponse(response.data);

      if (user != null) {
        return ApiSuccess(user);
      }

      return ApiError(
        ApiException(
          message: 'Invalid email verification response from server.',
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> resendEmailChangeCode() async {
    try {
      final response = await settingService.resendEmailChangeCode();

      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'];

        if (message is String) {
          return ApiSuccess(message);
        }
      }

      return ApiError(
        ApiException(
          message: 'Invalid resend code response from server.',
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<UserResponse>> verifyPhone(
      String firebaseIdToken,
      ) async {
    try {
      final response = await settingService.verifyPhone(
        firebaseIdToken,
      );

      final user = UserResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      return ApiSuccess(user);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<AuthResponse>> changePassword(
      ChangePasswordRequest request,
      ) async {
    try {
      final response =
      await settingService.changePassword(request);

      final authResponse =
      AuthResponse.fromJson(response.data);

      return ApiSuccess(authResponse);
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<UserResponse>> getCurrentUser() async {
    try {
      final response = await settingService.getCurrentUser();
      final user = _parseUserResponse(response.data);
      if (user != null) return ApiSuccess(user);
      return ApiError(ApiException(message: 'Invalid get current user response from server.'));
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(ApiException(message: e.toString()));
    }
  }


}
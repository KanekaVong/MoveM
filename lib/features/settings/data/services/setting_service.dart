import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

import '../dto/request/change_password_request.dart';
import '../dto/request/update_profile_request.dart';
import '../dto/request/update_profile_picture_request.dart';

class SettingService {
  final Dio _dio = DioClient().dio;

  Future<Response> updateProfile(UpdateProfileRequest request) {
    return _dio.patch('user/me', data: request.toJson());
  }

  Future<Response> unlinkPhone() {
    return _dio.patch('users/me/unlink-phone');
  }

  Future<Response> getCurrentUser() {
    return _dio.get('users/me');
  }

  Future<Response> updateProfilePicture(
      UpdateProfilePictureRequest request,
      ) {
    return _dio.patch(
      'users/me/profile-picture',
      data: request.toJson(),
    );
  }

  /// POST /api/user/me/profile-picture with multipart field `file`.
  /// The response is the updated user, including `profilePic`.
  Future<Response> uploadProfilePictureFile(String filePath) async {
    final fileName = filePath.split('/').last;
    return _dio.post(
      'user/me/profile-picture',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      }),
    );
  }

  Future<Response> requestEmailChange(String email) {
    return _dio.post('users/me/change-email',
      data: {
        'email': email,
      },
    );
  }

  Future<Response> verifyEmailChange(String code) {
    return _dio.post('users/me/verify-email-change',
      data: {
        'code': code,
      },
    );
  }

  Future<Response> resendEmailChangeCode() {
    return _dio.post('users/me/resend-email-change');
  }

  Future<Response> changePassword(
      ChangePasswordRequest request,
      ) {
    return _dio.patch(
      'users/me/change-password',
      data: request.toJson(),
    );
  }


}
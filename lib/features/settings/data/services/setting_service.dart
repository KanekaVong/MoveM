import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

import '../dto/request/change_password_request.dart';
import '../dto/request/update_profile_request.dart';
import '../dto/request/update_profile_picture_request.dart';

class SettingService {
  final Dio _dio = DioClient().dio;

  Future<Response> updateProfile(UpdateProfileRequest request) {
    return _dio.patch('users/me', data: request.toJson());
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

  /// Uploads the file and returns the URL the server sends back.
  Future<String?> uploadProfilePicFile(String filePath) async {
    final fileName = filePath.split('/').last;
    final response = await _dio.post(
      'uploads/profile-pic',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      }),
    );
    final data = response.data;
    if (data is String && data.trim().isNotEmpty) return data.trim();
    if (data is Map) {
      final url = data['url'] ?? data['profilePic'] ?? data['filePath'];
      if (url != null && url.toString().trim().isNotEmpty) return url.toString().trim();
    }
    return null;
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

  Future<Response> verifyPhone(String firebaseIdToken) {
    return _dio.post(
      'users/me/verify-phone',
      data: {
        'firebaseIdToken': firebaseIdToken,
      },
    );
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
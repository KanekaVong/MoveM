import '../../../../core/network/api_result.dart';

import '../../data/dto/request/update_profile_picture_request.dart';
import '../../data/dto/request/change_password_request.dart';
import '../../data/dto/request/update_profile_request.dart';
import '../../../auth/data/dto/response/user_response.dart';
import 'package:movem/features/auth/data/dto/response/auth_response.dart';

abstract class SettingRepository {
  Future<ApiResult<UserResponse>> updateProfile(UpdateProfileRequest request);
  Future<ApiResult<UserResponse>> updateProfilePicture(UpdateProfilePictureRequest request,);
  Future<ApiResult<UserResponse>> unlinkPhone();
  Future<ApiResult<UserResponse>> getCurrentUser();
  Future<ApiResult<String>> requestEmailChange(String email);
  Future<ApiResult<UserResponse>> verifyEmailChange(String code);
  Future<ApiResult<String>> resendEmailChangeCode();
  Future<ApiResult<UserResponse>> verifyPhone(String firebaseIdToken,);
  Future<ApiResult<AuthResponse>> changePassword(ChangePasswordRequest request,);
}
import 'user_response.dart';

class AuthResponse {
  final String? accessToken;
  final String? trustToken;
  final UserResponse? user;
  final String? message;

  AuthResponse({
    this.accessToken,
    this.trustToken,
    this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken']?.toString(),
      trustToken: json['trustToken']?.toString(),
      user: json['user'] != null && json['user'] is Map
          ? UserResponse.fromJson(Map<String, dynamic>.from(json['user']))
          : null,
      message: json['message']?.toString(),
    );
  }

  bool get isFullyLoggedIn =>
      accessToken != null &&
      accessToken!.isNotEmpty &&
      trustToken != null &&
      trustToken!.isNotEmpty;
}

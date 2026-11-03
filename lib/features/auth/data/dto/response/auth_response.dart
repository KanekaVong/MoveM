import 'user_response.dart';

class AuthResponse {
  final String? accessToken;
  final String? trustToken;
  final UserResponse? user;
  final String? message;

  /// Where the login OTP was sent, when the server says so.
  final String? email;

  AuthResponse({
    this.accessToken,
    this.trustToken,
    this.user,
    this.message,
    this.email,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'] != null && json['user'] is Map
        ? UserResponse.fromJson(Map<String, dynamic>.from(json['user']))
        : null;
    final rawEmail = json['email']?.toString() ?? '';
    final email = rawEmail.isNotEmpty ? rawEmail : user?.email;
    return AuthResponse(
      accessToken: json['accessToken']?.toString(),
      trustToken: json['trustToken']?.toString(),
      user: user,
      message: json['message']?.toString(),
      email: email == null || email.isEmpty ? null : email,
    );
  }

  bool get isFullyLoggedIn =>
      accessToken != null &&
      accessToken!.isNotEmpty &&
      trustToken != null &&
      trustToken!.isNotEmpty;
}

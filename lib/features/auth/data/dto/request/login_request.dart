class LoginRequest {
  final String username;
  final String password;
  final String deviceId;
  final String? trustToken;

  LoginRequest({
    required this.username,
    required this.password,
    required this.deviceId,
    this.trustToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'deviceId': deviceId,
      'trustToken': trustToken,
    };
  }
}

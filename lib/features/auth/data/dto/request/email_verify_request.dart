class EmailVerifyRequest {
  final String email;
  final String code;
  final String deviceId;

  EmailVerifyRequest({
    required this.email,
    required this.code,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
      'deviceId': deviceId,
    };
  }
}
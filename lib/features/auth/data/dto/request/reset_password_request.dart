class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;
  final String deviceId;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
        'deviceId': deviceId,
      };
}

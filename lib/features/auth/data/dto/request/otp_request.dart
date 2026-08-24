class OtpRequest {
  final String username;
  final String otp;
  final String deviceId;

  OtpRequest({
    required this.username,
    required this.otp,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'otp': otp,
      'deviceId': deviceId,
    };
  }
}

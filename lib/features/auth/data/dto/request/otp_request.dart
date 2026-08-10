class OtpRequest {
  final String username;
  final String otp;

  OtpRequest({
    required this.username,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'otp': otp,
    };
  }
}

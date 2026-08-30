class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String deviceId;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'deviceId': deviceId,
    };
  }
}
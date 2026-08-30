class UpdateProfilePictureRequest {
  final String? profilePic;

  UpdateProfilePictureRequest({
    this.profilePic,
  });

  Map<String, dynamic> toJson() {
    return {
      'profilePic': profilePic,
    };
  }
}
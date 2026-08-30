class UpdateProfileRequest {
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? bio;
  final String? gender;
  final String? dateOfBirth;
  final String? cityProvince;

  UpdateProfileRequest({
    this.firstname,
    this.lastname,
    this.username,
    this.bio,
    this.gender,
    this.dateOfBirth,
    this.cityProvince,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (firstname != null) json['firstname'] = firstname;
    if (lastname != null) json['lastname'] = lastname;
    if (username != null) json['username'] = username;
    if (bio != null) json['bio'] = bio;
    if (gender != null) json['gender'] = gender;
    if (dateOfBirth != null) json['dateOfBirth'] = dateOfBirth;
    if (cityProvince != null) json['cityProvince'] = cityProvince;
    return json;
  }
}
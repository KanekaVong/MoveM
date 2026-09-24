class FitnessClubModel {
  final int id;
  final String name;
  final String description;
  final int createdBy;
  final String privacy; // 'PUBLIC' or 'PRIVATE'
  final String joinToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int memberCount;
  final bool isMember;
  final String? userRole; // 'OWNER', 'ADMIN', 'MEMBER' or null

  FitnessClubModel({
    required this.id,
    required this.name,
    required this.description,
    this.createdBy = 0,
    this.privacy = 'PUBLIC',
    this.joinToken = '',
    this.createdAt,
    this.updatedAt,
    this.memberCount = 1,
    this.isMember = false,
    this.userRole,
  });

  bool get isPrivate => privacy.toUpperCase() == 'PRIVATE';
  bool get isOwner => userRole?.toUpperCase() == 'OWNER';
  bool get canCreateChallenges =>
      isMember || isOwner || (userRole != null && userRole!.isNotEmpty);

  factory FitnessClubModel.fromJson(Map<String, dynamic> json) {
    final role = json['userRole']?.toString() ?? json['role']?.toString();
    final member = json['isMember'] == true ||
        json['joined'] == true ||
        json['isJoined'] == true ||
        (role != null && role.isNotEmpty);
    return FitnessClubModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdBy: (json['createdBy'] as num?)?.toInt() ?? 0,
      privacy: json['privacy']?.toString() ?? 'PUBLIC',
      joinToken: json['joinToken']?.toString() ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 1,
      isMember: member,
      userRole: role,
    );
  }

  FitnessClubModel copyWith({
    bool? isMember,
    String? userRole,
  }) {
    return FitnessClubModel(
      id: id,
      name: name,
      description: description,
      createdBy: createdBy,
      privacy: privacy,
      joinToken: joinToken,
      createdAt: createdAt,
      updatedAt: updatedAt,
      memberCount: memberCount,
      isMember: isMember ?? this.isMember,
      userRole: userRole ?? this.userRole,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'privacy': privacy,
      'joinToken': joinToken,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'memberCount': memberCount,
      'isMember': isMember,
      'userRole': userRole,
    };
  }
}

class CreateFitnessClubRequest {
  final String name;
  final String description;
  final String privacy;

  CreateFitnessClubRequest({
    required this.name,
    required this.description,
    this.privacy = 'PUBLIC',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'privacy': privacy,
    };
  }
}

class FitnessClubMemberModel {
  final int clubId;
  final int userId;
  final String role; // 'OWNER', 'ADMIN', 'MEMBER'
  final DateTime? joinedAt;
  final String? userName;
  final String? avatarUrl;

  FitnessClubMemberModel({
    required this.clubId,
    required this.userId,
    required this.role,
    this.joinedAt,
    this.userName,
    this.avatarUrl,
  });

  factory FitnessClubMemberModel.fromJson(Map<String, dynamic> json) {
    final first = json['firstname']?.toString() ?? json['firstName']?.toString() ?? '';
    final last = json['lastname']?.toString() ?? json['lastName']?.toString() ?? '';
    final username = json['username']?.toString() ?? json['userName']?.toString() ?? json['name']?.toString() ?? '';
    final fullName = '$first $last'.trim();
    return FitnessClubMemberModel(
      clubId: (json['clubId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      role: json['role']?.toString() ?? 'MEMBER',
      joinedAt: json['joinedAt'] != null ? DateTime.tryParse(json['joinedAt'].toString()) : null,
      userName: fullName.isNotEmpty
          ? fullName
          : (username.isNotEmpty ? username : 'Member #${json['userId'] ?? ''}'),
      avatarUrl: json['avatarUrl']?.toString() ?? json['profilePic']?.toString(),
    );
  }

  FitnessClubMemberModel copyWith({String? userName, String? avatarUrl}) {
    return FitnessClubMemberModel(
      clubId: clubId,
      userId: userId,
      role: role,
      joinedAt: joinedAt,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clubId': clubId,
      'userId': userId,
      'role': role,
      'joinedAt': joinedAt?.toIso8601String(),
      'userName': userName,
      'avatarUrl': avatarUrl,
    };
  }
}

class ClubJoinRequestModel {
  final int id;
  final int clubId;
  final int requesterId;
  final String status; // 'PENDING', 'APPROVED', 'REJECTED', 'CANCELLED'
  final DateTime? requestedAt;
  final DateTime? respondedAt;
  final String? requesterName;
  final String? clubName;

  ClubJoinRequestModel({
    required this.id,
    required this.clubId,
    required this.requesterId,
    required this.status,
    this.requestedAt,
    this.respondedAt,
    this.requesterName,
    this.clubName,
  });

  factory ClubJoinRequestModel.fromJson(Map<String, dynamic> json) {
    final first = json['firstname']?.toString() ?? json['firstName']?.toString() ?? '';
    final last = json['lastname']?.toString() ?? json['lastName']?.toString() ?? '';
    final full = '$first $last'.trim();
    return ClubJoinRequestModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      clubId: (json['clubId'] as num?)?.toInt() ?? 0,
      requesterId: (json['requesterId'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'PENDING',
      requestedAt: json['requestedAt'] != null ? DateTime.tryParse(json['requestedAt'].toString()) : null,
      respondedAt: json['respondedAt'] != null ? DateTime.tryParse(json['respondedAt'].toString()) : null,
      requesterName: json['requesterName']?.toString() ??
          json['requesterUsername']?.toString() ??
          json['username']?.toString() ??
          (full.isNotEmpty ? full : null) ??
          'User #${json['requesterId'] ?? ''}',
      clubName: json['clubName']?.toString() ?? json['name']?.toString(),
    );
  }

  ClubJoinRequestModel copyWith({String? requesterName, String? clubName}) {
    return ClubJoinRequestModel(
      id: id,
      clubId: clubId,
      requesterId: requesterId,
      status: status,
      requestedAt: requestedAt,
      respondedAt: respondedAt,
      requesterName: requesterName ?? this.requesterName,
      clubName: clubName ?? this.clubName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clubId': clubId,
      'requesterId': requesterId,
      'status': status,
      'requestedAt': requestedAt?.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'requesterName': requesterName,
      'clubName': clubName,
    };
  }
}

class GroupChallengeCatalogModel {
  final int id;
  final String name;
  final String workoutType;
  final double targetValue;
  final String targetUnit;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GroupChallengeCatalogModel({
    required this.id,
    required this.name,
    required this.workoutType,
    required this.targetValue,
    required this.targetUnit,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupChallengeCatalogModel.fromJson(Map<String, dynamic> json) {
    return GroupChallengeCatalogModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      workoutType: json['workoutType']?.toString() ?? '',
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 0.0,
      targetUnit: json['targetUnit']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'workoutType': workoutType,
      'targetValue': targetValue,
      'targetUnit': targetUnit,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class GroupFitnessChallengeModel {
  final int id;
  final int clubId;
  final int createdBy;
  final String name;
  final String workoutType;
  final double targetValue;
  final String targetUnit;
  final String description;
  final DateTime? startAt;
  final DateTime? endAt;
  final String status; // 'UPCOMING', 'IN_PROGRESS', 'COMPLETE', 'CANCELLED'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? catalogId;
  final String? challengeSource; // 'RECOMMENDED', 'CUSTOM'
  final bool isJoined;
  final int participantCount;

  GroupFitnessChallengeModel({
    required this.id,
    required this.clubId,
    required this.createdBy,
    required this.name,
    required this.workoutType,
    required this.targetValue,
    required this.targetUnit,
    required this.description,
    this.startAt,
    this.endAt,
    this.status = 'IN_PROGRESS',
    this.createdAt,
    this.updatedAt,
    this.catalogId,
    this.challengeSource,
    this.isJoined = false,
    this.participantCount = 0,
  });

  factory GroupFitnessChallengeModel.fromJson(Map<String, dynamic> json) {
    return GroupFitnessChallengeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      clubId: (json['clubId'] as num?)?.toInt() ?? 0,
      createdBy: (json['createdBy'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      workoutType: json['workoutType']?.toString() ?? '',
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 0.0,
      targetUnit: json['targetUnit']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startAt: json['startAt'] != null ? DateTime.tryParse(json['startAt'].toString()) : null,
      endAt: json['endAt'] != null ? DateTime.tryParse(json['endAt'].toString()) : null,
      status: json['status']?.toString() ?? 'IN_PROGRESS',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      catalogId: (json['catalogId'] as num?)?.toInt(),
      challengeSource: json['challengeSource']?.toString(),
      isJoined: json['isJoined'] as bool? ?? false,
      participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clubId': clubId,
      'createdBy': createdBy,
      'name': name,
      'workoutType': workoutType,
      'targetValue': targetValue,
      'targetUnit': targetUnit,
      'description': description,
      'startAt': startAt?.toIso8601String(),
      'endAt': endAt?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'catalogId': catalogId,
      'challengeSource': challengeSource,
    };
  }
}

class ChallengeParticipantModel {
  final int id;
  final int challengeId;
  final int userId;
  final DateTime? joinedAt;
  final DateTime? completedAt;
  final String status; // 'ACTIVE', 'COMPLETED', 'LEFT', 'REMOVED'
  final String? userName;

  ChallengeParticipantModel({
    required this.id,
    required this.challengeId,
    required this.userId,
    this.joinedAt,
    this.completedAt,
    required this.status,
    this.userName,
  });

  factory ChallengeParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChallengeParticipantModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      challengeId: (json['challengeId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      joinedAt: json['joinedAt'] != null ? DateTime.tryParse(json['joinedAt'].toString()) : null,
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt'].toString()) : null,
      status: json['status']?.toString() ?? 'ACTIVE',
      userName: () {
        final first = json['firstname']?.toString() ?? json['firstName']?.toString() ?? '';
        final last = json['lastname']?.toString() ?? json['lastName']?.toString() ?? '';
        final full = '$first $last'.trim();
        if (full.isNotEmpty) return full;
        return json['userName']?.toString() ??
            json['username']?.toString() ??
            'User #${json['userId'] ?? ''}';
      }(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'userId': userId,
      'joinedAt': joinedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status,
    };
  }
}

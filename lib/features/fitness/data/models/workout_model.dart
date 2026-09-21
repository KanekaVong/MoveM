import '../../../task/data/dto/response/attachment_response.dart';

class StartWorkoutRequest {
  final String workoutType;
  final int? soloChallengeId;
  final int? participantId;

  StartWorkoutRequest({
    required this.workoutType,
    this.soloChallengeId,
    this.participantId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'workoutType': workoutType};
    if (soloChallengeId != null) data['soloChallengeId'] = soloChallengeId;
    if (participantId != null) data['participantId'] = participantId;
    return data;
  }
}

class FinishWorkoutRequest {
  final int durationSeconds;
  final int steps;
  final double distance;

  FinishWorkoutRequest({
    required this.durationSeconds,
    required this.steps,
    required this.distance,
  });

  Map<String, dynamic> toJson() {
    return {
      'durationSeconds': durationSeconds,
      'steps': steps,
      'distance': distance,
    };
  }
}

class WorkoutProgressRequest {
  final int durationSeconds;
  final int steps;
  final double distance;
  final double? latitude;
  final double? longitude;

  WorkoutProgressRequest({
    required this.durationSeconds,
    required this.steps,
    required this.distance,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'durationSeconds': durationSeconds,
      'steps': steps,
      'distance': distance,
    };
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    return data;
  }
}

class FitnessWorkoutSessionModel {
  final int sessionId;
  final int userId;
  final int? soloChallengeId;
  final int? groupChallengeParticipantId;
  final String workoutType;
  final String status;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int durationSeconds;
  final int steps;
  final double distance;
  final double caloriesBurned;
  final String? averagePace;
  final double? height;
  final double? weight;
  final double? bmi;

  FitnessWorkoutSessionModel({
    required this.sessionId,
    required this.userId,
    this.soloChallengeId,
    this.groupChallengeParticipantId,
    required this.workoutType,
    required this.status,
    this.startedAt,
    this.finishedAt,
    this.durationSeconds = 0,
    this.steps = 0,
    this.distance = 0.0,
    this.caloriesBurned = 0.0,
    this.averagePace,
    this.height,
    this.weight,
    this.bmi,
  });

  factory FitnessWorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    return FitnessWorkoutSessionModel(
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      soloChallengeId: (json['soloChallengeId'] as num?)?.toInt(),
      groupChallengeParticipantId: (json['groupChallengeParticipantId'] as num?)?.toInt(),
      workoutType: json['workoutType']?.toString() ?? '',
      status: json['status']?.toString() ?? 'IN_PROGRESS',
      startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt'].toString()) : null,
      finishedAt: json['finishedAt'] != null ? DateTime.tryParse(json['finishedAt'].toString()) : null,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
      averagePace: json['averagePace']?.toString(),
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'soloChallengeId': soloChallengeId,
      'groupChallengeParticipantId': groupChallengeParticipantId,
      'workoutType': workoutType,
      'status': status,
      'startedAt': startedAt?.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
      'durationSeconds': durationSeconds,
      'steps': steps,
      'distance': distance,
      'caloriesBurned': caloriesBurned,
      'averagePace': averagePace,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (bmi != null) 'bmi': bmi,
    };
  }

  FitnessWorkoutSummaryModel toSummaryModel() {
    return FitnessWorkoutSummaryModel(
      sessionId: sessionId,
      userId: userId,
      workoutType: workoutType,
      status: status,
      startedAt: startedAt,
      finishedAt: finishedAt,
      durationSeconds: durationSeconds,
      distance: distance,
      steps: steps,
      caloriesBurned: caloriesBurned,
    );
  }
}

class WorkoutHistoryItemModel {
  final int id;
  final String workoutType;
  final String status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int durationSeconds;
  final double distance;
  final double caloriesBurned;

  WorkoutHistoryItemModel({
    required this.id,
    required this.workoutType,
    required this.status,
    required this.startedAt,
    this.finishedAt,
    this.durationSeconds = 0,
    this.distance = 0.0,
    this.caloriesBurned = 0.0,
  });

  factory WorkoutHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      workoutType: json['workoutType']?.toString() ?? 'RUNNING',
      status: json['status']?.toString() ?? 'COMPLETED',
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      finishedAt: json['finishedAt'] != null ? DateTime.tryParse(json['finishedAt'].toString()) : null,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutType': workoutType,
      'status': status,
      'startedAt': startedAt.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
      'durationSeconds': durationSeconds,
      'distance': distance,
      'caloriesBurned': caloriesBurned,
    };
  }
}

class FitnessWorkoutSummaryModel {
  final int sessionId;
  final int userId;
  final String workoutType;
  final String? trackingMode;
  final String status;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int durationSeconds;
  final double distance;
  final int steps;
  final double caloriesBurned;
  final int reps;
  final int validReps;
  final int invalidReps;
  final int formScore;
  final List<String> feedback;

  FitnessWorkoutSummaryModel({
    required this.sessionId,
    required this.userId,
    required this.workoutType,
    this.trackingMode,
    required this.status,
    this.startedAt,
    this.finishedAt,
    this.durationSeconds = 0,
    this.distance = 0.0,
    this.steps = 0,
    this.caloriesBurned = 0.0,
    this.reps = 0,
    this.validReps = 0,
    this.invalidReps = 0,
    this.formScore = 0,
    this.feedback = const [],
  });

  factory FitnessWorkoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return FitnessWorkoutSummaryModel(
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      workoutType: json['workoutType']?.toString() ?? '',
      trackingMode: json['trackingMode']?.toString(),
      status: json['status']?.toString() ?? 'COMPLETED',
      startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt'].toString()) : null,
      finishedAt: json['finishedAt'] != null ? DateTime.tryParse(json['finishedAt'].toString()) : null,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
      reps: (json['reps'] as num?)?.toInt() ?? 0,
      validReps: (json['validReps'] as num?)?.toInt() ?? 0,
      invalidReps: (json['invalidReps'] as num?)?.toInt() ?? 0,
      formScore: (json['formScore'] as num?)?.toInt() ?? 0,
      feedback: json['feedback'] != null && json['feedback'] is List
          ? List<String>.from(json['feedback'].map((f) => f.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'workoutType': workoutType,
      'trackingMode': trackingMode,
      'status': status,
      'startedAt': startedAt?.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
      'durationSeconds': durationSeconds,
      'distance': distance,
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'reps': reps,
      'validReps': validReps,
      'invalidReps': invalidReps,
      'formScore': formScore,
      'feedback': feedback,
    };
  }
}

class FitnessWorkoutAnalysisRequest {
  final String exercise;
  final int reps;
  final int validReps;
  final int invalidReps;
  final int formScore;
  final List<String> feedback;

  FitnessWorkoutAnalysisRequest({
    required this.exercise,
    this.reps = 0,
    this.validReps = 0,
    this.invalidReps = 0,
    this.formScore = 100,
    this.feedback = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise,
      'reps': reps,
      'validReps': validReps,
      'invalidReps': invalidReps,
      'formScore': formScore,
      'feedback': feedback,
    };
  }
}

class FitnessWorkoutAnalysisResponse {
  final int id;
  final int sessionId;
  final String exercise;
  final int reps;
  final int validReps;
  final int invalidReps;
  final int formScore;
  final List<String> feedback;

  FitnessWorkoutAnalysisResponse({
    required this.id,
    required this.sessionId,
    required this.exercise,
    this.reps = 0,
    this.validReps = 0,
    this.invalidReps = 0,
    this.formScore = 100,
    this.feedback = const [],
  });

  factory FitnessWorkoutAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return FitnessWorkoutAnalysisResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      exercise: json['exercise']?.toString() ?? '',
      reps: (json['reps'] as num?)?.toInt() ?? 0,
      validReps: (json['validReps'] as num?)?.toInt() ?? 0,
      invalidReps: (json['invalidReps'] as num?)?.toInt() ?? 0,
      formScore: (json['formScore'] as num?)?.toInt() ?? 100,
      feedback: json['feedback'] != null && json['feedback'] is List
          ? List<String>.from(json['feedback'].map((f) => f.toString()))
          : [],
    );
  }
}

class RoutePointRequest {
  final int pointSequence;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final DateTime? recordedAt;

  RoutePointRequest({
    required this.pointSequence,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.recordedAt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'pointSequence': pointSequence,
      'latitude': latitude,
      'longitude': longitude,
    };
    if (accuracy != null) data['accuracy'] = accuracy;
    if (altitude != null) data['altitude'] = altitude;
    if (recordedAt != null) data['recordedAt'] = recordedAt!.toIso8601String();
    return data;
  }
}

class WorkoutRoutePointsRequest {
  final List<RoutePointRequest> points;

  WorkoutRoutePointsRequest({required this.points});

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((p) => p.toJson()).toList(),
    };
  }
}

class ShareWorkoutRequest {
  final bool shared;
  final String? description;

  ShareWorkoutRequest({
    required this.shared,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'shared': shared,
      if (description != null) 'description': description,
    };
  }
}

class SharedWorkoutPostResponse {
  final int sessionId;
  final int userId;
  final String username;
  final String? profilePicture;
  final String workoutType;
  final String? trackingMode;
  final String? shareDescription;
  final double distance;
  final int steps;
  final int durationSeconds;
  final double caloriesBurned;
  final DateTime? finishedAt;
  final int kudosCount;
  final bool myKudos;
  final int commentCount;
  final bool myPost;
  final String? averagePace;
  final String? challengeName;
  final List<AttachmentResponse> attachments;

  SharedWorkoutPostResponse({
    required this.sessionId,
    required this.userId,
    required this.username,
    this.profilePicture,
    required this.workoutType,
    this.trackingMode,
    this.shareDescription,
    this.distance = 0.0,
    this.steps = 0,
    this.durationSeconds = 0,
    this.caloriesBurned = 0.0,
    this.finishedAt,
    this.kudosCount = 0,
    this.myKudos = false,
    this.commentCount = 0,
    this.myPost = false,
    this.averagePace,
    this.challengeName,
    this.attachments = const [],
  });

  factory SharedWorkoutPostResponse.fromJson(Map<String, dynamic> json) {
    return SharedWorkoutPostResponse(
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      username: json['username']?.toString() ?? 'MoveM Athlete',
      profilePicture: json['profilePicture']?.toString(),
      workoutType: json['workoutType']?.toString() ?? 'WORKOUT',
      trackingMode: json['trackingMode']?.toString(),
      shareDescription: json['shareDescription']?.toString(),
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
      finishedAt: json['finishedAt'] != null
          ? DateTime.tryParse(json['finishedAt'].toString())
          : null,
      kudosCount: (json['kudosCount'] as num?)?.toInt() ?? 0,
      myKudos: json['myKudos'] as bool? ?? false,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      myPost: json['myPost'] as bool? ?? false,
      averagePace: json['averagePace']?.toString(),
      challengeName: _readChallengeName(json),
      attachments: json['attachments'] != null && json['attachments'] is List
          ? (json['attachments'] as List)
              .map((e) => AttachmentResponse.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'username': username,
      'profilePicture': profilePicture,
      'workoutType': workoutType,
      'trackingMode': trackingMode,
      'shareDescription': shareDescription,
      'distance': distance,
      'steps': steps,
      'durationSeconds': durationSeconds,
      'caloriesBurned': caloriesBurned,
      'finishedAt': finishedAt?.toIso8601String(),
      'kudosCount': kudosCount,
      'myKudos': myKudos,
      'commentCount': commentCount,
      'myPost': myPost,
      'averagePace': averagePace,
      'challengeName': challengeName,
      'attachments': attachments.map((e) => e.toJson()).toList(),
    };
  }

  static String? _readChallengeName(Map<String, dynamic> json) {
    final direct = json['challengeName'] ?? json['soloChallengeName'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString();
    }
    final nested = json['soloChallenge'] ?? json['challenge'];
    if (nested is Map && nested['name'] != null) {
      final name = nested['name'].toString().trim();
      if (name.isNotEmpty) return name;
    }
    return null;
  }
}



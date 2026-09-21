import 'package:uuid/uuid.dart';

enum SquatFormQuality {
  excellent,
  good,
  shallow,
}

class SquatRepData {
  final int repIndex;
  final DateTime timestamp;
  final double minKneeAngle;
  final double maxKneeAngle;
  final Duration repDuration;
  final SquatFormQuality formQuality;
  final double confidence;

  SquatRepData({
    required this.repIndex,
    required this.timestamp,
    required this.minKneeAngle,
    required this.maxKneeAngle,
    required this.repDuration,
    required this.formQuality,
    this.confidence = 1.0,
  });

  bool get isGoodForm => formQuality != SquatFormQuality.shallow;

  String get formQualityLabel {
    switch (formQuality) {
      case SquatFormQuality.excellent:
        return 'Deep Squat';
      case SquatFormQuality.good:
        return 'Good Depth';
      case SquatFormQuality.shallow:
        return 'Shallow';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'repIndex': repIndex,
      'timestamp': timestamp.toIso8601String(),
      'minKneeAngle': minKneeAngle,
      'maxKneeAngle': maxKneeAngle,
      'repDurationMs': repDuration.inMilliseconds,
      'formQuality': formQuality.name,
      'confidence': confidence,
    };
  }

  factory SquatRepData.fromJson(Map<String, dynamic> json) {
    return SquatRepData(
      repIndex: json['repIndex'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      minKneeAngle: (json['minKneeAngle'] as num?)?.toDouble() ?? 90.0,
      maxKneeAngle: (json['maxKneeAngle'] as num?)?.toDouble() ?? 160.0,
      repDuration: Duration(milliseconds: json['repDurationMs'] ?? 0),
      formQuality: SquatFormQuality.values.firstWhere(
        (e) => e.name == json['formQuality'],
        orElse: () => SquatFormQuality.good,
      ),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class SquatSession {
  final String sessionId;
  final int challengeId;
  final String challengeName;
  final DateTime startTime;
  DateTime? endTime;
  int totalReps;
  final int targetReps;
  final int sets;
  final List<SquatRepData> reps;
  bool isCompleted;

  SquatSession({
    String? sessionId,
    this.challengeId = 103,
    this.challengeName = 'Squats',
    DateTime? startTime,
    this.endTime,
    this.totalReps = 0,
    this.targetReps = 30,
    this.sets = 3,
    List<SquatRepData>? reps,
    this.isCompleted = false,
  })  : sessionId = sessionId ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now(),
        reps = reps ?? [];

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  int get caloriesBurned {
    return (totalReps * 0.35).round();
  }

  int get goodRepsCount {
    return reps.where((r) => r.isGoodForm).length;
  }

  int get shallowRepsCount {
    return reps.where((r) => !r.isGoodForm).length;
  }

  double get formAccuracyPercentage {
    if (reps.isEmpty) return 0.0;
    return (goodRepsCount / reps.length) * 100.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'challengeId': challengeId,
      'challengeName': challengeName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalReps': totalReps,
      'targetReps': targetReps,
      'sets': sets,
      'reps': reps.map((r) => r.toJson()).toList(),
      'isCompleted': isCompleted,
      'durationMs': duration.inMilliseconds,
      'caloriesBurned': caloriesBurned,
      'formAccuracyPercentage': formAccuracyPercentage,
    };
  }

  factory SquatSession.fromJson(Map<String, dynamic> json) {
    return SquatSession(
      sessionId: json['sessionId']?.toString(),
      challengeId: json['challengeId'] ?? 0,
      challengeName: json['challengeName']?.toString() ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      totalReps: json['totalReps'] ?? 0,
      targetReps: json['targetReps'] ?? 0,
      sets: json['sets'] ?? 3,
      reps: json['reps'] != null
          ? (json['reps'] as List)
              .map((r) => SquatRepData.fromJson(r as Map<String, dynamic>))
              .toList()
          : [],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

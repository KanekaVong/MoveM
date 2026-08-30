import 'package:uuid/uuid.dart';

enum PushUpFormQuality {
  excellent, // < 85 deg
  good, // 85 - 95 deg
  shallow, // > 95 deg
}

class PushUpRepData {
  final int repIndex;
  final DateTime timestamp;
  final double minElbowAngle;
  final double maxElbowAngle;
  final Duration repDuration;
  final PushUpFormQuality formQuality;
  final double confidence;

  PushUpRepData({
    required this.repIndex,
    required this.timestamp,
    required this.minElbowAngle,
    required this.maxElbowAngle,
    required this.repDuration,
    required this.formQuality,
    this.confidence = 1.0,
  });

  String get formQualityLabel {
    switch (formQuality) {
      case PushUpFormQuality.excellent:
        return 'Excellent';
      case PushUpFormQuality.good:
        return 'Good';
      case PushUpFormQuality.shallow:
        return 'Shallow';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'repIndex': repIndex,
      'timestamp': timestamp.toIso8601String(),
      'minElbowAngle': minElbowAngle,
      'maxElbowAngle': maxElbowAngle,
      'repDurationMs': repDuration.inMilliseconds,
      'formQuality': formQuality.name,
      'confidence': confidence,
    };
  }

  factory PushUpRepData.fromJson(Map<String, dynamic> json) {
    return PushUpRepData(
      repIndex: json['repIndex'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      minElbowAngle: (json['minElbowAngle'] as num?)?.toDouble() ?? 90.0,
      maxElbowAngle: (json['maxElbowAngle'] as num?)?.toDouble() ?? 160.0,
      repDuration: Duration(milliseconds: json['repDurationMs'] ?? 0),
      formQuality: PushUpFormQuality.values.firstWhere(
        (e) => e.name == json['formQuality'],
        orElse: () => PushUpFormQuality.good,
      ),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class PushUpSession {
  final String sessionId;
  final int challengeId;
  final String challengeName;
  final DateTime startTime;
  DateTime? endTime;
  int totalReps;
  final int targetReps;
  final int sets;
  final List<PushUpRepData> reps;
  bool isCompleted;

  PushUpSession({
    String? sessionId,
    this.challengeId = 1,
    this.challengeName = '4 Sets of 15 Push Up',
    DateTime? startTime,
    this.endTime,
    this.totalReps = 0,
    this.targetReps = 60,
    this.sets = 4,
    List<PushUpRepData>? reps,
    this.isCompleted = false,
  })  : sessionId = sessionId ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now(),
        reps = reps ?? [];

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  List<double> get repFormAngles =>
      reps.map((rep) => rep.minElbowAngle).toList();

  double get averageFormAngle {
    if (reps.isEmpty) return 0.0;
    final sum = reps.fold<double>(0.0, (prev, rep) => prev + rep.minElbowAngle);
    return sum / reps.length;
  }

  int get caloriesBurned {
    // Standard approximation: ~3 kcal per push up rep completed
    return (totalReps * 3.0).round();
  }

  String get formRating {
    final avg = averageFormAngle;
    if (reps.isEmpty) return 'No Reps';
    if (avg < 85) return 'Excellent Form 🏆';
    if (avg <= 95) return 'Good Form 💪';
    return 'Work on Depth ⚠️';
  }

  PushUpRepData? get bestRep {
    if (reps.isEmpty) return null;
    return reps.reduce((a, b) => a.minElbowAngle < b.minElbowAngle ? a : b);
  }

  PushUpRepData? get worstRep {
    if (reps.isEmpty) return null;
    return reps.reduce((a, b) => a.minElbowAngle > b.minElbowAngle ? a : b);
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
      'averageFormAngle': averageFormAngle,
      'caloriesBurned': caloriesBurned,
    };
  }
}

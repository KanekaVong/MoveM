import 'dart:math' as math;
import '../data/models/squat_session_model.dart';

enum SquatState {
  up,
  down,
}

class SquatStateMachine {
  final double upThreshold;
  final double downThreshold;
  final void Function(SquatRepData rep)? onRepCompleted;
  final void Function(SquatState state, double currentAngle, String feedback)?
      onStateChanged;

  SquatState _state = SquatState.up;
  double _minAngleInCurrentRep = 180.0;
  double _maxAngleInCurrentRep = 0.0;
  DateTime? _downPhaseStartTime;
  int _completedReps = 0;
  final List<SquatRepData> _repHistory = [];

  SquatStateMachine({
    this.upThreshold = 160.0,
    this.downThreshold = 95.0,
    this.onRepCompleted,
    this.onStateChanged,
  });

  SquatState get state => _state;
  int get completedReps => _completedReps;
  List<SquatRepData> get repHistory => List.unmodifiable(_repHistory);
  double get minAngleInCurrentRep => _minAngleInCurrentRep;

  void processAngle(double angle, {DateTime? timestamp, double confidence = 1.0}) {
    final now = timestamp ?? DateTime.now();

    if (angle > _maxAngleInCurrentRep) {
      _maxAngleInCurrentRep = angle;
    }

    if (_state == SquatState.up) {
      if (angle <= downThreshold) {
        _state = SquatState.down;
        _downPhaseStartTime = now;
        _minAngleInCurrentRep = angle;
        onStateChanged?.call(_state, angle, 'Good depth! Push up through your heels!');
      } else {
        onStateChanged?.call(
          _state,
          angle,
          angle < 130 ? 'Lower your hips...' : 'Stand tall and begin squatting',
        );
      }
    } else if (_state == SquatState.down) {
      if (angle < _minAngleInCurrentRep) {
        _minAngleInCurrentRep = angle;
      }

      if (angle >= upThreshold) {
        _state = SquatState.up;
        _completedReps++;

        final duration = _downPhaseStartTime != null
            ? now.difference(_downPhaseStartTime!)
            : const Duration(milliseconds: 1400);

        SquatFormQuality quality;
        if (_minAngleInCurrentRep <= 85.0) {
          quality = SquatFormQuality.excellent;
        } else if (_minAngleInCurrentRep <= 95.0) {
          quality = SquatFormQuality.good;
        } else {
          quality = SquatFormQuality.shallow;
        }

        final repData = SquatRepData(
          repIndex: _completedReps,
          timestamp: now,
          minKneeAngle: math.max(0.0, _minAngleInCurrentRep),
          maxKneeAngle: math.min(180.0, _maxAngleInCurrentRep),
          repDuration: duration,
          formQuality: quality,
          confidence: confidence,
        );

        _repHistory.add(repData);
        onRepCompleted?.call(repData);

        _minAngleInCurrentRep = 180.0;
        _maxAngleInCurrentRep = angle;
        _downPhaseStartTime = null;

        onStateChanged?.call(
          _state,
          angle,
          quality == SquatFormQuality.excellent
              ? 'Deep Squat! 🏆'
              : 'Rep #$_completedReps Complete!',
        );
      } else {
        onStateChanged?.call(
          _state,
          angle,
          'Stand all the way up!',
        );
      }
    }
  }

  void reset() {
    _state = SquatState.up;
    _completedReps = 0;
    _minAngleInCurrentRep = 180.0;
    _maxAngleInCurrentRep = 0.0;
    _downPhaseStartTime = null;
    _repHistory.clear();
  }
}

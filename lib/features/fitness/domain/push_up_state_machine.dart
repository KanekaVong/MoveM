import 'dart:math' as math;
import '../data/models/push_up_session_model.dart';

enum PushUpState {
  up,
  down,
}

class PushUpStateMachine {
  final double upThreshold;
  final double downThreshold;
  final void Function(PushUpRepData rep)? onRepCompleted;
  final void Function(PushUpState state, double currentAngle, String feedback)?
      onStateChanged;

  PushUpState _state = PushUpState.up;
  double _minAngleInCurrentRep = 180.0;
  double _maxAngleInCurrentRep = 0.0;
  DateTime? _downPhaseStartTime;
  int _completedReps = 0;
  final List<PushUpRepData> _repHistory = [];

  PushUpStateMachine({
    this.upThreshold = 160.0,
    this.downThreshold = 90.0,
    this.onRepCompleted,
    this.onStateChanged,
  });

  PushUpState get state => _state;
  int get completedReps => _completedReps;
  List<PushUpRepData> get repHistory => List.unmodifiable(_repHistory);
  double get minAngleInCurrentRep => _minAngleInCurrentRep;

  /// Processes a new frame elbow angle reading
  void processAngle(double angle, {DateTime? timestamp, double confidence = 1.0}) {
    final now = timestamp ?? DateTime.now();

    // Track peak lockout
    if (angle > _maxAngleInCurrentRep) {
      _maxAngleInCurrentRep = angle;
    }

    if (_state == PushUpState.up) {
      if (angle <= downThreshold) {
        // Transition UP -> DOWN
        _state = PushUpState.down;
        _downPhaseStartTime = now;
        _minAngleInCurrentRep = angle;
        onStateChanged?.call(_state, angle, 'Good depth! Now push up!');
      } else {
        // Still in UP state
        onStateChanged?.call(
          _state,
          angle,
          angle < 120 ? 'Lower down...' : 'Get ready to lower',
        );
      }
    } else if (_state == PushUpState.down) {
      // In DOWN phase, track the lowest angle reached
      if (angle < _minAngleInCurrentRep) {
        _minAngleInCurrentRep = angle;
      }

      if (angle >= upThreshold) {
        // Transition DOWN -> UP (Rep complete!)
        _state = PushUpState.up;
        _completedReps++;

        final duration = _downPhaseStartTime != null
            ? now.difference(_downPhaseStartTime!)
            : const Duration(milliseconds: 1200);

        PushUpFormQuality quality;
        if (_minAngleInCurrentRep <= 85.0) {
          quality = PushUpFormQuality.excellent;
        } else if (_minAngleInCurrentRep <= 95.0) {
          quality = PushUpFormQuality.good;
        } else {
          quality = PushUpFormQuality.shallow;
        }

        final repData = PushUpRepData(
          repIndex: _completedReps,
          timestamp: now,
          minElbowAngle: math.max(0.0, _minAngleInCurrentRep),
          maxElbowAngle: math.min(180.0, _maxAngleInCurrentRep),
          repDuration: duration,
          formQuality: quality,
          confidence: confidence,
        );

        _repHistory.add(repData);
        onRepCompleted?.call(repData);

        // Reset tracking for next rep
        _minAngleInCurrentRep = 180.0;
        _maxAngleInCurrentRep = angle;
        _downPhaseStartTime = null;

        onStateChanged?.call(
          _state,
          angle,
          quality == PushUpFormQuality.excellent
              ? 'Excellent Rep! 🏆'
              : 'Rep #$_completedReps Complete!',
        );
      } else {
        onStateChanged?.call(
          _state,
          angle,
          'Push all the way up!',
        );
      }
    }
  }

  void reset() {
    _state = PushUpState.up;
    _completedReps = 0;
    _minAngleInCurrentRep = 180.0;
    _maxAngleInCurrentRep = 0.0;
    _downPhaseStartTime = null;
    _repHistory.clear();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/no_data_component.dart';
import '../../data/models/group_challenge_model.dart';
import '../controllers/club_challenge_detail_controller.dart';
import '../controllers/fitness_club_controller.dart';
import 'create_club_challenge_screen.dart';

/// Muscle groups highlighted on the body diagram per workout type.
const _musclesByType = <String, Set<MuscleGroup>>{
  'RUNNING': {MuscleGroup.quads, MuscleGroup.hamstrings, MuscleGroup.calves, MuscleGroup.glutes},
  'WALKING': {MuscleGroup.calves, MuscleGroup.glutes},
  'CYCLING': {MuscleGroup.quads, MuscleGroup.glutes, MuscleGroup.calves},
  'SWIMMING': {MuscleGroup.shoulders, MuscleGroup.back, MuscleGroup.core},
  'HIIT': {MuscleGroup.quads, MuscleGroup.core, MuscleGroup.shoulders, MuscleGroup.glutes},
  'PUSH_UP': {MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.arms, MuscleGroup.core},
};

class ClubChallengeDetailScreen extends StatefulWidget {
  final GroupFitnessChallengeModel challenge;

  const ClubChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ClubChallengeDetailScreen> createState() => _ClubChallengeDetailScreenState();
}

class _ClubChallengeDetailScreenState extends State<ClubChallengeDetailScreen> {
  late final ClubChallengeDetailController _controller;
  late final String _tag;

  GroupFitnessChallengeModel get challenge => _controller.challenge.value;

  @override
  void initState() {
    super.initState();
    _tag = 'club-challenge-${widget.challenge.id}';
    _controller = Get.isRegistered<ClubChallengeDetailController>(tag: _tag)
        ? Get.find<ClubChallengeDetailController>(tag: _tag)
        : Get.put(ClubChallengeDetailController(widget.challenge), tag: _tag);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ClubChallengeDetailController>(tag: _tag)) {
      Get.delete<ClubChallengeDetailController>(tag: _tag);
    }
    super.dispose();
  }

  bool get _hasEnded {
    final endAt = challenge.endAt;
    final status = challenge.status.toUpperCase();
    if (status == 'COMPLETE' || status == 'CANCELLED') return true;
    return endAt != null && endAt.isBefore(DateTime.now());
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '--';
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$month / $day / ${value.year}';
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return '--';
    final startText = _formatTime(start);
    if (end == null) return startText;
    return '$startText - ${_formatTime(end)}';
  }

  String _formatTime(DateTime value) {
    final period = value.hour >= 12 ? 'PM' : 'AM';
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    return '$hour:${value.minute.toString().padLeft(2, '0')}$period';
  }

  String get _typeLabel {
    final type = challenge.workoutType.replaceAll('_', ' ');
    if (type.isEmpty) return 'Workout';
    return type
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
    final challenge = this.challenge;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(challenge.name),
            _buildInfoRow(challenge),
            if (_hasEnded)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Text(
                  'Challenge Has Ended',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descriptions',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _bullet(
                    '\u25CF',
                    challenge.description.isNotEmpty
                        ? challenge.description
                        : 'Complete ${challenge.targetValue.toStringAsFixed(0)} '
                            '${challenge.targetUnit.toLowerCase()} to finish this challenge.',
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Text(
                        'MUSCLES BUILT BY ',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Text(
                        _typeLabel.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.accentBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _buildMuscleDiagrams(),
                  const SizedBox(height: 28),
                  _buildMembersJoined(),
                  const SizedBox(height: 28),
                  if (_hasEnded) ...[
                    GestureDetector(
                      onTap: _createChallengeAgain,
                      child: Text(
                        'CREATE CHALLENGE AGAIN?',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildJoinButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    });
  }

  Widget _buildHero(String title) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: Image.asset(
              'assets/images/featured_challenge_runner.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.22),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 2)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(GroupFitnessChallengeModel challenge) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          _infoItem(Icons.calendar_today_outlined, _formatDate(challenge.startAt)),
          const SizedBox(width: 14),
          _infoItem(
            Icons.access_time,
            _formatTimeRange(challenge.startAt, challenge.endAt),
          ),
          const SizedBox(width: 14),
          _infoItem(Icons.directions_run, _typeLabel),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 17),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String marker, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            marker,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 9, height: 1.9),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleDiagrams() {
    final muscles = _musclesByType[challenge.workoutType.toUpperCase()] ??
        const {MuscleGroup.core};

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _muscleCard(muscles, isFront: true),
          const SizedBox(width: 28),
          _muscleCard(muscles, isFront: false),
        ],
      ),
    );
  }

  Widget _muscleCard(Set<MuscleGroup> muscles, {required bool isFront}) {
    return Container(
      width: 84,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: CustomPaint(
        painter: BodyMusclePainter(
          highlighted: muscles,
          isFront: isFront,
          bodyColor: AppColors.isDark ? const Color(0xFFE8EDF5) : const Color(0xFFF3F4F6),
          outlineColor: const Color(0xFF64748B),
          highlightColor: const Color(0xFF3B82F6),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Obx(() => ElevatedButton(
            onPressed: _controller.isJoining.value
                ? null
                : (_hasEnded ? _createChallengeAgain : _controller.joinChallenge),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.isDark ? Colors.white : Colors.white,
              foregroundColor: const Color(0xFF111827),
              disabledBackgroundColor: Colors.white70,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _controller.isJoining.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'JOIN CLUB CHALLENGE',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
          )),
    );
  }

  void _createChallengeAgain() {
    final club = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>().selectedClub.value
        : null;
    if (club == null) return;
    Get.to(
      () => CreateClubChallengeScreen(club: club, draft: challenge),
    );
  }

  Widget _buildMembersJoined() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(Get.context!)?.membersJoinedLabel ?? 'MEMBERS JOINED:',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (_controller.participants.isEmpty) {
            return NoDataComponent(
              compact: true,
              title: AppLocalizations.of(Get.context!)?.noMembersJoined ?? 'No members have joined yet',
            );
          }
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _controller.participants.take(8).map((p) {
              final name = p.userName ?? '';
              final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
              return CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.chipSurface,
                child: Text(
                  initial,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}

enum MuscleGroup { chest, shoulders, arms, core, back, glutes, quads, hamstrings, calves }

/// Simplified anatomical figure that tints the muscle groups a workout targets.
class BodyMusclePainter extends CustomPainter {
  final Set<MuscleGroup> highlighted;
  final bool isFront;
  final Color bodyColor;
  final Color outlineColor;
  final Color highlightColor;

  BodyMusclePainter({
    required this.highlighted,
    required this.isFront,
    required this.bodyColor,
    required this.outlineColor,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final body = Paint()..color = bodyColor;
    final outline = Paint()
      ..color = outlineColor.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    void shape(Path path, {bool active = false}) {
      canvas.drawPath(path, active ? (Paint()..color = highlightColor) : body);
      canvas.drawPath(path, outline);
    }

    Path rounded(double left, double top, double right, double bottom, double r) {
      return Path()
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTRB(left, top, right, bottom),
          Radius.circular(r),
        ));
    }

    // Head
    shape(Path()..addOval(Rect.fromCircle(center: Offset(cx, h * 0.09), radius: w * 0.11)));

    // Neck
    shape(rounded(cx - w * 0.05, h * 0.14, cx + w * 0.05, h * 0.18, w * 0.02));

    // Torso
    final torso = Path()
      ..moveTo(cx - w * 0.22, h * 0.18)
      ..lineTo(cx + w * 0.22, h * 0.18)
      ..lineTo(cx + w * 0.17, h * 0.46)
      ..lineTo(cx - w * 0.17, h * 0.46)
      ..close();
    shape(torso, active: highlighted.contains(isFront ? MuscleGroup.core : MuscleGroup.back));

    // Chest / upper back band
    shape(
      rounded(cx - w * 0.2, h * 0.2, cx + w * 0.2, h * 0.3, w * 0.04),
      active: highlighted.contains(isFront ? MuscleGroup.chest : MuscleGroup.back),
    );

    // Shoulders
    final shoulderActive = highlighted.contains(MuscleGroup.shoulders);
    shape(Path()..addOval(Rect.fromCircle(center: Offset(cx - w * 0.24, h * 0.21), radius: w * 0.07)),
        active: shoulderActive);
    shape(Path()..addOval(Rect.fromCircle(center: Offset(cx + w * 0.24, h * 0.21), radius: w * 0.07)),
        active: shoulderActive);

    // Arms
    final armActive = highlighted.contains(MuscleGroup.arms);
    shape(rounded(cx - w * 0.33, h * 0.24, cx - w * 0.23, h * 0.46, w * 0.04), active: armActive);
    shape(rounded(cx + w * 0.23, h * 0.24, cx + w * 0.33, h * 0.46, w * 0.04), active: armActive);

    // Forearms
    shape(rounded(cx - w * 0.36, h * 0.44, cx - w * 0.26, h * 0.6, w * 0.04));
    shape(rounded(cx + w * 0.26, h * 0.44, cx + w * 0.36, h * 0.6, w * 0.04));

    // Hips / glutes
    shape(
      rounded(cx - w * 0.19, h * 0.45, cx + w * 0.19, h * 0.56, w * 0.05),
      active: !isFront && highlighted.contains(MuscleGroup.glutes),
    );

    // Upper legs
    final thighActive = highlighted.contains(
      isFront ? MuscleGroup.quads : MuscleGroup.hamstrings,
    );
    shape(rounded(cx - w * 0.19, h * 0.55, cx - w * 0.03, h * 0.75, w * 0.05), active: thighActive);
    shape(rounded(cx + w * 0.03, h * 0.55, cx + w * 0.19, h * 0.75, w * 0.05), active: thighActive);

    // Lower legs
    final calfActive = highlighted.contains(MuscleGroup.calves);
    shape(rounded(cx - w * 0.17, h * 0.75, cx - w * 0.04, h * 0.94, w * 0.05), active: calfActive);
    shape(rounded(cx + w * 0.04, h * 0.75, cx + w * 0.17, h * 0.94, w * 0.05), active: calfActive);
  }

  @override
  bool shouldRepaint(covariant BodyMusclePainter oldDelegate) {
    return oldDelegate.highlighted != highlighted ||
        oldDelegate.isFront != isFront ||
        oldDelegate.bodyColor != bodyColor ||
        oldDelegate.highlightColor != highlightColor;
  }
}

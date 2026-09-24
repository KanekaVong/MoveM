import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/top_tool_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/fitness_club_model.dart';
import '../../data/models/group_challenge_model.dart';
import '../controllers/fitness_club_controller.dart';

/// Activity types offered when building a custom club challenge.
/// Values match the backend `workoutType` enum.
const _activityTypes = <String, String>{
  'RUNNING': 'Running',
  'CYCLING': 'Cycling',
  'SWIMMING': 'Swimming',
  'HIIT': 'HIIT',
  'PUSH_UP': 'Push Up',
  'WALKING': 'Walking',
};

const _unitsByType = <String, String>{
  'RUNNING': 'KM',
  'CYCLING': 'KM',
  'SWIMMING': 'METERS',
  'HIIT': 'MINUTES',
  'PUSH_UP': 'REPS',
  'WALKING': 'STEPS',
};

class CreateClubChallengeScreen extends StatefulWidget {
  final FitnessClubModel club;
  final GroupFitnessChallengeModel? draft;

  const CreateClubChallengeScreen({super.key, required this.club, this.draft});

  @override
  State<CreateClubChallengeScreen> createState() => _CreateClubChallengeScreenState();
}

class _CreateClubChallengeScreenState extends State<CreateClubChallengeScreen> {
  late final FitnessClubController _controller;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();

  late DateTime _startAt;
  late DateTime _endAt;
  String _selectedType = 'RUNNING';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<FitnessClubController>()
        ? Get.find<FitnessClubController>()
        : Get.put(FitnessClubController());

    final now = DateTime.now();
    _startAt = DateTime(now.year, now.month, now.day + 1, 5, 30);
    _endAt = _startAt.add(const Duration(hours: 2));

    final draft = widget.draft;
    if (draft != null) {
      _nameController.text = draft.name;
      _descriptionController.text = draft.description;
      _targetController.text = draft.targetValue == draft.targetValue.roundToDouble()
          ? draft.targetValue.toInt().toString()
          : draft.targetValue.toString();
      if (_activityTypes.containsKey(draft.workoutType)) {
        _selectedType = draft.workoutType;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  String get _targetUnit => _unitsByType[_selectedType] ?? 'REPS';

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final hour24 = value.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    return '$month / $day /${value.year} ${hour12.toString().padLeft(2, '0')}:$minute  $period';
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final initial = isStart ? _startAt : _endAt;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    final picked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _startAt = picked;
        if (!_endAt.isAfter(_startAt)) {
          _endAt = _startAt.add(const Duration(hours: 2));
        }
      } else {
        _endAt = picked;
      }
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        l10n?.challengeNameTitle ?? 'Challenge name',
        l10n?.pleaseEnterChallengeName ?? 'Please enter a challenge name.',
      );
      return;
    }
    if (!_endAt.isAfter(_startAt)) {
      Get.snackbar(
        l10n?.datesTitle ?? 'Dates',
        l10n?.endDateAfterStart ?? 'End date must be after the start date.',
      );
      return;
    }

    final targetValue = double.tryParse(_targetController.text.trim()) ?? 0;
    if (targetValue <= 0) {
      Get.snackbar(
        l10n?.targetTitle ?? 'Target',
        l10n?.enterTargetInUnit(_targetUnit) ?? 'Enter a target in $_targetUnit.',
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final created = await _controller.createClubChallenge(
      clubId: widget.club.id,
      name: name,
      workoutType: _selectedType,
      targetValue: targetValue,
      targetUnit: _targetUnit,
      description: _descriptionController.text.trim(),
      startAt: _startAt,
      endAt: _endAt,
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (created) Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(title: AppLocalizations.of(context)?.createChallenge ?? 'Create Challenge'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('CHALLENGE NAME'),
                    _fieldBox(
                      child: TextField(
                        controller: _nameController,
                        style: _inputStyle,
                        decoration: _inputDecoration('Morning Sprint Challenge'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _label('START DATE'),
                    _dateField(value: _startAt, onTap: () => _pickDateTime(isStart: true)),
                    const SizedBox(height: 18),
                    _label('END DATE'),
                    _dateField(value: _endAt, onTap: () => _pickDateTime(isStart: false)),
                    const SizedBox(height: 18),
                    _label('TARGET ($_targetUnit)'),
                    _fieldBox(
                      child: TextField(
                        controller: _targetController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: _inputStyle,
                        decoration: _inputDecoration('5'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _label('DESCRIPTIONS'),
                    _fieldBox(
                      height: 104,
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: _inputStyle,
                        decoration: _inputDecoration(
                          'Complete 5 continuous laps of the park track.',
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _label('ACTIVITY TYPE'),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _activityTypes.entries
                          .map((entry) => _typeChip(entry.key, entry.value))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.isDark ? Colors.white : AppColors.accentBlue,
                          disabledBackgroundColor: AppColors.chipSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow_outlined,
                                    color: AppColors.isDark ? const Color(0xFF111827) : Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'CREATE CHALLENGE',
                                    style: TextStyle(
                                      color: AppColors.isDark ? const Color(0xFF111827) : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _inputStyle => TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textCaption,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _fieldBox({required Widget child, double? height}) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }

  Widget _dateField({required DateTime value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: _fieldBox(
        child: Row(
          children: [
            Expanded(
              child: Text(_formatDateTime(value), style: _inputStyle),
            ),
            Icon(Icons.calendar_month_outlined, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String value, String label) {
    final isSelected = _selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (AppColors.isDark ? const Color(0xFFF1F5F9) : AppColors.accentBlue)
              : AppColors.chipSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (AppColors.isDark ? const Color(0xFF111827) : Colors.white)
                : AppColors.textSecondary,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

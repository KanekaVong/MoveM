import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/create_task_controller.dart';
import '../../../../core/theme/app_colors.dart';

class CreateTaskScreen extends GetView<CreateTaskController> {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateTaskController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      l10n?.taskTitleLabel ?? 'TASK TITLE',
                      l10n?.taskTitleHint ?? 'Give your Work a name',
                      controller.titleController,
                    ),
                    const SizedBox(height: 32),
                    _buildInputField(
                      l10n?.descriptionLabel ?? 'DESCRIPTION',
                      l10n?.descriptionHint ?? 'Write down a note',
                      controller.descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    _buildPropertiesCard(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => controller.submitTask(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textPrimary.withValues(alpha: 0.08),
                border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.15)),
              ),
              child: const Center(
                child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Create Task',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController textController, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: textController,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textCaption,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textPrimary),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.pickDeadlineDate(Get.context!),
            child: Obx(() => _buildPropertyRow(
              'DEADLINES',
              controller.formattedDeadlineDate,
              Icons.calendar_today_outlined,
            )),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => controller.addChecklistItem(),
            child: Row(
              children: [
                const Text(
                  'CHECKLIST',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.add, color: AppColors.textPrimary, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 12),
          Obx(() => Column(
            children: controller.checklistControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final textController = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_box_outline_blank, color: AppColors.textCaption, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Add an item',
                          hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.removeChecklistItem(index),
                      child: const Icon(Icons.close, color: AppColors.textCaption, size: 18),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 16),
          _buildRepeatDropdown(),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPriorityDropdown()),
              const SizedBox(width: 24),
              Expanded(child: _buildLabelDropdown()),
            ],
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => controller.toggleReminders(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Get upcoming reminders about your Tasks',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(() => Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: controller.remindersEnabled.value
                        ? const Color(0xFF3B82F6)
                        : Colors.transparent,
                    border: Border.all(
                      color: controller.remindersEnabled.value
                          ? const Color(0xFF3B82F6)
                          : AppColors.textCaption,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: controller.remindersEnabled.value
                      ? const Icon(Icons.check, size: 14, color: AppColors.textPrimary)
                      : null,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textCaption,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            Icon(icon, color: AppColors.textPrimary, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: AppColors.borderLight),
      ],
    );
  }

  Widget _buildRepeatDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) => controller.repeatFrequency.value = value,
      offset: const Offset(0, 40),
      color: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      itemBuilder: (context) => ['Daily', 'Weekly', 'Monthly', 'Yearly']
          .map((choice) => PopupMenuItem<String>(
                value: choice,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(choice, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(height: 1, color: AppColors.borderLight),
                  ],
                ),
              ))
          .toList(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REPEAT',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                controller.repeatFrequency.value ?? '',
                style: const TextStyle(
                  color: AppColors.textCaption,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              )),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: AppColors.borderLight),
        ],
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) => controller.priority.value = value,
      offset: const Offset(0, 30),
      color: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      itemBuilder: (context) => ['URGENT', 'HIGH', 'NORMAL', 'LOW']
          .map((choice) => PopupMenuItem<String>(
                value: choice,
                child: Text(choice, style: const TextStyle(color: AppColors.textPrimary)),
              ))
          .toList(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'PRIORITY',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            Color pillColor = AppColors.textCaption;
            if (controller.priority.value == 'LOW') pillColor = const Color(0xFF22C55E);
            if (controller.priority.value == 'NORMAL') pillColor = const Color(0xFFF59E0B);
            if (controller.priority.value == 'HIGH') pillColor = const Color(0xFFEF4444);
            if (controller.priority.value == 'URGENT') pillColor = const Color(0xFFDC2626);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: pillColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: pillColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                controller.priority.value,
                style: TextStyle(
                  color: pillColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLabelDropdown() {
    return PopupMenuButton<dynamic>(
      onSelected: (value) {
        if (value != 'CREATE') {
          controller.selectedLabel.value = value;
        } else {
          _showCreateLabelDialog();
        }
      },
      offset: const Offset(0, 30),
      color: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      itemBuilder: (context) {
        List<PopupMenuEntry<dynamic>> items = controller.availableLabels.map((l) {
          final color = Color(int.parse(l.color.replaceFirst('#', '0xFF')));
          return PopupMenuItem<dynamic>(
            value: l,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();

        items.add(
          PopupMenuItem<dynamic>(
            value: 'CREATE',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Create Label',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                ),
              ),
            ),
          ),
        );

        return items;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'LABEL',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(Icons.add, color: AppColors.textPrimary, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.selectedLabel.value == null) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chipSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Select Label',
                  style: TextStyle(
                    color: AppColors.textCaption,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final l = controller.selectedLabel.value!;
            final color = Color(int.parse(l.color.replaceFirst('#', '0xFF')));

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showCreateLabelDialog() {
    final nameController = TextEditingController();
    final RxString selectedColor = '#3B82F6'.obs;

    final List<String> colors = [
      '#EF4444',
      '#F97316',
      '#F59E0B',
      '#84CC16',
      '#22C55E',
      '#06B6D4',
      '#3B82F6',
      '#8B5CF6',
      '#D946EF',
      '#F43F5E',
    ];

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Label',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'NAME',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Enter label name',
                  hintStyle: TextStyle(color: AppColors.textCaption, fontSize: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3B82F6)),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'COLOR',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colors.map((colorHex) {
                  final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                  return GestureDetector(
                    onTap: () => selectedColor.value = colorHex,
                    child: Obx(() {
                      final isSelected = selectedColor.value == colorHex;
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: AppColors.textPrimary, width: 2) : null,
                        ),
                      );
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.textCaption)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Label name cannot be empty',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      controller.createLabel(nameController.text.trim(), selectedColor.value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Create', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

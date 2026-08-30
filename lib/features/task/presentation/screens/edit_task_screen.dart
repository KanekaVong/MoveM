import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/edit_task_controller.dart';
import '../../data/dto/response/label_response.dart';
import 'add_collaborator_screen.dart';

class EditTaskScreen extends GetView<EditTaskController> {
  const EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditTaskController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.taskDarkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.taskDetailBackground,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.35),
                    AppColors.taskDarkBackground.withOpacity(0.65),
                    AppColors.taskDarkBackground.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(l10n?.taskTitleLabel ?? 'TASK TITLE', l10n?.taskTitleHint ?? 'Give your Work a name', controller.titleController),
                        const SizedBox(height: 24),
                        _buildInputField(l10n?.descriptionLabel ?? 'DESCRIPTION', l10n?.descriptionHint ?? 'Write down a note', controller.descriptionController),
                        const SizedBox(height: 24),
                        _buildPropertiesCard(),
                        const SizedBox(height: 20),
                        _buildCollaboratorsSection(context),
                        const SizedBox(height: 16),
                        _buildAttachmentsSection(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x33000000),
                border: Border.all(color: Colors.white.withOpacity(0.24), width: 1),
              ),
              child: const Center(
                child: Icon(Icons.chevron_left, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            l10n?.editTask ?? 'Edit Task',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontStyle: FontStyle.italic),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF3B82F6)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.taskFigmaCard.withOpacity(0.20),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.pickDeadlineDate(Get.context!),
                  child: Obx(() => _buildPropertyRow('DEADLINE DATE', controller.formattedDeadlineDate, Icons.calendar_today)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.pickDeadlineTime(Get.context!),
                  child: Obx(() => _buildPropertyRow('TIME', controller.formattedDeadlineTime, Icons.access_time)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: () => controller.addChecklistItem(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'CHECKLIST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.add, color: Colors.white, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
            children: controller.checklists.asMap().entries.map((entry) {
              final index = entry.key;
              final textController = entry.value['controller'] as TextEditingController;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_box_outline_blank, color: AppColors.taskTextMuted, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Add an item',
                          hintStyle: TextStyle(color: AppColors.taskTextMuted, fontSize: 12, fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.removeChecklistItem(index),
                      child: const Icon(Icons.close, color: AppColors.taskTextMuted, size: 18),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 16),
          _buildRepeatDropdown(),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPriorityDropdown()),
              const SizedBox(width: 16),
              Expanded(child: _buildLabelDropdown()),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => controller.toggleReminders(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Get upcoming reminders about your due dates',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                Obx(() => Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: controller.remindersEnabled.value ? AppColors.taskGreenAccent : Colors.transparent,
                    border: Border.all(
                      color: controller.remindersEnabled.value ? AppColors.taskGreenAccent : Colors.white70,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: controller.remindersEnabled.value
                      ? const Icon(Icons.check, size: 14, color: Colors.black)
                      : null,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollaboratorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.collaborators.isEmpty) return const SizedBox();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collaborators (${controller.collaborators.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: controller.collaborators.asMap().entries.map((entry) {
                  final index = entry.key;
                  final collaborator = entry.value;
                  final name = collaborator is Map
                      ? (collaborator['name'] ?? collaborator['username'] ?? 'User')
                      : collaborator.toString();
                  final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.taskAvatarBg,
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            style: const TextStyle(
                              color: AppColors.taskTextMuted,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () => controller.removeCollaborator(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
        GestureDetector(
          onTap: () async {
            final result = await Get.to(() => const AddCollaboratorScreen());
            if (result != null && result is List) {
              for (var c in result) {
                final name = c is Map ? (c['name'] ?? c['username'] ?? 'User') : c.toString();
                controller.addCollaborator(name);
              }
            } else if (result != null && result is String) {
              controller.addCollaborator(result);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.taskFigmaCard.withOpacity(0.20),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Add Collaborators',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final totalCount = controller.existingAttachments.length + controller.pickedAttachments.length;
          if (totalCount == 0) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attachments ($totalCount)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...controller.existingAttachments.asMap().entries.map((entry) {
                      final index = entry.key;
                      final attachment = entry.value;
                      final url = attachment is Map
                          ? (attachment['url'] ?? attachment['fileUrl'] ?? '')
                          : attachment.toString();
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                url,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 90,
                                  height: 90,
                                  color: AppColors.taskSlateDark,
                                  child: const Icon(Icons.insert_drive_file, color: Colors.white54),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => controller.removeExistingAttachment(index),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    ...controller.pickedAttachments.asMap().entries.map((entry) {
                      final index = entry.key;
                      final xfile = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(xfile.path),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => controller.removePickedAttachment(index),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
        GestureDetector(
          onTap: () => _showImageSourcePicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.taskFigmaCard.withOpacity(0.20),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Add Attachments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showImageSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.taskSlateCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Upload Photo',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.taskBluePrimary),
                  title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Get.back();
                    controller.pickAttachment(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.taskGreenAccent),
                  title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Get.back();
                    controller.pickAttachment(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPropertyRow(String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: const TextStyle(color: AppColors.taskTextMuted, fontSize: 12, fontStyle: FontStyle.italic)),
            Icon(icon, color: Colors.white70, size: 16),
          ],
        ),
        const SizedBox(height: 6),
        Container(height: 0.5, color: Colors.white.withOpacity(0.2)),
      ],
    );
  }

  Widget _buildRepeatDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('REPEAT', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String?>(
          value: controller.repeatFrequency.value,
          dropdownColor: AppColors.taskSlateDark,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.taskBluePrimary)),
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            isDense: true,
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 20),
          items: const [
            DropdownMenuItem(value: null, child: Text('NONE', style: TextStyle(color: AppColors.taskTextMuted, fontStyle: FontStyle.italic))),
            DropdownMenuItem(value: 'DAILY', child: Text('DAILY', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic))),
            DropdownMenuItem(value: 'WEEKLY', child: Text('WEEKLY', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic))),
            DropdownMenuItem(value: 'MONTHLY', child: Text('MONTHLY', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic))),
          ],
          onChanged: (val) {
            controller.repeatFrequency.value = val;
            controller.isRecurring.value = val != null;
          },
        )),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PRIORITY', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
          value: controller.priority.value,
          dropdownColor: AppColors.taskSlateDark,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.taskBluePrimary)),
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            isDense: true,
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 20),
          items: const [
            DropdownMenuItem(value: 'LOW', child: Text('LOW', style: TextStyle(color: AppColors.taskGreenAccent, fontWeight: FontWeight.bold))),
            DropdownMenuItem(value: 'NORMAL', child: Text('NORMAL', style: TextStyle(color: AppColors.taskYellowPriority, fontWeight: FontWeight.bold))),
            DropdownMenuItem(value: 'HIGH', child: Text('HIGH', style: TextStyle(color: AppColors.taskRedPriority, fontWeight: FontWeight.bold))),
            DropdownMenuItem(value: 'URGENT', child: Text('URGENT', style: TextStyle(color: AppColors.taskRedError, fontWeight: FontWeight.bold))),
          ],
          onChanged: (val) {
            if (val != null) controller.priority.value = val;
          },
        )),
      ],
    );
  }

  Widget _buildLabelDropdown() {
    return PopupMenuButton<dynamic>(
      onSelected: (value) {
        if (value != 'CREATE') {
          controller.selectedLabel.value = value as LabelResponse?;
        } else {
          _showCreateLabelDialog();
        }
      },
      offset: const Offset(0, 30),
      color: AppColors.taskSlateCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.taskAvatarBg),
      ),
      itemBuilder: (context) {
        List<PopupMenuEntry<dynamic>> items = controller.availableLabels.map((l) {
          Color color;
          try {
            color = Color(int.parse(l.color.replaceFirst('#', '0xFF')));
          } catch (_) {
            color = AppColors.taskBluePrimary;
          }
          return PopupMenuItem<dynamic>(
            value: l,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
                color: AppColors.taskAvatarBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Create Label', style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic)),
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
              Text('LABEL', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Icon(Icons.add, color: Colors.white, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.selectedLabel.value == null) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.taskAvatarBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Select Label',
                  style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              );
            }

            final l = controller.selectedLabel.value!;
            Color color;
            try {
              color = Color(int.parse(l.color.replaceFirst('#', '0xFF')));
            } catch (_) {
              color = AppColors.taskBluePrimary;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.name,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
        backgroundColor: AppColors.taskSlateCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.taskAvatarBg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Label',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Label Name',
                  hintStyle: const TextStyle(color: AppColors.taskTextMuted, fontSize: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.taskBluePrimary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Color',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: colors.map((colorHex) {
                  final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                  return GestureDetector(
                    onTap: () => selectedColor.value = colorHex,
                    child: Obx(() => Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor.value == colorHex ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    )),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.taskTextMuted)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isNotEmpty) {
                        controller.createLabel(nameController.text.trim(), selectedColor.value);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.taskGreenButton,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Create', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () => controller.saveChanges(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.taskGreenButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: Text(
            l10n?.save ?? 'Save Changes',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}

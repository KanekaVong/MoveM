import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/edit_task_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/dto/response/attachment_response.dart';
import 'add_collaborator_screen.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/top_tool_bar.dart';

class EditTaskScreen extends GetView<EditTaskController> {
  const EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditTaskController());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            TopToolBar(title: l10n?.editTask ?? 'Edit Task'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDeadlinesSection(context),
                    SizedBox(height: 12),
                    Container(height: 0.5, color: AppColors.textPrimary.withOpacity(0.12)),
                    SizedBox(height: 12),
                    _buildPrioritySection(context),
                    SizedBox(height: 12),
                    Container(height: 0.5, color: AppColors.textPrimary.withOpacity(0.12)),
                    SizedBox(height: 12),
                    _buildDescriptionSection(context),
                    SizedBox(height: 12),
                    Container(height: 0.5, color: AppColors.textPrimary.withOpacity(0.12)),
                    const SizedBox(height: 20),
                    _buildPropertiesCard(context),
                    const SizedBox(height: 24),
                    _buildCollaboratorsSection(context),
                    const SizedBox(height: 24),
                    _buildAttachmentsSection(context),
                    const SizedBox(height: 24),
                    _buildSaveButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlinesSection(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.pickDeadlineDate(context),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DEADLINES',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Obx(() => Text(
            controller.formattedDeadlineDate,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPrioritySection(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.cyclePriority(),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRIORITY',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
            controller.priority.value.toUpperCase(),
            style: TextStyle(
              color: _getPriorityColor(controller.priority.value),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESCRIPTION',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller.descriptionController,
          maxLines: null,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            height: 1.4,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: 'Enter task description...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LABEL',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          _buildLabels(context),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'CHECKLIST',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () => controller.addChecklistItem(),
                child: Icon(Icons.add, color: AppColors.textPrimary, size: 16),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildChecklistItems(),
          SizedBox(height: 20),
          Text(
            'REPEAT',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6),
          GestureDetector(
            onTap: () => controller.cycleRepeat(),
            child: Obx(() => Text(
              controller.repeatFrequency.value?.toUpperCase() ?? (controller.isRecurring.value ? 'DAILY' : 'DAILY'),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => controller.pickDeadlineDate(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Your Next Reminder',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.calendar_today_outlined, color: AppColors.textPrimary, size: 16),
                  ],
                ),
                Obx(() => Text(
                  controller.formattedReminderDate,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabels(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedLabel.value;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          GestureDetector(
            onTap: () => _showLabelPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF68B684),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                selected != null && selected.name.toLowerCase().contains('homework')
                    ? selected.name
                    : 'Scool Homework',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showLabelPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A76A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                selected != null && !selected.name.toLowerCase().contains('homework')
                    ? selected.name
                    : 'Final Assignment',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildChecklistItems() {
    return Obx(() => Column(
      children: controller.checklists.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final textController = item['controller'] as TextEditingController;
        final bool isCompleted = item['completed'] == true;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add an item',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.checklists[index]['completed'] = !isCompleted;
                  controller.checklists.refresh();
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isCompleted ? Color(0xFF68B684) : AppColors.textSecondary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    color: isCompleted ? const Color(0xFF68B684).withOpacity(0.2) : Colors.transparent,
                  ),
                  child: isCompleted
                      ? Icon(Icons.check, size: 14, color: Color(0xFF68B684))
                      : null,
                ),
              ),
              if (controller.checklists.length > 1) ...[
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => controller.removeChecklistItem(index),
                  child: Icon(Icons.close, color: AppColors.textCaption, size: 14),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildCollaboratorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
          'Collaborators   (${controller.collaborators.length})',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        )),
        const SizedBox(height: 12),
        Obx(() => Wrap(
          spacing: 14,
          runSpacing: 10,
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
                    if (collaborator is Map && collaborator['profilePic'] != null && (collaborator['profilePic'] as String).isNotEmpty)
                      ClipOval(
                        child: Image.network(
                          collaborator['profilePic'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.cardSurface,
                            child: Text(
                              initial,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.cardSurface,
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      name,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: GestureDetector(
                    onTap: () => controller.removeCollaborator(index),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.borderMuted,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.pageBackground, width: 1.5),
                      ),
                      child: Center(
                        child: Icon(Icons.close, size: 10, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        )),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () async {
            final result = await Get.to(
              () => const AddCollaboratorScreen(),
              arguments: {
                'activityId': controller.initialTask.activityId,
                'collaborators': controller.collaborators.toList(),
              },
            );
            if (result != null && result is List) {
              for (var c in result) {
                controller.addCollaborator(c);
              }
            } else if (result != null && result is String) {
              controller.addCollaborator(result);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.textPrimary.withOpacity(0.06)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ADD COLLABORATORS',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(Icons.add_circle_outline, color: AppColors.textPrimary, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection(BuildContext context) {
    return Obx(() {
      final totalCount = controller.existingAttachments.length + controller.pickedAttachments.length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attachments   ($totalCount)',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          if (totalCount == 0)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'No attachments added',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ...controller.existingAttachments.asMap().entries.map((entry) {
            final index = entry.key;
            final att = entry.value;
            String fileName = '';
            String rawUrl = '';
            if (att is AttachmentResponse) {
              fileName = att.originalFileName.isNotEmpty
                  ? att.originalFileName
                  : att.filePath.split('/').last;
              rawUrl = att.url ?? '';
            } else if (att is Map) {
              final orig = att['originalFileName'] ?? att['fileName'];
              fileName = (orig != null && orig.toString().isNotEmpty)
                  ? orig.toString()
                  : (att['filePath']?.toString() ?? '').split('/').last;
              rawUrl = att['url']?.toString() ?? '';
            }
            if (fileName.isEmpty) fileName = 'Attachment';

            final bool hasUrl = rawUrl.isNotEmpty && (rawUrl.startsWith('http://') || rawUrl.startsWith('https://'));

            return Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: hasUrl
                        ? CachedNetworkImage(
                            imageUrl: rawUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: 44,
                              height: 44,
                              color: AppColors.chipSurface,
                              child: Icon(Icons.image, color: AppColors.borderMuted, size: 20),
                            ),
                          )
                        : Container(
                            width: 44,
                            height: 44,
                            color: AppColors.chipSurface,
                            child: Icon(Icons.attach_file, color: AppColors.borderMuted, size: 20),
                          ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Uploaded',
                          style: TextStyle(
                            color: Color(0xFF68B684),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.removeExistingAttachment(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.close, color: AppColors.textCaption, size: 18),
                    ),
                  ),
                ],
              ),
            );
          }),
          ...controller.pickedAttachments.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            final fileName = file.name;

            return Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(file.path),
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 44,
                        height: 44,
                        color: AppColors.chipSurface,
                        child: Icon(Icons.image, color: AppColors.borderMuted, size: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Ready to upload on save',
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.removePickedAttachment(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.close, color: AppColors.textCaption, size: 18),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 14),
          GestureDetector(
            onTap: () => _showImageSourcePicker(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.textPrimary.withOpacity(0.06)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ADD ATTACHMENTS',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Icon(Icons.add_circle_outline, color: AppColors.textPrimary, size: 24),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSaveButton(BuildContext context) {
    return AppButton(
      label: 'Save Changes',
      onPressed: () => controller.saveChanges(),
    );
  }

  void _showImageSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
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
                Text(
                  'Upload Photo',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Color(0xFF3B82F6)),
                  title: Text('Choose from Gallery', style: TextStyle(color: AppColors.textPrimary)),
                  onTap: () {
                    Get.back();
                    controller.pickAttachment(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Color(0xFF68B684)),
                  title: Text('Take a Photo', style: TextStyle(color: AppColors.textPrimary)),
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

  void _showLabelPicker(BuildContext context) async {
    if (controller.availableLabels.isEmpty) {
      await controller.loadLabels();
    }
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    if (controller.availableLabels.isEmpty) {
      Get.snackbar(l10n?.labelsLabel ?? 'Labels', l10n?.noLabelsAvailable ?? 'No labels available.', backgroundColor: AppColors.textPrimary, colorText: Colors.white);
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select Label', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.availableLabels.map((l) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectedLabel.value = l;
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF68B684),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l.name,
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String? priority) {
    String p = priority?.toUpperCase() ?? 'LOW';
    if (p == 'LOW') return const Color(0xFF68B684);
    if (p == 'NORMAL' || p == 'MEDIUM') return AppColors.taskYellowPriority;
    if (p == 'HIGH' || p == 'URGENT') return AppColors.taskRedPriority;
    return const Color(0xFF68B684);
  }
}

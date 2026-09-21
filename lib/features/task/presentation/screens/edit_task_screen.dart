import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/edit_task_controller.dart';
import '../../data/dto/response/attachment_response.dart';
import 'add_collaborator_screen.dart';

class EditTaskScreen extends GetView<EditTaskController> {
  const EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditTaskController());

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDeadlinesSection(context),
                    const SizedBox(height: 12),
                    Container(height: 0.5, color: AppColors.textPrimary.withOpacity(0.12)),
                    const SizedBox(height: 12),
                    _buildPrioritySection(context),
                    const SizedBox(height: 12),
                    Container(height: 0.5, color: AppColors.textPrimary.withOpacity(0.12)),
                    const SizedBox(height: 12),
                    _buildDescriptionSection(context),
                    const SizedBox(height: 12),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x33000000),
                border: Border.all(color: AppColors.textPrimary.withOpacity(0.24), width: 1),
              ),
              child: const Center(
                child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 22),
              ),
            ),
          ),
          const Text(
            'Edit Task',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 38), // Balance row
        ],
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
          const Text(
            'DEADLINES',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
            controller.formattedDeadlineDate,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
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
          const Text(
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
              fontStyle: FontStyle.italic,
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
        const Text(
          'DESCRIPTION',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller.descriptionController,
          maxLines: null,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontStyle: FontStyle.italic,
            height: 1.4,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: 'Enter task description...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
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
          const Text(
            'LABEL',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          _buildLabels(context),
          const SizedBox(height: 20),
          Row(
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
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => controller.addChecklistItem(),
                child: const Icon(Icons.add, color: AppColors.textPrimary, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildChecklistItems(),
          const SizedBox(height: 20),
          const Text(
            'REPEAT',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => controller.cycleRepeat(),
            child: Obx(() => Text(
              controller.repeatFrequency.value?.toUpperCase() ?? (controller.isRecurring.value ? 'DAILY' : 'DAILY'),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            )),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => controller.pickDeadlineDate(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
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
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
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
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
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
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
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
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Add an item',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
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
                      color: isCompleted ? const Color(0xFF68B684) : AppColors.textSecondary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    color: isCompleted ? const Color(0xFF68B684).withOpacity(0.2) : Colors.transparent,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Color(0xFF68B684))
                      : null,
                ),
              ),
              if (controller.checklists.length > 1) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => controller.removeChecklistItem(index),
                  child: const Icon(Icons.close, color: AppColors.textCaption, size: 14),
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
          style: const TextStyle(
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
                              style: const TextStyle(
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
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
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
                      child: const Center(
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
              children: const [
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
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          if (totalCount == 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'No attachments added',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
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
                              child: const Icon(Icons.image, color: AppColors.borderMuted, size: 20),
                            ),
                          )
                        : Container(
                            width: 44,
                            height: 44,
                            color: AppColors.chipSurface,
                            child: const Icon(Icons.attach_file, color: AppColors.borderMuted, size: 20),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Uploaded',
                          style: TextStyle(
                            color: Color(0xFF68B684),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.removeExistingAttachment(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close, color: AppColors.textCaption, size: 18),
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
                        child: const Icon(Icons.image, color: AppColors.borderMuted, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Ready to upload on save',
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.removePickedAttachment(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close, color: AppColors.textCaption, size: 18),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),
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
                children: const [
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
    return GestureDetector(
      onTap: () => controller.saveChanges(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.textPrimary.withOpacity(0.35),
                width: 1.0,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4B9D62).withOpacity(0.65),
                  const Color(0xFF4B9D62).withOpacity(0.45),
                  const Color(0xFF357A49).withOpacity(0.55),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4B9D62).withOpacity(0.30),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      gradient: LinearGradient(
                        begin: const Alignment(-0.5, -1.0),
                        end: const Alignment(0.5, 1.0),
                        colors: [
                          AppColors.textPrimary.withOpacity(0.28),
                          AppColors.textPrimary.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'SAVE CHANGES',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
                const Text(
                  'Upload Photo',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFF3B82F6)),
                  title: const Text('Choose from Gallery', style: TextStyle(color: AppColors.textPrimary)),
                  onTap: () {
                    Get.back();
                    controller.pickAttachment(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Color(0xFF68B684)),
                  title: const Text('Take a Photo', style: TextStyle(color: AppColors.textPrimary)),
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
    if (controller.availableLabels.isEmpty) {
      Get.snackbar('Labels', 'No labels available.', backgroundColor: AppColors.textPrimary, colorText: Colors.white);
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
                const Text('Select Label', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
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
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
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

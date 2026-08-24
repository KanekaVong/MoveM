import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_task_controller.dart';

class CreateTaskScreen extends GetView<CreateTaskController> {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateTaskController());

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField('TASK TITLE', 'Give your Work a name', controller.titleController),
                    const SizedBox(height: 32),
                    _buildInputField('DESCRIPTION', 'Write down a note', controller.descriptionController),
                    const SizedBox(height: 32),
                    _buildPropertiesCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: () => controller.submitTask(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E293B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text('Create Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          const Text('Create Task', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
          style: const TextStyle(color: Colors.white, fontSize: 14),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2F),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.pickDeadline(Get.context!),
            child: Obx(() => _buildPropertyRow('DEADLINES', controller.formattedDeadline, Icons.calendar_today)),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => controller.addChecklistItem(),
            child: _buildActionRow('CheckList', Icons.add),
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
            children: controller.checklistControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final textController = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Icon(Icons.check_box_outline_blank, color: const Color(0xFF475569), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Add an item',
                          hintStyle: TextStyle(color: Color(0xFF475569), fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.removeChecklistItem(index),
                      child: const Icon(Icons.close, color: Color(0xFF475569), size: 18),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          _buildRepeatDropdown(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildPriorityDropdown(),
              ),
              Expanded(
                child: _buildLabelDropdown(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => controller.toggleReminders(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Get upcoming reminders about your due dates', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                Obx(() => Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: controller.remindersEnabled.value ? const Color(0xFF3B82F6) : Colors.transparent,
                    border: Border.all(color: controller.remindersEnabled.value ? const Color(0xFF3B82F6) : Colors.white),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: controller.remindersEnabled.value ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) => controller.repeatFrequency.value = value,
      offset: const Offset(0, 40),
      color: const Color(0xFF131B2F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      itemBuilder: (context) => ['Daily', 'Weekly', 'Monthly', 'Yearly']
          .map((choice) => PopupMenuItem<String>(
                value: choice,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(choice, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(height: 1, color: const Color(0xFF334155)),
                  ],
                ),
              ))
          .toList(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('REPEAT', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                controller.repeatFrequency.value ?? '', 
                style: const TextStyle(color: Color(0xFF475569), fontSize: 14, fontStyle: FontStyle.italic)
              )),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) => controller.priority.value = value,
      offset: const Offset(0, 30),
      color: const Color(0xFF131B2F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      itemBuilder: (context) => ['URGENT', 'HIGH', 'NORMAL', 'LOW']
          .map((choice) => PopupMenuItem<String>(
                value: choice,
                child: Text(choice, style: const TextStyle(color: Colors.white)),
              ))
          .toList(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('PRIORITY', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            Color pillColor = Colors.grey;
            if (controller.priority.value == 'LOW') pillColor = const Color(0xFF86EFAC);
            if (controller.priority.value == 'NORMAL') pillColor = const Color(0xFFFDE047);
            if (controller.priority.value == 'HIGH') pillColor = const Color(0xFFFCA5A5);
            if (controller.priority.value == 'URGENT') pillColor = const Color(0xFFEF4444);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: pillColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.priority.value,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
      color: const Color(0xFF131B2F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      itemBuilder: (context) {
        List<PopupMenuEntry<dynamic>> items = controller.availableLabels.map((l) {
          final color = Color(int.parse(l.color.replaceFirst('#', '0xFF')));
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

        // Add create button at bottom
        items.add(
          PopupMenuItem<dynamic>(
            value: 'CREATE',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
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
              Text('LABEL', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Icon(Icons.add, color: Colors.white, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.selectedLabel.value == null) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Select Label',
                  style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              );
            }
            
            final l = controller.selectedLabel.value!;
            final color = Color(int.parse(l.color.replaceFirst('#', '0xFF')));
            
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

  Widget _buildPropertyRow(String title, String value, IconData icon, {bool hideText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!hideText) Text(value, style: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontStyle: FontStyle.italic)),
            if (hideText) const SizedBox(),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: Colors.white),
      ],
    );
  }

  Widget _buildActionRow(String title, IconData icon) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Icon(icon, color: Colors.white, size: 16),
      ],
    );
  }

  void _showCreateLabelDialog() {
    final nameController = TextEditingController();
    final RxString selectedColor = '#3B82F6'.obs; // Default blue
    
    final List<String> colors = [
      '#EF4444', // Red
      '#F97316', // Orange
      '#F59E0B', // Amber
      '#84CC16', // Lime
      '#22C55E', // Green
      '#06B6D4', // Cyan
      '#3B82F6', // Blue
      '#8B5CF6', // Violet
      '#D946EF', // Fuchsia
      '#F43F5E', // Rose
    ];

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF131B2F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Label', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const Text('NAME', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Enter label name',
                  hintStyle: TextStyle(color: Color(0xFF475569), fontSize: 14),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF3B82F6))),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 24),
              const Text('COLOR', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
                          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
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
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        Get.snackbar('Error', 'Label name cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
                        return;
                      }
                      controller.createLabel(nameController.text.trim(), selectedColor.value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
}

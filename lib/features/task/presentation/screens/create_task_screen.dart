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
          child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('New Task', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Step 1 of 2 - detail', style: TextStyle(color: Color(0xFFA0AAB2), fontSize: 12, fontStyle: FontStyle.italic)),
            ],
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
          _buildPropertyRow('REPEAT', '', Icons.keyboard_arrow_up, hideText: true),
          const SizedBox(height: 24),
          _buildActionRow('PRIORITY', Icons.add),
          const SizedBox(height: 24),
          _buildActionRow('LABEL', Icons.add),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Get upcoming reminders about your due dates', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
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
}

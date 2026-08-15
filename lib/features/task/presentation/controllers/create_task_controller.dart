import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateTaskController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final Rx<DateTime?> deadline = Rx<DateTime?>(null);
  
  final RxList<TextEditingController> checklistControllers = <TextEditingController>[].obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    for (var controller in checklistControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> pickDeadline(BuildContext context) async {
    final initialDate = deadline.value ?? DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              surface: Color(0xFF131B2F),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      deadline.value = selectedDate;
    }
  }

  String get formattedDeadline {
    if (deadline.value == null) return 'Not set';
    return DateFormat('d MMMM yyyy').format(deadline.value!);
  }

  void addChecklistItem() {
    checklistControllers.add(TextEditingController());
  }

  void removeChecklistItem(int index) {
    if (index >= 0 && index < checklistControllers.length) {
      final controller = checklistControllers[index];
      checklistControllers.removeAt(index);
      controller.dispose();
    }
  }

  // Returns a list of strings representing the actual checklist items (ignoring empty ones)
  List<String> getChecklistItems() {
    return checklistControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
  }
}

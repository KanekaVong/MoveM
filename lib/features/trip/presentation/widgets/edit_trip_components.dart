import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/edit_trip_controller.dart';
import 'package:image_picker/image_picker.dart';

/// Reusable edit form container.
class EditTripFormPanel extends StatelessWidget {
  final Widget child;

  const EditTripFormPanel({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate850 : AppColors.lightSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.slate700 : Colors.black12,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.30 : 0.08,
            ),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            30,
            24,
            30,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Reusable edit section title.
class EditTripSectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const EditTripSectionTitle({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color:
                  isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (icon != null)
          Icon(
            icon,
            color: isDark ? AppColors.slate300 : AppColors.slate600,
            size: 22,
          ),
      ],
    );
  }
}

/// Reusable text field for edit forms.
class EditTripTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const EditTripTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    final hintColor = isDark ? AppColors.slate400 : AppColors.slate500;

    final fieldColor = isDark ? AppColors.slate800 : Colors.white;

    final borderColor = isDark ? AppColors.slate700 : AppColors.slate300;

    final iconColor = isDark ? AppColors.slate400 : AppColors.slate500;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 15,
        ),
        labelStyle: TextStyle(
          color: hintColor,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : IconTheme(
                data: IconThemeData(
                  color: iconColor,
                ),
                child: prefixIcon!,
              ),
        suffixIcon: suffixIcon == null
            ? null
            : IconTheme(
                data: IconThemeData(
                  color: iconColor,
                ),
                child: suffixIcon!,
              ),
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
      ),
    );
  }
}

/// Reusable primary action button.
class EditTripPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  const EditTripPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        isDark ? const Color(0xFFF1F5F9) : AppColors.commentBarBg;
    final textColor = isDark ? AppColors.commentBarBg : Colors.white;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          disabledBackgroundColor:
              isDark ? AppColors.slate700 : AppColors.slate200,
          disabledForegroundColor:
              isDark ? AppColors.slate300 : AppColors.slate500,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Reusable secondary/outline button.
class EditTripSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const EditTripSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          side: BorderSide(
            color: isDark ? AppColors.slate600 : AppColors.slate300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable spacing between edit form fields.
class EditTripFieldSpacing extends StatelessWidget {
  final double height;

  const EditTripFieldSpacing({
    super.key,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}


class TripNameEditPanel extends StatefulWidget {
  final EditTripController controller;

  const TripNameEditPanel({
    super.key,
    required this.controller,
  });

  @override
  State<TripNameEditPanel> createState() => _TripNameEditPanelState();
}

class _TripNameEditPanelState extends State<TripNameEditPanel> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.controller.trip.value?.activityName ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        l10n?.editTripName ?? 'Trip Name',
        l10n?.editTripNameRequired ??
            'Trip name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final success =
    await widget.controller.saveTripName(name);

    if (success) {
      Get.snackbar(
        l10n?.editTripUpdateSuccess ?? 'Success',
        l10n?.editTripNameUpdated ??
            'Trip name updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ??
            'Failed to update trip',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditTripSectionTitle(
                title: l10n?.editTripName ?? 'Trip Name',
              ),

              const EditTripFieldSpacing(height: 24),

              EditTripTextField(
                controller: _nameController,
                hintText:
                l10n?.editTripNameHint ?? 'Enter trip name',
                textInputAction: TextInputAction.done,
              ),
            ],
          ),

          Obx(
                () => EditTripPrimaryButton(
              text: l10n?.editTripSaveChanges ?? 'SAVE CHANGES',
              isLoading: widget.controller.isSaving.value,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
}


class DurationEditPanel  extends StatefulWidget {
  final EditTripController controller;

  const DurationEditPanel ({
    super.key,
    required this.controller,
  });

  @override
  State<DurationEditPanel > createState() => _DurationEditPanelState();
}

class _DurationEditPanelState extends State<DurationEditPanel > {
  DateTime? _startActivity;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();

    final trip = widget.controller.trip.value;

    _startActivity = trip?.startActivity;
    _deadline = trip?.deadline;
  }

  Future<void> _selectStartDate() async {
    final current = _startActivity ?? DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );

    if (selectedTime == null) {
      return;
    }

    final result = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      _startActivity = result;

      if (_deadline != null &&
          _deadline!.isBefore(_startActivity!)) {
        _deadline = _startActivity;
      }
    });
  }

  Future<void> _selectDeadline() async {
    final current =
        _deadline ??
            _startActivity ??
            DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: _startActivity ?? DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );

    if (selectedTime == null) {
      return;
    }

    final result = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      _deadline = result;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date and time';
    }

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} $hour:$minute';
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);

    if (_startActivity == null || _deadline == null) {
      Get.snackbar(
        l10n?.editTripSectionDuration ?? 'Duration',
        'Please select both dates',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (_deadline!.isBefore(_startActivity!)) {
      Get.snackbar(
        l10n?.editTripSectionDuration ?? 'Duration',
        'Deadline cannot be before the start date',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final success = await widget.controller.saveDuration(
      startActivity: _startActivity!,
      deadline: _deadline!,
    );

    if (success) {
      Get.snackbar(
        l10n?.editTripUpdateSuccess ?? 'Success',
        'Duration updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ?? 'Failed to update trip',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title: l10n?.editTripSectionDuration ?? 'Duration',
            icon: Icons.calendar_month_rounded,
          ),
          const EditTripFieldSpacing(height: 24),
          EditTripDateField(
            label: l10n?.editTripStartDate ?? 'Start Date',
            value: _formatDate(_startActivity),
            onTap: _selectStartDate,
          ),
          const EditTripFieldSpacing(height: 16),
          EditTripDateField(
            label: l10n?.editTripEndDate ?? 'End Date',
            value: _formatDate(_deadline),
            onTap: _selectDeadline,
          ),
          const Spacer(),
          Obx(
                () => EditTripPrimaryButton(
              text: l10n?.editTripSaveChanges ?? 'SAVE CHANGES',
              isLoading: widget.controller.isSaving.value,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
}

class EditTripDateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const EditTripDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor:
          isDark ? AppColors.slate800 : Colors.white,
          labelStyle: TextStyle(
            color: isDark
                ? AppColors.slate400
                : AppColors.slate500,
          ),
          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            color: isDark
                ? AppColors.slate400
                : AppColors.slate500,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.slate700
                  : AppColors.slate300,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isDark
                ? AppColors.darkOnSurface
                : AppColors.lightOnSurface,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class StopsEditPanel extends StatelessWidget {
  final EditTripController controller;

  const StopsEditPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title: l10n?.editTripSectionStops ?? 'Stops',
            icon: Icons.location_on_rounded,
          ),

          const EditTripFieldSpacing(height: 12),

          Text(
            l10n?.editTripReorderStops ??
                'Drag to reorder stops',
            style: TextStyle(
              color: isDark
                  ? AppColors.slate400
                  : AppColors.slate500,
              fontSize: 13,
            ),
          ),

          const EditTripFieldSpacing(height: 16),

          Expanded(
            child: Obx(() {
              final stops = controller.stops;

              if (stops.isEmpty) {
                return Center(
                  child: Text(
                    l10n?.editTripNoStopsAdded ??
                        'No stops added',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.slate400
                          : AppColors.slate500,
                    ),
                  ),
                );
              }

              return ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: stops.length,
                onReorder: (oldIndex, newIndex) async {
                  await controller.reorderStops(
                    oldIndex,
                    newIndex,
                  );
                },
                itemBuilder: (context, index) {
                  final stop = stops[index];

                  final stopName =
                  stop.locationName?.trim().isNotEmpty == true
                      ? stop.locationName!
                      : l10n?.editTripUnnamedStop ??
                      'Unnamed stop';

                  final address =
                  stop.locationAddress?.trim();

                  return Container(
                    key: ValueKey(
                      stop.id ?? 'stop_$index',
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.slate800
                          : Colors.white,
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.slate700
                            : AppColors.slate300,
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.slate700
                              : AppColors.slate100,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        stopName,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                      subtitle: address == null ||
                          address.isEmpty
                          ? null
                          : Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Text(
                          address,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.slate400
                                : AppColors.slate500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: Icon(
                          Icons.drag_handle_rounded,
                          color: isDark
                              ? AppColors.slate400
                              : AppColors.slate500,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class PackingEditPanel extends StatefulWidget {
  final EditTripController controller;

  const PackingEditPanel({
    super.key,
    required this.controller,
  });

  @override
  State<PackingEditPanel> createState() =>
      _PackingEditPanelState();
}

class _PackingEditPanelState extends State<PackingEditPanel> {
  late final TextEditingController _itemController;

  @override
  void initState() {
    super.initState();

    _itemController = TextEditingController();
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    final l10n = AppLocalizations.of(context);
    final itemName = _itemController.text.trim();

    if (itemName.isEmpty) {
      Get.snackbar(
        l10n?.editTripItem ?? 'Item',
        l10n?.editTripItem ?? 'Please enter an item',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success =
    await widget.controller.addPackingItem(itemName);

    if (success) {
      _itemController.clear();

      Get.snackbar(
        l10n?.editTripUpdateSuccess ?? 'Success',
        l10n?.editTripAddItem ?? 'Item added',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ??
            'Failed to add item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _toggleItem(int itemId) async {
    final success =
    await widget.controller.togglePackingItem(itemId);

    if (!success && mounted) {
      final l10n = AppLocalizations.of(context);

      Get.snackbar(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ??
            'Failed to update item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title:
            l10n?.editTripSectionPacking ??
                'Packing Items',
            icon: Icons.backpack_rounded,
          ),

          const EditTripFieldSpacing(height: 20),

          Row(
            children: [
              Expanded(
                child: EditTripTextField(
                  controller: _itemController,
                  hintText:
                  l10n?.editTripAddItem ??
                      'Add Item',
                  textInputAction:
                  TextInputAction.done,
                  onSubmitted: (_) => _addItem(),
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                height: 50,
                width: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFFF1F5F9)
                        : AppColors.commentBarBg,
                    foregroundColor: isDark
                        ? AppColors.darkOnPrimary
                        : Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _addItem,
                  child: const Icon(
                    Icons.add_rounded,
                  ),
                ),
              ),
            ],
          ),

          const EditTripFieldSpacing(height: 16),

          Expanded(
            child: Obx(() {
              final items =
                  widget.controller.packingItems;

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    l10n?.editTripNoPackingItems ??
                        'No packing items yet',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.slate400
                          : AppColors.slate500,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Container(
                    key: ValueKey(
                      item.id ?? 'packing_$index',
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.slate800
                          : Colors.white,
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.slate700
                            : AppColors.slate300,
                      ),
                    ),
                    child: CheckboxListTile(
                      value: item.isPacked ?? false,
                      onChanged: item.id == null
                          ? null
                          : (_) => _toggleItem(
                        item.id!,
                      ),
                      controlAffinity:
                      ListTileControlAffinity.leading,
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      title: Text(
                        item.itemName ??
                            l10n?.editTripUnnamedStop ??
                            'Unnamed item',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w500,
                          decoration:
                          (item.isPacked ?? false)
                              ? TextDecoration
                              .lineThrough
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ChecklistEditPanel extends StatefulWidget {
  final EditTripController controller;

  const ChecklistEditPanel({
    super.key,
    required this.controller,
  });

  @override
  State<ChecklistEditPanel> createState() =>
      _ChecklistEditPanelState();
}

class _ChecklistEditPanelState
    extends State<ChecklistEditPanel> {
  late final TextEditingController _itemController;

  @override
  void initState() {
    super.initState();

    _itemController = TextEditingController();
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }


  Future<void> _addItem() async {
    final l10n = AppLocalizations.of(context);
    final itemName = _itemController.text.trim();

    if (itemName.isEmpty) {
      Get.snackbar(
        l10n?.editTripItem ?? 'Item',
        'Please enter a checklist item',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success =
    await widget.controller.addChecklist(itemName);

    if (success) {
      _itemController.clear();

      Get.snackbar(
        l10n?.editTripUpdateSuccess ?? 'Success',
        l10n?.editTripAddItem ?? 'Item added',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ??
            'Failed to add checklist item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _toggleItem(
      BuildContext context,
      int checklistId,
      ) async {
    final success =
    await widget.controller.toggleChecklist(checklistId);

    if (!success && context.mounted) {
      final l10n = AppLocalizations.of(context);

      Get.snackbar(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ??
            'Failed to update checklist',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _editItem(
      BuildContext context,
      int checklistId,
      String currentName,
      ) async {
    final l10n = AppLocalizations.of(context);

    final textController =
    TextEditingController(text: currentName);

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n?.editTripChecklist ?? 'Checklist',
          ),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n?.editTripItem ?? 'Item',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  textController.text.trim(),
                );
              },
              child: Text(
                l10n?.editTripSaveChanges ??
                    'SAVE CHANGES',
              ),
            ),
          ],
        );
      },
    );

    if (newName == null || newName.isEmpty) {
      return;
    }

    final success = await widget.controller.updateChecklist(
      checklistId,
      newName,
    );

    if (!context.mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }

      Get.snackbar(
        success
            ? (l10n?.editTripUpdateSuccess ?? 'Success')
            : (l10n?.error ?? 'Error'),
        success
            ? 'Checklist updated'
            : (l10n?.editTripUpdateFailed ??
            'Failed to update checklist'),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title:
            l10n?.editTripSectionChecklist ??
                'Checklist',
            icon: Icons.checklist_rounded,
          ),

      const EditTripFieldSpacing(height: 20),

      Row(
        children: [
          Expanded(
            child: EditTripTextField(
              controller: _itemController,
              hintText:
              l10n?.editTripAddItem ??
                  'Add Item',
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addItem(),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            height: 50,
            width: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFFF1F5F9)
                    : AppColors.commentBarBg,
                foregroundColor: isDark
                    ? AppColors.darkOnPrimary
                    : Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _addItem,
              child: const Icon(
                Icons.add_rounded,
              ),
            ),
          ),
        ],
      ),

          const EditTripFieldSpacing(height: 16),

          Expanded(
            child: Obx(() {
              final items = widget.controller.checklists;

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    l10n?.editTripNoChecklistItems ??
                        'No checklist items yet',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.slate400
                          : AppColors.slate500,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Container(
                    key: ValueKey(
                      item.id ?? 'checklist_$index',
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.slate800
                          : Colors.white,
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.slate700
                            : AppColors.slate300,
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      leading: Checkbox(
                        value: item.completed,
                        onChanged: item.id == null
                            ? null
                            : (_) => _toggleItem(
                          context,
                          item.id!,
                        ),
                      ),
                      title: Text(
                        item.itemName ?? '',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: item.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (item.id == null) {
                            return;
                          }

                          if (value == 'edit') {
                            _editItem(
                              context,
                              item.id!,
                              item.itemName ?? '',
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AttachmentsEditPanel extends StatefulWidget {
  final EditTripController controller;

  const AttachmentsEditPanel({
    super.key,
    required this.controller,
  });

  @override
  State<AttachmentsEditPanel> createState() =>
      _AttachmentsEditPanelState();
}

class _AttachmentsEditPanelState
    extends State<AttachmentsEditPanel> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadAttachment() async {
    final l10n = AppLocalizations.of(context);

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    final file = await dio.MultipartFile.fromFile(
      image.path,
      filename: image.name,
    );

    final success =
    await widget.controller.uploadAttachment(file);

    if (!mounted) {
      return;
    }

    Get.snackbar(
      success
          ? (l10n?.editTripUpdateSuccess ?? 'Success')
          : (l10n?.error ?? 'Error'),
      success
          ? 'Attachment uploaded'
          : (l10n?.editTripUpdateFailed ??
          'Failed to upload attachment'),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title:
            l10n?.editTripSectionAttachments ??
                'Attachments',
            icon: Icons.attach_file_rounded,
          ),

          const EditTripFieldSpacing(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFFF1F5F9)
                    : AppColors.commentBarBg,
                foregroundColor: isDark
                    ? AppColors.darkOnPrimary
                    : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
              onPressed: _uploadAttachment,
              icon: const Icon(
                Icons.upload_file_rounded,
              ),
              label: Text(
                l10n?.editTripUploadAttachment ??
                    'Upload Attachment',
              ),
            ),
          ),

          const EditTripFieldSpacing(height: 16),

          Expanded(
            child: Obx(() {
              final items =
                  widget.controller.attachments;

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    l10n?.editTripNoAttachments ??
                        'No attachments yet',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.slate400
                          : AppColors.slate500,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];

                  final isImage =
                      item.fileType?.startsWith('image/') == true;

                  return Container(
                    key: ValueKey(
                      item.id ??
                          'attachment_$index',
                    ),
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.slate800
                          : Colors.white,
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.slate700
                            : AppColors.slate300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.slate700
                                : AppColors.slate100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: isImage &&
                              item.url != null &&
                              item.url!.isNotEmpty
                              ? Image.network(
                            item.url!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Icon(
                                Icons.broken_image_rounded,
                                color: isDark
                                    ? AppColors.slate300
                                    : AppColors.slate600,
                              );
                            },
                          )
                              : Icon(
                            Icons.insert_drive_file_rounded,
                            color: isDark
                                ? AppColors.slate300
                                : AppColors.slate600,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.originalFileName ??
                                    'Attachment',
                                maxLines: 2,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors
                                      .darkOnSurface
                                      : AppColors
                                      .lightOnSurface,
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),

                              if (item.fileType != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.fileType!,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.slate400
                                        : AppColors.slate500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
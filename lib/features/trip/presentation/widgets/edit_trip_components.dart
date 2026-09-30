import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/edit_trip_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/dto/response/trip_member_response.dart';
import '../../../groups/data/dto/response/pending_invite_response.dart';
import '../../data/dto/response/trip_stop_response.dart';
import 'dart:async';
import 'package:movem/core/config/google_map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:movem/features/trip/data/services/google_places_service.dart';
import 'package:movem/core/utils/app_snack.dart';

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
      AppSnack.show(
        l10n?.editTripName ?? 'Trip Name',
        l10n?.editTripNameRequired ?? 'Trip name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final success = await widget.controller.saveTripName(name);

    if (success) {
      AppSnack.show(
        l10n?.editTripUpdateSuccess ?? 'Success',
        l10n?.editTripNameUpdated ?? 'Trip name updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      AppSnack.show(
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
                hintText: l10n?.editTripNameHint ?? 'Enter trip name',
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

class DurationEditPanel extends StatefulWidget {
  final EditTripController controller;

  const DurationEditPanel({
    super.key,
    required this.controller,
  });

  @override
  State<DurationEditPanel> createState() => _DurationEditPanelState();
}

class _DurationEditPanelState extends State<DurationEditPanel> {
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

      if (_deadline != null && _deadline!.isBefore(_startActivity!)) {
        _deadline = _startActivity;
      }
    });
  }

  Future<void> _selectDeadline() async {
    final current = _deadline ?? _startActivity ?? DateTime.now();

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
      AppSnack.show(
        l10n?.editTripSectionDuration ?? 'Duration',
        'Please select both dates',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (_deadline!.isBefore(_startActivity!)) {
      AppSnack.show(
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
      AppSnack.show(
        l10n?.editTripUpdateSuccess ?? 'Success',
        'Duration updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      AppSnack.show(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isDark ? AppColors.slate800 : Colors.white,
          labelStyle: TextStyle(
            color: isDark ? AppColors.slate400 : AppColors.slate500,
          ),
          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            color: isDark ? AppColors.slate400 : AppColors.slate500,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? AppColors.slate700 : AppColors.slate300,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class MembersEditPanel extends StatelessWidget {
  final EditTripController controller;
  final VoidCallback onInviteFriend;

  const MembersEditPanel({
    super.key,
    required this.controller,
    required this.onInviteFriend,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    final secondaryTextColor = isDark ? AppColors.slate400 : AppColors.slate500;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title: l10n?.tripMembers ?? 'Trip Members',
            icon: Icons.group_rounded,
          ),
          const EditTripFieldSpacing(height: 18),
          Expanded(
            child: Obx(() {
              final members = controller.members;
              final pendingInvites = controller.pendingInvites;

              final hasMembers = members.isNotEmpty;
              final hasPending = pendingInvites.isNotEmpty;

              if (!hasMembers && !hasPending) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.group_outlined,
                        size: 44,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n?.noMembersYet ?? 'No members yet',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (hasMembers) ...[
                    ...members.map(
                      (member) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MemberItem(
                          member: member,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ],
                  if (hasPending) ...[
                    const SizedBox(height: 8),
                    _MembersSubsectionTitle(
                      title: l10n?.pendingInvitations ?? 'Pending Invitations',
                      icon: Icons.schedule_rounded,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    ...pendingInvites.map(
                      (invite) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PendingInviteItem(
                          invite: invite,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onInviteFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? const Color(0xFFF1F5F9) : AppColors.commentBarBg,
                foregroundColor:
                    isDark ? AppColors.darkOnPrimary : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.person_add_alt_1,
                size: 19,
              ),
              label: Text(
                l10n?.inviteFriend ?? 'Invite Friend',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MembersSubsectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;

  const _MembersSubsectionTitle({
    required this.title,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.slate300 : AppColors.slate600,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.slate300 : AppColors.slate600,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MemberItem extends StatelessWidget {
  final TripMemberResponse member;
  final bool isDark;

  const _MemberItem({
    required this.member,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = '${member.firstname} ${member.lastname}'.trim();

    final displayName = fullName.isEmpty ? member.username : fullName;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate300,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isDark ? AppColors.slate700 : AppColors.slate100,
            backgroundImage: member.profilePic.isNotEmpty
                ? NetworkImage(member.profilePic)
                : null,
            child: member.profilePic.isEmpty
                ? Icon(
                    Icons.person_rounded,
                    color: isDark ? AppColors.slate300 : AppColors.slate600,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '@${member.username}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? AppColors.slate400 : AppColors.slate500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.slate700 : AppColors.slate100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              member.role,
              style: TextStyle(
                color: isDark ? AppColors.slate300 : AppColors.slate600,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingInviteItem extends StatelessWidget {
  final PendingInviteResponse invite;
  final bool isDark;

  const _PendingInviteItem({
    required this.invite,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final backgroundColor = isDark ? AppColors.slate800 : Colors.white;

    final borderColor = isDark ? AppColors.slate700 : AppColors.slate300;

    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    final secondaryTextColor = isDark ? AppColors.slate400 : AppColors.slate500;

    final initial = invite.inviteeUsername.isNotEmpty
        ? invite.inviteeUsername[0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isDark ? AppColors.slate700 : AppColors.slate100,
            child: Text(
              initial,
              style: TextStyle(
                color: isDark ? AppColors.slate200 : AppColors.slate600,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${invite.inviteeUsername}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (invite.inviteeEmail != null &&
                    invite.inviteeEmail!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    invite.inviteeEmail!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.slate700 : AppColors.slate100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              l10n?.pending ?? 'Pending',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StopsEditPanel extends StatefulWidget {
  final EditTripController controller;

  const StopsEditPanel({
    super.key,
    required this.controller,
  });

  @override
  State<StopsEditPanel> createState() => _StopsEditPanelState();
}

class _StopsEditPanelState extends State<StopsEditPanel> {
  final GooglePlacesService _placesService = GooglePlacesService();

  final TextEditingController _searchController = TextEditingController();

  GoogleMapController? _mapController;

  Timer? _autocompleteTimer;

  bool _hasPermission = false;
  bool _isGettingLocation = false;
  bool _isSearching = false;
  bool _isResolvingLocation = false;

  List<GooglePlacePrediction> _suggestions = [];

  static const LatLng _defaultLocation = LatLng(
    11.5564,
    104.9282,
  );

  LatLng _initialPosition = _defaultLocation;
  LatLng? _selectedLocation;

  int? _editingStopId;
  String? _selectedLocationName;
  String? _selectedLocationAddress;
  String? _selectedGooglePlaceId;

  @override
  void dispose() {
    _autocompleteTimer?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<bool> _ensureLocationPermission() async {
    var status = await Permission.location.status;

    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    if (!status.isGranted) {
      return false;
    }

    if (mounted) {
      setState(() {
        _hasPermission = true;
      });
    }

    return true;
  }

  Future<void> _checkLocationPermission() async {
    final granted = await _ensureLocationPermission();

    if (!granted) return;

    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    final granted = await _ensureLocationPermission();

    if (!granted) return;

    if (mounted) {
      setState(() {
        _isGettingLocation = true;
      });
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      _initialPosition = location;

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          location,
          15.0,
        ),
      );
    } catch (_) {
    } finally {
      if (!mounted) return;

      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    controller.setMapStyle(
      GoogleMapStyle.darkMapStyle,
    );

    final target = _selectedLocation ?? _initialPosition;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        target,
        _selectedLocation != null ? 15.0 : 12.0,
      ),
    );
  }

  void _onMapTap(LatLng position) {
    _resolveCoordinates(position);
  }

  Future<void> _resolveCoordinates(
    LatLng location,
  ) async {
    if (_isResolvingLocation) return;

    if (mounted) {
      setState(() {
        _isResolvingLocation = true;
      });
    }

    try {
      final result = await _placesService.reverseGeocode(
        location.latitude,
        location.longitude,
      );

      if (!mounted) return;

      setState(() {
        _selectedLocation = LatLng(
          result.latitude,
          result.longitude,
        );

        _selectedLocationName = result.name.trim();
        _selectedLocationAddress = result.address;
        _selectedGooglePlaceId = result.placeId;

        _searchController.text = result.name.trim();
        _suggestions = [];
      });

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            result.latitude,
            result.longitude,
          ),
          14.0,
        ),
      );
    } catch (_) {
      _showMessage(
        AppLocalizations.of(context)?.tripLocationNotFound ??
            'Location not found',
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isResolvingLocation = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _autocompleteTimer?.cancel();

    final query = value.trim();

    if (query.isEmpty) {
      _placesService.resetSession();

      setState(() {
        _suggestions = [];
        _isSearching = false;
      });

      return;
    }

    if (query.length < 3) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });

      return;
    }

    setState(() {
      _isSearching = true;
    });

    _autocompleteTimer = Timer(
      const Duration(milliseconds: 400),
      () {
        _loadSuggestions(query);
      },
    );
  }

  Future<void> _loadSuggestions(String query) async {
    try {
      final results = await _placesService.autocomplete(query);

      if (!mounted) return;

      if (_searchController.text.trim() != query) {
        return;
      }

      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
    }
  }

  Future<void> _selectPrediction(
    GooglePlacePrediction prediction,
  ) async {
    FocusScope.of(context).unfocus();

    _autocompleteTimer?.cancel();

    if (mounted) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
    }

    try {
      final details = await _placesService.getPlaceDetails(
        prediction.placeId,
      );

      if (!mounted) return;

      final location = LatLng(
        details.latitude,
        details.longitude,
      );

      setState(() {
        _selectedLocation = location;
        _selectedLocationName = details.name.trim();
        _selectedLocationAddress = details.address;
        _selectedGooglePlaceId = details.placeId;

        _searchController.text = details.name.trim();
      });

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          location,
          14.0,
        ),
      );
    } catch (_) {
      _showMessage(
        AppLocalizations.of(context)?.tripLocationSearchFailed ??
            'Location search failed',
      );
    }
  }

  Future<void> _addStop() async {
    final location = _selectedLocation;
    final locationName = _selectedLocationName;

    if (location == null ||
        locationName == null ||
        locationName.trim().isEmpty) {
      return;
    }

    if (_editingStopId != null) {
      final success = await widget.controller.updateTripStop(
        stopId: _editingStopId!,
        locationName: locationName,
        locationAddress: _selectedLocationAddress,
        lat: location.latitude,
        lng: location.longitude,
        googlePlaceId: _selectedGooglePlaceId,
      );

      if (!mounted) {
        return;
      }

      final l10n = AppLocalizations.of(context);

      Get.snackbar(
        success
            ? (l10n?.editTripUpdateSuccess ?? 'Success')
            : (l10n?.error ?? 'Error'),
        success
            ? 'Stop updated successfully'
            : (l10n?.editTripUpdateFailed ?? 'Failed to update stop'),
        snackPosition: SnackPosition.BOTTOM,
      );

      if (success) {
        setState(() {
          _editingStopId = null;
          _selectedLocation = null;
          _selectedLocationName = null;
          _selectedLocationAddress = null;
          _selectedGooglePlaceId = null;
          _searchController.clear();
          _suggestions = [];
        });

        _placesService.resetSession();
      }

      return;
    }

    final success = await widget.controller.addTripStop(
      locationName: locationName,
      sequenceOrder: widget.controller.stops.length + 1,
      locationAddress: _selectedLocationAddress,
      lat: location.latitude,
      lng: location.longitude,
      googlePlaceId: _selectedGooglePlaceId,
    );

    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context);

    Get.snackbar(
      success
          ? (l10n?.editTripUpdateSuccess ?? 'Success')
          : (l10n?.error ?? 'Error'),
      success
          ? (l10n?.editTripAddStopSuccess ?? 'Stop added successfully')
          : (l10n?.editTripUpdateFailed ?? 'Failed to add stop'),
      snackPosition: SnackPosition.BOTTOM,
    );

    if (success) {
      setState(() {
        _selectedLocation = null;
        _selectedLocationName = null;
        _selectedLocationAddress = null;
        _selectedGooglePlaceId = null;
        _searchController.clear();
        _suggestions = [];
      });

      _placesService.resetSession();
    }
  }

  Future<void> _deleteStop(
    BuildContext context,
    int stopId,
  ) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n?.editTripDeleteStop ?? 'Delete Stop',
          ),
          content: Text(
            l10n?.editTripDeleteStopConfirmation ??
                'Are you sure you want to delete this stop?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final success = await widget.controller.deleteTripStop(stopId);

    if (!context.mounted) {
      return;
    }

    Get.snackbar(
      success
          ? (l10n?.editTripUpdateSuccess ?? 'Success')
          : (l10n?.error ?? 'Error'),
      success
          ? (l10n?.editTripDeleteStop ?? 'Stop deleted')
          : (l10n?.editTripUpdateFailed ?? 'Failed to delete stop'),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _editStop(
    BuildContext context,
    TripStopResponse stop,
  ) async {
    if (stop.id == null || stop.lat == null || stop.lng == null) {
      Get.snackbar(
        'Error',
        'This stop does not have a valid location.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _editingStopId = stop.id;
      _selectedLocation = LatLng(
        stop.lat!,
        stop.lng!,
      );
      _selectedLocationName = stop.locationName;
      _selectedLocationAddress = stop.locationAddress;
      _selectedGooglePlaceId = stop.googlePlaceId;
      _searchController.text = stop.locationName ?? '';
      _suggestions = [];
    });

    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          stop.lat!,
          stop.lng!,
        ),
        14.0,
      ),
    );

    _placesService.resetSession();
  }

  Widget _buildSearchOverlay(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          color: const Color(0xE6151D2D),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: l10n.tripLocationSearchHint,
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                  ),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : (_searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();

                                setState(() {
                                  _suggestions = [];
                                  _isSearching = false;
                                  _selectedLocation = null;
                                  _selectedLocationName = null;
                                  _selectedLocationAddress = null;
                                  _selectedGooglePlaceId = null;
                                });

                                _placesService.resetSession();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                              ),
                            )
                          : null),
                  filled: true,
                  fillColor: const Color(0x99171E2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              if (_suggestions.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 250,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xF2171E2D),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.white.withValues(
                        alpha: 0.08,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final prediction = _suggestions[index];

                      return ListTile(
                        onTap: () => _selectPrediction(
                          prediction,
                        ),
                        leading: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                          size: 21,
                        ),
                        title: Text(
                          prediction.primaryText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: prediction.secondaryText == null
                            ? null
                            : Text(
                                prediction.secondaryText!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EditTripFormPanel(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditTripSectionTitle(
              title: l10n?.editTripSectionStops ?? 'Stops',
              icon: Icons.location_on_rounded,
            ),
            const EditTripFieldSpacing(height: 12),
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 12.0,
                      ),
                      onMapCreated: _onMapCreated,
                      onTap: _onMapTap,
                      myLocationEnabled: _hasPermission,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      markers: _selectedLocation == null
                          ? {}
                          : {
                              Marker(
                                markerId: const MarkerId(
                                  'selected-location',
                                ),
                                position: _selectedLocation!,
                              ),
                            },
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: _buildSearchOverlay(
                        context,
                        l10n!,
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Column(
                        children: [
                          _buildMapControl(
                            icon: Icons.add,
                            onTap: () async {
                              await _mapController?.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildMapControl(
                            icon: Icons.remove,
                            onTap: () async {
                              await _mapController?.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildMapControl(
                            icon: Icons.my_location,
                            onTap: _getCurrentLocation,
                          ),
                        ],
                      ),
                    ),
                    if (_isResolvingLocation)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.15),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const EditTripFieldSpacing(height: 12),
            if (_selectedLocationName != null)
              Text(
                _selectedLocationName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (_selectedLocationAddress != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _selectedLocationAddress!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? AppColors.slate400 : AppColors.slate500,
                    fontSize: 12,
                  ),
                ),
              ),
            const EditTripFieldSpacing(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedLocation == null ? null : _addStop,
                icon: const Icon(
                  Icons.add_location_alt_rounded,
                ),
                label: Text(
                  _editingStopId != null
                      ? 'Save Changes'
                      : (l10n?.editTripAddStop ?? 'Add Stop'),
                ),
              ),
            ),
            const EditTripFieldSpacing(height: 16),
            Text(
              l10n?.editTripReorderStops ?? 'Drag to reorder stops',
              style: TextStyle(
                color: isDark ? AppColors.slate400 : AppColors.slate500,
                fontSize: 13,
              ),
            ),
            const EditTripFieldSpacing(height: 12),
            Obx(() {
              final stops = widget.controller.stops;

              if (stops.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: Center(
                    child: Text(
                      l10n?.editTripNoStopsAdded ?? 'No stops added',
                      style: TextStyle(
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                  ),
                );
              }

              return ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: stops.length,
                onReorder: (oldIndex, newIndex) async {
                  await widget.controller.reorderStops(
                    oldIndex,
                    newIndex,
                  );
                },
                itemBuilder: (context, index) {
                  final stop = stops[index];

                  final stopName = stop.locationName?.trim().isNotEmpty == true
                      ? stop.locationName!
                      : l10n?.editTripUnnamedStop ?? 'Unnamed stop';

                  final address = stop.locationAddress?.trim();

                  return Container(
                    key: ValueKey(
                      stop.id ?? 'stop_$index',
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.slate800 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.slate700 : AppColors.slate300,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.slate700 : AppColors.slate100,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface,
                            fontWeight: FontWeight.w700,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: address == null || address.isEmpty
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.slate400
                                      : AppColors.slate500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editStop(
                                  context,
                                  stop,
                                );
                              }

                              if (value == 'delete' && stop.id != null) {
                                _deleteStop(
                                  context,
                                  stop.id!,
                                );
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                          ReorderableDragStartListener(
                            index: index,
                            child: Icon(
                              Icons.drag_handle_rounded,
                              color: isDark
                                  ? AppColors.slate400
                                  : AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
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
  State<PackingEditPanel> createState() => _PackingEditPanelState();
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
      AppSnack.show(
        l10n?.editTripItem ?? 'Item',
        l10n?.editTripItem ?? 'Please enter an item',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await widget.controller.addPackingItem(itemName);

    if (success) {
      _itemController.clear();

      AppSnack.show(
        l10n?.editTripUpdateSuccess ?? 'Success',
        l10n?.editTripAddItem ?? 'Item added',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      AppSnack.show(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ?? 'Failed to add item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _toggleItem(int itemId) async {
    final success = await widget.controller.togglePackingItem(itemId);

    if (!success && mounted) {
      final l10n = AppLocalizations.of(context);

      AppSnack.show(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ?? 'Failed to update item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> _deleteItem(int itemId) async {
    return await widget.controller.deletePackingItem(itemId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title: l10n?.editTripSectionPacking ?? 'Packing Items',
            icon: Icons.backpack_rounded,
          ),
          const EditTripFieldSpacing(height: 20),

          Row(
            children: [
              Expanded(
                child: EditTripTextField(
                  controller: _itemController,
                  hintText: l10n?.editTripAddItem ?? 'Add Item',
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
                    foregroundColor:
                        isDark ? AppColors.darkOnPrimary : Colors.white,
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
              final items = widget.controller.packingItems;

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    l10n?.editTripNoPackingItems ?? 'No packing items yet',
                    style: TextStyle(
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Material(
                    color: isDark ? AppColors.slate800 : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              isDark ? AppColors.slate700 : AppColors.slate300,
                        ),
                      ),
                      child: CheckboxListTile(
                        value: item.isPacked ?? false,
                        onChanged: item.id == null
                            ? null
                            : (_) => _toggleItem(item.id!),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
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
                            fontWeight: FontWeight.w500,
                            decoration: (item.isPacked ?? false)
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        secondary: item.id == null
                            ? null
                            : IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () async {
                                  final success = await _deleteItem(item.id!);

                                  if (!mounted) return;

                                  if (success) {
                                    Get.snackbar(
                                      l10n?.editTripUpdateSuccess ?? 'Success',
                                      '${item.itemName ?? 'Item'} deleted',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    Get.snackbar(
                                      l10n?.error ?? 'Error',
                                      l10n?.editTripUpdateFailed ??
                                          'Failed to delete item',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
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
  State<ChecklistEditPanel> createState() => _ChecklistEditPanelState();
}

class _ChecklistEditPanelState extends State<ChecklistEditPanel> {
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
      AppSnack.show(
        l10n?.editTripItem ?? 'Item',
        'Please enter a checklist item',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await widget.controller.addChecklist(itemName);

    if (success) {
      _itemController.clear();

      AppSnack.show(
        l10n?.editTripUpdateSuccess ?? 'Success',
        l10n?.editTripAddItem ?? 'Item added',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      AppSnack.show(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ?? 'Failed to add checklist item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _toggleItem(
    BuildContext context,
    int checklistId,
  ) async {
    final success = await widget.controller.toggleChecklist(checklistId);

    if (!success && context.mounted) {
      final l10n = AppLocalizations.of(context);

      AppSnack.show(
        l10n?.error ?? 'Error',
        l10n?.editTripUpdateFailed ?? 'Failed to update checklist',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _deleteItem(
    BuildContext context,
    int checklistId,
  ) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n?.editTripDeleteChecklist ?? 'Delete Checklist',
          ),
          content: Text(
            l10n?.editTripDeleteChecklistConfirm ??
                'Are you sure you want to delete this checklist item?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                l10n?.editTripCancel ?? 'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                l10n?.editTripDelete ?? 'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final success = await widget.controller.deleteChecklist(
      checklistId,
    );

    if (!context.mounted) {
      return;
    }

    Get.snackbar(
      success
          ? (l10n?.editTripUpdateSuccess ?? 'Success')
          : (l10n?.error ?? 'Error'),
      success
          ? (l10n?.editTripDeleteChecklistSuccess ??
              'Checklist deleted successfully')
          : (l10n?.editTripDeleteChecklistFailed ??
              'Failed to delete checklist item'),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _editItem(
    BuildContext context,
    int checklistId,
    String currentName,
  ) async {
    final l10n = AppLocalizations.of(context);

    final textController = TextEditingController(text: currentName);

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
                l10n?.editTripSaveChanges ?? 'SAVE CHANGES',
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

      AppSnack.show(
        success
            ? (l10n?.editTripUpdateSuccess ?? 'Success')
            : (l10n?.error ?? 'Error'),
        success
            ? 'Checklist updated'
            : (l10n?.editTripUpdateFailed ?? 'Failed to update checklist'),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title: l10n?.editTripSectionChecklist ?? 'Checklist',
            icon: Icons.checklist_rounded,
          ),
          const EditTripFieldSpacing(height: 20),
          Row(
            children: [
              Expanded(
                child: EditTripTextField(
                  controller: _itemController,
                  hintText: l10n?.editTripAddItem ?? 'Add Item',
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
                    foregroundColor:
                        isDark ? AppColors.darkOnPrimary : Colors.white,
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
                    l10n?.editTripNoChecklistItems ?? 'No checklist items yet',
                    style: TextStyle(
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Container(
                    key: ValueKey(
                      item.id ?? 'checklist_$index',
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.slate800 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.slate700 : AppColors.slate300,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
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

                          if (value == 'delete') {
                            _deleteItem(
                              context,
                              item.id!,
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(
                              l10n?.editTripEdit ?? 'Edit',
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              l10n?.editTripDelete ?? 'Delete',
                            ),
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
  State<AttachmentsEditPanel> createState() => _AttachmentsEditPanelState();
}

class _AttachmentsEditPanelState extends State<AttachmentsEditPanel> {
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

    final success = await widget.controller.uploadAttachment(file);

    if (!mounted) {
      return;
    }

    AppSnack.show(
      success
          ? (l10n?.editTripUpdateSuccess ?? 'Success')
          : (l10n?.error ?? 'Error'),
      success
          ? 'Attachment uploaded'
          : (l10n?.editTripUpdateFailed ?? 'Failed to upload attachment'),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EditTripFormPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditTripSectionTitle(
            title: l10n?.editTripSectionAttachments ?? 'Attachments',
            icon: Icons.attach_file_rounded,
          ),

          const EditTripFieldSpacing(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? const Color(0xFFF1F5F9) : AppColors.commentBarBg,
                foregroundColor:
                    isDark ? AppColors.darkOnPrimary : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _uploadAttachment,
              icon: const Icon(
                Icons.upload_file_rounded,
              ),
              label: Text(
                l10n?.editTripUploadAttachment ?? 'Upload Attachment',
              ),
            ),
          ),

          const EditTripFieldSpacing(height: 16),

          Expanded(
            child: Obx(() {
              final items = widget.controller.attachments;

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    l10n?.editTripNoAttachments ?? 'No attachments yet',
                    style: TextStyle(
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];

                  final isImage = item.fileType?.startsWith('image/') == true;

                  return Container(
                    key: ValueKey(
                      item.id ?? 'attachment_$index',
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.slate800 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.slate700 : AppColors.slate300,
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
                                  item.filePath != null &&
                                  item.filePath!.isNotEmpty
                              ? Image.network(
                                  item.filePath!,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.originalFileName ?? 'Attachment',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkOnSurface
                                      : AppColors.lightOnSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
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

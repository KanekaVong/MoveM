import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// `builder` for showDatePicker / showTimePicker / showDateRangePicker.
///
/// Gives every picker the same look and keeps its text readable in both
/// light and dark mode (Material 3 pickers otherwise mix surface colors from
/// one theme with text colors from the other).
Widget pickerThemeBuilder(BuildContext context, Widget? child) {
  final base = Theme.of(context);
  final dark = base.brightness == Brightness.dark;
  final surface = dark ? AppColors.slate850 : Colors.white;
  final onSurface = dark ? const Color(0xFFE8EDF5) : const Color(0xFF111827);
  final muted = dark ? AppColors.slate400 : const Color(0xFF6B7280);
  final accent = dark ? const Color(0xFF5B8CFF) : const Color(0xFF3B6FE8);

  return Theme(
    data: base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: accent,
        onPrimary: Colors.white,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: muted,
        surfaceContainerHigh: surface,
        surfaceContainerHighest: dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        outlineVariant: dark ? const Color(0x33FFFFFF) : const Color(0xFFE5E7EB),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        headerForegroundColor: onSurface,
        dividerColor: dark ? const Color(0x33FFFFFF) : const Color(0xFFE5E7EB),
        rangePickerBackgroundColor: surface,
        rangePickerSurfaceTintColor: Colors.transparent,
        rangePickerHeaderForegroundColor: onSurface,
        rangeSelectionBackgroundColor: accent.withValues(alpha: 0.2),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: surface,
        dialBackgroundColor: dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        hourMinuteTextColor: onSurface,
        dayPeriodTextColor: onSurface,
        helpTextStyle: TextStyle(color: muted),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accent),
      ),
    ),
    child: child!,
  );
}

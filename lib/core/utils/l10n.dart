import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../storage/user_manager.dart';

/// Language code the app is showing ('en' or 'km').
String get appLanguageCode {
  final code = Get.locale?.languageCode ?? _savedLanguageCode();
  final supported = AppLocalizations.supportedLocales.any((l) => l.languageCode == code);
  return supported ? code : 'en';
}

String _savedLanguageCode() {
  try {
    return UserManager().languageCode;
  } catch (_) {
    // Storage isn't ready yet (very early startup, or plain unit tests).
    return 'en';
  }
}

/// Strings in the app's current language, usable anywhere (widgets,
/// controllers, repositories) without a BuildContext.
///
/// Read it at the moment the text is shown, not in a `static final` or a
/// field initializer, so a language switch is picked up on the next build.
AppLocalizations get tr => lookupAppLocalizations(Locale(appLanguageCode));

/// Makes `DateFormat` use the app language (Khmer month names in Khmer).
void syncIntlLocale() => Intl.defaultLocale = appLanguageCode;

/// "13th August 2026" in English, "13 សីហា 2026" in Khmer.
String formatDayMonthYear(DateTime date, {bool padDay = false}) =>
    '${_dayWithOrdinal(date, padDay)} ${DateFormat('MMMM yyyy').format(date)}';

/// "13th August" in English, "13 សីហា" in Khmer.
String formatDayMonth(DateTime date, {bool padDay = false}) =>
    '${_dayWithOrdinal(date, padDay)} ${DateFormat('MMMM').format(date)}';

String _dayWithOrdinal(DateTime date, bool pad) {
  final day = pad ? '${date.day}'.padLeft(2, '0') : '${date.day}';
  if (appLanguageCode != 'en') return day;
  final d = date.day;
  if (d % 10 == 1 && d != 11) return '${day}st';
  if (d % 10 == 2 && d != 12) return '${day}nd';
  if (d % 10 == 3 && d != 13) return '${day}rd';
  return '${day}th';
}

/// Task priority value (URGENT/HIGH/MEDIUM/NORMAL/LOW) as shown to users.
String priorityLabel(String? value) {
  switch (value?.toUpperCase()) {
    case 'URGENT':
      return tr.priorityUrgent;
    case 'HIGH':
      return tr.priorityHigh;
    case 'MEDIUM':
    case 'NORMAL':
      return tr.priorityMedium;
    default:
      return tr.priorityLow;
  }
}

/// Repeat value (NONE/DAILY/WEEKLY/MONTHLY/YEARLY, any case) as shown to users.
String repeatLabel(String? value) {
  switch (value?.toUpperCase()) {
    case 'DAILY':
      return tr.repeatDaily;
    case 'WEEKLY':
      return tr.repeatWeekly;
    case 'MONTHLY':
      return tr.repeatMonthly;
    case 'YEARLY':
      return tr.repeatYearly;
    case 'CUSTOM':
      return tr.repeatCustom;
    default:
      return tr.repeatNone;
  }
}

/// Route travel mode (DRIVING/WALKING/CYCLING/RIDING) as shown to users.
String travelModeLabel(String? value) {
  switch (value?.toUpperCase()) {
    case 'WALKING':
      return tr.travelWalking;
    case 'CYCLING':
      return tr.travelCycling;
    case 'RIDING':
      return tr.travelRiding;
    default:
      return tr.travelDriving;
  }
}

/// Workout type value (RUNNING, PUSH_UP, ...) as shown to users. Unknown
/// types fall back to the value in title case.
String workoutTypeLabel(String? value) {
  final v = (value ?? '').toUpperCase();
  switch (v) {
    case 'RUNNING':
      return tr.workoutRunning;
    case 'WALKING':
      return tr.workoutWalking;
    case 'CYCLING':
      return tr.workoutCycling;
    case 'SWIMMING':
      return tr.workoutSwimming;
    case 'HIKING':
      return tr.workoutHiking;
    case 'HIIT':
      return 'HIIT';
    case 'PUSH_UP':
    case 'PUSHUP':
      return tr.workoutPushUp;
    case 'SQUATS':
    case 'SQUAT':
      return tr.workoutSquats;
    case 'STRENGTH_TRAINING':
      return tr.workoutStrength;
    case 'BODYWEIGHT':
      return tr.workoutBodyweight;
    case 'YOGA':
      return tr.workoutYoga;
    case 'STRETCHING':
      return tr.workoutStretching;
    case 'CARDIO':
      return tr.workoutCardio;
    case 'SPORTS':
      return tr.workoutSports;
    case 'BADMINTON':
      return tr.workoutBadminton;
    case 'TENNIS':
      return tr.workoutTennis;
  }
  return v
      .split('_')
      .where((w) => w.isNotEmpty)
      .map((w) => '${w[0]}${w.substring(1).toLowerCase()}')
      .join(' ');
}

/// Challenge target unit (KM, METERS, MINUTES, REPS, STEPS) as shown to users.
String unitLabel(String? value) {
  switch ((value ?? '').toUpperCase()) {
    case 'KM':
      return tr.unitKm;
    case 'METERS':
    case 'M':
      return tr.unitMeters;
    case 'MINUTES':
    case 'MIN':
      return tr.unitMinutes;
    case 'STEPS':
      return tr.unitSteps;
    case 'REPS':
      return tr.unitReps;
  }
  return value ?? '';
}

/// Club member role (OWNER/ADMIN/MEMBER) as shown to users.
String memberRoleLabel(String? role) {
  switch ((role ?? '').toUpperCase()) {
    case 'OWNER':
      return tr.roleOwner;
    case 'ADMIN':
      return tr.roleAdmin;
    default:
      return tr.member;
  }
}

/// Achievement category filter (ALL/GENERAL/WORKOUT/RUNNING/CHALLENGE).
String achievementCategoryLabel(String category) {
  switch (category.toUpperCase()) {
    case 'ALL':
      return tr.allFilter.toUpperCase();
    case 'GENERAL':
      return tr.categoryGeneral;
    case 'WORKOUT':
      return tr.activityWorkout.toUpperCase();
    case 'RUNNING':
      return tr.workoutRunning.toUpperCase();
    case 'CHALLENGE':
      return tr.activityChallenge.toUpperCase();
  }
  return category;
}

/// Workout level value (NOVICE, INTERMEDIATE_LEVEL, ...) as shown to users.
String workoutLevelLabel(String level) {
  final v = level.toUpperCase().replaceAll('_LEVEL', '');
  switch (v) {
    case 'NOVICE':
    case 'BEGINNER':
      return tr.levelBeginner;
    case 'INTERMEDIATE':
      return tr.levelIntermediate;
    case 'ADVANCED':
      return tr.levelAdvanced;
    case 'ELITE':
      return tr.levelElite;
  }
  return workoutTypeLabel(v);
}

/// A DateFormat pattern with its 12-hour clock ("h:mm a") switched to a
/// 24-hour clock in Khmer, where intl's short AM/PM marks read poorly.
String timePattern(String pattern) {
  if (appLanguageCode == 'en') return pattern;
  return pattern.replaceAll(RegExp(r'h{1,2}:mm\s*a'), 'HH:mm');
}

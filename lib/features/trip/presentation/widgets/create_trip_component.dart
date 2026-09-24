import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movem/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

class CreateTripColors {
  static const lightBackground = AppColors.lightBackground;
  static const darkBackground = AppColors.darkBackground;

  static const lightText = AppColors.lightOnSurface;
  static const darkText = Colors.white;

  static const lightGlass = AppColors.lightSurface;
  static final darkGlass = AppColors.slate800.withValues(alpha: 0.9);

  static const lightBorder = AppColors.slate200;
  static const darkBorder = AppColors.slate700;
}

class CreateTripFonts {
  static const String condensed = 'RobotoCondensed';
  static const String mono = 'RobotoMono';
  static const khmerFallback = <String>[
    'NotoSansKhmer',
  ];

  static TextStyle condensedStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.robotoCondensed(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
    ).copyWith(fontFamilyFallback: khmerFallback);
  }

  static TextStyle monoStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
    ).copyWith(fontFamilyFallback: khmerFallback);
  }
}

class CreateTripL10n {
  static String text({
    required String en,
    required String km,
  }) {
    return Get.locale?.languageCode == 'km' ? km : en;
  }
}

List<BoxShadow> _lightNeumorphicShadows({
  double blur = 24,
  double spread = -4,
  Offset offset = const Offset(6, 10),
  double ambientBlur = 12,
  double highlightBlur = 16,
  Offset highlightOffset = const Offset(-4, -4),
}) {
  return [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: blur,
      spreadRadius: spread,
      offset: offset,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: ambientBlur,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.7),
      blurRadius: highlightBlur,
      offset: highlightOffset,
    ),
  ];
}

final _darkGlassShadow = [
  BoxShadow(
    color: AppColors.slate950.withValues(alpha: 0.45),
    blurRadius: 30,
    offset: const Offset(4, 4),
  ),
];

class CreateTripGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const CreateTripGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(16),
    ),
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isDark ? 10 : 0,
          sigmaY: isDark ? 10 : 0,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark
                ? CreateTripColors.darkGlass
                : CreateTripColors.lightGlass,
            borderRadius: borderRadius,
            border: isDark
                ? Border.all(color: CreateTripColors.darkBorder)
                : null,
            boxShadow: isDark
                ? _darkGlassShadow
                : _lightNeumorphicShadows(),
          ),
          child: child,
        ),
      ),
    );
  }
}

class CreateTripGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const CreateTripGlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? CreateTripColors.darkGlass
                  : CreateTripColors.lightGlass,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? CreateTripColors.darkBorder
                    : CreateTripColors.lightBorder,
              ),
              boxShadow: _darkGlassShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: isDark
                            ? Colors.white
                            : CreateTripColors.lightText,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: CreateTripFonts.condensedStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 1.1,
                        color: isDark
                            ? Colors.white
                            : CreateTripColors.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateTripHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const CreateTripHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 32,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),
            ),
          ),
          Text(
            title,
            style: CreateTripFonts.condensedStyle(
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateTripGlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CreateTripGlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: isDark
            ? _darkGlassShadow
            : _lightNeumorphicShadows(
          blur: 14,
          spread: -3,
          offset: const Offset(3, 5),
          ambientBlur: 8,
          highlightBlur: 8,
          highlightOffset: const Offset(-2, -2),
        ),
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isDark ? 10 : 0,
            sigmaY: isDark ? 10 : 0,
          ),
          child: Material(
            color: isDark
                ? CreateTripColors.darkGlass
                : CreateTripColors.lightGlass,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  icon,
                  size: 18,
                  color: isDark
                      ? Colors.white
                      : CreateTripColors.lightText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateTripStepIndicator extends StatelessWidget {
  final int activeIndex;

  const CreateTripStepIndicator({
    super.key,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final steps = [
      l10n.tripStepName,
      l10n.tripStepLocation,
      l10n.tripStepDuration,
      l10n.tripStepStops,
      l10n.tripStepFriends,
      l10n.tripStepPacking,
      l10n.tripStepChecklist,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Row(
        children: List.generate(
          steps.length,
              (index) {
            final active = index <= activeIndex;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == steps.length - 1 ? 0 : 6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CreateTripFonts.monoStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CreateTripFormPanel extends StatelessWidget {
  final List<Widget> children;
  final Widget? bottomAction;

  const CreateTripFormPanel({
    super.key,
    required this.children,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? CreateTripColors.darkBackground
            : CreateTripColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const verticalPadding = 28.0 + 20.0; // top + bottom padding below

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - verticalPadding,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...children,
                    const Spacer(), // <-- shrinks first, then scroll kicks in
                    if (bottomAction != null)
                      SafeArea(top: false, child: bottomAction!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CreateTripBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CreateTripBottomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CreateTripGlassButton(
      text: text,
      onPressed: onPressed,
    );
  }
}

class CreateTripSummary extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String budget;
  final String stops;

  const CreateTripSummary({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.budget,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CreateTripFonts.condensedStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        _infoRow(Icons.location_on, location, textColor),
        _infoRow(
          Icons.hourglass_bottom,
          date,
          textColor,
          mono: true,
        ),
        _infoRow(Icons.attach_money, budget, textColor),
        _infoRow(Icons.map, stops, textColor),
      ],
    );
  }

  Widget _infoRow(
      IconData icon,
      String value,
      Color color, {
        bool mono = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: color.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: mono
                  ? CreateTripFonts.monoStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              )
                  : CreateTripFonts.condensedStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateTripAvatarChip extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback onRemove;

  const CreateTripAvatarChip({
    super.key,
    required this.name,
    this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : 'U';

    return SizedBox(
      width: 62,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage:
                imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage(imageUrl!)
                    : null,
                backgroundColor: AppColors.slate700,
                child: imageUrl == null || imageUrl!.isEmpty
                    ? Text(
                  initial,
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                )
                    : null,
              ),
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.slate950,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CreateTripFonts.condensedStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : CreateTripColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateTripSelectableFriendTile extends StatelessWidget {
  final String name;
  final String username;
  final String? imageUrl;
  final bool selected;
  final VoidCallback onTap;

  const CreateTripSelectableFriendTile({
    super.key,
    required this.name,
    required this.username,
    this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor =
    isDark ? Colors.white : CreateTripColors.lightText;

    final initial = name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : 'U';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.slate700,
                backgroundImage:
                imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage(imageUrl!)
                    : null,
                child: imageUrl == null || imageUrl!.isEmpty
                    ? Text(
                  initial,
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CreateTripFonts.condensedStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CreateTripFonts.condensedStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: textColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: selected ? textColor : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? textColor
                        : textColor.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: selected
                    ? Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: isDark
                      ? CreateTripColors.darkBackground
                      : Colors.white,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateTripBackground extends StatelessWidget {
  final String imagePath;
  final Widget child;

  const CreateTripBackground({
    super.key,
    required this.imagePath,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.gradientBackground,
          ),
        ),
        child,
      ],
    );
  }
}

class CreateTripChecklistItemTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onToggle;

  const CreateTripChecklistItemTile({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor =
    isDark ? Colors.white : CreateTripColors.lightText;

    return GestureDetector(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? _darkGlassShadow
                : _lightNeumorphicShadows(
              blur: 18,
              spread: -4,
              offset: const Offset(4, 7),
              ambientBlur: 9,
              highlightBlur: 12,
              highlightOffset: const Offset(-3, -3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: isDark ? 10 : 0,
                sigmaY: isDark ? 10 : 0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? CreateTripColors.darkGlass
                      : CreateTripColors.lightGlass,
                  borderRadius: BorderRadius.circular(20),
                  border: isDark
                      ? Border.all(color: CreateTripColors.darkBorder)
                      : null,
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? textColor
                            : Colors.transparent,
                        border: Border.all(
                          color: textColor.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: isCompleted
                          ? Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: isDark
                            ? CreateTripColors.darkBackground
                            : Colors.white,
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: CreateTripFonts.condensedStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
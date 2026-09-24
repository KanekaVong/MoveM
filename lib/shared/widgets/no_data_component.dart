import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_images.dart';

/// Shared empty-state for lists and full screens.
class NoDataComponent extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  const NoDataComponent({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = compact ? 72.0 : 104.0;

    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 28,
        vertical: compact ? 8 : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.emptyFolder,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),
          SizedBox(height: compact ? 10 : 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: compact ? 14 : 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            SizedBox(height: compact ? 4 : 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: compact ? 12 : 13,
                height: 1.4,
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? 12 : 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );

    final body = SizedBox(width: double.infinity, child: content);
    if (compact) return body;
    return Center(child: body);
  }
}

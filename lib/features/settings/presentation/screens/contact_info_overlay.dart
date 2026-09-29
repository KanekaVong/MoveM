import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/contact_type.dart';
import '../../../../shared/widgets/app_button.dart';

class ContactInfoOverlay extends StatelessWidget {
  final ContactType type;
  final String value;
  final VoidCallback onChange;
  final VoidCallback? onUnlink;

  const ContactInfoOverlay({
    super.key,
    required this.type,
    required this.value,
    required this.onChange,
    this.onUnlink,
  });

  @override
  Widget build(BuildContext context) {
    final isEmail = type == ContactType.email;

    return Dialog(
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderLight),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              isEmail ? Icons.email_outlined : Icons.phone_outlined,
              color: AppColors.accentBlue,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              isEmail ? 'Your email address:' : 'Your phone number:',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isEmail
                  ? 'Your email address is linked to your account and remains private. If updated, your previous address may be kept for account recovery.'
                  : 'Your phone number is linked to your account and remains private. If updated, your previous number may be kept for account recovery.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textCaption,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: isEmail ? 'Change email' : 'Change phone number',
              onPressed: onChange,
            ),
            if (!isEmail && onUnlink != null) ...[
              const SizedBox(height: 12),
              AppButton.secondary(
                label: 'Unlink phone number',
                onPressed: onUnlink,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
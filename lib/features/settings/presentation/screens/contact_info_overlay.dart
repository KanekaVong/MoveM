import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/contact_type.dart';
import '../../../../shared/widgets/app_button.dart';
import 'package:movem/core/utils/l10n.dart';

class ContactInfoOverlay extends StatelessWidget {
  final ContactType type;
  final String value;
  final VoidCallback onChange;

  const ContactInfoOverlay({
    super.key,
    required this.type,
    required this.value,
    required this.onChange,
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
              isEmail ? tr.yourEmailAddress : tr.yourPhoneNumber,
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
                  ? tr.emailPrivacyNote
                  : tr.phonePrivacyNote,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textCaption,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: isEmail ? tr.changeEmail : tr.changePhoneNumber,
              onPressed: onChange,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/contact_type.dart';
import '../controllers/setting_controller.dart';

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
      backgroundColor: const Color(0xFF131D38),
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
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),

            Icon(
              isEmail
                  ? Icons.email_outlined
                  : Icons.phone_outlined,
              color: Colors.white,
              size: 40,
            ),

            const SizedBox(height: 16),

            Text(
              isEmail
                  ? 'Your email address:'
                  : 'Your phone number:',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              isEmail
                  ? 'Your email address is linked to your account and remains private. If updated, your previous address may be kept for account recovery.'
                  : 'Your phone number is linked to your account and remains private. If updated, your previous number may be kept for account recovery.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onChange,
                child: Text(
                  isEmail
                      ? 'Change email'
                      : 'Change phone number',
                ),
              ),
            ),

            if (!isEmail && onUnlink != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onUnlink,
                  child: const Text(
                    'Unlink phone number',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
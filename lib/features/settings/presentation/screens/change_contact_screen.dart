import 'package:flutter/material.dart';
import '../models/contact_type.dart';
import 'verify_contact_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movem/core/routes/app_routes.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../controllers/setting_controller.dart';

import 'package:movem/features/settings/data/services/firebase_phone_service.dart';

class ChangeContactScreen extends StatefulWidget {
  final ContactType type;

  const ChangeContactScreen({
    super.key,
    required this.type,
  });

  @override
  State<ChangeContactScreen> createState() => _ChangeContactScreenState();
}

class _ChangeContactScreenState extends State<ChangeContactScreen> {

  late final TextEditingController _contactController;
  late final SettingController _settingController;
  final FirebasePhoneService _firebasePhoneService = FirebasePhoneService();

  String _completePhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _contactController = TextEditingController();
    _settingController = Get.find<SettingController>();
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = widget.type == ContactType.email;

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B132B),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  isEmail
                      ? Icons.email_outlined
                      : Icons.phone_outlined,
                  color: Colors.white,
                  size: 48,
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  isEmail ? 'Change email' : 'Add phone',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              isEmail
                  ? TextField(
                controller: _contactController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white24,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white54,
                    ),
                  ),
                ),
              )
                  :IntlPhoneField(
                controller: _contactController,
                initialCountryCode: 'KH',
                dropdownTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                keyboardType: TextInputType.phone,

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],

                decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white24,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white54,
                    ),
                  ),
                ),

                dropdownIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white54,
                ),

                onChanged: (phone) {
                  _completePhoneNumber = phone.completeNumber;
                },
              ),

              const SizedBox(height: 16),

              Text(
                isEmail
                    ? 'Your email address is linked to your account and remains private. If updated, your previous address may be kept for account recovery.'
                    : 'We will send a verification code via SMS to confirm your identity. Please check your SMS and enter the code on the next screen.',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final value = widget.type == ContactType.email
                        ? _contactController.text.trim()
                        : _completePhoneNumber;

                    debugPrint('Phone sent to Firebase: $value');

                    if (value.isEmpty) {
                      return;
                    }

                    // EMAIL
                    if (widget.type == ContactType.email) {
                      final success =
                      await _settingController.requestEmailChange(value);

                      if (!success || !mounted) {
                        return;
                      }

                      Get.toNamed(
                        AppRoutes.verifyContact,
                        arguments: {
                          'type': widget.type,
                          'value': value,
                        },
                      );

                      return;
                    }

                    // PHONE
                    if (widget.type == ContactType.phone) {
                      try {
                        final verificationId =
                        await _firebasePhoneService.sendVerificationCode(
                          phoneNumber: value,
                        );

                        if (!mounted) {
                          return;
                        }

                        Get.toNamed(
                          AppRoutes.verifyContact,
                          arguments: {
                            'type': widget.type,
                            'value': value,
                            'verificationId': verificationId,
                          },
                        );
                      } catch (e) {
                        debugPrint(
                          'Firebase phone verification error: $e',
                        );

                        if (!mounted) {
                          return;
                        }

                        // Show your existing error message here.
                      }
                    }
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
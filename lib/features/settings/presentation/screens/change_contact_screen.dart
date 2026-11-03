import 'package:flutter/material.dart';
import '../models/contact_type.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movem/core/routes/app_routes.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../controllers/setting_controller.dart';

import 'package:movem/core/storage/user_manager.dart';
import 'package:movem/core/theme/app_colors.dart';
import '../../data/dto/request/update_profile_request.dart';
import 'package:movem/shared/widgets/app_button.dart';
import 'package:movem/shared/widgets/top_tool_bar.dart';
import 'package:movem/core/utils/app_snack.dart';
import 'package:movem/core/utils/l10n.dart';

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

  String _completePhoneNumber = '';

  @override
  void initState() {
    super.initState();
    final user = UserManager().getUser();
    String initialText = '';
    if (widget.type == ContactType.email) {
      initialText = user?.email ?? '';
    } else {
      final phone = user?.phone ?? '';
      initialText = phone.startsWith('+855') ? phone.substring(4) : phone;
      _completePhoneNumber = phone;
    }
    _contactController = TextEditingController(text: initialText);
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
    final dark = AppColors.isDark;
    final pageColor = AppColors.pageBackground;
    final fg = AppColors.textPrimary;
    final textColor = dark ? Colors.white : AppColors.textPrimary;
    final hintColor = dark ? Colors.white54 : AppColors.textSecondary;
    final borderColor = dark ? Colors.white24 : AppColors.borderMuted;
    final focusBorderColor = dark ? Colors.white : AppColors.accentBlue;

    return Scaffold(
      backgroundColor: pageColor,
      appBar: TopToolBar(
        title: tr.yourProfile,
        backgroundColor: pageColor,
        foregroundColor: fg,
        onBack: () => Navigator.of(context).pop(),
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
                  color: dark ? Colors.white : AppColors.accentBlue,
                  size: 48,
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  isEmail ? tr.changeEmail : tr.addPhone,
                  style: TextStyle(
                    color: fg,
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
                style: TextStyle(
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: tr.emailAddress,
                  hintStyle: TextStyle(
                    color: hintColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: borderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: focusBorderColor,
                      width: 1.5,
                    ),
                  ),
                ),
              )
                  : IntlPhoneField(
                controller: _contactController,
                initialCountryCode: 'KH',
                disableLengthCheck: true,
                dropdownTextStyle: TextStyle(
                  color: textColor,
                ),
                style: TextStyle(
                  color: textColor,
                ),
                cursorColor: focusBorderColor,
                keyboardType: TextInputType.phone,

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],

                decoration: InputDecoration(
                  counterText: '',
                  hintText: tr.phoneNumberLower,
                  hintStyle: TextStyle(
                    color: hintColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: borderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: focusBorderColor,
                      width: 1.5,
                    ),
                  ),
                ),

                dropdownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: hintColor,
                ),

                onChanged: (phone) {
                  final raw = phone.number.trim();
                  final clean = raw.startsWith('0') ? raw.substring(1) : raw;
                  _completePhoneNumber = '${phone.countryCode}$clean';
                },
              ),

              const SizedBox(height: 16),

              Text(
                isEmail
                    ? tr.emailPrivacyNote
                    : tr.phoneUpdateNote,
                style: TextStyle(
                  color: hintColor,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              AppButton(
                  label: tr.change,
                  onPressed: () async {
                    String value;
                    if (widget.type == ContactType.email) {
                      value = _contactController.text.trim();
                    } else {
                      if (_completePhoneNumber.isNotEmpty) {
                        value = _completePhoneNumber.trim();
                      } else {
                        final raw = _contactController.text.trim();
                        final clean = raw.startsWith('0') ? raw.substring(1) : raw;
                        value = clean.isNotEmpty ? '+855$clean' : '';
                      }
                    }

                    if (value.isEmpty) {
                      AppSnack.show(
                        tr.requiredField,
                        widget.type == ContactType.email
                            ? tr.pleaseEnterEmail
                            : tr.pleaseEnterValidPhone,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

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

                    if (widget.type == ContactType.phone) {
                      final updatedUser = await _settingController.updateProfile(
                        UpdateProfileRequest(phone: value),
                        goBack: false,
                      );

                      if (updatedUser != null && mounted) {
                        Get.back();
                        AppSnack.show(
                          tr.editTripUpdateSuccess,
                          tr.phoneUpdated,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                      return;
                    }
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
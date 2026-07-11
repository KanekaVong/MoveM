import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:movem/core/utils/AppIcons.dart';
import 'package:movem/shared/widgets/custom_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/storage/user_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final isKhmer = Get.locale?.languageCode == 'km';
    final newLanguage = isKhmer ? 'en' : 'km';
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String newTheme = isDarkMode ? 'light' : 'dark';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   localize.gender,
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Theme.of(context).colorScheme.secondary,
            //   ),
            // ),
            // const SizedBox(height: 12),
            // SvgPicture.asset(
            //   AppIcons.icTickIcon,
            //   width: 24.0,
            //   height: 24.0,
            // ),
            // const SizedBox(height: 10),
            // Image.asset(
            //   AppIcons.icPlaceHolderProfile,
            //   width: 24,
            //   height: 24,
            // ),
            // const SizedBox(height: 10),
            // CustomImage(
            //   imageUrl: "https://img.a.transfermarkt.technology/portrait/big/8198-1748102259.jpg?lm=1",
            //   width: 250.0,
            //   height: 300.0,
            // ),
            // const SizedBox(height: 32),
            // ElevatedButton(
            //   onPressed: () {
            //     UserManager().setLanguage(newLanguage);
            //     Get.updateLocale(Locale(newLanguage));
            //   },
            //   child: Text(isKhmer ? '🇺🇸 English' : '🇰🇭 ខ្មែរ'),
            // ),
            // const SizedBox(height: 12),
            // ElevatedButton(
            //   onPressed: () {
            //     UserManager().setThemeMode(newTheme);
            //     Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            //   },
            //   child: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/storage/user_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final isKhmer = Get.locale?.languageCode == 'km';
    final newLanguage = isKhmer ? 'en' : 'km';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localize.helloYoulong, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(localize.test, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                UserManager().setLanguage(newLanguage);
                Get.updateLocale(Locale(newLanguage));
              },
              child: Text(isKhmer ? '🇺🇸 English' : '🇰🇭 ខ្មែរ'),
            ),
          ],
        ),
      ),
    );
  }
}

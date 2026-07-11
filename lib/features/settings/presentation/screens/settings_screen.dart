import 'package:flutter/material.dart';
import 'package:movem/core/utils/app_dialogs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(
      child: Text('Welcome to Settings!', style: TextStyle(fontSize: 24)),
    ));
    //     body: Center(
    //   child:
    //   ElevatedButton(
    //     onPressed: () => AppDialogs.showSingleActionDialog(
    //       title: "Helo Youlong",
    //       message: "Just Testing daialog",
    //       onConfirm: () => {},
    //       // onCancel: () {},
    //     ),
    //     child: Text("Use Base Dialog"),
    //   ),
    // ));
  }
}

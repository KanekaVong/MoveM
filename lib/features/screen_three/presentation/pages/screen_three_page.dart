import 'package:flutter/material.dart';

class ScreenThreePage extends StatelessWidget {
  const ScreenThreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Screen 3')),
      body: const Center(child: Text('This is Sample Screen 3')),
    );
  }
}

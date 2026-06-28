import 'package:flutter/material.dart';

class ScreenOnePage extends StatelessWidget {
  const ScreenOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Screen 1')),
      body: const Center(child: Text('This is Sample Screen 1')),
    );
  }
}

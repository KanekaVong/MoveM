import 'package:flutter/material.dart';

class ScreenTwoPage extends StatelessWidget {
  const ScreenTwoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Screen 2')),
      body: const Center(child: Text('This is Sample Screen 2')),
    );
  }
}

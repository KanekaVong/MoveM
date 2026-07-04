import 'package:flutter/material.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to Fitness!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to Trips!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

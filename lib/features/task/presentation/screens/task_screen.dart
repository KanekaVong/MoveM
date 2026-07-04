import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to Tasks!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

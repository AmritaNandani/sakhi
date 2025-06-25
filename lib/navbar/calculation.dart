import 'package:flutter/material.dart';

class DemoCalculationPage extends StatelessWidget {
  const DemoCalculationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Calculation'), centerTitle: true),
      body: const Center(
        child: Text(
          'Coming Soon',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

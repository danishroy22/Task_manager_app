import 'package:flutter/material.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Settings"),
      ),
      body: Center(
        child: Text(
          'Here you can change the theme of the app.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

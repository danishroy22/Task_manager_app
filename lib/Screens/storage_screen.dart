import 'package:flutter/material.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Settings"),
      ),
      body: Center(
        child: Text(
          'Here you can manage the app storage and clear data.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

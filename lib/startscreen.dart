import 'package:flutter/material.dart';
import 'package:saferfire/main.dart';

class Startscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CurrentAlarms()),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  final String sessionCode;
  const WaitingScreen({super.key, required this.sessionCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Waiting Room")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text("Waiting for support agent to join..."),
            const SizedBox(height: 10),
            Text("Session Code: $sessionCode",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

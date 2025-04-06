import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HiSupportApp());
}

class HiSupportApp extends StatelessWidget {
  const HiSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiSupport',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

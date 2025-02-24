import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PennyPlanner',
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Roboto'),
      home: const SplashScreen(), // Starts with SplashScreen
    );
  }
}

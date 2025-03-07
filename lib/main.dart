import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PennyPlanner',
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Starts with SplashScreen
    );
  }
}

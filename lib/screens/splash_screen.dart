import 'package:flutter/material.dart';
import 'setuppin.dart'; // Import the SetupPin screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE91E63), // Pink color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Icon
              Icon(Icons.show_chart, color: Colors.white, size: 60.0),

              const SizedBox(height: 16.0),

              // App Name
              const Text(
                'PennyPlanner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8.0),

              // Tagline
              const Text(
                'Your personal finance manager',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),

              const SizedBox(height: 48.0),

              // Let's Go Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to SetupPin page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupPin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFE91E63),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  "Let's Go",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

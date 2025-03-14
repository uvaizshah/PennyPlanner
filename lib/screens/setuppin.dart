import 'package:flutter/material.dart';
import 'pin.dart'; // Import Pin page

class SetupPin extends StatelessWidget {
  const SetupPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom Logo (ppPinkLogo.png)
              Image.asset(
                'assets/images/ppPinkLogo.png', // Updated path
                height: 80.0, // Increased from 60.0 to 80.0
                width: 80.0,  // Increased from 60.0 to 80.0
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50.0,
                  ); // Fallback if image fails to load
                },
              ),

              const SizedBox(height: 16.0),

              // App Name
              const Text(
                'PennyPlanner',
                style: TextStyle(
                  color: Color(0xFFE91E63),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8.0),

              // Tagline
              Text(
                'Your personal finance manager',
                style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
              ),

              const SizedBox(height: 48.0),

              // Setup Pin Button (Now Goes to PIN Entry First)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Pin()), // First go to PIN entry
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  'Setup PIN',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
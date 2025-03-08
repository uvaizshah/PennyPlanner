import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart'; // Import SignUpScreen

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
              // Logo
              Image.asset(
                'assets/images/ppWhiteLogo.png', // White logo
                height: 110.0, // Increased by 10%
                width: 110.0,  // Increased by 10%
              ),

              const SizedBox(height: 8.0), // Reduced space

              // App Name
              Text(
                'PennyPlanner',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8.0),

              // Tagline
              Text(
                'Your personal finance manager',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 48.0),

              // Let's Go Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to SignUp page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFE91E63),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  "Let's Go",
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE91E63),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
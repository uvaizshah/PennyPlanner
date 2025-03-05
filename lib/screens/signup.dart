import 'package:flutter/material.dart';
import 'setuppin.dart'; // Navigate to PIN setup after signing up

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isFormComplete = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isFormComplete = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.length >= 6; // Minimum 6 characters for password
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & Title
              const Center(
                child: Icon(
                  Icons.show_chart,
                  color: Color(0xFFE91E63),
                  size: 50.0,
                ),
              ),
              const SizedBox(height: 10.0),
              const Center(
                child: Text(
                  'PennyPlanner',
                  style: TextStyle(
                    color: Color(0xFFE91E63),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // Name Input
              const Text("Full Name", style: TextStyle(fontSize: 16.0)),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Email Input
              const Text("Email", style: TextStyle(fontSize: 16.0)),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Password Input
              const Text("Password", style: TextStyle(fontSize: 16.0)),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // Sign Up Button
              Center(
                child: ElevatedButton(
                  onPressed: isFormComplete
                      ? () {
                          // Navigate to PIN Setup Screen after signing up
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SetupPin(),
                            ),
                          );
                        }
                      : null, // Disable button if form isn't complete
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormComplete ? const Color(0xFFE91E63) : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60.0,
                      vertical: 14.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(height: 15.0),

              // Already have an account? Login
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to Login Screen
                  },
                  child: const Text(
                    "Already have an account? Log in",
                    style: TextStyle(
                      color: Color(0xFFE91E63),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'enterpin_screen.dart'; // Navigate to EnterPin after login
import 'signup.dart'; // Import SignUpScreen for back navigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage;
  bool _isPasswordVisible = false; // Toggle for password visibility
  bool _isFormComplete = false; // Track form completion

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormComplete = _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  Future<void> _login() async {
    setState(() {
      errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to EnterPin after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EnterPinScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage = 'Email or password is incorrect';
        } else {
          errorMessage = e.message ?? 'An error occurred during login';
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Custom Logo (ppPinkLogo.png)
                      Image.asset(
                        'assets/images/ppPinkLogo.png',
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50.0,
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // App Name with Gradient
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'PennyPlanner',
                          style: GoogleFonts.poppins(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      // Tagline
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 40.0),

                      // Email Input
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email, color: Color(0xFFE91E63)),
                          ),
                          style: GoogleFonts.poppins(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Password Input with Eye Icon
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.lock, color: Color(0xFFE91E63)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFFE91E63),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          style: GoogleFonts.poppins(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // Error Message
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            errorMessage!,
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 14.0,
                            ),
                          ),
                        ),

                      // Login Button
                      ElevatedButton(
                        onPressed: _isFormComplete ? _login : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormComplete
                              ? const Color(0xFFE91E63)
                              : Colors.grey[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 14.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          elevation: 6.0,
                        ),
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 16.0,
              left: 16.0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFE91E63),
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
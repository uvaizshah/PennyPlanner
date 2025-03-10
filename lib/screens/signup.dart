import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setup_page1.dart'; // Navigate to Setup Page 1 after signing up
import 'login_screen.dart'; // Import Login Screen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isFormComplete = false;
  bool isLoading = false;
  String? errorMessage;
  bool _isPasswordVisible = false; // Toggle for password visibility
  bool _isConfirmPasswordVisible = false; // Toggle for confirm password visibility

  // Regex for email validation
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // Regex for password validation (8+ chars, 1 special char, 1 number)
  final RegExp _passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}$');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      bool isEmailValid = _emailRegex.hasMatch(_emailController.text.trim());
      bool isPasswordValid = _passwordRegex.hasMatch(_passwordController.text.trim());
      bool passwordsMatch = _passwordController.text.trim() == _confirmPasswordController.text.trim();

      isFormComplete = _nameController.text.trim().isNotEmpty &&
          isEmailValid &&
          isPasswordValid &&
          passwordsMatch;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // Navigate to SetupPage1
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SetupPage1()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildConditionBullet(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle,
          size: 12.0,
          color: isMet ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12.0,
            color: isMet ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Handle keyboard resize
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Custom Logo & Title
                Image.asset(
                  'assets/images/ppPinkLogo.png', // Pink logo
                  height: 88.0,
                  width: 88.0,
                ),
                const SizedBox(height: 5.0),
                Text(
                  'PennyPlanner',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFE91E63),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40.0),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Field
                      Text(
                        "Full Name",
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5EAA),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      const SizedBox(height: 20.0),

                      // Email Field
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5EAA),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          errorText: _emailController.text.isNotEmpty &&
                                  !_emailRegex.hasMatch(_emailController.text.trim())
                              ? "Please enter a valid email address"
                              : null,
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      const SizedBox(height: 20.0),

                      // Password Field with Conditions
                      Text(
                        "Password",
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5EAA),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
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
                        style: GoogleFonts.poppins(fontSize: 16),
                        onChanged: (value) => _validateForm(),
                      ),
                      const SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildConditionBullet(
                            "At least 8 characters",
                            _passwordController.text.length >= 8,
                          ),
                          _buildConditionBullet(
                            "At least 1 number",
                            RegExp(r'[0-9]').hasMatch(_passwordController.text),
                          ),
                          _buildConditionBullet(
                            "At least 1 special character (!@#\$%^&*)",
                            RegExp(r'[!@#$%^&*]').hasMatch(_passwordController.text),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // Confirm Password Field
                      Text(
                        "Confirm Password",
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5EAA),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFFE91E63),
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          errorText: _confirmPasswordController.text.isNotEmpty &&
                                  _passwordController.text != _confirmPasswordController.text
                              ? "Passwords do not match"
                              : null,
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),

                // Error Message (if any)
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

                // Sign Up Button
                Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                        )
                      : ElevatedButton(
                          onPressed: isFormComplete ? _signUp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isFormComplete ? const Color(0xFFE91E63) : Colors.grey[400],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60.0,
                              vertical: 14.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 6,
                            shadowColor: const Color(0xFFE91E63).withOpacity(0.4),
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 15.0),

                // Already have an account? Login
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "Already have an account? Log in",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFE91E63),
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
      ),
    );
  }
}
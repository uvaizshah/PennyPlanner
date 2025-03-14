import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'homescreen.dart';

class Pin extends StatefulWidget {
  const Pin({super.key});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      setState(() {}); // Update UI when the PIN changes
    });
    _confirmPinController.addListener(() {
      setState(() {}); // Update UI when the confirm PIN changes
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  String _hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  Future<void> _storePin() async {
    setState(() {
      errorMessage = null;
    });

    if (_pinController.text.length != 4 || _confirmPinController.text.length != 4) {
      setState(() {
        errorMessage = "Both PINs must be exactly 4 digits.";
      });
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      setState(() {
        errorMessage = "PINs do not match. Please try again.";
      });
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      String hashedPin = _hashPin(_pinController.text);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'pin': hashedPin,
        'updatedAt': Timestamp.now(),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "PIN set successfully!",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFE91E63),
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to Home Screen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error saving PIN: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPinComplete = _pinController.text.length == 4 && _confirmPinController.text.length == 4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
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
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Tagline
                  Text(
                    'Set your 4-digit PIN',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // PIN Input with Enhanced Styling
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
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: '••••',
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE91E63),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Confirm PIN Input
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
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _confirmPinController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: '••••',
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE91E63),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
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

                  // Set PIN Button
                  ElevatedButton(
                    onPressed: isPinComplete ? _storePin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isPinComplete ? const Color(0xFFE91E63) : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48.0,
                        vertical: 14.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      elevation: isPinComplete ? 6.0 : 0.0,
                    ),
                    child: Text(
                      'Set PIN',
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
      ),
    );
  }
}
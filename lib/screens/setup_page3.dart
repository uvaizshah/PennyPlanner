import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setup_page4.dart';

class SetupPage3 extends StatefulWidget {
  final double totalIncome;

  const SetupPage3({super.key, required this.totalIncome});

  @override
  _SetupPage3State createState() => _SetupPage3State();
}

class _SetupPage3State extends State<SetupPage3> {
  late TextEditingController _savingsController;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _saveSavingsData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      double savingsAmount = double.tryParse(_savingsController.text) ?? 0.0;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'savingsAmount': savingsAmount,
        'updatedAt': Timestamp.now(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetupPage4(
            totalIncome: widget.totalIncome,
            savingsAmount: savingsAmount,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error saving data: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    double recommendedSavings = widget.totalIncome * 0.2;
    _savingsController = TextEditingController(text: recommendedSavings.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _savingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 180, child: Lottie.asset('assets/animations/Piggy Bank.json', fit: BoxFit.cover)),
                      const SizedBox(height: 15),

                      Text(
                        "Plan Your Savings 💰",
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "How much do you want to save?",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 15),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Recommended: Save 20% of ₹${widget.totalIncome * 0.2}",
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.pink[800]),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _savingsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter Savings Amount (₹)",
                            labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.savings, color: Colors.pink),
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6B7280)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      "Back",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                        )
                      : ElevatedButton(
                          onPressed: _saveSavingsData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            elevation: 6,
                            shadowColor: const Color(0xFFE91E63).withOpacity(0.4),
                          ),
                          child: Text(
                            "Next",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
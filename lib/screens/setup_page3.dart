import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'setup_page4.dart';

class SetupPage3 extends StatefulWidget {
  final double totalIncome;

  const SetupPage3({super.key, required this.totalIncome});

  @override
  _SetupPage3State createState() => _SetupPage3State();
}

class _SetupPage3State extends State<SetupPage3> {
  late TextEditingController _savingsController;

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
                      // **Piggy Bank Animation**
                      SizedBox(height: 180, child: Lottie.asset('assets/animations/Piggy Bank.json', fit: BoxFit.cover)),
                      const SizedBox(height: 15),

                      // **Title**
                      Text(
                        "Plan Your Savings 💰",
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // **Subtitle**
                      Text(
                        "How much do you want to save?",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 15),

                      // **Recommendation Box**
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

                      // **Savings Amount Input**
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

            // **Navigation Buttons**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // **Back Button**
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "← Back",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),

                  // **Next Button**
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63), // Pink like SetupPage2
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      double savingsAmount = double.tryParse(_savingsController.text) ?? 0.0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetupPage4(
                            totalIncome: widget.totalIncome,
                            savingsAmount: savingsAmount,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

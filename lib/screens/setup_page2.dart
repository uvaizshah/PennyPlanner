import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'setup_page3.dart';

class SetupPage2 extends StatefulWidget {
  final int numIncomeSources;

  const SetupPage2({super.key, required this.numIncomeSources});

  @override
  _SetupPage2State createState() => _SetupPage2State();
}

class _SetupPage2State extends State<SetupPage2> {
  List<TextEditingController> incomeSourceControllers = [];
  List<TextEditingController> incomeAmountControllers = [];
  double totalIncome = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on numIncomeSources
    incomeSourceControllers = List.generate(
      widget.numIncomeSources,
      (index) => TextEditingController(),
    );
    incomeAmountControllers = List.generate(
      widget.numIncomeSources,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in incomeSourceControllers) {
      controller.dispose();
    }
    for (var controller in incomeAmountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateTotalIncome() {
    double total = 0.0;
    for (var controller in incomeAmountControllers) {
      total += double.tryParse(controller.text) ?? 0.0;
    }
    setState(() {
      totalIncome = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie Animation with Debugging
                SizedBox(
                  height: 200,
                  child: Lottie.asset(
                    'assets/animations/Piggy Bank.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    errorBuilder: (context, error, stackTrace) {
                      print("Lottie Error in SetupPage2: $error\nStack Trace: $stackTrace");
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Text(
                            "Animation not found. Please check assets.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "Let's Set Up Your Income Details!",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3142),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  "Enter details to personalize your plan.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Income Input Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.numIncomeSources,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Income Source ${index + 1}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4B5EAA),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: incomeSourceControllers[index],
                              decoration: InputDecoration(
                                hintText: "Enter source name (e.g., Salary)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 12, right: 8),
                                  child: Text(
                                    "💰",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Monthly Income",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4B5EAA),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: incomeAmountControllers[index],
                              keyboardType: TextInputType.number,
                              onChanged: (value) => updateTotalIncome(),
                              decoration: InputDecoration(
                                hintText: "Enter amount",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.currency_rupee,
                                  color: Color(0xFFE91E63),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Total Income Display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Income: ",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5EAA),
                        ),
                      ),
                      Text(
                        "₹${totalIncome.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6B7280)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Back",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetupPage3(
                              totalIncome: totalIncome,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
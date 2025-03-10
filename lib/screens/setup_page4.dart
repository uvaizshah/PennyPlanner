import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setup_page5.dart';

class SetupPage4 extends StatefulWidget {
  final double totalIncome;
  final double savingsAmount;

  const SetupPage4({super.key, required this.totalIncome, required this.savingsAmount});

  @override
  _SetupPage4State createState() => _SetupPage4State();
}

class _SetupPage4State extends State<SetupPage4> {
  final TextEditingController rentController = TextEditingController();
  final TextEditingController foodController = TextEditingController();
  final TextEditingController groceriesController = TextEditingController();
  final TextEditingController transportController = TextEditingController();
  final TextEditingController healthcareController = TextEditingController();
  final TextEditingController entertainmentController = TextEditingController();
  final TextEditingController giftController = TextEditingController();
  final TextEditingController otherController = TextEditingController();

  double remainingBalance = 0.0;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _saveExpenseData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      final expenses = {
        'rent': double.tryParse(rentController.text) ?? 0.0,
        'food': double.tryParse(foodController.text) ?? 0.0,
        'groceries': double.tryParse(groceriesController.text) ?? 0.0,
        'transport': double.tryParse(transportController.text) ?? 0.0,
        'healthcare': double.tryParse(healthcareController.text) ?? 0.0,
        'entertainment': double.tryParse(entertainmentController.text) ?? 0.0,
        'gift': double.tryParse(giftController.text) ?? 0.0,
        'other': double.tryParse(otherController.text) ?? 0.0,
      };

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'expenses': expenses,
        'remainingBalance': remainingBalance,
        'updatedAt': Timestamp.now(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetupPage5(
            totalIncome: widget.totalIncome,
            savingsAmount: widget.savingsAmount,
            rent: double.tryParse(rentController.text) ?? 0.0,
            food: double.tryParse(foodController.text) ?? 0.0,
            groceries: double.tryParse(groceriesController.text) ?? 0.0,
            transport: double.tryParse(transportController.text) ?? 0.0,
            healthcare: double.tryParse(healthcareController.text) ?? 0.0,
            entertainment: double.tryParse(entertainmentController.text) ?? 0.0,
            gift: double.tryParse(giftController.text) ?? 0.0,
            other: double.tryParse(otherController.text) ?? 0.0,
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
    remainingBalance = widget.totalIncome - widget.savingsAmount;
    rentController.addListener(updateRemainingBalance);
    foodController.addListener(updateRemainingBalance);
    groceriesController.addListener(updateRemainingBalance);
    transportController.addListener(updateRemainingBalance);
    healthcareController.addListener(updateRemainingBalance);
    entertainmentController.addListener(updateRemainingBalance);
    giftController.addListener(updateRemainingBalance);
    otherController.addListener(updateRemainingBalance);
  }

  void updateRemainingBalance() {
    double totalExpenses = 0.0;
    totalExpenses += double.tryParse(rentController.text) ?? 0.0;
    totalExpenses += double.tryParse(foodController.text) ?? 0.0;
    totalExpenses += double.tryParse(groceriesController.text) ?? 0.0;
    totalExpenses += double.tryParse(transportController.text) ?? 0.0;
    totalExpenses += double.tryParse(healthcareController.text) ?? 0.0;
    totalExpenses += double.tryParse(entertainmentController.text) ?? 0.0;
    totalExpenses += double.tryParse(giftController.text) ?? 0.0;
    totalExpenses += double.tryParse(otherController.text) ?? 0.0;

    setState(() {
      remainingBalance = widget.totalIncome - widget.savingsAmount - totalExpenses;
      if (remainingBalance < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Expenses exceed remaining balance!")),
        );
      }
    });
  }

  @override
  void dispose() {
    rentController.dispose();
    foodController.dispose();
    groceriesController.dispose();
    transportController.dispose();
    healthcareController.dispose();
    entertainmentController.dispose();
    giftController.dispose();
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Almost There!",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3142),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    Text(
                      "Let's set up your expense categories.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    Text(
                      "Remaining Balance: ₹${remainingBalance.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: remainingBalance < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildExpenseInput("🏠 Rent / Housing", rentController),
                    _buildExpenseInput("🍽️ Food", foodController),
                    _buildExpenseInput("🏪 Groceries", groceriesController),
                    _buildExpenseInput("🚗 Transportation", transportController),
                    _buildExpenseInput("⚕️ Healthcare", healthcareController),
                    _buildExpenseInput("🎉 Entertainment", entertainmentController),
                    _buildExpenseInput("🎁 Gift", giftController),
                    _buildExpenseInput("📦 Other", otherController),
                  ],
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                          onPressed: _saveExpenseData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            elevation: 6,
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
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8.0),
            child: Text(
              '₹',
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.pink),
            ),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        onChanged: (value) {
          updateRemainingBalance();
        },
      ),
    );
  }
}
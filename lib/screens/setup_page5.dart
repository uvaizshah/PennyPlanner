import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setuppin.dart';

class SetupPage5 extends StatelessWidget {
  final double totalIncome;
  final double savingsAmount;
  final double rent;
  final double food;
  final double groceries;
  final double transport;
  final double healthcare;
  final double entertainment;
  final double gift;
  final double other;

  const SetupPage5({
    super.key,
    required this.totalIncome,
    required this.savingsAmount,
    required this.rent,
    required this.food,
    required this.groceries,
    required this.transport,
    required this.healthcare,
    required this.entertainment,
    required this.gift,
    required this.other,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Space after SafeArea

                // **Title**
                Text(
                  "Review Your Setup",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // **Subtitle**
                Text(
                  "Here’s a summary of your financial setup.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                // **Summary Card**
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow("💰 Total Income", totalIncome),
                      _buildSummaryRow("💸 Savings", savingsAmount),
                      _buildSummaryRow("🏠 Rent / Housing", rent),
                      _buildSummaryRow("🍽️ Food", food),
                      _buildSummaryRow("🏪 Groceries", groceries),
                      _buildSummaryRow("🚗 Transportation", transport),
                      _buildSummaryRow("⚕️ Healthcare", healthcare),
                      _buildSummaryRow("🎉 Entertainment", entertainment),
                      _buildSummaryRow("🎁 Gift", gift),
                      _buildSummaryRow("📦 Other", other),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // **Navigation Buttons**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
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
                    // Continue Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SetupPin()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        elevation: 6,
                      ),
                      child: Text(
                        "Continue",
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

  // **Reusable Summary Row**
  Widget _buildSummaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
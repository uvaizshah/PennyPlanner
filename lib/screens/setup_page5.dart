import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> _confirmSetup(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'totalIncome': totalIncome,
        'savingsAmount': savingsAmount,
        'expenses': {
          'rent': rent,
          'food': food,
          'groceries': groceries,
          'transport': transport,
          'healthcare': healthcare,
          'entertainment': entertainment,
          'gift': gift,
          'other': other,
        },
        'updatedAt': Timestamp.now(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SetupPin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error confirming setup: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

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

                Text(
                  "Here’s a summary of your financial setup.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

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
                    ElevatedButton(
                      onPressed: () => _confirmSetup(context),
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
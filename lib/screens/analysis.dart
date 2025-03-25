import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  Map<String, dynamic> categories = {};

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            categories = userDoc['categories'] as Map<String, dynamic>? ?? {};
          });
        }
      } catch (e) {
        print("Error fetching categories: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Merge duplicate keys from Firestore
    Map<String, dynamic> mergedCategories = {};
    categories.forEach((key, value) {
      String normalizedKey = key.toLowerCase();
      if (normalizedKey == 'healthcare' || normalizedKey == 'medicine') {
        if (mergedCategories.containsKey('medicine')) {
          mergedCategories['medicine']['allocatedBudget'] =
              (mergedCategories['medicine']['allocatedBudget'] ?? 0.0) +
                  (value['allocatedBudget'] ?? 0.0);
          mergedCategories['medicine']['expense'] =
              (mergedCategories['medicine']['expense'] ?? 0.0) +
                  (value['expense'] ?? 0.0);
        } else {
          mergedCategories['medicine'] = Map<String, dynamic>.from(value);
        }
      } else if (normalizedKey == 'gift' || normalizedKey == 'gifts') {
        if (mergedCategories.containsKey('gifts')) {
          mergedCategories['gifts']['allocatedBudget'] =
              (mergedCategories['gifts']['allocatedBudget'] ?? 0.0) +
                  (value['allocatedBudget'] ?? 0.0);
          mergedCategories['gifts']['expense'] =
              (mergedCategories['gifts']['expense'] ?? 0.0) +
                  (value['expense'] ?? 0.0);
        } else {
          mergedCategories['gifts'] = Map<String, dynamic>.from(value);
        }
      } else {
        mergedCategories[key] = value;
      }
    });

    // Calculate totals for summary
    double totalAllocated = 0.0;
    double totalExpense = 0.0;
    mergedCategories.forEach((key, value) {
      totalAllocated += value['allocatedBudget'] ?? 0.0;
      totalExpense += value['expense'] ?? 0.0;
    });
    double totalRemaining = totalAllocated - totalExpense;

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
            top: 50.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Total Budget Summary in a curved box
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Light gray background
                borderRadius: BorderRadius.circular(20), // Curved corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Allocated: ₹${totalAllocated.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Neutral color
                    ),
                  ),
                  const SizedBox(height: 8), // Spacing between items
                  Text(
                    "Total Expense: ₹${totalExpense.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize:  долго16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Expense in red
                    ),
                  ),
                  const SizedBox(height: 8), // Spacing between items
                  Text(
                    "Total Remaining: ₹${totalRemaining.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Remaining in green
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Category-wise Analysis",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Track your spending and remaining budget",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: mergedCategories.length,
                itemBuilder: (context, index) {
                  Map<String, String> emojiMapping = {
                    'food': '🍽️',
                    'transport': '🚗',
                    'groceries': '🏪',
                    'rent': '🏠',
                    'medicine': '⚕️',
                    'entertainment': '🎉',
                    'gifts': '🎁',
                    'other': '📦',
                  };
                  Map<String, Color> containerColorMapping = {
                    'food': Colors.deepOrange,
                    'transport': Colors.indigo,
                    'groceries': Colors.teal,
                    'rent': Colors.blueGrey,
                    'medicine': const Color(0xFFDAA520),
                    'entertainment': Colors.deepPurple,
                    'gifts': Colors.orange,
                    'other': Colors.brown,
                  };
                  String key = mergedCategories.keys.elementAt(index);
                  String displayCategory = key;
                  if (key == 'medicine') {
                    displayCategory = "Medicine";
                  } else if (key == 'gifts') {
                    displayCategory = "Gifts";
                  }
                  Map<String, dynamic> catData = mergedCategories[key];
                  String emoji = emojiMapping[key] ?? (catData['emoji'] ?? '🎯');
                  Color containerColor = containerColorMapping[key] ?? Colors.grey;
                  double allocatedBudget = catData['allocatedBudget'] ?? 0.0;
                  double expense = catData['expense'] ?? 0.0;
                  double remaining = allocatedBudget - expense;
                  double progress =
                      allocatedBudget != 0 ? (expense / allocatedBudget) : 0.0;

                  Color textColor = Colors.white;
                  if (key.toLowerCase() == 'food' ||
                      key.toLowerCase() == 'medicine' ||
                      key.toLowerCase() == 'gifts') {
                    textColor = Colors.black;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.grey[200]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              "$emoji  $displayCategory",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Allocated: ₹${allocatedBudget.toStringAsFixed(2)}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Remaining: ₹${remaining.toStringAsFixed(2)}",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.red), // Progress bar in red
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${(progress * 100).toStringAsFixed(0)}% of your budget spent",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
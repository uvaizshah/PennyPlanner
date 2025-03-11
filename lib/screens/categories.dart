import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_expense.dart'; // Import the Add Expense Page

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0; // Retained for potential future use
  Map<String, double> expenseData = {}; // Store expense amounts
  double totalIncome = 0.0; // To calculate proportional budgets

  @override
  void initState() {
    super.initState();
    _fetchCategoryData();
  }

  Future<void> _fetchCategoryData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          print("Category data fetched: ${userDoc.data()}");
          setState(() {
            totalIncome = (userDoc['totalIncome'] as num?)?.toDouble() ?? 0.0;
            Map<String, dynamic>? expenses = userDoc['expenses'] as Map<String, dynamic>?;
            expenseData = expenses?.map((key, value) => MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ?? {};
          });
        }
      } catch (e) {
        print("Error fetching category data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // TODO: Notification Functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            String label = categoryItems[index]["label"].toLowerCase();
            double expense = expenseData[label] ?? 0.0;
            // Temporary: Assume allocated budget is proportional to totalIncome (e.g., 1/8th each category)
            double allocatedBudget = totalIncome > 0 ? totalIncome / 8 : 0.0;
            double remainingBudget = allocatedBudget - expense;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index; // Retained for potential future use
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(
                      category: categoryItems[index]["label"],
                      remainingBudget: remainingBudget,
                    ),
                  ),
                );
              },
              child: CategoryItem(
                icon: categoryItems[index]["icon"],
                label: categoryItems[index]["label"],
                isSelected: _selectedIndex == index, // Retained but not affecting color
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected; // Retained but not affecting color

  const CategoryItem({super.key, required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63), // All buttons now #E91E63
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> categoryItems = [
  {"icon": Icons.restaurant, "label": "Food"},
  {"icon": Icons.directions_bus, "label": "Transport"},
  {"icon": Icons.medical_services, "label": "Medicine"},
  {"icon": Icons.local_grocery_store, "label": "Groceries"},
  {"icon": Icons.key, "label": "Rent"},
  {"icon": Icons.card_giftcard, "label": "Gifts"},
  {"icon": Icons.savings, "label": "Savings"},
  {"icon": Icons.movie, "label": "Entertainment"},
  {"icon": Icons.add, "label": "More"},
];
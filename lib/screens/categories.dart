import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_expense.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Map<String, Map<String, double>> categoriesData = {};

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
            Map<String, dynamic>? categories = userDoc['categories'] as Map<String, dynamic>?;
            categoriesData = categories?.map((key, value) => MapEntry(key, {
              'allocatedBudget': (value['allocatedBudget'] as num?)?.toDouble() ?? 0.0,
              'expense': (value['expense'] as num?)?.toDouble() ?? 0.0,
            })) ?? {};
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
            onPressed: () {},
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
            String firestoreKey = categoryItems[index]["firestoreKey"];
            double allocatedBudget = categoriesData[firestoreKey]?['allocatedBudget'] ?? 0.0;
            double expense = categoriesData[firestoreKey]?['expense'] ?? 0.0;
            double remainingBudget = allocatedBudget - expense;

            return GestureDetector(
              onTap: () {
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

  const CategoryItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63),
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
  {"icon": Icons.restaurant, "label": "Food", "firestoreKey": "food"},
  {"icon": Icons.directions_bus, "label": "Transport", "firestoreKey": "transport"},
  {"icon": Icons.medical_services, "label": "Medicine", "firestoreKey": "healthcare"},
  {"icon": Icons.local_grocery_store, "label": "Groceries", "firestoreKey": "groceries"},
  {"icon": Icons.key, "label": "Rent", "firestoreKey": "rent"},
  {"icon": Icons.card_giftcard, "label": "Gifts", "firestoreKey": "gift"},
  {"icon": Icons.movie, "label": "Entertainment", "firestoreKey": "entertainment"},
  {"icon": Icons.add, "label": "Other", "firestoreKey": "other"},
];
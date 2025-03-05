import 'package:flutter/material.dart';
import 'add_expense.dart'; // Import the Add Expense Page

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0; // Default selected category index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAF7), // Light background color
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
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
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
            crossAxisCount: 3, // 3 categories per row
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1, // Square shape
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index; // Update selected category
                });

                // Navigate to Add Expense Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(
                      category: categoryItems[index]["label"],
                      remainingBudget: 5000.0, // Example budget (Replace with actual data)
                    ),
                  ),
                );
              },
              child: CategoryItem(
                icon: categoryItems[index]["icon"],
                label: categoryItems[index]["label"],
                isSelected: _selectedIndex == index, // Change color when selected
              ),
            );
          },
        ),
      ),
    );
  }
}

// Category Item Widget
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const CategoryItem({super.key, required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Smooth transition effect
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE91E63) : Colors.pink[100],
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

// List of Categories
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

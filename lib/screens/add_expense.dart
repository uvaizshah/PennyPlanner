import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpenseScreen extends StatefulWidget {
  final String category;
  final double remainingBudget;

  const AddExpenseScreen({super.key, required this.category, required this.remainingBudget});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to take a photo using the camera
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to save the expense to Firestore
  Future<void> _saveExpense() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0 || amount > widget.remainingBudget) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid amount or exceeds remaining budget!")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);
        if (!snapshot.exists) return;

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> expenses = (data['expenses'] as Map<String, dynamic>?) ?? {};
        double currentSavingsAmount = (data['savingsAmount'] as num?)?.toDouble() ?? 0.0;
        double currentTotalIncome = (data['totalIncome'] as num?)?.toDouble() ?? 0.0;

        // Update category expense
        String categoryKey = widget.category.toLowerCase();
        double currentExpense = (expenses[categoryKey] as num?)?.toDouble() ?? 0.0;
        expenses[categoryKey] = currentExpense + amount;

        // Calculate new remaining balance
        double totalExpenses = expenses.values.fold(0.0, (sum, value) => sum + (value as num).toDouble());
        double newRemainingBalance = currentTotalIncome - totalExpenses - currentSavingsAmount;

        transaction.update(userDocRef, {
          'expenses': expenses,
          'remainingBalance': newRemainingBalance,
        });

        // Add transaction to transactions subcollection
        await userDocRef.collection('transactions').add({
          'amount': amount,
          'category': widget.category,
          'type': 'expense',
          'date': Timestamp.fromDate(DateTime.now()),
        });
      });

      // Clear the form and navigate back
      _amountController.clear();
      setState(() {
        _selectedImage = null;
      });
      Navigator.pop(context); // Return to CategoriesScreen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense added successfully!")),
      );
    } catch (e) {
      print("Error saving expense: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving expense. Try again!")),
      );
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
        title: Text(
          widget.category, // Display selected category name
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remaining Budget Display
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Remaining Budget",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "₹ ${widget.remainingBudget.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Photo Upload & Camera Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Upload from Gallery
                IconButton(
                  icon: const Icon(Icons.photo, size: 40, color: Color(0xFFE91E63)),
                  onPressed: _pickImage,
                ),
                // Capture from Camera
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 40, color: Color(0xFFE91E63)),
                  onPressed: _captureImage,
                ),
              ],
            ),

            // Display Selected Image
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Image.file(_selectedImage!, height: 100, fit: BoxFit.cover),
                ),
              ),

            const SizedBox(height: 25),

            // Amount Entry Field
            const Text("Enter Amount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "₹ Enter expense amount",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 30),

            // Submit Button (Changed to "Add Expense")
            Center(
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text("Add Expense", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
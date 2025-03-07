import 'package:flutter/material.dart';
import 'setuppin.dart'; // Import the Setup PIN page

class SetupPage4 extends StatefulWidget {
  final double totalIncome;
  final double savingsAmount;

  const SetupPage4({super.key, required this.totalIncome, required this.savingsAmount});

  @override
  _SetupPage4State createState() => _SetupPage4State();
}

class _SetupPage4State extends State<SetupPage4> {
  final Map<String, TextEditingController> _budgetControllers = {};
  final List<String> _categories = ["Food", "Medicine", "Groceries", "Entertainment", "Rent", "Transport", "Gifts"];
  double _remainingBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _remainingBudget = widget.totalIncome - widget.savingsAmount;
    for (var category in _categories) {
      _budgetControllers[category] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _budgetControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateRemainingBudget() {
    double totalAllocated = 0.0;
    for (var controller in _budgetControllers.values) {
      totalAllocated += double.tryParse(controller.text) ?? 0.0;
    }
    setState(() {
      _remainingBudget = (widget.totalIncome - widget.savingsAmount) - totalAllocated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup: Budget Allocation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Allocate your remaining budget: ₹${(widget.totalIncome - widget.savingsAmount).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Savings: ₹${widget.savingsAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Budget Allocation Inputs
            Expanded(
              child: ListView(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      controller: _budgetControllers[category],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "$category Budget (₹)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _updateRemainingBudget();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Remaining Budget Display
            Text(
              "Remaining Budget: ₹${_remainingBudget.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _remainingBudget < 0 ? Colors.red : Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            // Finish Setup Button
            ElevatedButton(
              onPressed: _remainingBudget < 0
                  ? null // Disable button if budget is exceeded
                  : () {
                      // Navigate to HomeScreen
                      Navigator.pushReplacement(
                      context,
                       MaterialPageRoute(builder: (context) => const SetupPin()),
                      );
                    },
              child: const Text("Finish Setup"),
            ),
          ],
        ),
      ),
    );
  }
}

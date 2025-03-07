import 'package:flutter/material.dart';
import 'setup_page4.dart';


class SetupPage3 extends StatefulWidget {
  final double totalIncome; // Receive total income from previous page

  const SetupPage3({super.key, required this.totalIncome});

  @override
  _SetupPage3State createState() => _SetupPage3State();
}

class _SetupPage3State extends State<SetupPage3> {
  late double _savingsAmount;

  @override
  void initState() {
    super.initState();
    _savingsAmount = widget.totalIncome * 0.2; // Default: 20% of total income
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup: Savings Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How much do you want to save?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              "We recommend saving 20% of your total income: ₹${(widget.totalIncome * 0.2).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Savings Amount Input
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Savings Amount (₹)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _savingsAmount = double.tryParse(value) ?? 0.0;
                });
              },
            ),

            const SizedBox(height: 20),

            // Next Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Setup Page 4 (Budget Allocation)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetupPage4(
                      totalIncome: widget.totalIncome,
                      savingsAmount: _savingsAmount,
                    ),
                  ),
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

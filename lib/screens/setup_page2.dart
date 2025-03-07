import 'package:flutter/material.dart';
import 'setup_page3.dart'; // Same folder


class SetupPage2 extends StatefulWidget {
  final int numIncomeSources; // Get number of income sources from previous page

  const SetupPage2({super.key, required this.numIncomeSources});

  @override
  _SetupPage2State createState() => _SetupPage2State();
}

class _SetupPage2State extends State<SetupPage2> {
  List<TextEditingController> _incomeControllers = [];
  List<TextEditingController> _sourceControllers = [];
  double _totalIncome = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on the number of income sources
    _incomeControllers = List.generate(widget.numIncomeSources, (index) => TextEditingController());
    _sourceControllers = List.generate(widget.numIncomeSources, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _incomeControllers) {
      controller.dispose();
    }
    for (var controller in _sourceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Function to update total income dynamically
  void _updateTotalIncome() {
    double total = 0.0;
    for (var controller in _incomeControllers) {
      double value = double.tryParse(controller.text) ?? 0.0;
      total += value;
    }
    setState(() {
      _totalIncome = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup: Income Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your income sources and amounts:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Dynamic Input Fields for Each Income Source
            Expanded(
              child: ListView.builder(
                itemCount: widget.numIncomeSources,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        // Income Source Name
                        Expanded(
                          child: TextField(
                            controller: _sourceControllers[index],
                            decoration: InputDecoration(
                              labelText: "Income Source ${index + 1}",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Income Amount
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _incomeControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "₹ Amount",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _updateTotalIncome(); // Update total when amount is entered
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Total Income Display
            Text(
              "Total Income: ₹$_totalIncome",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Next Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Setup Page 3 (Savings)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetupPage3(totalIncome: _totalIncome),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:lottie/lottie.dart'; // Add this import for Lottie

class SplitTheBillScreen extends StatefulWidget {
  @override
  _SplitTheBillScreenState createState() => _SplitTheBillScreenState();
}

class _SplitTheBillScreenState extends State<SplitTheBillScreen> {
  final TextEditingController _peopleController = TextEditingController();
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _expenseControllers = [];
  int _numberOfPeople = 0;
  List<String> _transactions = [];

  @override
  void dispose() {
    _peopleController.dispose();
    _nameControllers.forEach((controller) => controller.dispose());
    _expenseControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _submitPeople() {
    setState(() {
      _numberOfPeople = int.tryParse(_peopleController.text) ?? 0;
      if (_numberOfPeople > 0) {
        _nameControllers.clear();
        _expenseControllers.clear();
        for (int i = 0; i < _numberOfPeople; i++) {
          _nameControllers.add(TextEditingController());
          _expenseControllers.add(TextEditingController());
        }
      }
    });
  }

  void _calculateSplit() {
    double totalExpense = 0;
    List<double> expenses = [];
    for (int i = 0; i < _numberOfPeople; i++) {
      double expense = double.tryParse(_expenseControllers[i].text) ?? 0;
      expenses.add(expense);
      totalExpense += expense;
    }
    double averageExpense = totalExpense / _numberOfPeople;
    List<Map<String, dynamic>> balances = [];
    for (int i = 0; i < _numberOfPeople; i++) {
      balances.add({
        'name': _nameControllers[i].text.isEmpty ? 'Friend ${i + 1}' : _nameControllers[i].text,
        'balance': expenses[i] - averageExpense
      });
    }
    balances.sort((a, b) => a['balance'].compareTo(b['balance']));
    _transactions.clear();
    int i = 0, j = _numberOfPeople - 1;
    while (i < j) {
      double amount = min(-balances[i]['balance'], balances[j]['balance']);
      _transactions.add('${balances[i]['name']} owes ${balances[j]['name']} Rs ${amount.toStringAsFixed(2)}');
      balances[i]['balance'] += amount;
      balances[j]['balance'] -= amount;
      if (balances[i]['balance'] == 0) i++;
      if (balances[j]['balance'] == 0) j--;
    }
    setState(() {});
  }

  void _reset() {
    setState(() {
      _numberOfPeople = 0;
      _peopleController.clear();
      _nameControllers.clear();
      _expenseControllers.clear();
      _transactions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split The Bill', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFE91E63),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_numberOfPeople == 0) ...[
                Card(
                  color: Color(0xFFE91E63),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Enter number of people', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        TextField(
                          controller: _peopleController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                            hintText: 'Number of people',
                            hintStyle: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 32), // Increased space between text box and button
                        ElevatedButton(
                          onPressed: _submitPeople,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          ),
                          child: Text('Submit', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Lottie animation
                Container(
                  height: 200,
                  child: Lottie.asset('assets/animations/splitfriends.json'),  // Consistent with other animations
                ),
              ] else ...[
                for (int i = 0; i < _numberOfPeople; i++) ...[
                  TextField(
                    controller: _nameControllers[i],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      hintText: 'Friend ${i + 1}',
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _expenseControllers[i],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      prefixIcon: Icon(Icons.currency_rupee),
                      hintText: 'Amount spent',
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: _calculateSplit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text('Calculate', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
              if (_transactions.isNotEmpty) ...[
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      Text('Result', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      for (String transaction in _transactions) ...[
                        Text(transaction, style: GoogleFonts.poppins(fontSize: 16)),
                        SizedBox(height: 6),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    fixedSize: Size(200, 50),
                  ),
                  child: Text('New Split', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F7FA),
    );
  }
}

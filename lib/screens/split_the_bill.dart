import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Split The Bill', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFFE91E63),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_numberOfPeople == 0) ...[
                // Initial State: Enter number of people
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.group, color: Colors.white, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Enter Number of People',
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      TextField(
                        controller: _peopleController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'e.g., 3',
                          hintStyle: GoogleFonts.poppins(color: Colors.white70),
                          prefixIcon: Icon(Icons.people, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _submitPeople,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFE91E63),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          elevation: 5,
                        ),
                        child: Text('Submit', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  height: 200,
                  child: Lottie.asset('assets/animations/splitfriends.json'),
                ),
              ] else if (_transactions.isEmpty) ...[
                // Data Entry: Names and Expenses
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 28),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Enter Details for Each Friend',
                              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      for (int i = 0; i < _numberOfPeople; i++) ...[
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _nameControllers[i],
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Friend ${i + 1} Name',
                                  hintStyle: GoogleFonts.poppins(color: Colors.white70),
                                  prefixIcon: Icon(Icons.person, color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _expenseControllers[i],
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Amount Spent',
                                  hintStyle: GoogleFonts.poppins(color: Colors.white70),
                                  prefixIcon: Icon(Icons.currency_rupee, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _calculateSplit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFE91E63),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          elevation: 5,
                        ),
                        child: Text('Calculate', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Result Display
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFFE91E63), size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Split Result',
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      for (String transaction in _transactions) ...[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_forward, color: Color(0xFFE91E63)),
                              SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: transaction.split(' owes ')[0],
                                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                                      ),
                                      TextSpan(
                                        text: ' owes ',
                                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: transaction.split(' owes ')[1].split(' Rs ')[0],
                                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                      TextSpan(
                                        text: ' Rs ${transaction.split(' Rs ')[1]}',
                                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          elevation: 5,
                        ),
                        child: Text('New Split', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
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
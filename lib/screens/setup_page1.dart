import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setup_page2.dart';

class SetupPage1 extends StatefulWidget {
  const SetupPage1({super.key});

  @override
  _SetupPage1State createState() => _SetupPage1State();
}

class _SetupPage1State extends State<SetupPage1> {
  int numIncomeSources = 1;
  int numUsers = 1;
  String surname = '';
  bool isLoading = false;
  String? errorMessage;

  Future<void> _saveSetupData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'surname': surname.trim(),
        'numIncomeSources': numIncomeSources,
        'numUsers': numUsers,
        'updatedAt': Timestamp.now(),
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => SetupPage2(numIncomeSources: numIncomeSources)));
    } catch (e) {
      setState(() {
        errorMessage = "Error saving data: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 200, child: Lottie.asset('assets/animations/setup_intro.json', fit: BoxFit.cover)),
                const SizedBox(height: 20),
                Text("Welcome to PennyPlanner!", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text("Let's set up your financial journey.", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]), textAlign: TextAlign.center),
                const SizedBox(height: 30),
                _buildTextField("Surname/Family Name", (String newValue) => setState(() => surname = newValue)),
                const SizedBox(height: 20),
                _buildDropdown("Number of Income Sources", numIncomeSources, (int newValue) => setState(() => numIncomeSources = newValue)),
                const SizedBox(height: 20),
                _buildDropdown("Number of Users", numUsers, (int newValue) => setState(() => numUsers = newValue)),
                const SizedBox(height: 40),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      errorMessage!,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63))))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _saveSetupData,
                          child: Text("Get Started", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, int currentValue, ValueChanged<int> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
        child: DropdownButton<int>(
          value: currentValue,
          isExpanded: true,
          underline: const SizedBox(),
          items: List.generate(10, (index) => index + 1)
              .map((value) => DropdownMenuItem<int>(value: value, child: Text("$value", style: GoogleFonts.poppins(fontSize: 16))))
              .toList(),
          onChanged: (int? newValue) => newValue != null ? onChanged(newValue) : null,
        ),
      ),
    ]);
  }

  Widget _buildTextField(String label, ValueChanged<String> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(fontSize: 18, color: Colors.black)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your surname",
            hintStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
          ),
          style: GoogleFonts.poppins(fontSize: 16),
          onChanged: onChanged,
        ),
      ),
    ]);
  }
}
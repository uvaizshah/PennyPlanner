import 'package:flutter/material.dart';
import 'setup_page2.dart';


class SetupPage1 extends StatefulWidget {
  const SetupPage1({super.key});

  @override
  _SetupPage1State createState() => _SetupPage1State();
}

class _SetupPage1State extends State<SetupPage1> {
  final TextEditingController _familyNameController = TextEditingController();
  int _numUsers = 1;
  int _numIncomeSources = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setup: Basic Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Family Name"),
            TextField(
              controller: _familyNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Family Name",
              ),
            ),
            SizedBox(height: 20),
            Text("Number of Users"),
            DropdownButton<int>(
              value: _numUsers,
              items: List.generate(10, (index) => index + 1)
                  .map((num) => DropdownMenuItem(value: num, child: Text("$num")))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _numUsers = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Number of Income Sources"),
            DropdownButton<int>(
              value: _numIncomeSources,
              items: List.generate(10, (index) => index + 1)
                  .map((num) => DropdownMenuItem(value: num, child: Text("$num")))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _numIncomeSources = value!;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigate to Step 2 (Income Details Page)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => SetupPage2(numIncomeSources: _numIncomeSources),
                  ),

                );
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

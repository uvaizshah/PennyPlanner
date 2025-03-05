import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homescreen.dart'; // Import Home Screen

class Pin extends StatefulWidget {
  const Pin({super.key});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      setState(() {}); // Update UI when the PIN changes
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPinComplete = _pinController.text.length == 4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Title
                const Icon(
                  Icons.show_chart,
                  color: Color(0xFFE91E63),
                  size: 50.0,
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'PennyPlanner',
                  style: TextStyle(
                    color: Color(0xFFE91E63),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Enter your 4-digit PIN',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                ),
                const SizedBox(height: 32.0),

                // PIN Input using TextField
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '', // Hide character counter
                      hintText: '••••',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFE91E63),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFE91E63),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFFE91E63),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Next Button
                ElevatedButton(
                  onPressed: isPinComplete
                      ? () {
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("PIN setup successful!"),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          // Navigate to Home Screen after 2 seconds
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          });
                        }
                      : null, // Disable button if PIN is incomplete
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPinComplete ? const Color(0xFFE91E63) : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 14.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

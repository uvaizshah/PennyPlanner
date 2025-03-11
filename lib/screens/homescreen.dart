import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'analysis.dart';
import 'categories.dart';
import 'profile.dart';
import 'login_screen.dart'; // Assuming LoginScreen exists
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(const PennyPlannerApp());
}

class PennyPlannerApp extends StatelessWidget {
  const PennyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data != null ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreenContent(),
    const AnalysisScreen(),
    const CategoriesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isHomeScreen = _selectedIndex == 0;

    return Scaffold(
      backgroundColor: isHomeScreen ? const Color(0xFFE91E63) : Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: isHomeScreen ? Colors.white : Colors.pink,
        buttonBackgroundColor: isHomeScreen ? Colors.white : Colors.pink,
        height: 60,
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          Icon(Icons.home, size: 30, color: _selectedIndex == 0 ? Colors.pink : Colors.white),
          Icon(Icons.bar_chart, size: 30, color: _selectedIndex == 1 ? Colors.white : Colors.black),
          Icon(Icons.category, size: 30, color: _selectedIndex == 2 ? Colors.white : Colors.black),
          Icon(Icons.person, size: 30, color: _selectedIndex == 3 ? Colors.white : Colors.black),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double balance = 0.0;
  String surname = "User";

  @override
  void initState() {
    super.initState();
    _setupRealtimeListener();
  }

  void _setupRealtimeListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in");
      return;
    }

    print("Starting listener for user: ${user.uid}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen(
          (snapshot) {
            print("Snapshot received for user ${user.uid}: exists=${snapshot.exists}, data=${snapshot.data()}");
            if (snapshot.exists) {
              try {
                setState(() {
                  surname = (snapshot['surname'] as String?) ??
                      (snapshot['fullName'] as String?)?.split(' ').last ??
                      "User";
                  totalIncome = (snapshot['totalIncome'] as num?)?.toDouble() ?? 0.0;
                  Map<String, dynamic>? oldExpenses = snapshot['expenses'] as Map<String, dynamic>?;
                  totalExpense = oldExpenses != null
                      ? oldExpenses.values.fold(0.0, (sum, value) => sum + ((value is num) ? value.toDouble() : 0.0))
                      : 0.0;
                  balance = totalIncome - totalExpense;
                  print("State updated - surname: $surname, totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance");
                });
              } catch (e) {
                print("Error processing snapshot data: $e");
              }
            } else {
              print("No document exists for user: ${user.uid}");
            }
          },
          onError: (error) {
            print("Listener error: $error");
          },
          onDone: () {
            print("Listener completed for user: ${user.uid}");
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    double expensePercentage = totalIncome != 0 ? (totalExpense / totalIncome) : 0.0;
    print("Building with surname: $surname, totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance");

    return SafeArea(
      child: Container(
        // Keep the app's background as #E91E63
        color: const Color(0xFFE91E63),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey, $surname",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _getGreeting(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white, size: 30),
                      onPressed: () {
                        // TODO: Navigate to Notifications Page
                      },
                    ),
                  ],
                ),
              ),
              // Box for Balance and Total Expense (changed to solid white)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Changed to solid white
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Subtle shadow for depth
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Balance",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black, // Changed to black
                                ),
                              ),
                              Text(
                                "₹${balance.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Changed to black
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Total Expense",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black, // Changed to black
                                ),
                              ),
                              Text(
                                "-₹${totalExpense.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF1744), // Neon red (still visible against white)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Original Total Monthly Income: ",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black, // Changed to black
                              ),
                            ),
                            TextSpan(
                              text: "₹${totalIncome.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00E676), // Neon green (still visible against white)
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: expensePercentage,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)), // Original pink (visible against white)
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${(expensePercentage * 100).toStringAsFixed(0)}% of your income spent",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black, // Changed to black
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else if (hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }
}
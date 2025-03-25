import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'analysis.dart';
import 'categories.dart';
import 'profile.dart';
import 'login_screen.dart';
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
                  double savingsAmount = (snapshot['savingsAmount'] as num?)?.toDouble() ?? 0.0;
                  Map<String, dynamic>? categories = snapshot['categories'] as Map<String, dynamic>?;
                  totalExpense = categories != null
                      ? categories.values.fold(0.0, (sum, cat) {
                          if (cat is Map<String, dynamic>) {
                            return sum + ((cat['expense'] as num?)?.toDouble() ?? 0.0);
                          }
                          return sum;
                        })
                      : 0.0;
                  balance = totalIncome - savingsAmount - totalExpense;
                  print("State updated - surname: $surname, totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance");

                  FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                    'remainingBalance': balance,
                  }).catchError((error) {
                    print("Failed to update remainingBalance: $error");
                  });
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
        color: const Color(0xFFE91E63),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey, $surname 👋",
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "₹${balance.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "-₹${totalExpense.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF1744),
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
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "₹${totalIncome.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00E676),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: expensePercentage,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${(expensePercentage * 100).toStringAsFixed(0)}% of your income spent",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  constraints: BoxConstraints(
                    minHeight: 250,
                    maxWidth: MediaQuery.of(context).size.width - 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.receipt, color: Color(0xFFE91E63), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "Recent Transactions",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "See All",
                              style: GoogleFonts.poppins(color: Color(0xFFE91E63)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection('transactions')
                              .orderBy('date', descending: true)
                              .limit(5)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Text(
                                "Error loading transactions",
                                style: GoogleFonts.poppins(color: Colors.black54),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  "No transactions yet",
                                  style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 16),
                                ),
                              );
                            }

                            final transactions = snapshot.data!.docs;

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index].data() as Map<String, dynamic>;
                                final amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
                                final category = transaction['category'] as String? ?? "Unknown";
                                final date = (transaction['date'] as Timestamp?)?.toDate() ?? DateTime.now();

                                String emoji = _getCategoryEmoji(category);

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "$category $emoji",
                                                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${date.day} ${date.monthName} ${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                                                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "-₹${amount.toStringAsFixed(2)}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: const Color(0xFFFF1744),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index < transactions.length - 1)
                                      Divider(
                                        color: Colors.grey[300],
                                        thickness: 0.5,
                                        height: 20,
                                      ),
                                  ],
                                );
                              },
                            );
                          },
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

  String _getCategoryEmoji(String category) {
    final categoryMap = {
      'food': '🍽️',
      'transport': '🚌',
      'groceries': '🥕',
      'rent': '🏠',
      'healthcare': '🏥',
      'entertainment': '🎬',
      'gift': '🎁',
      'other': '📌',
    };
    return categoryMap[category.toLowerCase()] ?? "📌";
  }
}

extension DateOnly on DateTime {
  String get monthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
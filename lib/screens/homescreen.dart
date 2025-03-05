import 'package:flutter/material.dart';
import 'analysis.dart';
import 'categories.dart';
import 'profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import package

void main() {
  runApp(const PennyPlannerApp());
}

class PennyPlannerApp extends StatelessWidget {
  const PennyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Active tab index

  // Pages for navigation
  final List<Widget> _pages = [
    const HomeScreenContent(),  // ✅ FIXED: Now HomeScreenContent is properly included
    AnalysisScreen(),     // Analysis
    CategoriesScreen(),   // Categories
    ProfileScreen(),      // Profile
  ];

  @override
  Widget build(BuildContext context) {
    bool isHomeScreen = _selectedIndex == 0;

    return Scaffold(
      backgroundColor: isHomeScreen ? const Color(0xFFF06292) : Colors.white, // Pink for Home, White for others
      body: _pages[_selectedIndex], // Show selected page

      // Curved Bottom Navigation Bar
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Ensures the background blends correctly
        color: isHomeScreen ? Colors.white : Colors.pink, // Navbar white on home, pink on other pages
        buttonBackgroundColor: isHomeScreen ? Colors.white : Colors.pink, // White circle for selected item
        height: 60, // Bar height
        index: _selectedIndex, // Active tab index
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          Icon(Icons.home, size: 30, color: _selectedIndex == 0 ? Colors.pink : Colors.white), // Home
          Icon(Icons.bar_chart, size: 30, color: _selectedIndex == 1 ? Colors.white : Colors.black), // Analysis
          Icon(Icons.category, size: 30, color: _selectedIndex == 2 ? Colors.white : Colors.black), // Categories
          Icon(Icons.person, size: 30, color: _selectedIndex == 3 ? Colors.white : Colors.black), // Profile
        ],
      ),
    );
  }
}

// ✅ ADDED: HomeScreenContent Definition
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Greeting & Notification Icon
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, Uvaiz", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Good Morning", style: TextStyle(fontSize: 16, color: Colors.white)),
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

          // Balance & Expense Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        children: [
                          Text("Total Balance", style: TextStyle(fontSize: 16, color: Colors.black54)),
                          Text("₹56,250.00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Total Expense", style: TextStyle(fontSize: 16, color: Colors.black54)),
                          Text("-₹22,500.40", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress Bar
                  LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                  ),
                  const SizedBox(height: 5),
                  const Text("30% of your expenses, looks good.", style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart'; // Import LoginScreen for logout redirection
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'dart:io'; // Import dart:io for File

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String surname = "User"; // Default until fetched
  int numIncomeSources = 0; // Default until fetched
  double totalIncome = 0.0; // Default until fetched
  String email = ""; // New field for email
  String profileImageUrl = ""; // New field for profile image URL
  bool isProfilePictureUploaded = false; // New field to track profile picture upload

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            surname = (userDoc['surname'] as String?) ??
                (userDoc['fullName'] as String?)?.split(' ').last ?? "User";
            numIncomeSources = (userDoc['numIncomeSources'] as int?) ?? 0;
            totalIncome = (userDoc['totalIncome'] as num?)?.toDouble() ?? 0.0;
            email = user.email ?? ""; // Fetch email
            profileImageUrl = userDoc['profileImageUrl'] ?? ""; // Fetch profile image URL
            isProfilePictureUploaded = profileImageUrl.isNotEmpty; // Check if profile picture is uploaded
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
      );
    }
  }

  Future<void> _uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // TODO: Upload the image to a storage service and get the URL
      // For now, we'll just simulate the upload
      String uploadedImageUrl = await _simulateImageUpload(imageFile);

      setState(() {
        profileImageUrl = uploadedImageUrl;
        isProfilePictureUploaded = true;
      });

      // Update the user's profile image URL in Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'profileImageUrl': uploadedImageUrl});
      }
    }
  }

  Future<String> _simulateImageUpload(File imageFile) async {
    // Simulate an image upload and return a URL
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return "https://example.com/path/to/uploaded/image.jpg"; // Simulated URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE91E63),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: _uploadProfilePicture,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl.isEmpty
                        ? Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              // User Info Section
              Text(
                "$surname Family 👋", // Remove "Hey,"
                style: GoogleFonts.poppins(
                  fontSize: 20, // Adjust font size
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE91E63),
                ),
              ),
              Text(
                email, // Display email
                style: GoogleFonts.poppins(
                  fontSize: 12, // Adjust font size
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Income Info Boxes (Matching HomeScreen style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100, // Set a fixed height
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Income Sources", // Remove "Total"
                              style: GoogleFonts.poppins(
                                fontSize: 12, // Reduced font size
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "$numIncomeSources",
                              style: GoogleFonts.poppins(
                                fontSize: 18, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100, // Set a fixed height
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Monthly Income",
                              style: GoogleFonts.poppins(
                                fontSize: 12, // Reduced font size
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "₹${totalIncome.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: 18, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00E676), // Green for income
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Options
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
                    children: [
                      ProfileMenuItem(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {
                          // TODO: Implement settings
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.info,
                        title: "About Us",
                        onTap: () {
                          // TODO: Implement about us
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.logout,
                        title: "Logout",
                        onTap: _logout,
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
}

// Profile Menu Item Widget (Reused from original)
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE91E63), size: 28),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

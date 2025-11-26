import 'package:express_car/HomeDetails/Menu/Menu.dart';
import 'Add_Car.dart';
import 'DashBoard.dart';
import 'Manage_Booking.dart';
import 'Manage_Cars.dart';
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ViewProfile.dart';
import 'package:express_car/Splash/GetStart.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HandleBusinessPage extends StatefulWidget {
  const HandleBusinessPage({Key? key}) : super(key: key);

  @override
  State<HandleBusinessPage> createState() => _HandleBusinessPageState();
}

class _HandleBusinessPageState extends State<HandleBusinessPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _profileImage;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _profileImage = data['photoURL'] ?? '';
        _userName = data['displayName'] ?? '';
        _userEmail = data['email'] ?? user.email ?? '';
      });
    } else {
      // fallback
      setState(() {
        _userName = user.displayName ?? '';
        _userEmail = user.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuPage(),
                        ),
                      );
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Handle Business",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewProfilePage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          (_profileImage != null && _profileImage!.isNotEmpty)
                          ? NetworkImage(_profileImage!)
                          : const AssetImage("assets/images/profile.jpg")
                                as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName.isNotEmpty ? _userName : 'Loading...',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _userEmail.isNotEmpty ? _userEmail : '',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Menu Items
              _buildMenuItem(Icons.dashboard, "Dashboard", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.directions_car, "Add Car", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCarPage()),
                );
              }),
              _buildMenuItem(Icons.car_rental, "Manage Cars", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageCarsPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.book_online, "Manage Bookings", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageBookingsPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.person, "Profile", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewProfilePage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.logout, "Logout", () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const GetStart()),
                  (route) => false,
                );
              }),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 34, 26),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Back To Home",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }
}

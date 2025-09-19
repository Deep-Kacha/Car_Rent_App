import 'Add_Car.dart';
import 'DashBoard.dart';
import 'Manage_Booking.dart';
import 'Manage_Cars.dart';
// TODO: The following imports are from a different project and their paths need to be corrected.
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ViewProfile.dart';
import 'package:express_car/Splash/GetStart.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HandleBusinessPage extends StatelessWidget {
  const HandleBusinessPage({Key? key}) : super(key: key);

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
                      Navigator.pop(context);
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
                  const SizedBox(width: 48), // spacing to balance row
                ],
              ),

              const SizedBox(height: 20),

              // Profile info (tappable)
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/profile.jpg"),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Ethan John",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "ethanjohn@example.com",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Menu Items with icons
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
              _buildMenuItem(Icons.logout, "Logout",  () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => GetStart()), 
                (route) => false,
              );
            },),

              const Spacer(),

              // Back to Home button
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

  // Reusable Menu Item with icon
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black), //  Icon added
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }
}

import 'package:car_rental_project/Home%20Page/home_page.dart';
import 'package:flutter/material.dart';

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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // spacing to balance row
                ],
              ),

              const SizedBox(height: 20),

              // Profile info
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3", // Replace with your image
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Ethan John",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "ethanjohn@example.com",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Menu Items with icons
              _buildMenuItem(Icons.dashboard, "Dashboard", () {}),
              _buildMenuItem(Icons.directions_car, "Add Car", () {}),
              _buildMenuItem(Icons.car_rental, "Manage Cars", () {}),
              _buildMenuItem(Icons.book_online, "Manage Bookings", () {}),
              _buildMenuItem(Icons.person, "Profile", () {}),
              _buildMenuItem(Icons.logout, "Logout", () {}),

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

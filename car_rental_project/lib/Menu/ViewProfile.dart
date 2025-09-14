<<<<<<< Updated upstream
import 'package:car_rental_project/Home%20Page/Menu.dart';
import 'package:car_rental_project/Menu/EditProfile.dart';
=======
import 'package:car_rental_project/Authorization/Menu/Menu.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button & Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(
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
                        "View Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the row
                ],
              ),

              const SizedBox(height: 20),

              // Profile Picture
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
              const SizedBox(height: 12),

              // Name & Join Date
              const Text(
                "Ethan John",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Joined Dec 2023",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                "Profile with personal info and connected social media appear more trustworthy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),
              const Divider(),

              // Section Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verified Info",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // Email row
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Email address"),
                trailing: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.grey),
                  onPressed: () {},
                ),
              ),

              // Google row
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Google"),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text("Connect"),
                ),
              ),

              // Phone
              _buildInfoField("Phone", "+91 41555 50132"),

              // Address
              _buildInfoField("Address", "Rajkot, Gujarat, India"),

              // DOB & Gender
              Row(
                children: [
                  Expanded(
                    child: _buildInfoField("Date of Birth", "20/05/2004"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoField("Gender", "Male")),
                ],
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 63, 34, 26),
        shape: const CircleBorder(),
        onPressed: () {
<<<<<<< Updated upstream
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const EditProfilePage(), // Change to EditProfilePage when implemented
            ),
          );
=======
          // Navigator.push(
          //   // context,
          //   // MaterialPageRoute(
          //   //   builder: (context) =>
          //   //       const EditProfilePage(), // Change to EditProfilePage when implemented
          //   // ),
          // );
>>>>>>> Stashed changes
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  // Helper for read-only info fields
  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

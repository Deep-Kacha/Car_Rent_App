import 'package:flutter/material.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Profile Image
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(
                  "assets/profile.jpg",
                ), // replace with NetworkImage if needed
              ),
              const SizedBox(height: 10),

              // Name
              const Text(
                "Ethan John",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),
              const Text(
                "Profile with personal info and connected social\nmedia appear more trustworthy.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const SizedBox(height: 20),

              // Divider
              const Divider(thickness: 1, color: Colors.grey),

              // Verified Info
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verified Info",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              // Email Address row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Email address",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Icon(Icons.settings, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 15),

              // Google Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Google", style: TextStyle(fontSize: 15)),
                  Text(
                    "Connect",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Phone Field
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Phone",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "+91 98765 43210",
                ),
              ),
              const SizedBox(height: 15),

              // Address Field
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Address",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Surat, Gujarat, India",
                ),
              ),
              const SizedBox(height: 15),

              // Date of Birth & Gender Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Date of Birth",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "20/05/2004",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Gender",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Male",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Floating Edit Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Edit Profile Page
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}

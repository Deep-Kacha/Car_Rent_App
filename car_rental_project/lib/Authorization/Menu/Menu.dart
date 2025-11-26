import 'package:car_rental_project/Admin%20Panel%20Files/HandleBussiness.dart';
import 'package:car_rental_project/Authorization/Menu/Menus%20Files/Account.dart';
import 'package:car_rental_project/Authorization/Menu/Menus%20Files/ChangePassword.dart';
import 'package:car_rental_project/Authorization/Menu/Menus%20Files/EditProfile.dart';

import 'package:car_rental_project/Authorization/Menu/Menus%20Files/ViewProfile.dart';
import 'package:car_rental_project/Splash/GetStart.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Full white background
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// Title
              const Text(
                "Menu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 20),

              /// Profile (row: avatar + name)
              /// Profile (row: avatar + name)
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
                  children: const [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.jpg"),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Ethan John",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Divider
              Divider(color: Colors.grey, thickness: 1),

              const SizedBox(height: 20),

              /// Menu Items
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(Icons.person_outline, "Account", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountPage(),
                        ),
                      );
                    }),
                    _buildMenuItem(Icons.badge_outlined, "View Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewProfilePage(),
                        ),
                      );
                    }),
                    _buildMenuItem(Icons.edit, "Edit Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    }),
                    _buildMenuItem(Icons.lock_outline, "Change Password", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    }),
                    _buildMenuItem(
                      Icons.business_center,
                      "Handle Business",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HandleBusinessPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(Icons.logout, "Log Out", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GetStart(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menu Item UI
  static Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
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

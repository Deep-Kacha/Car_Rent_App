import 'package:express_car/Handle_car/HandleBussiness.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/Account.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ChangePassword.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/EditProfile.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ViewProfile.dart';
import 'package:express_car/Splash/GetStart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                    _buildMenuItem(Icons.logout, "Log Out", () async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => GetStart(),
                        ), // Replace with your sign in page widget
                        (route) => false,
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

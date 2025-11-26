import 'package:express_car/Handle_car/HandleBussiness.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/Account.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ChangePassword.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/EditProfile.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ViewProfile.dart';
import 'package:express_car/Splash/GetStart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'displayName': 'Guest User', 'photoURL': ''};

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();

      return {
        'displayName': data?['displayName'] ?? user.displayName ?? 'Guest User',
        'photoURL': data?['photoURL'] ?? user.photoURL ?? '',
      };
    } catch (e) {
      print("Error fetching user data: $e");
      return {
        'displayName': user.displayName ?? 'Guest User',
        'photoURL': user.photoURL ?? '',
      };
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
              const SizedBox(height: 10),
              const Text(
                "Menu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              /// Profile Row
              FutureBuilder<Map<String, dynamic>>(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      children: const [
                        CircleAvatar(radius: 25, backgroundColor: Colors.grey),
                        SizedBox(width: 15),
                        Text("Loading...", style: TextStyle(fontSize: 26)),
                      ],
                    );
                  }

                  final userData = snapshot.data ?? {};
                  final name = userData['displayName'] ?? 'Guest User';
                  final photoUrl = userData['photoURL'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProfilePage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : const AssetImage("assets/images/profile.jpg")
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 20),

              /// Menu Items
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(
                      Icons.person_outline,
                      "Account",
                      context,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AccountPage()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.badge_outlined,
                      "View Profile",
                      context,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ViewProfilePage()),
                        );
                      },
                    ),
                    _buildMenuItem(Icons.edit, "Edit Profile", context, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfilePage()),
                      );
                    }),
                    _buildMenuItem(
                      Icons.lock_outline,
                      "Change Password",
                      context,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.business_center,
                      "Handle Business",
                      context,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HandleBusinessPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(Icons.logout, "Log Out", context, () async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => GetStart()),
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

  static Widget _buildMenuItem(
    IconData icon,
    String title,
    BuildContext context,
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

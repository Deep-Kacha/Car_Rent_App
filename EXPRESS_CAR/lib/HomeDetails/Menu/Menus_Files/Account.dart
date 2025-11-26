import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _obscurePassword = true;

  User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (currentUser == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      final data = doc.data() ?? {};

      setState(() {
        userData = {
          'email': currentUser!.email ?? 'No Email',
          'phone': data['phone'] ?? 'Not Provided',
          'password': data['password'] ?? '********',
          'googleConnected': currentUser!.providerData.any(
            (p) => p.providerId == 'google.com',
          ),
        };
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        userData = {
          'email': currentUser!.email ?? 'No Email',
          'phone': 'Not Provided',
          'password': '********',
          'googleConnected': currentUser!.providerData.any(
            (p) => p.providerId == 'google.com',
          ),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Email
              const Text(
                "Email",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: userData?['email'] ?? "Loading...",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              const Text(
                "Password",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                obscureText: _obscurePassword,
                controller: TextEditingController(
                  text: _obscurePassword
                      ? "**********"
                      : userData?['password'] ?? '********',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Phone number
              const Text(
                "Phone number",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: userData?['phone'] ?? "Loading...",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Google connection
              const Text(
                "Google",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                userData?['googleConnected'] == true
                    ? "Connected"
                    : "Not connected",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Divider(thickness: 0.8, height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

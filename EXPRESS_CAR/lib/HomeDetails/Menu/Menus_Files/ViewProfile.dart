import 'package:express_car/HomeDetails/Menu/Menus_Files/EditProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({Key? key}) : super(key: key);

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
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
          'displayName':
              data['displayName'] ?? currentUser!.displayName ?? 'Guest User',
          'photoURL': data['photoURL'] ?? currentUser!.photoURL ?? '',
          'email': currentUser!.email ?? 'Not Provided',
          'phone': data['phone'] ?? 'Not Provided',
          'address': data['address'] ?? 'Not Provided',
          'dob': data['dob'] ?? 'Not Provided',
          'gender': data['gender'] ?? 'Not Provided',
          'googleConnected': currentUser!.providerData.any(
            (p) => p.providerId == 'google.com',
          ),
        };
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        userData = {
          'displayName': currentUser!.displayName ?? 'Guest User',
          'photoURL': currentUser!.photoURL ?? '',
          'email': currentUser!.email ?? 'Not Provided',
          'phone': 'Not Provided',
          'address': 'Not Provided',
          'dob': 'Not Provided',
          'gender': 'Not Provided',
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
        child: userData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top Row: Back button + title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Profile",
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

                    // Profile photo
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userData!['photoURL'] != ''
                          ? NetworkImage(userData!['photoURL'])
                          : const AssetImage("assets/images/profile.jpg")
                                as ImageProvider,
                    ),
                    const SizedBox(height: 12),

                    // Name
                    Text(
                      userData!['displayName'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Description
                    const Text(
                      "Profile with personal info and connected social media appear more trustworthy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),

                    // Verified Info Title
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Verified Info",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _buildInfoField("Email", userData!['email']),

                    // Google
                    _buildInfoField(
                      "Google",
                      userData!['googleConnected'] == true
                          ? "Connected"
                          : "Not connected",
                    ),

                    // Phone
                    _buildInfoField("Phone", userData!['phone']),

                    // Address
                    _buildInfoField("Address", userData!['address']),

                    // DOB & Gender
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoField(
                            "Date of Birth",
                            userData!['dob'],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoField("Gender", userData!['gender']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),

      // Floating edit button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 63, 34, 26),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfilePage()),
          );
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

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

import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _obscurePassword = true; //  password toggle
  final String _password = "ethanjohn@123"; //  your actual password

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
              /// Back button + Title
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

              /// Email
              const Text(
                "Email",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Password with toggle
              const Text(
                "Password",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                obscureText: _obscurePassword,
                controller: TextEditingController(
                  text: _obscurePassword ? "**********" : _password,
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

              /// Phone number
              const Text(
                "Phone number",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "+91 41555 50132",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Google
              const Text(
                "Google",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              const Text(
                "Not connected",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Divider(thickness: 0.8, height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hasPassword = true;
  bool isUpdating = false;

  bool oldVisible = false;
  bool newVisible = false;
  bool confirmVisible = false;

  final Color brown = const Color.fromARGB(255, 63, 34, 26);

  @override
  void initState() {
    super.initState();
    _checkPasswordState();
  }

  Future<void> _checkPasswordState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    hasPassword = user.providerData.any((p) => p.providerId == "password");

    setState(() {});
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => isUpdating = true);

    final user = FirebaseAuth.instance.currentUser;

    try {
      if (hasPassword) {
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: oldPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);
      }

      await user!.updatePassword(newPasswordController.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {"hasPassword": true},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: ${e.toString()}")));
    } finally {
      setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Change Password",
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

                if (!hasPassword)
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        "assets/images/ChangePassword.jpg",
                        height: 180,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "You signed in using Google.\nNo password is set for this account.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => setState(() => hasPassword = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brown,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Set Password",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                else ...[
                  const Text(
                    "Enter your new password below",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  Image.asset("assets/images/ChangePassword.jpg", height: 180),
                  const SizedBox(height: 30),

                  _buildField(
                    label: "Old Password",
                    controller: oldPasswordController,
                    isVisible: oldVisible,
                    toggleVisibility: () =>
                        setState(() => oldVisible = !oldVisible),
                    validator: (value) =>
                        value.isEmpty ? "Enter old password" : null,
                  ),

                  _buildField(
                    label: "New Password",
                    controller: newPasswordController,
                    isVisible: newVisible,
                    toggleVisibility: () =>
                        setState(() => newVisible = !newVisible),
                    validator: (value) {
                      if (value.isEmpty) return "Password required";
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  _buildField(
                    label: "Confirm Password",
                    controller: confirmPasswordController,
                    isVisible: confirmVisible,
                    toggleVisibility: () =>
                        setState(() => confirmVisible = !confirmVisible),
                    validator: (value) => value != newPasswordController.text
                        ? "Passwords do not match"
                        : null,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isUpdating ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brown,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isUpdating
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required String? Function(String) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: !isVisible,
            validator: (value) => validator(value ?? ""),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: toggleVisibility,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

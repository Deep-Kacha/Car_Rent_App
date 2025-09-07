import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  String? newPasswordError;
  String? confirmPasswordError;

  // Password validation (same style as SignUp)
  String? _validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])').hasMatch(value)) {
      return "Must contain at least 1 uppercase & 1 number";
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value != newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Enter your new password below",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 30),

                // Illustration
                Center(
                  child: Image.asset(
                    "assets/images/ChangePassword.jpg",
                    height: 180,
                  ),
                ),

                const SizedBox(height: 30),

                // Old Password
                _buildPasswordField(
                  label: "Old Password",
                  controller: oldPasswordController,
                  isVisible: oldPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      oldPasswordVisible = !oldPasswordVisible;
                    });
                  },
                ),

                // New Password
                _buildPasswordField(
                  label: "New Password",
                  controller: newPasswordController,
                  isVisible: newPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      newPasswordVisible = !newPasswordVisible;
                    });
                  },
                  validator: _validatePassword,
                  onChanged: (val) {
                    setState(() {
                      newPasswordError = _validatePassword(val);
                    });
                  },
                  errorText: newPasswordError,
                ),

                // Confirm Password
                _buildPasswordField(
                  label: "Confirm Password",
                  controller: confirmPasswordController,
                  isVisible: confirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      confirmPasswordVisible = !confirmPasswordVisible;
                    });
                  },
                  validator: _validateConfirmPassword,
                  onChanged: (val) {
                    setState(() {
                      confirmPasswordError = _validateConfirmPassword(val);
                    });
                  },
                  errorText: confirmPasswordError,
                ),

                const SizedBox(height: 30),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (newPasswordError == null &&
                          confirmPasswordError == null &&
                          newPasswordController.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password changed successfully!"),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fix the errors first!"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 63, 34, 26),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Confirm Password",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable password field with eye icon + validation
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    String? Function(String)? validator,
    Function(String)? onChanged,
    String? errorText,
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
            onChanged: onChanged,
            validator: (value) => validator?.call(value ?? ""),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              errorText: errorText,
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

import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  // Real-time validation messages
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  void _validateOldPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _oldPasswordError = "Please enter your old password";
      } else {
        _oldPasswordError = null;
      }
    });
  }

  void _validateNewPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _newPasswordError = "Please enter a new password";
      } else if (value.length < 6) {
        _newPasswordError = "Password must be at least 6 characters";
      } else {
        _newPasswordError = null;
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value != newPasswordController.text) {
        _confirmPasswordError = "Passwords do not match";
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _submitForm() {
    _validateOldPassword(oldPasswordController.text);
    _validateNewPassword(newPasswordController.text);
    _validateConfirmPassword(confirmPasswordController.text);

    if (_oldPasswordError == null &&
        _newPasswordError == null &&
        _confirmPasswordError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),

              // Title
              Center(
                child: Column(
                  children: const [
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Enter your new password below.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Old Password
              TextField(
                controller: oldPasswordController,
                obscureText: _isObscureOld,
                onChanged: _validateOldPassword,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  errorText: _oldPasswordError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureOld ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureOld = !_isObscureOld;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // New Password
              TextField(
                controller: newPasswordController,
                obscureText: _isObscureNew,
                onChanged: _validateNewPassword,
                decoration: InputDecoration(
                  labelText: "New Password",
                  errorText: _newPasswordError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureNew = !_isObscureNew;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: _isObscureConfirm,
                onChanged: _validateConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  errorText: _confirmPasswordError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirm = !_isObscureConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _submitForm,
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
    );
  }
}

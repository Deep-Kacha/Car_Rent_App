import 'package:flutter/material.dart';
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedGender;

  bool _isSubmitting = false;
  final Color _primaryBrown = const Color(0xFF3E2723);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isSubmitting = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  InputDecoration _fieldDecoration(
    String label,
    String hint, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top bar with back button + centered title
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Complete your profile",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // keeps title centered
                ],
              ),
              const SizedBox(height: 6),

              Text(
                "Give the information to make you trusted user",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              Center(
                child: Image.asset(
                  "assets/images/complete_profile.jpg",
                  height: 180,
                ),
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _fieldDecoration("Full Name", "Ethan John"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        // Only alphabets (a-z, A-Z) and spaces allowed
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
                          return 'Name should contain only letters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _fieldDecoration(
                        "Phone Number",
                        "Enter phone number",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your phone number";
                        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return "Enter valid 10-digit number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _fieldDecoration(
                        "Address",
                        "Enter your address",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Date of Birth
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _fieldDecoration(
                        "Date Of Birth",
                        "Select your date of birth",
                        suffix: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _dobController.text =
                              "${picked.day}/${picked.month}/${picked.year}";
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      decoration: _fieldDecoration("Gender", "Select gender"),
                      value: _selectedGender,
                      items: ["Male", "Female", "Other"]
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                      validator: (value) =>
                          value == null ? "Please select your gender" : null,
                    ),
                    const SizedBox(height: 24),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBrown,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:car_rental_project/Admin%20Panel%20Files/Done.dart';
import 'package:car_rental_project/Admin%20Panel%20Files/HandleBussiness.dart';
import 'package:car_rental_project/Authorization/Menu/Menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController carNameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController numberPlateController = TextEditingController();
  final TextEditingController featureController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _carImage;
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _carImage = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No image selected.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  // Save Car
  void _saveCar() {
    if (_formKey.currentState!.validate() && _carImage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Car saved successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and upload an image."),
        ),
      );
    }
  }

  // Reusable Text Field with real-time validation
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?) validator, {
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        autovalidateMode:
            AutovalidateMode.onUserInteraction, // ✅ Real-time validation
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back + Title + Menu
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
                          "Add Car",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HandleBusinessPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Text(
                  "Fill car details below",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),

                // Upload Car Photo
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      image: _carImage != null
                          ? DecorationImage(
                              image: FileImage(_carImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _carImage == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt, color: Colors.grey),
                              SizedBox(width: 10),
                              Text("Upload car photo"),
                            ],
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                // Input Fields with validation
                _buildTextField("Car Name", carNameController, (value) {
                  if (value!.isEmpty) return "Car name is required";
                  return null;
                }),
                _buildTextField("Model", modelController, (value) {
                  if (value!.isEmpty) return "Model is required";
                  return null;
                }),
                _buildTextField("Car Number Plate", numberPlateController, (
                  value,
                ) {
                  if (value!.isEmpty) return "Number plate is required";
                  return null;
                }),
                _buildTextField("Car Feature", featureController, (value) {
                  if (value!.isEmpty) return "Feature is required";
                  return null;
                }),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("Year", yearController, (value) {
                        if (value!.isEmpty) return "Year is required";
                        if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                          return "Enter valid year";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField("Price / day", priceController, (
                        value,
                      ) {
                        if (value!.isEmpty) return "Price is required";
                        if (double.tryParse(value) == null) {
                          return "Enter valid number";
                        }
                        return null;
                      }),
                    ),
                  ],
                ),

                _buildTextField("Description", descriptionController, (value) {
                  if (value!.isEmpty) return "Description is required";
                  return null;
                }, maxLines: 3),

                const Spacer(),

                // Save Car Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _carImage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Car saved successfully!"),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinalDonePage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please fill all fields and upload an image.",
                            ),
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
                      "Save Car",
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
}

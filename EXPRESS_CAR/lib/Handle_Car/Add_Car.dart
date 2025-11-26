import 'dart:io';
import 'package:express_car/Handle_Car/HandleBussiness.dart';
import 'Done.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  final TextEditingController carNameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController numberPlateController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pickupDropController = TextEditingController();

  File? _carImage;
  final ImagePicker _picker = ImagePicker();

  // Initialize Cloudinary
  final cloudinary = CloudinaryPublic(
    'dstlqyncg', // Replace with your Cloudinary cloud name
    'carimages18', // Replace with your Cloudinary upload preset
    cache: false,
  );

  String? _selectedCarType;
  List<String> _selectedFeatures = [];

  // Car features
  final List<String> carFeatures = [
    "Petrol engine",
    "Diesel engine",
    "CNG engine",
    "Hybrid engine",
    "Electric motor",
    "Manual gearbox",
    "Automatic gearbox",
    "Power steering",
    "Air conditioning",
    "Sunroof",
    "Alloy wheels",
    "Touchscreen",
    "Android Auto",
    "Apple CarPlay",
    "ABS",
    "Airbags",
    "Rear camera",
    "Cruise control",
    "Bluetooth",
    "Navigation",
  ];

  // Car types
  final List<String> carTypes = [
    "Sedan",
    "Coupe",
    "Hatchback",
    "SUV",
    "Crossover",
    "Convertible",
    "Wagon",
    "Pickup",
    "Van",
    "SportsCar",
    "Luxury",
    "Electric",
    "Hybrid",
  ];

  // Pick image
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _carImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  // Get the next car ID using a Firestore transaction
  Future<int> _getNextCarId() async {
    final counterRef =
        FirebaseFirestore.instance.collection('counters').doc('car_counter');

    return FirebaseFirestore.instance.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);

      if (!snapshot.exists) {
        transaction.set(counterRef, {'current_id': 1});
        return 1;
      }

      final newId = (snapshot.data()!['current_id'] as int) + 1;
      transaction.update(counterRef, {'current_id': newId});
      return newId;
    });
  }

  // Save car
  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate() &&
        _carImage != null &&
        _selectedCarType != null &&
        _selectedFeatures.isNotEmpty) {
      setState(() => _isSaving = true);

      try {
        // 1. Upload image to Cloudinary
        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(_carImage!.path,
              resourceType: CloudinaryResourceType.Image),
        );
        final imageUrl = response.secureUrl;

        // 2. Get current user and next car ID
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("User not logged in");

        final carId = await _getNextCarId();

        // 3. Prepare data for Firestore
        final carData = {
          'car_id': carId,
          'owner_email': user.email,
          'name': carNameController.text,
          'model': modelController.text,
          'type': _selectedCarType,
          'number_plate': numberPlateController.text,
          'features': _selectedFeatures,
          'location': pickupDropController.text,
          'year': int.tryParse(yearController.text),
          'price_per_day': double.tryParse(priceController.text),
          'description': descriptionController.text,
          'image_url': imageUrl,
          'created_at': FieldValue.serverTimestamp(),
        };

        // 4. Save to Firestore
        await FirebaseFirestore.instance
            .collection('cars')
            .doc(carId.toString())
            .set(carData);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FinalDonePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to save car: $e")));
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields and selections!")),
      );
    }
  }

  // TextField builder
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
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

  // Searchable Car Type
  Widget _buildCarTypeField() {
    return GestureDetector(
      onTap: () {
        _openSearchDialog(
          title: "Select Car Type",
          items: carTypes,
          isMulti: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCarType ?? "Select Car Type",
              style: TextStyle(
                color: _selectedCarType == null ? Colors.grey : Colors.black,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // Searchable Features
  Widget _buildFeatureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _openSearchDialog(
              title: "Select Car Features",
              items: carFeatures,
              isMulti: true,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedFeatures.isEmpty
                      ? "Select Features"
                      : "${_selectedFeatures.length} Selected",
                  style: TextStyle(
                    color: _selectedFeatures.isEmpty
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (_selectedFeatures.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _selectedFeatures
                .map(
                  (f) => Chip(
                    label: Text(f),
                    onDeleted: () {
                      setState(() {
                        _selectedFeatures.remove(f);
                      });
                    },
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  // Reusable search dialog
  void _openSearchDialog({
    required String title,
    required List<String> items,
    required bool isMulti,
  }) {
    List<String> filtered = List.from(items);
    List<String> tempSelected = List.from(_selectedFeatures);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        filtered = items
                            .where(
                              (i) =>
                                  i.toLowerCase().contains(val.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, index) {
                        final item = filtered[index];
                        final isSelected = isMulti
                            ? tempSelected.contains(item)
                            : _selectedCarType == item;
                        return ListTile(
                          title: Text(item),
                          trailing: isMulti
                              ? Checkbox(
                                  value: isSelected,
                                  onChanged: (val) {
                                    setModalState(() {
                                      if (val == true) {
                                        tempSelected.add(item);
                                      } else {
                                        tempSelected.remove(item);
                                      }
                                    });
                                  },
                                )
                              : isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            if (isMulti) {
                              setModalState(() {
                                if (tempSelected.contains(item)) {
                                  tempSelected.remove(item);
                                } else {
                                  tempSelected.add(item);
                                }
                              });
                            } else {
                              setState(() {
                                _selectedCarType = item;
                              });
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  if (isMulti)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFeatures = List.from(tempSelected);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Done"),
                    ),
                ],
              ),
            );
          },
        );
      },
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
            child: ListView(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      "Add Car",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
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
                const SizedBox(height: 20),

                // Upload Car Image
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
                        ? const Center(child: Text("Upload car photo"))
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                // Input fields
                _buildTextField(
                  "Car Name",
                  carNameController,
                  (val) => val!.isEmpty ? "Car name required" : null,
                ),
                _buildTextField(
                  "Model",
                  modelController,
                  (val) => val!.isEmpty ? "Model required" : null,
                ),

                // Car Type dropdown
                _buildCarTypeField(),

                _buildTextField(
                  "Car Number Plate",
                  numberPlateController,
                  (val) => val!.isEmpty ? "Plate required" : null,
                ),

                // Features dropdown
                _buildFeatureField(),

                _buildTextField(
                  "Pickup & Drop Location",
                  pickupDropController,
                  (val) => val!.isEmpty ? "Pickup location required" : null,
                ),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("Year", yearController, (value) {
                        if (value!.isEmpty) return "Year required";
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
                        if (value!.isEmpty) return "Price required";
                        if (double.tryParse(value) == null) {
                          return "Enter number";
                        }
                        return null;
                      }),
                    ),
                  ],
                ),

                _buildTextField(
                  "Description",
                  descriptionController,
                  (val) => val!.isEmpty ? "Description required" : null,
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveCar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 63, 34, 26),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save Car",
                            style: TextStyle(color: Colors.white),
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

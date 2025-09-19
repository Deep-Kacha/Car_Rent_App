import 'dart:io';
import 'package:car_rental_project/Admin%20Panel%20Files/Done.dart';
import 'package:car_rental_project/Admin%20Panel%20Files/HandleBussiness.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  final TextEditingController yearController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _carImage;
  final ImagePicker _picker = ImagePicker();

  // Selected features
  List<String> _selectedFeatures = [];

  // Car features list
  final List<String> carFeatures = [
    "Petrol engine",
    "Diesel engine",
    "CNG engine",
    "Hybrid engine",
    "Electric motor",
    "Manual gearbox",
    "Automatic gearbox",
    "AMT gearbox",
    "CVT gearbox",
    "DCT gearbox",
    "Power steering",
    "Power windows",
    "Central locking",
    "Adjustable seats",
    "Air conditioning",
    "Heater",
    "Odometer",
    "Speedometer",
    "Tachometer",
    "Fuel gauge",
    "Seat belts",
    "Halogen lamps",
    "Spare wheel",
    "Toolkit",
    "Keyless entry",
    "Push start",
    "Remote start",
    "Cruise control",
    "Tilt steering",
    "Telescopic steering",
    "Height seat",
    "Rear vents",
    "USB ports",
    "Cup holders",
    "Armrests",
    "Storage box",
    "Cooled glovebox",
    "Auto climate",
    "Ventilated seats",
    "Heated seats",
    "Rear armrest",
    "Split seats",
    "Power tailgate",
    "ABS",
    "EBD",
    "ESP",
    "Hill assist",
    "Hill descent",
    "Airbags",
    "Pretensioners",
    "ISOFIX",
    "Parking sensors",
    "Rear camera",
    "360 camera",
    "Blind spot",
    "Lane warning",
    "Adaptive cruise",
    "Brake assist",
    "TPMS",
    "Immobilizer",
    "Anti-theft",
    "Auto-dimming IRVM",
    "Touchscreen",
    "Android Auto",
    "Apple CarPlay",
    "Navigation",
    "Bluetooth",
    "FM radio",
    "USB/AUX",
    "Premium audio",
    "Steering controls",
    "Voice assist",
    "Wi-Fi hotspot",
    "Internet",
    "Rear screens",
    "Alloy wheels",
    "LED lamps",
    "DRLs",
    "Fog lamps",
    "Projectors",
    "Matrix lights",
    "Auto headlamps",
    "Rain wipers",
    "Electric ORVMs",
    "Heated mirrors",
    "Sunroof",
    "Panoramic roof",
    "Roof rails",
    "Shark antenna",
    "Spoiler",
    "Chrome trim",
    "Black pack",
    "Digital cluster",
    "Head-up display",
    "Drive modes",
    "Paddle shifters",
    "Auto parking",
    "Collision avoid",
    "Sign detect",
    "Connected car",
    "OTA updates",
    "Leather seats",
    "Ambient lights",
    "Massage seats",
    "Gesture control",
    "4-zone AC",
    "Soft doors",
    "Window blinds",
    "Air purifier",
    "Fragrance",
    "Mini fridge",
    "Soundproof glass",
    "Lounge seats",
    "Turbo engine",
    "AWD",
    "4x4 drive",
    "Launch control",
    "Sport exhaust",
    "Air suspension",
    "Diff lock",
    "Tow hook",
    "Trailer assist",
    "Drive-by-wire",
  ];

  // Pick image from gallery
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

  // Save Car
  void _saveCar() {
    if (_formKey.currentState!.validate() &&
        _carImage != null &&
        _selectedFeatures.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Car saved successfully!")));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FinalDonePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields, select features, and upload image.",
          ),
        ),
      );
    }
  }

  // Text field
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

  @override
  Widget build(BuildContext context) {
    final featureItems = carFeatures
        .map((f) => MultiSelectItem<String>(f, f))
        .toList();

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
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
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

                // Input Fields
                _buildTextField(
                  "Car Name",
                  carNameController,
                  (value) => value!.isEmpty ? "Car name required" : null,
                ),
                _buildTextField(
                  "Model",
                  modelController,
                  (value) => value!.isEmpty ? "Model required" : null,
                ),
                _buildTextField(
                  "Car Number Plate",
                  numberPlateController,
                  (value) => value!.isEmpty ? "Plate required" : null,
                ),

                // Multi-select Dropdown
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: MultiSelectDialogField(
                    items: featureItems,
                    title: const Text("Car Features"),
                    searchable: true,
                    buttonText: const Text("Select Features"),
                    onConfirm: (values) {
                      setState(() {
                        _selectedFeatures = values.cast<String>();
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay(),
                  ),
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
                  (value) => value!.isEmpty ? "Description required" : null,
                  maxLines: 3,
                ),

                const Spacer(),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveCar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 63, 34, 26),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
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

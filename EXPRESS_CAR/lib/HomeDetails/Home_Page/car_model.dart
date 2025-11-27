class Car {
  final int carId;
  final String name;
  final String model;
  final String type; // sedan, SUV, etc.
  final String numberPlate;
  final List<String> features;
  final String location;
  final int year;
  final double pricePerDay;
  final String description;
  final String? imageUrl; // Made nullable for safety
  final String? ownerEmail;

  Car({
    required this.carId,
    required this.name,
    required this.model,
    required this.type,
    required this.numberPlate,
    required this.features,
    required this.location,
    required this.year,
    required this.pricePerDay,
    required this.description,
    this.imageUrl,
    this.ownerEmail,
  });

  // Factory to create Car from Firestore data
  factory Car.fromFirestore(Map<String, dynamic> data) {
    try {
      final allKeys = data.keys.toList();
      print("📋 Document has ${allKeys.length} fields: $allKeys");
      
      final car = Car(
        carId: _parseIntField(data, 'car_id'),
        name: _parseStringFieldRequired(data, 'name', 'Unknown Car'),
        model: _parseStringFieldRequired(data, 'model', 'Unknown'),
        type: _parseStringFieldRequired(data, 'type', 'Sedan'), // Default to Sedan if missing
        numberPlate: _parseStringFieldRequired(data, 'number_plate', 'N/A'),
        features: _parseFeaturesField(data),
        location: _parseStringFieldRequired(data, 'location', 'Unknown'),
        year: _parseIntField(data, 'year'),
        pricePerDay: _parseDoubleField(data, 'price_per_day'),
        description: _parseStringFieldRequired(data, 'description', 'No description'),
        imageUrl: _parseStringField(data, 'image_url'),
        ownerEmail: _parseStringField(data, 'owner_email'),
      );
      
      print("✅ Car created: ${car.name} (Type: ${car.type}, Price: ${car.pricePerDay}/day)");
      return car;
    } catch (e) {
      print("❌ Error parsing car: $e");
      print("Data keys: ${data.keys}");
      rethrow;
    }
  }
  
  static int _parseIntField(Map<String, dynamic> data, String key, [int defaultValue = 0]) {
    try {
      final value = data[key];
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      print("⚠️ Error parsing $key as int: $e");
      return defaultValue;
    }
  }

  static double _parseDoubleField(Map<String, dynamic> data, String key, [double defaultValue = 0.0]) {
    try {
      final value = data[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      print("⚠️ Error parsing $key as double: $e");
      return defaultValue;
    }
  }

  static String _parseStringFieldRequired(Map<String, dynamic> data, String key, String defaultValue) {
    try {
      final value = data[key];
      if (value == null) return defaultValue;
      return value.toString();
    } catch (e) {
      print("⚠️ Error parsing $key as string: $e");
      return defaultValue;
    }
  }

  static String? _parseStringField(Map<String, dynamic> data, String key, [String? defaultValue]) {
    try {
      final value = data[key];
      if (value == null) return defaultValue;
      return value.toString();
    } catch (e) {
      print("⚠️ Error parsing $key as string: $e");
      return defaultValue;
    }
  }

  static List<String> _parseFeaturesField(Map<String, dynamic> data) {
    try {
      final value = data['features'];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      print("⚠️ Error parsing features: $e");
      return [];
    }
  }

  // Convert Car to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'car_id': carId,
      'name': name,
      'model': model,
      'type': type,
      'number_plate': numberPlate,
      'features': features,
      'location': location,
      'year': year,
      'price_per_day': pricePerDay,
      'description': description,
      'image_url': imageUrl,
      'owner_email': ownerEmail,
    };
  }
}

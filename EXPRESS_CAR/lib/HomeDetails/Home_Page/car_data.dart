import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_model.dart';

List<Car> cars = [];

Future<void> fetchCarsFromFirestore() async {
  try {
    print("🔄 Starting to fetch cars from Firestore...");
    
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('cars').get();

    print("📊 Retrieved ${snapshot.docs.length} documents from cars collection");
    
    if (snapshot.docs.isEmpty) {
      print("⚠️ No documents found in cars collection");
      cars = [];
      return;
    }

    cars = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print("📄 Document ID: ${doc.id}");
      print("📄 All fields: ${data.keys.toList()}");
      print("📄 Document data: $data");
      
      try {
        final car = Car.fromFirestore(data);
        print("✅ Created Car: ${car.name} (ID: ${car.carId})");
        return car;
      } catch (e) {
        print("❌ Error creating Car from document: $e");
        rethrow;
      }
    }).toList();

    print("✅ Successfully fetched ${cars.length} cars from Firestore");
    print("🚗 Cars list: ${cars.map((c) => c.name).toList()}");
  } catch (e) {
    print("❌ Error fetching cars from Firestore: $e");
    cars = [];
  }
}

// Get car by ID
Car? getCarById(int carId) {
  try {
    return cars.firstWhere((car) => car.carId == carId);
  } catch (e) {
    print("Car with ID $carId not found");
    return null;
  }
}

// Get cars by type (category)
List<Car> getCarsByType(String type) {
  return cars.where((car) => car.type.toLowerCase() == type.toLowerCase()).toList();
}

// Get cars by owner email
List<Car> getCarsByOwner(String ownerEmail) {
  return cars.where((car) => car.ownerEmail == ownerEmail).toList();
}

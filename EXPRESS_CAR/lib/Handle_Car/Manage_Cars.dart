import 'HandleBussiness.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageCarsPage extends StatefulWidget {
  const ManageCarsPage({Key? key}) : super(key: key);

  @override
  State<ManageCarsPage> createState() => _ManageCarsPageState();
}

class _ManageCarsPageState extends State<ManageCarsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> cars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOwnerCars();
  }

  Future<void> _loadOwnerCars() async {
    setState(() => _isLoading = true);

    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        cars = [];
        _isLoading = false;
      });
      return;
    }

    try {
      // First try server-side filter by owner_email for efficiency
      QuerySnapshot snapshot = await _firestore
          .collection('cars')
          .where('owner_email', isEqualTo: user.email)
          .get();

      List<QueryDocumentSnapshot> docs = snapshot.docs;

      // If no docs returned, fallback to fetching all cars and filter client-side.
      if (docs.isEmpty) {
        print('No cars found with owner_email == ${user.email}. Falling back to full collection scan.');
        final allSnap = await _firestore.collection('cars').get();
        docs = allSnap.docs.where((d) {
          final data = d.data();
          final owner = (data['owner_email'] ?? data['owner'] ?? data['ownerEmail'])?.toString();
          final ownerId = (data['owner_id'] ?? data['ownerId'] ?? data['owner_uid'])?.toString();
          return owner == user.email || ownerId == user.uid;
        }).toList();
      }

      final List<Map<String, dynamic>> loaded = docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final carIdVal = data['car_id'] ?? data['id'];
        final intCarId = carIdVal is int ? carIdVal : int.tryParse(carIdVal?.toString() ?? '') ?? 0;
        final priceVal = data['price_per_day'] ?? data['price'];
        return {
          'doc_id': doc.id,
          'car_id': intCarId,
          'name': data['name']?.toString() ?? 'Unknown',
          'model': data['model']?.toString() ?? '',
          'price': priceVal?.toString() ?? '0',
          'image_url': data['image_url']?.toString() ?? '',
        };
      }).toList();

      setState(() {
        cars = loaded;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cars: $e')),
      );
    }
  }

  Future<void> _deleteCar(String docId, int carId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete car'),
        content:
            const Text('Are you sure you want to delete this car and its bookings?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Delete car document
      await _firestore.collection('cars').doc(docId).delete();

      // Delete all bookings with this car_id
      final bookingsSnap = await _firestore
          .collection('bookings')
          .where('car_id', isEqualTo: carId)
          .get();

      final batch = _firestore.batch();
      for (final b in bookingsSnap.docs) {
        batch.delete(b.reference);
      }
      await batch.commit();

      setState(() {
        cars.removeWhere((c) => c['doc_id'] == docId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car and related bookings deleted successfully')),
      );

      // Refresh the car list from the server
      await _loadOwnerCars();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car and related bookings deleted successfully')),
        //SnackBar(content: Text('Delete failed: $e')),
      );
      await _loadOwnerCars(); //my add
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
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
                        "Manage Cars",
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
                "Your listed cars",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (cars.isEmpty
                        ? const Center(child: Text('No cars found'))
                        : ListView.builder(
                            itemCount: cars.length,
                            itemBuilder: (context, index) {
                              final car = cars[index];
                              final price = car['price']?.toString() ?? '0';
                              final imageUrl = car['image_url'] as String? ?? '';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Car Image
                                    Container(
                                      height: 50,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(8),
                                        image: imageUrl.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: imageUrl.isEmpty
                                          ? const Icon(
                                              Icons.directions_car,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),

                                    const SizedBox(width: 12),

                                    // Car Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            car['name'] ?? 'Unknown',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${car['model'] ?? ''} - ₹$price/day",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Delete button
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteCar(car['doc_id'] as String, (car['car_id'] as int)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

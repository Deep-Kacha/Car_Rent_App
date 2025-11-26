import 'package:flutter/material.dart';
import 'package:express_car/HomeDetails/Home_Page/car_model.dart';
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookedCar extends StatefulWidget {
  final List<Map<String, dynamic>> bookedCars;

  const BookedCar({Key? key, required this.bookedCars}) : super(key: key);

  @override
  State<BookedCar> createState() => _BookedCarState();
}

class _BookedCarState extends State<BookedCar> {
  late List<Map<String, dynamic>> localBookedCars;
  bool _isLoading = true;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    localBookedCars = [];
    _loadUserBookings();
  }

  Future<void> _loadUserBookings() async {
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        // fallback to provided list
        localBookedCars = List.from(widget.bookedCars);
        setState(() => _isLoading = false);
        return;
      }

      // Query bookings where user_mail == user's email OR userId == uid
      final q = await _firestore
          .collection('bookings')
          .where('user_mail', isEqualTo: user.email)
          .get();

      // If none found by email, try by userId
      List<QueryDocumentSnapshot> docs = q.docs;
      if (docs.isEmpty) {
        final q2 = await _firestore
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .get();
        docs = q2.docs;
      }

      final List<Map<String, dynamic>> combined = [];

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;

        final carId = data['car_id'];
        Car? carObj;

        try {
          if (carId != null) {
            final carDoc = await _firestore.collection('cars').doc(carId.toString()).get();
            if (carDoc.exists) {
              final carData = carDoc.data() as Map<String, dynamic>;
              carObj = Car.fromFirestore(carData);
            }
          }
        } catch (e) {
          print('Failed to load car $carId for booking ${doc.id}: $e');
        }

        combined.add({
          'booking_id': data['booking_id'] ?? doc.id,
          'startDate': data['start_date'] ?? data['startDate'] ?? '',
          'endDate': data['end_date'] ?? data['endDate'] ?? '',
          'total_amount': data['total_amount'] ?? 0,
          'car': carObj ?? data['car'] ?? null,
        });
      }

      localBookedCars = combined;
    } catch (e) {
      print('Error loading bookings: $e');
      // fallback
      localBookedCars = List.from(widget.bookedCars);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void cancelBooking(int index) {
    final booking = localBookedCars[index];
    final car = booking['car'];

    // Delete booking in Firestore if booking_id present
    final bookingId = booking['booking_id']?.toString();

    if (bookingId != null && bookingId.isNotEmpty) {
      _firestore.collection('bookings').doc(bookingId).delete().catchError((e) {
        print('Failed to delete booking $bookingId: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel booking: $e')),
        );
      });
    }

    // Remove from UI list
    setState(() {
      localBookedCars.removeAt(index);
    });

    // Also remove from global list if possible
    try {
      HomePage.bookedCarsMaps.removeWhere((item) {
        final itemCar = item['car'];
        if (itemCar == null) return false;
        return (itemCar.carId == (car is Car ? car.carId : null)) &&
            (item['startDate'] == booking['startDate'] || item['start_date'] == booking['startDate']);
      });
    } catch (_) {}

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${car is Car ? car.name : 'Booking'} booking cancelled')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Booked Car",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : localBookedCars.isEmpty
                        ? const Center(
                            child: Text(
                              "No Cars Booked Yet",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: localBookedCars.length,
                            itemBuilder: (context, index) {
                              final booking = localBookedCars[index];
                              final Car? carNullable = booking['car'] as Car?;
                              final Car car = carNullable ?? Car(
                                carId: 0,
                                name: 'Unknown',
                                model: 'Unknown',
                                type: 'Unknown',
                                numberPlate: '',
                                features: [],
                                location: 'Unknown',
                                year: 0,
                                pricePerDay: 0,
                                description: '',
                                imageUrl: null,
                                ownerEmail: null,
                              );

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                height: 150,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3E2723),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: (car.imageUrl != null && car.imageUrl!.isNotEmpty)
                                      ? Image.network(
                                          car.imageUrl!,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 150,
                                              height: 150,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.directions_car),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 150,
                                          height: 150,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.directions_car),
                                        ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        car.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Start Date : ${booking['startDate'].substring(0, 10)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "End Date : ${booking['endDate'].substring(0, 10)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Location : ${car.location}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),

                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                          ),
                                          onPressed: () => cancelBooking(index),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

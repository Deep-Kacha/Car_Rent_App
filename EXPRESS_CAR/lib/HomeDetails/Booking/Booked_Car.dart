import 'package:flutter/material.dart';
import 'package:express_car/HomeDetails/Home_Page/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookedCar extends StatefulWidget {
  final List<Map<String, dynamic>> bookedCars;
  // The bookingTrigger is no longer needed.
  // final int bookingTrigger;

  const BookedCar({Key? key, required this.bookedCars}) : super(key: key);

  @override
  State<BookedCar> createState() => _BookedCarState();
}

class _BookedCarState extends State<BookedCar> {
  late List<Map<String, dynamic>> localBookedCars;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void cancelBooking(String bookingId, Car? car) {
    // Delete booking in Firestore if booking_id present
    if (bookingId != null && bookingId.isNotEmpty) {
      _firestore.collection('bookings').doc(bookingId).delete().catchError((e) {
        print('Failed to delete booking $bookingId: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel booking: $e')),
        );
      });
    }

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

              Expanded(child: _buildBookingsStream()),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text("Please log in to see your bookings."));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('bookings')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No Cars Booked Yet",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return _buildBookingCard(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildBookingCard(DocumentSnapshot bookingDoc) {
    final booking = bookingDoc.data() as Map<String, dynamic>;
    final carId = booking['car_id'];
    final bookingId = booking['booking_id']?.toString() ?? bookingDoc.id;

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('cars').doc(carId.toString()).get(),
      builder: (context, carSnapshot) {
        if (!carSnapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 150,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final carData = carSnapshot.data?.data() as Map<String, dynamic>?;
        final Car car = carData != null
            ? Car.fromFirestore(carData)
            : Car.fromFirestore({}); // Fallback for missing car

        final startDate = booking['start_date'] ?? '';
        final endDate = booking['end_date'] ?? '';

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
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.directions_car),
                        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text("Start Date : ${startDate.isNotEmpty ? startDate.substring(0, 10) : 'N/A'}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    Text("End Date : ${endDate.isNotEmpty ? endDate.substring(0, 10) : 'N/A'}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    Text("Location : ${car.location}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onPressed: () => cancelBooking(bookingId, car),
                        child: const Text("Cancel", style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

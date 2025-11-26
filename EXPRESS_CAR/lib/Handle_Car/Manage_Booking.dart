import 'HandleBussiness.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageBookingsPage extends StatefulWidget {
  const ManageBookingsPage({Key? key}) : super(key: key);

  @override
  _ManageBookingsPageState createState() => _ManageBookingsPageState();
}

class _ManageBookingsPageState extends State<ManageBookingsPage> {
  List<Map<String, dynamic>> bookings = [];
  bool _isLoading = true;
  int _totalBooked = 0;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadOwnerBookings();
  }

  Future<void> _loadOwnerBookings() async {
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Get all cars owned by this user
      final carsSnap = await _firestore
          .collection('cars')
          .where('owner_email', isEqualTo: user.email)
          .get();

      final carIds = carsSnap.docs.map((doc) => (doc['car_id'] as int)).toList();
      if (carIds.isEmpty) {
        setState(() {
          bookings = [];
          _totalBooked = 0;
          _isLoading = false;
        });
        return;
      }

      // Get bookings for these cars
      final bookingsSnap = await _firestore
          .collection('bookings')
          .where('car_id', whereIn: carIds)
          .get();

      final List<Map<String, dynamic>> loaded = [];
      for (final doc in bookingsSnap.docs) {
        final data = doc.data();
        loaded.add({
          'booking_id': data['booking_id'] ?? doc.id,
          'car_id': data['car_id'] ?? 0,
          'car_name': data['car_name'] ?? 'Car ${data['car_id']}',
          'user_email': data['user_mail'] ?? 'unknown',
          'start_date': data['start_date'] ?? '',
          'end_date': data['end_date'] ?? '',
          'total_amount': data['total_amount'] ?? 0,
        });
      }

      setState(() {
        bookings = loaded;
        _totalBooked = loaded.length;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading bookings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings: $e')),
      );
      setState(() => _isLoading = false);
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
                        "Manage Bookings",
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

              Text(
                "Total Booked Cars: $_totalBooked",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              const Text(
                "Bookings for your cars",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (bookings.isEmpty
                        ? const Center(
                            child: Text(
                              "No bookings yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookings[index];
                              final carName = booking['car_name'] ?? 'Unknown Car';
                              final startDate = booking['start_date']?.toString().substring(0, 10) ?? 'N/A';
                              final endDate = booking['end_date']?.toString().substring(0, 10) ?? 'N/A';
                              final totalAmount = booking['total_amount'] ?? 0;
                              final userEmail = booking['user_email'] ?? 'unknown';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    // Placeholder for car image
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.directions_car),
                                    ),
                                    const SizedBox(width: 12),

                                    // Car details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            carName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "$startDate → $endDate",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "User: $userEmail",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "Total: ₹$totalAmount",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 8),
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

import 'package:express_car/HomeDetails/Home_Page/car_model.dart';
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final Car car;
  final Function(Map<String, dynamic> bookingDetails) onCarBooked;

  const BookingPage({super.key, required this.car, required this.onCarBooked});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? startDate;
  DateTime? endDate;
  bool _isBooking = false;

  Future<void> pickDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;

          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("End date reset because it's before Start date"),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          if (startDate != null && picked.isBefore(startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("End date cannot be before Start date"),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            endDate = picked;
          }
        }
      });
    }
  }

  /// -------------------------------------------------------------
  /// REAL-TIME BOOKING CHECK (NO UI CHANGE)
  /// -------------------------------------------------------------
  // Get the next booking ID using a Firestore transaction
  Future<int> _getNextBookingId() async {
    final counterRef =
        FirebaseFirestore.instance.collection('counters').doc('booking_counter');

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
  bool isCarAlreadyBooked(DateTime start, DateTime end) {
    for (var booking in HomePage.bookedCarsMaps) {
      if (booking['car'].carId == widget.car.carId) {
        DateTime s = DateTime.parse(booking['startDate']);
        DateTime e = DateTime.parse(booking['endDate']);

        // If date range overlaps → reject
        if (start.isBefore(e) && end.isAfter(s)) {
          return true;
        }
      }
    }
    return false;
  }

  /// -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    // Calculate rental days and total dynamically
    int rentalDays = 0;
    if (startDate != null && endDate != null) {
      if (!endDate!.isBefore(startDate!)) {
        rentalDays = endDate!.difference(startDate!).inDays + 1;
      }
    }
    final int totalAmount = (rentalDays * car.pricePerDay).toInt();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Booking",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Car Image
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: (car.imageUrl != null && car.imageUrl!.isNotEmpty)
                      ? Image.network(
                          car.imageUrl!,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(Icons.directions_car),
                            );
                          },
                        )
                      : Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Icon(Icons.directions_car),
                        ),
                ),

                /// Car Name
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(),

                /// Trip Dates
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: buildDateColumn("Starting Date", startDate, () {
                          pickDate(isStart: true);
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: buildDateColumn("Ending Date", endDate, () {
                          pickDate(isStart: false);
                        }),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                /// Location
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "Pickup & Return Location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            car.location,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),

                /// Features
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "Car Basics & Features",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: car.features.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 20,
                              childAspectRatio: 4,
                            ),
                        itemBuilder: (context, index) {
                          final f = car.features[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 7,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    car.description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
                const Divider(),

                /// Warning
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Warning",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Payment will be required at the time of car pick-up.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Book Button
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B221D),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    onPressed: _isBooking
                        ? null
                        : () async {
                      if (startDate != null && endDate != null) {
                        /// ----------------------------
                        /// REAL-TIME DATE CHECK
                        /// ----------------------------
                        if (isCarAlreadyBooked(startDate!, endDate!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Car already booked for selected dates",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        // compute booking details
                        final startIso = DateTime(
                          startDate!.year,
                          startDate!.month,
                          startDate!.day,
                        ).toIso8601String();
                        final endIso = DateTime(
                          endDate!.year,
                          endDate!.month,
                          endDate!.day,
                        ).toIso8601String();

                        setState(() => _isBooking = true);

                        try {
                          final bookingId = await _getNextBookingId();
                          final user = FirebaseAuth.instance.currentUser;
                          final userEmail = user?.email ?? 'unknown';

                          final bookingData = {
                            'booking_id': bookingId,
                            'car_id': widget.car.carId,
                            'user_mail': userEmail,
                            'userId': user?.uid,
                            'owner_email': widget.car.ownerEmail ?? '',
                            'start_date': startIso,
                            'end_date': endIso,
                            'total_amount': totalAmount,
                            'created_at': FieldValue.serverTimestamp(),
                          };

                          // Save booking to Firestore under 'bookings' collection
                          await FirebaseFirestore.instance
                              .collection('bookings')
                              .doc(bookingId.toString())
                              .set(bookingData);

                          final bookedCarInfo = {
                            'car': widget.car,
                            'startDate': startIso,
                            'endDate': endIso,
                            'booking_id': bookingId,
                            'total_amount': totalAmount,
                          };

                          Navigator.pop(context, 1);
                        } on FirebaseException catch (e) {
                          // Handle Firestore permission errors specifically
                          final isPermissionError =
                              e.code == 'permission-denied' ||
                                  (e.message != null &&
                                      e.message!.toLowerCase().contains('permission'));

                          if (isPermissionError) {
                            // Show a blocking dialog with guidance
                            if (mounted) {
                              await showDialog<void>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Permission Denied'),
                                  content: const Text(
                                      'Cloud Firestore: permission denied — caller does not have permission to perform this operation.\n\nCheck your Firestore security rules or ensure the user is authenticated.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            // Also log for debugging
                            print('Firestore permission denied: ${e.message}');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to save booking: ${e.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to save booking: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          if (mounted) setState(() => _isBooking = false);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select both start and end dates",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: _isBooking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            // Show dynamic total when both dates are selected, otherwise show 0
                            startDate != null && endDate != null && rentalDays > 0
                                ? "Total ₹$totalAmount (${rentalDays} days)"
                                : "Total ₹0",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
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

  Widget buildDateColumn(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null
                      ? "${date.day}/${date.month}/${date.year}"
                      : "Select Date",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
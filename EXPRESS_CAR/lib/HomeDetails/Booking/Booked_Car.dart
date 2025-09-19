import 'package:flutter/material.dart';
import 'package:express_car/HomeDetails/Home_Page/car_model.dart';

class BookedCar extends StatefulWidget {
  final List<Map<String, dynamic>> bookedCars;

  const BookedCar({Key? key, required this.bookedCars}) : super(key: key);

  @override
  State<BookedCar> createState() => _BookedCarState();
}

class _BookedCarState extends State<BookedCar> {
  late List<Map<String, dynamic>> localBookedCars;

  @override
  void initState() {
    super.initState();
    // Copy bookedCars so we can modify it locally
    localBookedCars = List.from(widget.bookedCars);
  }

  void cancelBooking(int index) {
    final car = localBookedCars[index]['car'];
    setState(() {
      localBookedCars.removeAt(index);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${car.name} booking cancelled")));
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

              /// List of booked cars
              Expanded(
                child: localBookedCars.isEmpty
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
                          final car = booking['car'] as Car;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF3E2723,
                              ), // Brown background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Car Image (left side)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    car.image,
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// Car Details + Cancel Button
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
                                        "Start Date : ${booking['startDate']}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "End Date : ${booking['endDate']}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Location : ${car.address}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),

                                      /// Cancel Button
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
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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

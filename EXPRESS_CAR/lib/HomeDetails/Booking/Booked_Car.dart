import 'package:flutter/material.dart';
import 'package:express_car/HomeDetails/Home_Page/car_model.dart';
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';

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
    localBookedCars = List.from(widget.bookedCars);
  }

  void cancelBooking(int index) {
    final car = localBookedCars[index]['car'];

    // Remove from UI list
    setState(() {
      localBookedCars.removeAt(index);
    });

    // Remove from global list also (REAL-TIME)
    HomePage.bookedCarsMaps.removeWhere(
      (item) =>
          item['car'].carId == car.carId &&
          item['startDate'] == widget.bookedCars[index]['startDate'],
    );

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
                          final Car car = booking['car'];

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

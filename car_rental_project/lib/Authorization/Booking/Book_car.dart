import 'package:car_rental_project/Authorization/Home%20Page/car_model.dart';
import 'package:car_rental_project/Authorization/Home%20Page/home_page.dart';
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
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

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
                  child: Image.asset(
                    car.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        car.address,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                /// Features
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Car Features",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: car.features
                        .map(
                          (f) => Chip(
                            label: Text(f),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Divider(),

                /// Description
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
                    car.description ?? '',
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
                const Divider(),

                /// Warning
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
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
                ),
                const Divider(),

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
                    onPressed: () {
                      if (startDate != null && endDate != null) {
                        final bookedCarInfo = {
                          'car': widget.car,
                          'startDate':
                              "${startDate!.day}/${startDate!.month}/${startDate!.year}",
                          'endDate':
                              "${endDate!.day}/${endDate!.month}/${endDate!.year}",
                        };

                        HomePage.bookedCarsMaps.add(bookedCarInfo);

                        widget.onCarBooked(bookedCarInfo);

                        Navigator.pop(context, 1);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select both start and end dates",
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Total ${car.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

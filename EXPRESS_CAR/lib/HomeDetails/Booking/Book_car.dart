import 'package:express_car/HomeDetails/Home_Page/car_model.dart';
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
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
  bool isCarAlreadyBooked(DateTime start, DateTime end) {
    for (var booking in HomePage.bookedCarsMaps) {
      if (booking['car'].name == widget.car.name) {
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
                            car.address,
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
                    car.description ?? '',
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
                    onPressed: () {
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

                        final bookedCarInfo = {
                          'car': widget.car,
                          'startDate': DateTime(
                            startDate!.year,
                            startDate!.month,
                            startDate!.day,
                          ).toIso8601String(),
                          'endDate': DateTime(
                            endDate!.year,
                            endDate!.month,
                            endDate!.day,
                          ).toIso8601String(),
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
                            backgroundColor: Colors.red,
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

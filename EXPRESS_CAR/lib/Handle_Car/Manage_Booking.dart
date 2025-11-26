import 'HandleBussiness.dart';
import 'package:flutter/material.dart';

class ManageBookingsPage extends StatefulWidget {
  const ManageBookingsPage({Key? key}) : super(key: key);

  @override
  _ManageBookingsPageState createState() => _ManageBookingsPageState();
}

class _ManageBookingsPageState extends State<ManageBookingsPage> {
  List<Map<String, dynamic>> bookings = [
    {
      "car": "Toyota Corolla",
      "date": "2025-06-28 → 2025-06-29",
      "status": "confirmed",
    },
    {
      "car": "Volvo C40 EV",
      "date": "2025-06-25 → 2025-06-27",
      "status": "pending",
    },
  ];

  //  Confirm booking
  void _confirmBooking(int index) {
    setState(() {
      bookings[index]["status"] = "confirmed";
    });
  }

  //  Cancel booking (only if not confirmed)
  void _cancelBooking(int index) {
    if (bookings[index]["status"] == "confirmed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Confirmed booking cannot be cancelled")),
      );
      return;
    }

    setState(() {
      bookings[index]["status"] = "cancelled";
    });
  }

  //  Status badge widget
  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case "confirmed":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case "pending":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case "cancelled":
        bgColor = Colors.grey.shade300;
        textColor = Colors.grey.shade800;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
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

              const Text(
                "Approve or cancel booking requests",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final status = booking["status"];

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
                          ),
                          const SizedBox(width: 12),

                          // Car details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking["car"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  booking["date"],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status Badge
                          _statusBadge(status),

                          const SizedBox(width: 8),

                          // Confirm/Cancel buttons (only for pending)
                          if (status == "pending")
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () => _confirmBooking(index),
                                  child: const Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _cancelBooking(index),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
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

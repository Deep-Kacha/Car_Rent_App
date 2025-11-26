
import 'package:flutter/material.dart';

class GetStart extends StatelessWidget {
  const GetStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Title
            const Text(
              "Express Car\nRental",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            const Text(
              "Rent the car of your dreams to travel\nanywhere and anytime",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 50),

            // Car Image
            Center(
              child: Image.asset(
                "assets/images/StartCar.jpg", // <-- replace with your car image
                height: 280,
              ),
            ),

            const Spacer(),

            // Get Started button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    63,
                    34,
                    26,
                  ), // dark brown
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SingUp()),
                  // );
                },
                child: const Text(
                  "Get started",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Already have an account button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // orange color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SignIn()),
                  // );
                },
                child: const Text(
                  "Already have an account",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

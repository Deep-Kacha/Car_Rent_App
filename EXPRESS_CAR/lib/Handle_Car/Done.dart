import 'package:express_car/Handle_Car/HandleBussiness.dart';
import 'package:flutter/material.dart';

import 'package:express_car/Handle_car/HandleBussiness.dart';

class FinalDonePage extends StatefulWidget {
  const FinalDonePage({Key? key}) : super(key: key);

  @override
  State<FinalDonePage> createState() => _FinalDonePageState();
}

class _FinalDonePageState extends State<FinalDonePage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                "You’re all done",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Subtitle
              const Text(
                "Lets start your journey and increase your earnings.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Illustration Image (replace with your asset)
              Image.asset("assets/images/done.jpg", height: 180),

              const SizedBox(height: 30),

              // Terms Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: const Color.fromARGB(255, 63, 34, 26),
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'By tapping “Agree” below, you agree to the express car rental terms of service.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Agree Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isChecked
                      ? () {
                         
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HandleBusinessPage(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 34, 26),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Agree",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

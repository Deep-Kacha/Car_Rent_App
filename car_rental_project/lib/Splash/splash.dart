import 'package:car_rental_project/Splash/GetStart.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to HomePage after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStart()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // background color
      body: Stack(
        children: [
          // Logo positioned manually
          Positioned(
            top: 155, // distance from top
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/splash.jpg", // your splash image
              height: 500,
            ),
          ),

          // Text positioned manually
          const Positioned(
            bottom: 100, // distance from bottom
            left: 0,
            right: 0,
            child: Text(
              "Starting An App....",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 57, 36, 29),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

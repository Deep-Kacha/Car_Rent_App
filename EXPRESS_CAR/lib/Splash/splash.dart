// Path: lib/Splash/splash.dart
import 'package:express_car/Authentication/auth_wrapper.dart';
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
    // Navigate after 2 seconds to AuthWrapper which will route to sign-in or home
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 155,
            left: 0,
            right: 0,
            child: Image.asset("assets/images/splash.jpg", height: 500),
          ),
          const Positioned(
            bottom: 100,
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

import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
import 'package:express_car/Splash/GetStart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While waiting for connection, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in, show Dashboard
        if (snapshot.hasData) {
          return HomePage();
        }

        // If user is not logged in, show Get Started page
        return const GetStart();
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
import 'package:express_car/Splash/GetStart.dart';
import 'package:express_car/Authentication/verify_email_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<void> _createUserDocumentIfNeeded(User user) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        "displayName": user.displayName ?? "",
        "email": user.email ?? "",
        "photoURL": user.photoURL ?? "",
        "favorites": [],
        "createdAt": DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF3E2723)),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;

          /// 🟢 Ensure Firestore user profile exists
          _createUserDocumentIfNeeded(user);

          if (user.emailVerified) {
            return HomePage();
          } else {
            return const VerifyEmailPage();
          }
        }

        return const GetStart();
      },
    );
  }
}

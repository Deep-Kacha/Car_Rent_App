import 'package:car_rental_project/Admin%20Panel%20Files/Done.dart';
import 'package:car_rental_project/Authorization/Home%20Page/home_page.dart';
// import 'package:car_rental_project/Menu/Account.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
      // AccountPage(),
      // SignIn(),
      // SplashScreen(),
    );
  }
}

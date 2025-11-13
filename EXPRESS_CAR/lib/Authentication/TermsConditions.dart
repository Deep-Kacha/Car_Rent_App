import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Agreement",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Terms & conditions",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            // Scrollable Terms text
            Expanded(
              child: SingleChildScrollView(
                child: const Text(
                  """
These Terms and Conditions govern your use of the Express Car Rental App provided.

1. Acceptance of Terms: By downloading, installing, accessing, or using the Express Car Rental App, you agree to be bound by these Terms. The Company reserves the right to update, modify, or replace these Terms at any time without prior notice. Your continued use of the App after any changes to these Terms constitutes acceptance of such changes.

2. Registration: To access certain features of the Express Car Rental App, you may be required to register and provide personal information. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. You are solely responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.

3. Use of the App: The Express Car Rental App is intended for personal, non-commercial use only. You agree not to use the App for any unlawful or prohibited purpose or in any manner that could damage, disable, overburden, or impair the functionality of the App.
                  """,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Continue Button
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
                  Navigator.pop(context); // go back or navigate anywhere else
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

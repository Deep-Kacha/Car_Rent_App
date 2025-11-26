import 'package:express_car/HomeDetails/Home_Page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String password;

  const VerifyCodeScreen({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _pinController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  /// Send the Firebase verification email
  Future<void> _sendVerificationEmail() async {
    setState(() => _isResending = true);
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );

      await userCredential.user?.sendEmailVerification();

      setState(() {
        _isResending = false;
        _emailSent = true;
      });

      _showSnackBar("Verification email sent to ${widget.email}");
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Failed to send verification email");
      setState(() => _isResending = false);
    }
  }

  /// Check if user verified their email
  Future<void> _verifyEmailStatus() async {
    setState(() => _isVerifying = true);

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      _showSnackBar("Email verified successfully!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    } else {
      _showSnackBar("Email not verified yet. Please check your inbox.");
    }

    setState(() => _isVerifying = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            /// Title
            const Text(
              "Verify Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            /// Subtitle
            Text(
              _emailSent
                  ? "We sent a verification link to:\n${widget.email}\nPlease verify your email to continue."
                  : "Sending verification email to:\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            /// Image
            SizedBox(
              height: 180,
              child: Image.asset(
                "assets/images/enter_otp1.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            /// Dummy OTP Input (UI only, kept same)
            Pinput(
              controller: _pinController,
              length: 6,
              defaultPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true, // Since OTP not used in this flow
            ),
            const SizedBox(height: 20),

            /// Resend Verification Email
            _isResending
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.brown,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _sendVerificationEmail,
                    child: const Text(
                      "Resend verification email",
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ),
                    ),
                  ),
            const SizedBox(height: 40),

            /// Verify Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyEmailStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B2A25),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Verify",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

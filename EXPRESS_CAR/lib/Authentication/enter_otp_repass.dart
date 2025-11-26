import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:express_car/Authentication/enter_newpassword.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _pinController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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
              "Please enter the code we just sent to email\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            /// Image just above OTP field
            SizedBox(
              height: 180,
              child: Image.asset(
                "assets/images/enter_otp1.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            /// OTP Input
            Pinput(
              controller: _pinController,
              length: 6, // changed from 4 to 6
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
            ),
            const SizedBox(height: 20),

            /// Didn't receive OTP text
            const Text(
              "Didn't receive OTP?",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            /// Resend Code as clickable text
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
                    onTap: _resendOtp,
                    child: const Text(
                      "Resend code",
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
                onPressed: _onVerifyPressed,
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

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending) return;
    setState(() => _isResending = true);

    // Simulate a network delay for testing
    await Future.delayed(const Duration(seconds: 2));

    _showSnackBar('OTP resent successfully!');

    // Reset the resending state
    if (mounted) {
      setState(() => _isResending = false);
    }
  }

  /// Verifies the OTP with the backend.
  Future<String?> _verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  Future<void> _onVerifyPressed() async {
    if (_isVerifying) return;

    final otp = _pinController.text.trim();
    if (otp.length != 6) {
      _showSnackBar('Please enter the 6-digit OTP');
      return;
    }

    setState(() => _isVerifying = true);

    final String? errorMessage = await _verifyOtp(otp);

    if (errorMessage == null) {
      // OTP is considered valid for testing. Navigate to the new password screen.
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPasswordPage(email: widget.email),
          ),
        );
      }
    } else {
      // Show the specific error from the server
      _showSnackBar(errorMessage);
    }
    if (mounted) {
      setState(() => _isVerifying = false);
    }
  }
}

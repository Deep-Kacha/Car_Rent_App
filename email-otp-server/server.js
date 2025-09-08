// Import required modules
const express = require('express');
const nodemailer = require('nodemailer');
const admin = require('firebase-admin');
const cors = require('cors');
const path = require('path');
require('dotenv').config(); // Load environment variables from .env file

// Initialize Express app
const app = express();
app.use(express.json()); // Parse incoming JSON requests
app.use(cors()); // Enable CORS for cross-origin requests (important for Flutter/web clients)

// Initialize Firebase Admin SDK using service account credentials
const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');
const serviceAccount = require(serviceAccountPath); // Use the robust path
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
const db = admin.firestore(); // Get Firestore instance

// Function to generate a 6-digit OTP
function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

// Route to send OTP to a user's email and store it in Firestore
app.post('/send-otp', async (req, res) => {
  const { email } = req.body; // Extract email from request body
  const otp = generateOTP(); // Generate OTP
  const expiresAt = Date.now() + 5 * 60 * 1000; // Set expiry time (5 minutes from now)

  // Configure Nodemailer with Gmail credentials
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL_USER, // Gmail address from .env
      pass: process.env.EMAIL_PASS  // App password from .env
    }
  });

  // Email content
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: 'Your OTP Code',
    text: `Your One-Time Password is: ${otp}`
  };

  try {
    // Send email
    await transporter.sendMail(mailOptions);

    // Store OTP in Firestore with metadata
    // Use the email as the document ID to easily retrieve/update it later.
    // This avoids needing complex queries and composite indexes for verification.
    await db.collection('emailOtps').doc(email).set({
      otp,
      expiresAt,
      verified: false
    });

    // Respond to client
    console.log(`Successfully sent OTP to ${email}`);
    res.status(200).json({ success: true, message: 'OTP sent successfully' });
  } catch (error) {
    // Handle errors
    console.error('Error in /send-otp endpoint:', error);
    res.status(500).json({ success: false, error: 'Failed to send OTP. Please try again.' });
  }
});

// Route to verify OTP entered by user
app.post('/verify-otp', async (req, res) => {
  const { email, otp: userOtp } = req.body;

  try {
    const otpDocRef = db.collection('emailOtps').doc(email);
    const doc = await otpDocRef.get();

    if (!doc.exists) {
      return res.status(400).json({ success: false, error: 'OTP not found. Please request a new one.' });
    }

    const { otp: storedOtp, expiresAt, verified } = doc.data();
    const now = Date.now();

    if (verified) {
      return res.status(400).json({ success: false, error: 'This OTP has already been used.' });
    }

    if (expiresAt < now) {
      return res.status(400).json({ success: false, error: 'OTP has expired. Please request a new one.' });
    }

    if (storedOtp !== userOtp) {
      return res.status(400).json({ success: false, error: 'Invalid OTP.' });
    }

    // Mark OTP as verified
    await otpDocRef.update({ verified: true });

    // Respond to client
    res.status(200).json({ success: true, message: 'OTP verified successfully' });
  } catch (error) {
    console.error('Error in /verify-otp endpoint:', error);
    res.status(500).json({ success: false, error: 'An internal server error occurred during verification.' });
  }
});

// Start the server on port 3000
app.listen(3000, () => console.log('✅ Server running on port 3000'));
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  late Razorpay _razorpay;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> storeOrderInFirestore(double totalAmount, List<Map<String, dynamic>> items) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return; // Ensure the user is logged in

  await FirebaseFirestore.instance.collection('orders').add({
    'userId': user.uid,
    'items': items,
    'totalAmount': totalAmount,
    'timestamp': Timestamp.now(),
  });
}

  void makePayment(double amount, Function onSuccess) {
    var options = {
      'key': 'rzp_test_DGXhYrCF8ObYOA', // Replace with your Razorpay test key
      'amount': amount * 100, // Razorpay expects amount in paise (₹1 = 100 paise)
      'currency': 'INR',
      'name': 'E-Commerce App',
      'description': 'Product Purchase',
      'prefill': {
        'contact': '7559269620',
        'email': 'nairsreerag2@gmail.com'
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  debugPrint("Payment Successful: ${response.paymentId}");

  await FirebaseFirestore.instance.collection('orders').add({
    'paymentId': response.paymentId,
    'timestamp': Timestamp.now(),
  });

  onSuccess(); // Calls function to clear cart and navigate
}

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
  }

  void dispose() {
    _razorpay.clear();
  }
  
  void onSuccess() {

  }
}

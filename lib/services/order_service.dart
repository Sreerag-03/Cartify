import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<void> placeOrder(double totalAmount, List<Map<String, dynamic>> items) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'items': items,
      'totalAmount': totalAmount,
      'timestamp': Timestamp.now(),
    });

    sendPushNotification(user.uid);
  }

  Future<void> sendPushNotification(String userId) async {
    // Retrieve FCM Token from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!userDoc.exists) return;
    
    String? token = userDoc['fcmToken'];

    if (token != null) {
      var serverKey = "YOUR_SERVER_KEY_HERE"; // Replace with Firebase Server Key

      var body = jsonEncode({
        "to": token,
        "notification": {
          "title": "Order Placed!",
          "body": "Your order has been successfully placed.",
        },
      });

      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: body,
      );    

  void sendNotification(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();
    
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'title': 'Order Placed!',
      'body': 'Your order has been successfully placed.',
      'timestamp': Timestamp.now(),
      'token': token,
    });

    print("Notification sent to user: $userId");
  }
}
  }}
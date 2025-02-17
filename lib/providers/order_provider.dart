import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore; // Add prefix
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await firestore.FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    _orders = snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
    notifyListeners();
  }
}

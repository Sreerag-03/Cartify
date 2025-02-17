import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final Timestamp timestamp;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      userId: data['userId'],
      items: List<Map<String, dynamic>>.from(data['items']),
      totalAmount: data['totalAmount'],
      timestamp: data['timestamp'],
    );
  }
}

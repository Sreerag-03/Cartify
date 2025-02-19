import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  List<WishlistItem> _wishlist = [];

  List<WishlistItem> get wishlist => _wishlist;

  Future<void> fetchWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .get();

    _wishlist = snapshot.docs
        .map((doc) => WishlistItem.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> toggleWishlist(WishlistItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(item.id);

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete(); // Remove from wishlist
      _wishlist.removeWhere((wishItem) => wishItem.id == item.id);
    } else {
      await docRef.set(item.toMap()); // Add to wishlist
      _wishlist.add(item);
    }
    
    notifyListeners();
  }
}

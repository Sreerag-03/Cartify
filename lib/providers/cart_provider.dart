import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  // Add item to cart
  void addToCart(CartItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity += 1;
    } else {
      _items[item.id] = item;
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Get total items count
  int get itemCount => _items.length;

  // Get total price
  double get totalPrice {
    double total = 0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

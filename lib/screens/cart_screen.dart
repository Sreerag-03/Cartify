import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cartProvider.items.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProvider.items.values.toList()[index];
                      return ListTile(
                        leading: Image.network(cartItem.image, width: 50, height: 50),
                        title: Text(cartItem.name),
                        subtitle: Text("\$${cartItem.price} x ${cartItem.quantity}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => cartProvider.removeFromCart(cartItem.id),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Total: \$${cartProvider.totalPrice}", style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: const Text("Proceed to Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

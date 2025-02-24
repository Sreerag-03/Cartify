import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final paymentService = PaymentService();
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Summary", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final cartItem = cartProvider.items.values.toList()[index];
                  return ListTile(
                    leading: Image.network(cartItem.image, width: 50, height: 50),
                    title: Text(cartItem.name),
                    subtitle: Text("\$${cartItem.price} x ${cartItem.quantity}"),
                  );
                },
              ),
            ),
            Text("Total: ₹${cartProvider.totalPrice}", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await orderService.placeOrder(cartProvider.totalPrice, cartProvider.items.values.map((item) => {
                    'name': item.name,
                    'price': item.price,
                    'quantity': item.quantity,
                    'image': item.image,
                  }).toList());

                  cartProvider.clearCart();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order placed successfully!"), backgroundColor: Colors.green),
                  );

                },
                child: const Text("Confirm Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

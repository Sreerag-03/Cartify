import 'package:cartify/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Hero(
            tag: product.id,
            child: Image.network(product.image, height: 250, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding:const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
               const SizedBox(height: 10),
                Text(
                  "\$${product.price}",
                  style:const TextStyle(fontSize: 20, color: Colors.blue),
                ),
               const SizedBox(height: 10),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      cartProvider.addToCart(CartItem(
                        id: product.id,
                        name: product.name,
                        price: product.price,
                        image: product.image,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Added to Cart"),
                        backgroundColor: Colors.green,
                      ));
                    },
                    child: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

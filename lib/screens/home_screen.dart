import 'package:cartify/providers/product_provder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/product_model.dart';
import '../models/wishlist_model.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce App"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: productProvider.products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 3 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final Product product =
                    productProvider.products[index]; // ✅ Define product here

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product)),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    child: Column(
                      children: [
                        Hero(
                          tag: product.id,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              product.image,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(product.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("\$${product.price}",
                              style: TextStyle(color: Colors.blue)),
                        ),
                        IconButton(
                          icon: Icon(
                            wishlistProvider.wishlist
                                    .any((wish) => wish.id == product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: wishlistProvider.wishlist
                                    .any((wish) => wish.id == product.id)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            wishlistProvider.toggleWishlist(
                              WishlistItem(
                                id: product.id,
                                name: product.name,
                                image: product.image,
                                price: product.price,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

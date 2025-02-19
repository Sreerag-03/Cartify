import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text("My Wishlist")),
      body: wishlistProvider.wishlist.isEmpty
          ? Center(child: Text("Your wishlist is empty"))
          : ListView.builder(
              itemCount: wishlistProvider.wishlist.length,
              itemBuilder: (context, index) {
                final item = wishlistProvider.wishlist[index];
                return ListTile(
                  leading: Image.network(item.image, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text("₹${item.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => wishlistProvider.toggleWishlist(item),
                  ),
                );
              },
            ),
    );
  }
}

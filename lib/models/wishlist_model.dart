class WishlistItem {
  final String id;
  final String name;
  final String image;
  final double price;

  WishlistItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  factory WishlistItem.fromMap(Map<String, dynamic> data, String documentId) {
    return WishlistItem(
      id: documentId,
      name: data['name'],
      image: data['image'],
      price: (data['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
    };
  }
}

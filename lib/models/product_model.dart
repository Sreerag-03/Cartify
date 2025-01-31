class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      image: data['image'],
      category: data['category'],
      description: data['description'],
    );
  }
}


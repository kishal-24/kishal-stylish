class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
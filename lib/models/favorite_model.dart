class FavoriteModel {
  final int? id;
  final String name;
  final String image;
  final String description;
  final String price;
  final String oldPrice;
  final String discount;
  final double? rating;
  final String category;

  const FavoriteModel({
    this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.discount,
    this.rating,
    required this.category,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: (map['id'] as num?)?.toInt(),
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      description: map['desc']?.toString() ?? '',
      price: map['price']?.toString() ?? '',
      oldPrice: map['oldPrice']?.toString() ?? '',
      discount: map['discount']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble(),
      category: map['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'desc': description,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
      'rating': rating,
      'category': category,
    };
  }
}

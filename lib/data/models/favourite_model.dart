class FavoriteModel {
  final int? id;
  final String name;
  final String image;
  final String price;
  final String oldPrice;
  final String discount;
  final String desc;
  final String category;
  final double rating;

  const FavoriteModel({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.desc,
    required this.category,
    required this.rating,
  });

  factory FavoriteModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return FavoriteModel(
      id: map['id'] is int
          ? map['id']
          : int.tryParse(
        map['id']?.toString() ?? '',
      ),
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      price: map['price']?.toString() ?? '₹0',
      oldPrice: map['oldPrice']?.toString() ?? '',
      discount: map['discount']?.toString() ?? '',
      desc: map['desc']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
      'desc': desc,
      'category': category,
      'rating': rating,
    };
  }
}
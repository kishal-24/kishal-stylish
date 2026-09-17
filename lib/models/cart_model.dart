class CartModel {
  final int? id;
  final String name;
  final String image;
  final String price;
  final String desc;
  final String? selectedSize;
  final int quantity;

  const CartModel({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.desc,
    this.selectedSize,
    this.quantity = 1,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] is int
          ? map['id']
          : int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      price: map['price']?.toString() ?? '0',
      desc: map['desc']?.toString() ?? '',
      selectedSize: map['selectedSize']?.toString(),
      quantity: int.tryParse(
        map['quantity']?.toString() ?? '1',
      ) ??
          1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'desc': desc,
      'selectedSize': selectedSize,
      'quantity': quantity,
    };
  }

  CartModel copyWith({
    int? id,
    String? name,
    String? image,
    String? price,
    String? desc,
    String? selectedSize,
    int? quantity,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      desc: desc ?? this.desc,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }
}
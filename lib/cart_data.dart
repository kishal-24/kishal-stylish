import 'package:flutter/foundation.dart';
class cart {
  static final List<Map<String, dynamic>> cartItems = [];
  static final ValueNotifier<int> cartCount =
  ValueNotifier<int>(0);
  static void addToCart(Map<String, dynamic> product) {
    int existingIndex = cartItems.indexWhere(
          (item) => item['name'] == product['name'],
    );
    if (existingIndex != -1) {
      cartItems[existingIndex]['quantity'] =
          (cartItems[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      cartItems.add({
        ...product,
        'quantity': 1,
      });
    }

    updateCartCount();
  }
  static void increaseQuantity(int index) {
    cartItems[index]['quantity'] =
        (cartItems[index]['quantity'] ?? 1) + 1;
    updateCartCount();
  }
  static void decreaseQuantity(int index) {
    int quantity = cartItems[index]['quantity'] ?? 1;
    if (quantity > 1) {
      cartItems[index]['quantity'] = quantity - 1;
    } else {
      cartItems.removeAt(index);
    }
    updateCartCount();
  }
  static void updateCartCount() {
    int totalQuantity = 0;

    for (var item in cartItems) {
      totalQuantity += (item['quantity'] ?? 1) as int;
    }

    cartCount.value = totalQuantity;
  }
  static void removeFromCart(int index) {
    cartItems.removeAt(index);

    updateCartCount();
  }
  static void clearCart() {
    cartItems.clear();
    cartCount.value = 0;
  }
}
import 'package:flutter/foundation.dart';

import '../api/api_service.dart';

class cart {
  // ==========================================
  // LOCAL CART
  // ==========================================

  static final List<Map<String, dynamic>> cartItems = [];

  static final ValueNotifier<int> cartCount =
  ValueNotifier<int>(0);

  // ==========================================
  // ADD TO CART
  // ==========================================

  static void addToCart(
      Map<String, dynamic> product,
      ) {
    final int existingIndex = cartItems.indexWhere(
          (item) => item['id'] == product['id'],
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

  // ==========================================
  // INCREASE QUANTITY
  // ==========================================

  static void increaseQuantity(int index) {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    cartItems[index]['quantity'] =
        (cartItems[index]['quantity'] ?? 1) + 1;

    updateCartCount();
  }

  // ==========================================
  // DECREASE QUANTITY
  // ==========================================

  static void decreaseQuantity(int index) {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    final int quantity =
        cartItems[index]['quantity'] ?? 1;

    if (quantity > 1) {
      cartItems[index]['quantity'] =
          quantity - 1;
    } else {
      cartItems.removeAt(index);
    }

    updateCartCount();
  }

  // ==========================================
  // REMOVE PRODUCT
  // ==========================================

  static void removeFromCart(int index) {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    cartItems.removeAt(index);

    updateCartCount();
  }

  // ==========================================
  // UPDATE CART COUNT
  // ==========================================

  static void updateCartCount() {
    int totalQuantity = 0;

    for (final item in cartItems) {
      totalQuantity +=
          int.tryParse(
            item['quantity']?.toString() ?? '1',
          ) ??
              1;
    }

    cartCount.value = totalQuantity;
  }

  // ==========================================
  // SEND CART TO API
  // ==========================================

  static Future<Map<String, dynamic>?>
  syncCartToApi() async {
    if (cartItems.isEmpty) {
      return null;
    }

    final List<Map<String, dynamic>> products =
    cartItems.map((item) {
      return {
        'id': item['id'],
        'quantity': item['quantity'] ?? 1,
      };
    }).toList();

    return await ApiService.addCart(
      userId: 1,
      products: products,
    );
  }

  // ==========================================
  // CLEAR CART
  // ==========================================

  static void clearCart() {
    cartItems.clear();

    cartCount.value = 0;
  }
}
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';

class cart {

  static final List<Map<String, dynamic>> cartItems = [];
  static const String _cartStorageKey = 'cart_items';


  static final ValueNotifier<int> cartCount =
  ValueNotifier<int>(0);

  static final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  static Future<void> addToCart(
      Map<String, dynamic> product,
      ) async {
    final int existingIndex = cartItems.indexWhere(
          (item) =>
      item['id'] == product['id'] &&
          item['selectedSize'] == product['selectedSize'],
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

  static Future<void> increaseQuantity(int index) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    cartItems[index]['quantity'] =
        (cartItems[index]['quantity'] ?? 1) + 1;

    updateCartCount();
    isLoading.value = false;
  }



  static Future<void> decreaseQuantity(int index) async {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network sync
    final int quantity =
        cartItems[index]['quantity'] ?? 1;

    if (quantity > 1) {
      cartItems[index]['quantity'] =
          quantity - 1;
    } else {
      cartItems.removeAt(index);
    }

    updateCartCount();
    isLoading.value = false;
  }



  static void removeFromCart(int index) {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    cartItems.removeAt(index);

    updateCartCount();
  }



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


  static Future<Map<String, dynamic>?>
  syncCartToApi() async {
    return null;
  }

  static Future<void> saveCart() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String cartJson = jsonEncode(cartItems);

      await prefs.setString(
        _cartStorageKey,
        cartJson,
      );
    } catch (e) {
      debugPrint('SAVE CART ERROR: $e');
    }
  }
  static Future<void> loadCart() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String? cartJson =
      prefs.getString(_cartStorageKey);

      if (cartJson == null || cartJson.isEmpty) {
        cartItems.clear();
        updateCartCount();
        return;
      }

      final dynamic decodedData =
      jsonDecode(cartJson);

      if (decodedData is List) {
        cartItems.clear();

        for (final item in decodedData) {
          if (item is Map) {
            cartItems.add(
              Map<String, dynamic>.from(item),
            );
          }
        }
      }

      updateCartCount();
    } catch (e) {
      debugPrint('LOAD CART ERROR: $e');

      cartItems.clear();
      updateCartCount();
    }
  }

  static Future<void> clearCart() async {
    cartItems.clear();

    cartCount.value = 0;

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_cartStorageKey);
  }
}
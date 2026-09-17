import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  static const String _storageKey = 'cart_items';

  Future<List<Map<String, dynamic>>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_storageKey);
    if (value == null || value.isEmpty) return [];

    final decoded = jsonDecode(value);
    if (decoded is! List) return [];

    return decoded
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> saveCart(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(items));
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  List<Map<String, dynamic>> addProduct(
    List<Map<String, dynamic>> currentItems,
    Map<String, dynamic> product,
  ) {
    final items = currentItems.map(Map<String, dynamic>.from).toList();
    final index = items.indexWhere(
      (item) =>
          item['id'] == product['id'] &&
          item['selectedSize'] == product['selectedSize'],
    );

    if (index == -1) {
      items.add({...product, 'quantity': 1});
    } else {
      items[index]['quantity'] = (items[index]['quantity'] ?? 1) + 1;
    }
    return items;
  }

  List<Map<String, dynamic>> updateQuantity(
    List<Map<String, dynamic>> currentItems,
    int index,
    int change,
  ) {
    if (index < 0 || index >= currentItems.length) return currentItems;

    final items = currentItems.map(Map<String, dynamic>.from).toList();
    final quantity = items[index]['quantity'] ?? 1;
    if (change < 0 && quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index]['quantity'] = quantity + change;
    }
    return items;
  }

  List<Map<String, dynamic>> removeProduct(
    List<Map<String, dynamic>> currentItems,
    int index,
  ) {
    if (index < 0 || index >= currentItems.length) return currentItems;
    return currentItems.map(Map<String, dynamic>.from).toList()
      ..removeAt(index);
  }
}

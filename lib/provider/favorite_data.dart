import 'package:flutter/foundation.dart';

class FavoriteData {
  static final ValueNotifier<List<Map<String, dynamic>>> favorites =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  static void toggleFavorite(Map<String, dynamic> product) {
    final currentList = List<Map<String, dynamic>>.from(favorites.value);

    final index = currentList.indexWhere(
      (item) => item['name'] == product['name'],
    );

    if (index != -1) {
      currentList.removeAt(index);
    } else {
      currentList.add(product);
    }

    favorites.value = currentList;
  }

  static bool isFavorite(Map<String, dynamic> product) {
    return favorites.value.any((item) => item['name'] == product['name']);
  }
}

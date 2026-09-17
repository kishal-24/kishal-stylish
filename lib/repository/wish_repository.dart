import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite_model.dart';

class WishRepository {
  static const String _storageKey = 'wishlist_items';

  Future<List<FavoriteModel>> loadWishes() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_storageKey);
    if (value == null || value.isEmpty) return [];

    final decoded = jsonDecode(value);
    if (decoded is! List) return [];

    return decoded
        .whereType<Map>()
        .map((item) => FavoriteModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveWishes(List<FavoriteModel> wishes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(wishes.map((wish) => wish.toMap()).toList()),
    );
  }

  Future<void> clearWishes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

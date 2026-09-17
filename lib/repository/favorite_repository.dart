import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRepository {
  static const String _storageKey = 'favorite_items';

  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String? favoriteJson =
      prefs.getString(_storageKey);

      if (favoriteJson == null || favoriteJson.isEmpty) {
        return [];
      }
      final dynamic decoded = jsonDecode(favoriteJson);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
      )
          .toList();
    } catch (e) {
      throw Exception('Failed to load favorites');
    }
  }
  Future<void> saveFavorites(
      List<Map<String, dynamic>> favorites,
      ) async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String favoriteJson =
      jsonEncode(favorites);

      await prefs.setString(
        _storageKey,
        favoriteJson,
      );
    } catch (e) {
      throw Exception('Failed to save favorites');
    }
  }
  Future<void> clearFavorites() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.remove(_storageKey);
    } catch (e) {
      throw Exception('Failed to clear favorites');
    }
  }
}
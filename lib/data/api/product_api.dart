import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_models.dart';


class ProductApi {
  static const String baseUrl = 'https://dummyjson.com';

  static Future<List<Product>> getProducts({
    required int page,
    required int limit,
  }) async {
    final int skip = (page - 1) * limit;

    final url = Uri.parse(
      '$baseUrl/products?limit=$limit&skip=$skip',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body);

      final List products = data['products'];

      return products
          .map(
            (json) => Product.fromJson(json),
      )
          .toList();
    } else {
      throw Exception(
        'Failed to load products',
      );
    }
  }
}
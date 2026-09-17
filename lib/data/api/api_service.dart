import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static const String baseUrl = 'https://dummyjson.com';
  static const Duration _timeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> getProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final int skip = (page - 1) * limit;

      final Uri url = Uri.parse(
        '$baseUrl/products?limit=$limit&skip=$skip',
      );

      final http.Response response = await http
          .get(
        url,
        headers: const {
          'Accept': 'application/json',
        },
      )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load products: ${response.statusCode}',
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid products response');
      }

      final List<dynamic> products =
          decoded['products'] as List<dynamic>? ?? [];

      final List<Map<String, dynamic>> formattedProducts =
      products.map<Map<String, dynamic>>((product) {
        if (product is! Map<String, dynamic>) {
          return <String, dynamic>{};
        }

        final double price =
            (product['price'] as num?)?.toDouble() ?? 0.0;

        final double discount =
            (product['discountPercentage'] as num?)?.toDouble() ?? 0.0;

        return {
          'id': product['id'],
          'name': product['title']?.toString() ?? '',
          'image': product['thumbnail']?.toString() ?? '',
          'desc': product['description']?.toString() ?? '',
          'price': '₹${price.toStringAsFixed(0)}',
          'oldPrice': '₹${(price * 1.4).toStringAsFixed(0)}',
          'discount': '${discount.toStringAsFixed(0)}% off',
          'rating': product['rating'],
          'category': product['category']?.toString() ?? '',
        };
      }).where((product) => product.isNotEmpty).toList();

      return {
        'products': formattedProducts,
        'total': (decoded['total'] as num?)?.toInt() ?? 0,
      };
    } on http.ClientException {
      throw Exception(
        'Network error. Please check your internet connection.',
      );
    } on FormatException {
      throw Exception('Invalid response from server.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timed out. Please try again.',
        );
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> addCart({
    required int userId,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final http.Response response = await http
          .post(
        Uri.parse('$baseUrl/carts/add'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'products': products,
        }),
      )
          .timeout(_timeout);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getCart(
      int cartId,
      ) async {
    try {
      final http.Response response = await http
          .get(
        Uri.parse('$baseUrl/carts/$cartId'),
        headers: const {
          'Accept': 'application/json',
        },
      )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createOrder({
    required int userId,
    required List<Map<String, dynamic>> products,
    required double totalAmount,
    required String selectedAddress,
  }) async {
    try {
      final http.Response response = await http
          .post(
        Uri.parse('$baseUrl/carts/add'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'products': products,
          'totalAmount': totalAmount,
          'deliveryAddress': selectedAddress,
        }),
      )
          .timeout(_timeout);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}

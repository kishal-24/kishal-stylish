import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'https://dummyjson.com';



  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List products = data['products'];

        return products
            .map<Map<String, dynamic>>((product) {
          return {
            'id': product['id'],
            'name': product['title'],
            'image': product['thumbnail'],
            'desc': product['description'],
            'price': '₹${product['price']}',
            'oldPrice':
                '₹${(product['price'] * 1.4).toStringAsFixed(0)}',
            'discount':
                '${product['discountPercentage'].toStringAsFixed(0)}% off',
            'rating': product['rating'],
            'category': product['category'],
          };
        }).toList();
      }

      throw Exception(
        'Failed to load products: ${response.statusCode}',
      );
    } catch (e) {
      print('GET PRODUCTS ERROR: $e');
      rethrow;
    }
  }



  static Future<Map<String, dynamic>?> addCart({
    required int userId,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/carts/add'),

        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'products': products,
        }),
      );

      print('CART API STATUS: ${response.statusCode}');
      print('CART API RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print('ADD CART ERROR: $e');
      return null;
    }
  }


  static Future<Map<String, dynamic>?> getCart(
    int cartId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carts/$cartId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print('GET CART ERROR: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createOrder({
    required int userId,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/carts/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'products': products,
        }),
      );

      print('ORDER API STATUS: ${response.statusCode}');
      print('ORDER API RESPONSE: ${response.body}');

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print('ORDER API ERROR: $e');
      return null;
    }
  }
}
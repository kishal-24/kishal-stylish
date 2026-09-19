import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';
  Future<Map<String, dynamic>> getProducts({
    required int page,
    required int limit,
  }) async {
    final int skip = (page - 1) * limit;

    final Uri url = Uri.parse(
      '$baseUrl/products?limit=$limit&skip=$skip',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        jsonDecode(response.body);

        return _convertResponse(data);
      } else {
        throw Exception(
          'Failed to load products: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'Unable to connect to server',
      );
    }
  }


  Future<Map<String, dynamic>> searchProducts({
    required String query,
    required int page,
    required int limit,
  }) async {
    final int skip = (page - 1) * limit;

    final Uri url = Uri.parse(
      '$baseUrl/products/search'
          '?q=${Uri.encodeQueryComponent(query)}'
          '&limit=$limit'
          '&skip=$skip',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        jsonDecode(response.body);

        return _convertResponse(data);
      } else {
        throw Exception(
          'Failed to search products: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'Unable to search products',
      );
    }
  }

  // ==========================================================
  // FILTER PRODUCTS
  // ==========================================================

  Future<Map<String, dynamic>> filterProducts({
    required double minPrice,
    required double maxPrice,
    required int page,
    required int limit,
  }) async {
    /*
      DummyJSON does not provide a direct
      minPrice/maxPrice query parameter.

      Therefore we request the products from
      the API and apply the price condition
      to the returned API data.
    */

    try {
      final Uri url = Uri.parse(
        '$baseUrl/products?limit=0',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load products',
        );
      }

      final Map<String, dynamic> data =
      jsonDecode(response.body);

      final List<dynamic> apiProducts =
          data['products'] ?? [];

      final List<Map<String, dynamic>> filteredProducts =
      apiProducts
          .where((product) {
        final double price =
            (product['price'] as num?)?.toDouble() ?? 0;

        return price >= minPrice &&
            price <= maxPrice;
      })
          .map<Map<String, dynamic>>((product) {
        return _convertProduct(product);
      })
          .toList();

      // Pagination after filtering
      final int startIndex =
          (page - 1) * limit;

      final int endIndex =
          startIndex + limit;

      final List<Map<String, dynamic>> paginatedProducts =
      startIndex < filteredProducts.length
          ? filteredProducts.sublist(
        startIndex,
        endIndex > filteredProducts.length
            ? filteredProducts.length
            : endIndex,
      )
          : [];

      return {
        'products': paginatedProducts,
        'total': filteredProducts.length,
        'skip': startIndex,
        'limit': limit,
      };
    } catch (e) {
      throw Exception(
        'Unable to filter products',
      );
    }
  }

  // ==========================================================
  // SORT PRODUCTS
  // ==========================================================

  Future<Map<String, dynamic>> sortProducts({
    required String sortBy,
    required String order,
    required int page,
    required int limit,
  }) async {
    final int skip = (page - 1) * limit;

    final Uri url = Uri.parse(
      '$baseUrl/products'
          '?sortBy=$sortBy'
          '&order=$order'
          '&limit=$limit'
          '&skip=$skip',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        jsonDecode(response.body);

        return _convertResponse(data);
      } else {
        throw Exception(
          'Failed to sort products: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'Unable to sort products',
      );
    }
  }

  // ==========================================================
  // CONVERT API RESPONSE
  // ==========================================================

  Map<String, dynamic> _convertResponse(
      Map<String, dynamic> data,
      ) {
    final List<dynamic> products =
        data['products'] ?? [];

    final List<Map<String, dynamic>> convertedProducts =
    products
        .map<Map<String, dynamic>>((product) {
      return _convertProduct(product);
    })
        .toList();

    return {
      'products': convertedProducts,
      'total': data['total'] ?? convertedProducts.length,
      'skip': data['skip'] ?? 0,
      'limit': data['limit'] ?? convertedProducts.length,
    };
  }


  Map<String, dynamic> _convertProduct(
      dynamic product,
      ) {
    return {
      // Original ID
      'id': product['id'],

      // Product name
      'name': product['title'] ?? '',

      // Price
      'price': product['price'] ?? 0,

      // Description
      'desc': product['description'] ?? '',

      // Image
      'image': product['thumbnail'] ??
          (product['images'] != null &&
              (product['images'] as List).isNotEmpty
              ? product['images'][0]
              : ''),

      // Rating
      'rating': product['rating'] ?? 0,

      // Category
      'category': product['category'] ?? '',

      // Brand
      'brand': product['brand'] ?? '',

      // Discount
      'discount': product['discountPercentage'] ?? 0,

      // Stock
      'stock': product['stock'] ?? 0,

      // Original DummyJSON data
      'originalData': product,
    };
  }
}

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
// Example:
// page = 1, limit = 10 → skip = 0
// page = 2, limit = 10 → skip = 10
// page = 3, limit = 10 → skip = 20

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

// Check status code
if (response.statusCode != 200) {
throw Exception(
'Failed to load products: ${response.statusCode}',
);
}

// Convert JSON string to Dart object
final dynamic decoded = jsonDecode(response.body);

// Make sure response is a Map
if (decoded is! Map<String, dynamic>) {
throw const FormatException(
'Invalid products response',
);
}

// Get products list
final List<dynamic> products =
decoded['products'] as List<dynamic>? ?? [];

// Format products for the app
final List<Map<String, dynamic>> formattedProducts =
products
    .whereType<Map<String, dynamic>>()
    .map<Map<String, dynamic>>((product) {
final double price =
(product['price'] as num?)?.toDouble() ?? 0.0;

final double discount =
(product['discountPercentage'] as num?)
    ?.toDouble() ??
0.0;

return {
'id': product['id'],
'name': product['title']?.toString() ?? '',
'image': product['thumbnail']?.toString() ?? '',
'desc': product['description']?.toString() ?? '',
'price': '₹${price.toStringAsFixed(0)}',
'oldPrice':
'₹${(price * 1.4).toStringAsFixed(0)}',
'discount':
'${discount.toStringAsFixed(0)}% off',
'rating': product['rating'],
'category':
product['category']?.toString() ?? '',
};
}).toList();

// Total number of products
final int total =
(decoded['total'] as num?)?.toInt() ?? 0;

// Return everything needed by ProductBloc
return {
'products': formattedProducts,
'total': total,
'page': page,
'limit': limit,
'skip': skip,
};
} on http.ClientException {
throw Exception(
'Network error. Please check your internet connection.',
);
} on FormatException {
throw Exception(
'Invalid response from server.',
);
} catch (e) {
if (e.toString().contains('TimeoutException')) {
throw Exception(
'Request timed out. Please try again.',
);
}

rethrow;
}
}

// ============================================================
// ADD CART
// ============================================================

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
final dynamic decoded =
jsonDecode(response.body);

if (decoded is Map<String, dynamic>) {
return decoded;
}
}

return null;
} catch (_) {
return null;
}
}

// ============================================================
// GET CART
// ============================================================

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
final dynamic decoded =
jsonDecode(response.body);

if (decoded is Map<String, dynamic>) {
return decoded;
}
}

return null;
} catch (_) {
return null;
}
}

// ============================================================
// CREATE ORDER
// ============================================================

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
final dynamic decoded =
jsonDecode(response.body);

if (decoded is Map<String, dynamic>) {
return decoded;
}
}

return null;
} catch (_) {
return null;
}
}
}


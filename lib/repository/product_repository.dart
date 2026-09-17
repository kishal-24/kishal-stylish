import '../data/api/api_service.dart';

class ProductRepository {
  Future<Map<String, dynamic>> getProducts({
    required int page,
    required int limit,
  }) {
    return ApiService.getProducts(page: page, limit: limit);
  }
}

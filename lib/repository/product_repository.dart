import '../api/api_service.dart';


class ProductRepository {
  final ApiService apiService;

  ProductRepository({
    ApiService? apiService,
  }) : apiService = apiService ?? ApiService();


  Future<Map<String, dynamic>> getProducts({
    required int page,
    required int limit,
  }) async {
    return await apiService.getProducts(
      page: page,
      limit: limit,
    );
  }


  Future<Map<String, dynamic>> searchProducts({
    required String query,
    required int page,
    required int limit,
  }) async {
    return await apiService.searchProducts(
      query: query,
      page: page,
      limit: limit,
    );
  }


  Future<Map<String, dynamic>> filterProducts({
    required double minPrice,
    required double maxPrice,
    required int page,
    required int limit,
  }) async {
    return await apiService.filterProducts(
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: page,
      limit: limit,
    );
  }


  Future<Map<String, dynamic>> sortProducts({
    required String sortBy,
    required String order,
    required int page,
    required int limit,
  }) async {
    return await apiService.sortProducts(
      sortBy: sortBy,
      order: order,
      page: page,
      limit: limit,
    );
  }
}
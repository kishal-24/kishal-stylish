import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({ProductRepository? repository})
    : _repository = repository ?? ProductRepository(),
      super(const ProductInitial()) {
    // Fetch first page
    on<FetchProducts>(_fetchProducts);

    // Load next page
    on<LoadMoreProducts>(_loadMoreProducts);

    // Refresh
    on<RefreshProducts>(_refreshProducts);
  }

  int currentPage = 1;
  final int limit = 10;
  final ProductRepository _repository;

  // Store all loaded products
  List<Map<String, dynamic>> allProducts = [];

  // -----------------------------
  // FETCH PRODUCTS
  // -----------------------------

  Future<void> _fetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(const ProductLoading());

      currentPage = 1;

      final result = await _repository.getProducts(
        page: currentPage,
        limit: limit,
      );
      final products = List<Map<String, dynamic>>.from(
        result['products'] ?? const [],
      );

      allProducts = products;

      emit(
        ProductLoaded(
          products: products,
          hasMore:
              products.length <
              ((result['total'] as num?)?.toInt() ?? products.length),
        ),
      );
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }

  // -----------------------------
  // LOAD MORE PRODUCTS
  // -----------------------------

  Future<void> _loadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductLoaded) return;

    final currentState = state as ProductLoaded;

    if (!currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      currentPage++;

      final result = await _repository.getProducts(
        page: currentPage,
        limit: limit,
      );
      final newProducts = List<Map<String, dynamic>>.from(
        result['products'] ?? const [],
      );

      allProducts.addAll(newProducts);

      emit(
        ProductLoaded(
          products: List.from(allProducts),
          hasMore:
              allProducts.length <
              ((result['total'] as num?)?.toInt() ?? allProducts.length),
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  // -----------------------------
  // REFRESH PRODUCTS
  // -----------------------------

  Future<void> _refreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    currentPage = 1;
    allProducts.clear();

    add(const FetchProducts());
  }
}

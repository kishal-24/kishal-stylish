import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  // Number of products loaded per API request
  static const int _limit = 20;

  ProductBloc({ProductRepository? repository})
    : _repository = repository ?? ProductRepository(),
      super(const ProductInitial()) {


    on<FetchProducts>(_fetchProducts);
    on<LoadMoreProducts>(_loadMoreProducts);
    on<RefreshProducts>(_refreshProducts);
    on<SearchProducts>(_searchProducts);
    on<FilterProducts>(_filterProducts);
    on<SortProducts>(_sortProducts);
  }
  Future<void> _fetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final response = await _repository.getProducts(page: 1, limit: _limit);

      _emitLoadedState(
        emit,
        response,
        page: 1,
        searchText: '',
        minPrice: null,
        maxPrice: null,
        sortBy: '',
        order: '',
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<void> _loadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ProductLoaded) {
      return;
    }

    if (currentState.isLoadingMore) {
      return;
    }

    if (!currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final response = await _loadProductsForState(
        currentState,
        page: nextPage,
      );

      final newProducts = _extractProducts(response);

      if (newProducts.isEmpty) {
        emit(currentState.copyWith(hasMore: false, isLoadingMore: false));
        return;
      }

      final allProducts = [...currentState.allProducts, ...newProducts];

      emit(
        currentState.copyWith(
          products: allProducts,
          allProducts: allProducts,
          currentPage: nextPage,
          hasMore: _hasMore(response, nextPage),
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }



  Future<void> _refreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentState = state;

      if (currentState is ProductLoaded) {
        final response = await _loadProductsForState(currentState, page: 1);

        _emitLoadedState(
          emit,
          response,
          page: 1,
          searchText: currentState.searchText,
          minPrice: currentState.minPrice,
          maxPrice: currentState.maxPrice,
          sortBy: currentState.sortBy,
          order: currentState.order,
        );
        return;
      }

      final response = await _repository.getProducts(page: 1, limit: _limit);

      _emitLoadedState(
        emit,
        response,
        page: 1,
        searchText: '',
        minPrice: null,
        maxPrice: null,
        sortBy: '',
        order: '',
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<void> _searchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      add(const FetchProducts());
      return;
    }

    try {
      final response = await _repository.searchProducts(
        query: query,
        page: 1,
        limit: _limit,
      );

      _emitLoadedState(
        emit,
        response,
        page: 1,
        searchText: query,
        minPrice: null,
        maxPrice: null,
        sortBy: '',
        order: '',
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }


  Future<void> _filterProducts(
    FilterProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ProductLoaded) {
      return;
    }

    try {
      final response = await _repository.filterProducts(
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        page: 1,
        limit: _limit,
      );

      _emitLoadedState(
        emit,
        response,
        page: 1,
        searchText: currentState.searchText,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        sortBy: currentState.sortBy,
        order: currentState.order,
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<void> _sortProducts(
    SortProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ProductLoaded) {
      return;
    }

    try {
      final response = await _repository.sortProducts(
        sortBy: event.sortBy,
        order: event.order,
        page: 1,
        limit: _limit,
      );

      _emitLoadedState(
        emit,
        response,
        page: 1,
        searchText: currentState.searchText,
        minPrice: currentState.minPrice,
        maxPrice: currentState.maxPrice,
        sortBy: event.sortBy,
        order: event.order,
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<Map<String, dynamic>> _loadProductsForState(
    ProductLoaded currentState, {
    required int page,
  }) async {
    final query = currentState.searchText.trim();

    if (query.isNotEmpty) {
      return _repository.searchProducts(
        query: query,
        page: page,
        limit: _limit,
      );
    }

    if (currentState.minPrice != null || currentState.maxPrice != null) {
      return _repository.filterProducts(
        minPrice: currentState.minPrice ?? 0,
        maxPrice: currentState.maxPrice ?? double.infinity,
        page: page,
        limit: _limit,
      );
    }

    if (currentState.sortBy.isNotEmpty) {
      return _repository.sortProducts(
        sortBy: currentState.sortBy,
        order: currentState.order,
        page: page,
        limit: _limit,
      );
    }

    return _repository.getProducts(page: page, limit: _limit);
  }



  void _emitLoadedState(
    Emitter<ProductState> emit,
    Map<String, dynamic> response, {
    required int page,
    required String searchText,
    required double? minPrice,
    required double? maxPrice,
    required String sortBy,
    required String order,
  }) {
    final products = _extractProducts(response);
    final total = _extractTotal(response);

    emit(
      ProductLoaded(
        products: products,
        allProducts: products,
        currentPage: page,
        hasMore: _hasMore(response, page),
        isLoadingMore: false,
        searchText: searchText,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        order: order,
      ),
    );
  }

  bool _hasMore(Map<String, dynamic> response, int page) {
    final total = _extractTotal(response);
    return total > page * _limit;
  }

  int _extractTotal(Map<String, dynamic> response) {
    final total = response['total'];

    if (total is int) {
      return total;
    }

    if (total is num) {
      return total.toInt();
    }

    return _extractProducts(response).length;
  }

  // ==========================================================
  // EXTRACT PRODUCT LIST FROM API RESPONSE
  // ==========================================================

  List<Map<String, dynamic>> _extractProducts(Map<String, dynamic> response) {
    final dynamic data = response['products'];

    if (data is List) {
      return data
          .whereType<Map>()
          .map((product) => Map<String, dynamic>.from(product))
          .toList();
    }

    return [];
  }

  // ==========================================================
  // CONVERT PRICE TO DOUBLE
  // ==========================================================

  double _getPrice(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    final priceString = value
        .toString()
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(priceString) ?? 0;
  }
}

import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// ==========================================================
// INITIAL
// ==========================================================

class ProductInitial extends ProductState {
  const ProductInitial();
}

// ==========================================================
// LOADING
// ==========================================================

class ProductLoading extends ProductState {
  const ProductLoading();
}

// ==========================================================
// LOADED
// ==========================================================

class ProductLoaded extends ProductState {
  final List<Map<String, dynamic>> products;

  // Original complete product list
  final List<Map<String, dynamic>> allProducts;

  // Pagination
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  // Search
  final String searchText;

  // Filter
  final double? minPrice;
  final double? maxPrice;

  // Sort
  final String sortBy;
  final String order;

  const ProductLoaded({
    required this.products,
    List<Map<String, dynamic>>? allProducts,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.searchText = '',
    this.minPrice,
    this.maxPrice,
    this.sortBy = '',
    this.order = '',
  }) : allProducts = allProducts ?? products;

  ProductLoaded copyWith({
    List<Map<String, dynamic>>? products,
    List<Map<String, dynamic>>? allProducts,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchText,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchText: searchText ?? this.searchText,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    products,
    allProducts,
    currentPage,
    hasMore,
    isLoadingMore,
    searchText,
    minPrice,
    maxPrice,
    sortBy,
    order,
  ];
}

// ==========================================================
// ERROR
// ==========================================================

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
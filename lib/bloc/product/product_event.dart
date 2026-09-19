import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}


// Fetch products
class FetchProducts extends ProductEvent {
  const FetchProducts();
}


// Load more products
class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}


// Refresh products
class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}


// Search products
class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}


// Filter products
class FilterProducts extends ProductEvent {
  final double minPrice;
  final double maxPrice;

  const FilterProducts({
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  List<Object?> get props => [
    minPrice,
    maxPrice,
  ];
}


// Sort products
class SortProducts extends ProductEvent {
  final String sortBy;
  final String order;

  const SortProducts({
    required this.sortBy,
    required this.order,
  });

  @override
  List<Object?> get props => [
    sortBy,
    order,
  ];
}
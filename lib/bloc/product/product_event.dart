import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Get products from API
class FetchProducts extends ProductEvent {
  const FetchProducts();
}

// Load next page
class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

// Refresh products
class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}
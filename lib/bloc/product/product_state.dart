import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ProductInitial extends ProductState {
  const ProductInitial();
}

// Loading first page
class ProductLoading extends ProductState {
  const ProductLoading();
}

// Products loaded successfully
class ProductLoaded extends ProductState {
  final List<Map<String, dynamic>> products;
  final bool hasMore;
  final bool isLoadingMore;

  const ProductLoaded({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ProductLoaded copyWith({
    List<Map<String, dynamic>>? products,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, isLoadingMore];
}

// Error state
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

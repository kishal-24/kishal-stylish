import 'package:equatable/equatable.dart';


// ============================================================
// BASE STATE
// ============================================================

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}


// ============================================================
// INITIAL
// ============================================================

class CartInitial extends CartState {
  const CartInitial();
}


// ============================================================
// LOADING
// ============================================================

class CartLoading extends CartState {
  const CartLoading();
}


// ============================================================
// LOADED
// ============================================================

class CartLoaded extends CartState {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CartLoaded({
    this.cartItems = const [],
    this.totalPrice = 0.0,
  });

  CartLoaded copyWith({
    List<Map<String, dynamic>>? cartItems,
    double? totalPrice,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [
    cartItems,
    totalPrice,
  ];
}


// ============================================================
// ERROR
// ============================================================

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [
    message,
  ];
}
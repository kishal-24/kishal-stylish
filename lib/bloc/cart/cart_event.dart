import 'package:equatable/equatable.dart';


// ============================================================
// BASE EVENT
// ============================================================

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}


// ============================================================
// LOAD CART
// ============================================================

class LoadCart extends CartEvent {
  const LoadCart();
}


// ============================================================
// ADD TO CART
// ============================================================

class AddCartItem extends CartEvent {
  final Map<String, dynamic> product;

  const AddCartItem(this.product);

  @override
  List<Object?> get props => [product];
}


// ============================================================
// INCREASE QUANTITY
// ============================================================

class IncreaseQuantity extends CartEvent {
  final int index;

  const IncreaseQuantity(this.index);

  @override
  List<Object?> get props => [index];
}


// ============================================================
// DECREASE QUANTITY
// ============================================================

class DecreaseQuantity extends CartEvent {
  final int index;

  const DecreaseQuantity(this.index);

  @override
  List<Object?> get props => [index];
}


// ============================================================
// REMOVE ITEM
// ============================================================

class RemoveCartItem extends CartEvent {
  final int index;

  const RemoveCartItem(this.index);

  @override
  List<Object?> get props => [index];
}


// ============================================================
// CLEAR CART
// ============================================================

class ClearCart extends CartEvent {
  const ClearCart();
}
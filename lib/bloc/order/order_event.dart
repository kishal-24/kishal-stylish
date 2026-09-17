import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final String selectedAddress;

  const PlaceOrder({
    required this.cartItems,
    required this.totalAmount,
    required this.selectedAddress,
  });

  @override
  List<Object?> get props => [
    cartItems,
    totalAmount,
    selectedAddress,
  ];
}
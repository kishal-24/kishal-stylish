import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/api_service.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<PlaceOrder>(_placeOrder);
  }

  Future<void> _placeOrder(
      PlaceOrder event,
      Emitter<OrderState> emit,
      ) async {
    try {
      emit(OrderLoading());

      if (event.cartItems.isEmpty) {
        emit(const OrderError('Cart is empty'));
        return;
      }

      final products = event.cartItems.map((item) {
        return {
          'id': item['id'],
          'quantity': item['quantity'] ?? 1,
        };
      }).toList();

      final result = await ApiService.createOrder(
        userId: 1,
        products: products,
        totalAmount: event.totalAmount + 30,
        selectedAddress: event.selectedAddress,
      );

      if (result == null) {
        emit(const OrderError('Order API failed'));
        return;
      }

      emit(OrderSuccess(result));
    } catch (e) {
      emit(
        OrderError(
          'Order failed',
        ),
      );
    }
  }
}
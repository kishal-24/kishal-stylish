import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cart_model.dart';

import 'cart_event.dart';
import 'cart_state.dart';


class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitial()) {

    // Register events
    on<LoadCart>(_loadCart);
    on<AddCartItem>(_addCartItem);
    on<IncreaseQuantity>(_increaseQuantity);
    on<DecreaseQuantity>(_decreaseQuantity);
    on<RemoveCartItem>(_removeCartItem);
    on<ClearCart>(_clearCart);
  }



  static const String _cartStorageKey = 'cart_items';



  Future<void> _loadCart(
      LoadCart event,
      Emitter<CartState> emit,
      ) async {
    try {
      emit(const CartLoading());

      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String? cartJson =
      prefs.getString(_cartStorageKey);

      if (cartJson == null || cartJson.isEmpty) {
        emit(
          const CartLoaded(
            cartItems: [],
            totalPrice: 0.0,
          ),
        );

        return;
      }

      final dynamic decodedData =
      jsonDecode(cartJson);

      final List<Map<String, dynamic>> cartItems = [];

      if (decodedData is List) {
        for (final item in decodedData) {
          if (item is Map) {
            final CartModel cartModel =
            CartModel.fromMap(
              Map<String, dynamic>.from(item),
            );

            cartItems.add(
              cartModel.toMap(),
            );
          }
        }
      }

      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice: _calculateTotal(cartItems),
        ),
      );
    } catch (e) {
      emit(
        const CartError(
          'Failed to load cart',
        ),
      );
    }
  }



  Future<void> _addCartItem(
      AddCartItem event,
      Emitter<CartState> emit,
      ) async {
    try {
      List<Map<String, dynamic>> cartItems = [];

      if (state is CartLoaded) {
        final currentState =
        state as CartLoaded;

        cartItems =
        List<Map<String, dynamic>>.from(
          currentState.cartItems,
        );
      }

      final Map<String, dynamic> product =
      Map<String, dynamic>.from(
        event.product,
      );



      final int existingIndex =
      cartItems.indexWhere(
            (item) =>
        item['id'] == product['id'] &&
            item['selectedSize'] ==
                product['selectedSize'],
      );


      if (existingIndex != -1) {

        // Product already exists
        final int quantity =
            int.tryParse(
              cartItems[existingIndex]
              ['quantity']
                  ?.toString() ??
                  '1',
            ) ??
                1;

        final Map<String, dynamic> updatedItem =
        Map<String, dynamic>.from(
          cartItems[existingIndex],
        );

        updatedItem['quantity'] =
            quantity + 1;

        cartItems[existingIndex] =
            updatedItem;

      } else {

        // New product
        cartItems.add({
          ...product,
          'quantity': 1,
        });
      }


      // Save to SharedPreferences
      await _saveCart(cartItems);


      // Update state
      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice:
          _calculateTotal(cartItems),
        ),
      );

    } catch (e) {
      emit(
        const CartError(
          'Failed to add product to cart',
        ),
      );
    }
  }


  // ==========================================================
  // INCREASE QUANTITY
  // ==========================================================

  Future<void> _increaseQuantity(
      IncreaseQuantity event,
      Emitter<CartState> emit,
      ) async {

    if (state is! CartLoaded) {
      return;
    }

    final currentState =
    state as CartLoaded;


    final List<Map<String, dynamic>> cartItems =
    List<Map<String, dynamic>>.from(
      currentState.cartItems,
    );


    // Check index
    if (event.index < 0 ||
        event.index >= cartItems.length) {
      return;
    }


    final int quantity =
        int.tryParse(
          cartItems[event.index]['quantity']
              ?.toString() ??
              '1',
        ) ??
            1;


    final Map<String, dynamic> updatedItem =
    Map<String, dynamic>.from(
      cartItems[event.index],
    );

    updatedItem['quantity'] =
        quantity + 1;

    cartItems[event.index] =
        updatedItem;


    // Save
    await _saveCart(cartItems);


    // Update state
    emit(
      CartLoaded(
        cartItems: cartItems,
        totalPrice:
        _calculateTotal(cartItems),
      ),
    );
  }


  // ==========================================================
  // DECREASE QUANTITY
  // ==========================================================

  Future<void> _decreaseQuantity(
      DecreaseQuantity event,
      Emitter<CartState> emit,
      ) async {

    if (state is! CartLoaded) {
      return;
    }

    final currentState =
    state as CartLoaded;


    final List<Map<String, dynamic>> cartItems =
    List<Map<String, dynamic>>.from(
      currentState.cartItems,
    );


    // Check index
    if (event.index < 0 ||
        event.index >= cartItems.length) {
      return;
    }


    final int quantity =
        int.tryParse(
          cartItems[event.index]['quantity']
              ?.toString() ??
              '1',
        ) ??
            1;


    if (quantity > 1) {

      final Map<String, dynamic> updatedItem =
      Map<String, dynamic>.from(
        cartItems[event.index],
      );

      updatedItem['quantity'] =
          quantity - 1;

      cartItems[event.index] =
          updatedItem;

    } else {

      // Quantity is 1
      // Remove product
      cartItems.removeAt(event.index);
    }


    // Save
    await _saveCart(cartItems);


    // Update state
    emit(
      CartLoaded(
        cartItems: cartItems,
        totalPrice:
        _calculateTotal(cartItems),
      ),
    );
  }


  // ==========================================================
  // REMOVE CART ITEM
  // ==========================================================

  Future<void> _removeCartItem(
      RemoveCartItem event,
      Emitter<CartState> emit,
      ) async {

    if (state is! CartLoaded) {
      return;
    }

    final currentState =
    state as CartLoaded;


    final List<Map<String, dynamic>> cartItems =
    List<Map<String, dynamic>>.from(
      currentState.cartItems,
    );


    // Check index
    if (event.index < 0 ||
        event.index >= cartItems.length) {
      return;
    }


    // Remove
    cartItems.removeAt(event.index);


    // Save
    await _saveCart(cartItems);


    // Update state
    emit(
      CartLoaded(
        cartItems: cartItems,
        totalPrice:
        _calculateTotal(cartItems),
      ),
    );
  }


  // ==========================================================
  // CLEAR CART
  // ==========================================================

  Future<void> _clearCart(
      ClearCart event,
      Emitter<CartState> emit,
      ) async {

    try {

      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.remove(
        _cartStorageKey,
      );


      emit(
        const CartLoaded(
          cartItems: [],
          totalPrice: 0.0,
        ),
      );

    } catch (e) {

      emit(
        const CartError(
          'Failed to clear cart',
        ),
      );
    }
  }


  // ==========================================================
  // SAVE CART
  // ==========================================================

  Future<void> _saveCart(
      List<Map<String, dynamic>> cartItems,
      ) async {

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();


    final String cartJson =
    jsonEncode(cartItems);


    await prefs.setString(
      _cartStorageKey,
      cartJson,
    );
  }


  // ==========================================================
  // CALCULATE TOTAL
  // ==========================================================

  double _calculateTotal(
      List<Map<String, dynamic>> cartItems,
      ) {

    double total = 0.0;


    for (final item in cartItems) {

      String priceText =
          item['price']?.toString() ?? '0';


      priceText = priceText
          .replaceAll('₹', '')
          .replaceAll(',', '')
          .trim();


      final double price =
          double.tryParse(priceText) ?? 0.0;


      final int quantity =
          int.tryParse(
            item['quantity']
                ?.toString() ??
                '1',
          ) ??
              1;


      total += price * quantity;
    }


    return total;
  }
}
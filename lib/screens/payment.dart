import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';

import '../bloc/order/order_bloc.dart';
import '../bloc/order/order_event.dart';
import '../bloc/order/order_state.dart';

import '../widget/bot.dart';

class PaymentPage extends StatefulWidget {
  final String selectedAddress;
  final double totalAmount;
  final double subtotal;
  final double shipping;

  const PaymentPage({
    super.key,
    required this.selectedAddress,
    required this.totalAmount,
    required this.subtotal,
    required this.shipping,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  void showErrorToast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> showOrderSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/DONE.json',
                    width: 110,
                    height: 110,
                    repeat: false,
                    onLoaded: (composition) {
                      Future.delayed(const Duration(seconds: 3), () {
                        if (Navigator.of(dialogContext).canPop()) {
                          Navigator.of(dialogContext).pop();
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Order placed successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your order has been placed successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, orderState) async {
        // ======================================================
        // ORDER SUCCESS
        // ======================================================

        if (orderState is OrderSuccess) {
          await showOrderSuccessDialog();

          if (!mounted) return;

          // Clear cart using CartBloc
          context.read<CartBloc>().add(const ClearCart());

          // Go back to bottom navigation
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const bot()),
            (route) => false,
          );
        }

        // ======================================================
        // ORDER ERROR
        // ======================================================

        if (orderState is OrderError) {
          showErrorToast(orderState.message);
        }
      },

      child: Scaffold(
        backgroundColor: const Color(0xffFDFDFD),

        // ======================================================
        // APP BAR
        // ======================================================
        appBar: AppBar(
          backgroundColor: const Color(0xffFDFDFD),
          elevation: 0,
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title: const Text(
            'Checkout',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ======================================================
        // CART BLOC
        // ======================================================
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            // ==================================================
            // CART LOADING
            // ==================================================

            if (cartState is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xffF83758)),
              );
            }

            // ==================================================
            // CART ERROR
            // ==================================================

            if (cartState is CartError) {
              return Center(
                child: Text(
                  cartState.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // ==================================================
            // CART LOADED
            // ==================================================

            if (cartState is CartLoaded) {
              final cartItems = cartState.cartItems;

              final double totalAmount = widget.totalAmount;

              final double finalTotal = totalAmount;

              // ================================================
              // EMPTY CART
              // ================================================

              if (cartItems.isEmpty) {
                return const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                );
              }

              // ================================================
              // PAYMENT BODY
              // ================================================

              return SingleChildScrollView(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 20),

                    // ==========================================
                    // ORDER SUMMARY
                    // ==========================================
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // ORDER PRICE
                    // ==========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          'Order',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        Text(
                          '₹ ${widget.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // ==========================================
                    // SHIPPING
                    // ==========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          'Shipping',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        Text(
                          widget.shipping == 0
                              ? 'FREE'
                              : '₹ ${widget.shipping.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    // ==========================================
                    // TOTAL
                    // ==========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          '₹ ${finalTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // PAYMENT METHOD
                    // ==========================================
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    paymentMethod(image: 'assets/visa.png'),

                    const SizedBox(height: 15),

                    paymentMethod(image: 'assets/paypal.png'),

                    const SizedBox(height: 15),

                    paymentMethod(image: 'assets/ic_launcher.png'),

                    const SizedBox(height: 30),

                    // ==========================================
                    // CONTINUE BUTTON
                    // ==========================================
                    BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, orderState) {
                        final bool isLoading = orderState is OrderLoading;

                        return Center(
                          child: SizedBox(
                            width: 250,
                            height: 55,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffF83758),

                                disabledBackgroundColor: const Color(
                                  0xffF83758,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              onPressed: isLoading
                                  ? null
                                  : () {
                                      // ======================
                                      // SEND ORDER EVENT
                                      // ======================

                                      context.read<OrderBloc>().add(
                                        PlaceOrder(
                                          cartItems: cartItems,
                                          totalAmount: totalAmount,
                                          selectedAddress:
                                              widget.selectedAddress,
                                        ),
                                      );
                                    },

                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT METHOD WIDGET
  // ============================================================

  Widget paymentMethod({required String image}) {
    return Container(
      width: double.infinity,
      height: 65,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),

        child: Image.asset(
          image,
          width: 55,
          height: 55,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}

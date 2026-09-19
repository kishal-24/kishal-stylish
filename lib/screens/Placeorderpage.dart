import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../utils/order_total.dart';
import 'payment.dart';

class PlaceOrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final bool isBuyNow;

  const PlaceOrderPage({
    super.key,
    required this.cartItems,
    required this.isBuyNow,
  });

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  String selectedAddress = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  Future<void> loadAddress() async {
    final prefs = await SharedPreferences.getInstance();

    final bool useBusinessAddress =
        prefs.getBool('useBusinessAddress') ?? false;

    String address;

    if (useBusinessAddress) {
      address = prefs.getString('businessAddress') ?? '';
    } else {
      address = prefs.getString('primaryAddress') ?? '';
    }

    if (mounted) {
      setState(() {
        selectedAddress = address;
        isLoading = false;
      });
    }
  }

  void placeOrder(double total, double subtotal, double shipping) {
    if (selectedAddress.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please add a delivery address',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          totalAmount: total,
          subtotal: subtotal,
          shipping: shipping,
          selectedAddress: selectedAddress,
        ),
      ),
    );
  }

  Widget addressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCCD5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFF83758)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'Address selection can be added here',
                  );
                },
                child: const Text(
                  'Change',
                  style: TextStyle(color: Color(0xFFF83758)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (selectedAddress.isEmpty)
            const Text(
              'No delivery address found',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          else
            Text(
              selectedAddress,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }

  Widget orderSummary({
    required double subtotal,
    required double shipping,
    required double total,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              Text(
                '₹${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shipping',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              Text(
                shipping == 0 ? 'FREE' : '₹${shipping.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: shipping == 0 ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF83758),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget productCard(Map<String, dynamic> item) {
    final String title = item['title']?.toString() ?? 'Product';

    final double price = double.tryParse(item['price'].toString()) ?? 0;

    final int quantity = int.tryParse(item['quantity'].toString()) ?? 1;

    final String image =
        item['thumbnail']?.toString() ?? item['image']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: image.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : const Icon(Icons.image, color: Colors.grey),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '₹${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF83758),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Quantity: $quantity',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        List<Map<String, dynamic>> items;

        if (widget.isBuyNow) {
          items = widget.cartItems;
        } else {
          if (state is CartLoaded) {
            items = state.cartItems;
          } else {
            items = widget.cartItems;
          }
        }

        if (items.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Place Order',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            body: const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
            ),
          );
        }

        final double subtotal = calculateSubtotal(items);

        final double shipping = calculateShipping(subtotal);

        final double total = calculateGrandTotal(subtotal);

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),

            title: const Text(
              'Place Order',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // --------------------------------------------------
          // BODY
          // --------------------------------------------------
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF83758)),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------------------------
                      // ADDRESS
                      // -------------------------------

                      addressCard(),

                      const SizedBox(height: 20),

                      // -------------------------------
                      // PRODUCTS
                      // -------------------------------
                      const Text(
                        'Your Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...items.map((item) => productCard(item)),

                      const SizedBox(height: 8),

                      // -------------------------------
                      // ORDER SUMMARY
                      // -------------------------------
                      orderSummary(
                        subtotal: subtotal,
                        shipping: shipping,
                        total: total,
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),

          // --------------------------------------------------
          // BOTTOM BUTTON
          // --------------------------------------------------
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    placeOrder(total, subtotal, shipping);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF83758),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Continue to Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

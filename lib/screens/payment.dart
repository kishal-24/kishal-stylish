import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:stylish/data/api/api_service.dart';


import '../provider/cart_data.dart';
import '../widget/bot.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;
  final String selectedAddress;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.cartItems,
    required this.selectedAddress,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;



  Future<void> placeOrder() async {
    try {


      if (widget.cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }



      final List<Map<String, dynamic>> products =
      widget.cartItems.map((item) {
        return {
          'id': item['id'],
          'quantity': item['quantity'] ?? 1,
        };
      }).toList();


      final result = await ApiService.createOrder(
        userId: 1,
        products: products,
        totalAmount: widget.totalAmount + 30,
        selectedAddress: widget.selectedAddress,
      );

      if (!mounted) return;



      if (result == null) {
        setState(() {
          isLoading = false;
        });

        showErrorToast('Order API failed');

        return;
      }


      debugPrint('ORDER CREATED SUCCESSFULLY');
      debugPrint(result.toString());



      await showOrderSuccessDialog();

      if (!mounted) return;


      await cart.clearCart();


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const bot(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint('ORDER ERROR: $e');

      showErrorToast(
        'Order failed',
      );
    }
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
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your order has been placed successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  void showErrorToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final double finalTotal =
        widget.totalAmount + 30;

    return Scaffold(
      backgroundColor: const Color(0xffFDFDFD),



      appBar: AppBar(
        backgroundColor:
        const Color(0xffFDFDFD),

        elevation: 0,

        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),

          onPressed: isLoading
              ? null
              : () {
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


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),


            const Text(
              'Order Summary',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Order',

                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                Text(
                  '₹ ${widget.totalAmount.toStringAsFixed(2)}',

                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: const [
                Text(
                  'Shipping',

                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                Text(
                  '₹ 30',

                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const Divider(
              height: 30,
            ),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

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

            const Text(
              'Payment Method',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            paymentMethod(
              image: 'assets/visa.png',
            ),

            const SizedBox(height: 15),


            paymentMethod(
              image: 'assets/paypal.png',
            ),

            const SizedBox(height: 15),


            paymentMethod(
              image: 'assets/maes.png',
            ),

            const SizedBox(height: 30),



            Center(
              child: SizedBox(
                width: 250,
                height: 55,

                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xffF83758),

                    disabledBackgroundColor:
                    const Color(0xffF83758),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() {
                      isLoading = true;
                    });


                    await placeOrder();
                  },

                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,

                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Continue',

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget paymentMethod({
    required String image,
  }) {
    return Container(
      width: double.infinity,
      height: 65,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(10),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
        ),

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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:stylish/screens/checkout.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});



  double getProductPrice(Map<String, dynamic> product) {
    String priceText = product['price']?.toString() ?? '0';

    priceText = priceText
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(priceText) ?? 0;
  }



  int getProductQuantity(Map<String, dynamic> product) {
    return int.tryParse(
      product['quantity']?.toString() ?? '1',
    ) ??
        1;
  }


  Widget productImage(Map<String, dynamic> item) {
    final String image = item['image']?.toString() ?? '';


    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 90,
        height: 110,
        fit: BoxFit.cover,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const SizedBox(
            width: 90,
            height: 110,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },

        errorBuilder: (context, error, stackTrace) {
          return imageError();
        },
      );
    }


    return Image.asset(
      image,
      width: 90,
      height: 110,
      fit: BoxFit.cover,

      errorBuilder: (context, error, stackTrace) {
        return imageError();
      },
    );
  }



  Widget imageError() {
    return Container(
      width: 90,
      height: 110,
      color: Colors.grey[200],
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  }


  void proceedToCheckout(
      BuildContext context,
      List<Map<String, dynamic>> cartItems,
      ) {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your cart is empty',
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const checkout(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,



      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),


      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {

          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(
                        const LoadCart(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }



          if (state is CartLoaded) {
            final List<Map<String, dynamic>> cartItems =
                state.cartItems;



            if (cartItems.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 15),

                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Add some products to your cart',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }



            return Column(
              children: [


                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: cartItems.length,

                    itemBuilder: (context, index) {
                      final Map<String, dynamic> item =
                      cartItems[index];

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(12),

                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [

                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(10),

                              child: productImage(item),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [
                                  // PRODUCT NAME
                                  Text(
                                    item['name']
                                        ?.toString() ??
                                        '',

                                    maxLines: 2,

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // PRICE
                                  Text(
                                    item['price']
                                        ?.toString() ??
                                        '',

                                    style: const TextStyle(
                                      fontSize: 16,
                                      color:
                                      Color(0xffF83758),
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),


                                  if (item['selectedSize'] !=
                                      null &&
                                      item['selectedSize']
                                          .toString()
                                          .isNotEmpty)
                                    Text(
                                      'Size: ${item['selectedSize']}',
                                      style:
                                      GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight:
                                        FontWeight.w500,
                                      ),
                                    ),

                                  const SizedBox(height: 3),


                                  Text(
                                    item['desc']
                                        ?.toString() ??
                                        '',

                                    maxLines: 2,

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style:
                                    GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 10),



                                  Row(
                                    children: [
                                      // MINUS
                                      Container(
                                        width: 32,
                                        height: 32,

                                        decoration:
                                        BoxDecoration(
                                          border:
                                          Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                          BorderRadius
                                              .circular(6),
                                        ),

                                        child: IconButton(
                                          padding:
                                          EdgeInsets.zero,

                                          onPressed: () {
                                            context
                                                .read<
                                                CartBloc>()
                                                .add(
                                              DecreaseQuantity(
                                                index,
                                              ),
                                            );
                                          },

                                          icon: const Icon(
                                            Icons.remove,
                                            size: 18,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      // QUANTITY NUMBER
                                      Text(
                                        '${getProductQuantity(item)}',

                                        style:
                                        const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      // PLUS
                                      Container(
                                        width: 32,
                                        height: 32,

                                        decoration:
                                        BoxDecoration(
                                          border:
                                          Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                          BorderRadius
                                              .circular(6),
                                        ),

                                        child: IconButton(
                                          padding:
                                          EdgeInsets.zero,

                                          onPressed: () {
                                            context
                                                .read<
                                                CartBloc>()
                                                .add(
                                              IncreaseQuantity(
                                                index,
                                              ),
                                            );
                                          },

                                          icon: const Icon(
                                            Icons.add,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // =================================
                            // DELETE
                            // =================================

                            IconButton(
                              onPressed: () {
                                context
                                    .read<CartBloc>()
                                    .add(
                                  RemoveCartItem(index),
                                );
                              },

                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // =============================================
                // BOTTOM TOTAL SECTION
                // =============================================

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: const BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // =======================================
                      // TOTAL
                      // =======================================

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'Total',

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            '₹${state.totalPrice.toStringAsFixed(2)}',

                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xffF83758),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // =======================================
                      // CHECKOUT BUTTON
                      // =======================================

                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: () {
                            proceedToCheckout(
                              context,
                              cartItems,
                            );
                          },

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xffF83758),

                            foregroundColor: Colors.white,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                          ),

                          child: const Text(
                            'Proceed to Checkout',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // -------------------------------------------------
          // INITIAL
          // -------------------------------------------------

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
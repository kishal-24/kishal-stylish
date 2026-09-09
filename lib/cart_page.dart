import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/cart_data.dart';
import 'package:untitled/checkout.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // ============================================================
  // GET PRODUCT PRICE
  // ============================================================

  double getProductPrice(
      Map<String, dynamic> product,
      ) {
    String priceText =
        product['price']?.toString() ?? '0';

    priceText = priceText
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(priceText) ?? 0;
  }

  // ============================================================
  // GET PRODUCT QUANTITY
  // ============================================================

  int getProductQuantity(
      Map<String, dynamic> product,
      ) {
    return int.tryParse(
      product['quantity']?.toString() ?? '1',
    ) ??
        1;
  }

  // ============================================================
  // TOTAL PRICE
  // ============================================================

  double get totalPrice {
    double total = 0;

    for (final product in cart.cartItems) {
      final double price =
      getProductPrice(product);

      final int quantity =
      getProductQuantity(product);

      total += price * quantity;
    }

    return total;
  }

  // ============================================================
  // PRODUCT IMAGE
  // Supports API URL + local asset
  // ============================================================

  Widget productImage(
      Map<String, dynamic> item,
      ) {
    final String image =
        item['image']?.toString() ?? '';

    // API IMAGE
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 90,
        height: 110,
        fit: BoxFit.cover,

        loadingBuilder:
            (context, child, loadingProgress) {
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

        errorBuilder:
            (context, error, stackTrace) {
          return imageError();
        },
      );
    }

    // LOCAL IMAGE
    return Image.asset(
      image,
      width: 90,
      height: 110,
      fit: BoxFit.cover,

      errorBuilder:
          (context, error, stackTrace) {
        return imageError();
      },
    );
  }

  // ============================================================
  // IMAGE ERROR
  // ============================================================

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

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  void increaseQuantity(int index) {
    if (index < 0 ||
        index >= cart.cartItems.length) {
      return;
    }

    setState(() {
      cart.increaseQuantity(index);
    });
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  void decreaseQuantity(int index) {
    if (index < 0 ||
        index >= cart.cartItems.length) {
      return;
    }

    setState(() {
      cart.decreaseQuantity(index);
    });
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  void removeItem(int index) {
    if (index < 0 ||
        index >= cart.cartItems.length) {
      return;
    }

    setState(() {
      cart.removeFromCart(index);
    });
  }

  // ============================================================
  // PROCEED TO CHECKOUT
  // ============================================================

  void proceedToCheckout() {
    if (cart.cartItems.isEmpty) {
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

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

      // ========================================================
      // BODY
      // ========================================================

      body: cart.cartItems.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Icon(
              Icons
                  .shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),

            SizedBox(
              height: 15,
            ),

            Text(
              'Your cart is empty',

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Text(
              'Add some products to your cart',

              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // ==================================================
          // CART LIST
          // ==================================================

          Expanded(
            child: ListView.builder(
              padding:
              const EdgeInsets.all(15),

              itemCount:
              cart.cartItems.length,

              itemBuilder:
                  (context, index) {
                final item =
                cart.cartItems[index];

                return Container(
                  margin:
                  const EdgeInsets.only(
                    bottom: 15,
                  ),

                  padding:
                  const EdgeInsets.all(
                    10,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color:
                        Color(
                          0x1A000000,
                        ),

                        blurRadius: 6,

                        offset:
                        Offset(0, 2),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [


                      ClipRRect(
                        borderRadius:
                        BorderRadius
                            .circular(
                          10,
                        ),

                        child:
                        productImage(
                          item,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),



                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [
                            // NAME
                            Text(
                              item['name']
                                  ?.toString() ??
                                  '',

                              maxLines: 2,

                              overflow:
                              TextOverflow
                                  .ellipsis,

                              style:
                              const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            // PRICE
                            Text(
                              item['price']
                                  ?.toString() ??
                                  '',

                              style:
                              const TextStyle(
                                fontSize: 16,
                                color:
                                Color(
                                  0xffF83758,
                                ),
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 3,
                            ),

                            // DESCRIPTION
                            Text(
                              item['desc']
                                  ?.toString() ??
                                  '',

                              maxLines: 2,

                              overflow:
                              TextOverflow
                                  .ellipsis,

                              style:
                              GoogleFonts
                                  .poppins(
                                fontSize: 12,
                                color:
                                Colors.grey,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // ==================================================
                            // QUANTITY
                            // ==================================================

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
                                      color:
                                      Colors.grey,
                                    ),

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      6,
                                    ),
                                  ),

                                  child:
                                  IconButton(
                                    padding:
                                    EdgeInsets
                                        .zero,

                                    onPressed:
                                        () {
                                      decreaseQuantity(
                                        index,
                                      );
                                    },

                                    icon:
                                    const Icon(
                                      Icons.remove,
                                      size: 18,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                // QUANTITY TEXT
                                Text(
                                  '${item['quantity'] ?? 1}',

                                  style:
                                  const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                // PLUS
                                Container(
                                  width: 32,
                                  height: 32,

                                  decoration:
                                  BoxDecoration(
                                    border:
                                    Border.all(
                                      color:
                                      Colors.grey,
                                    ),

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      6,
                                    ),
                                  ),

                                  child:
                                  IconButton(
                                    padding:
                                    EdgeInsets
                                        .zero,

                                    onPressed:
                                        () {
                                      increaseQuantity(
                                        index,
                                      );
                                    },

                                    icon:
                                    const Icon(
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

                      // ==================================================
                      // DELETE
                      // ==================================================

                      IconButton(
                        onPressed: () {
                          removeItem(index);
                        },

                        icon:
                        const Icon(
                          Icons
                              .delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ==================================================
          // BOTTOM TOTAL
          // ==================================================

          Container(
            padding:
            const EdgeInsets.all(
              20,
            ),

            decoration:
            const BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color:
                  Color(
                    0x1A000000,
                  ),

                  blurRadius: 8,

                  offset:
                  Offset(0, -2),
                ),
              ],
            ),

            child: Column(
              children: [
                // ==================================================
                // TOTAL
                // ==================================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [
                    const Text(
                      'Total',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),

                    Text(
                      '₹${totalPrice.toStringAsFixed(2)}',

                      style:
                      const TextStyle(
                        fontSize: 20,
                        color:
                        Color(
                          0xffF83758,
                        ),
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),


                SizedBox(
                  width: double.infinity,

                  height: 50,

                  child:
                  ElevatedButton(
                    onPressed:
                    proceedToCheckout,

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(
                        0xffF83758,
                      ),

                      foregroundColor:
                      Colors.white,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          8,
                        ),
                      ),
                    ),

                    child:
                    const Text(
                      'Proceed to Checkout',

                      style:
                      TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
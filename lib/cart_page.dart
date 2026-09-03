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


  double get totalPrice {
    double total = 0;

    for (final product in cart.cartItems) {
      final price = getProductPrice(product);

      final quantity =
      getProductQuantity(product);

      total += price * quantity;
    }
    return total;
  }
  void increaseQuantity(int index) {
    setState(() {
      cart.increaseQuantity(index);
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      cart.decreaseQuantity(index);
    });
  }
  void removeItem(int index) {
    setState(() {
      cart.removeFromCart(index);
    });
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


      body: cart.cartItems.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
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
      )
          : Column(
        children: [

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),

              itemCount: cart.cartItems.length,

              itemBuilder: (context, index) {

                final item =
                cart.cartItems[index];

                return Container(
                  margin:
                  const EdgeInsets.only(
                    bottom: 15,
                  ),

                  padding:
                  const EdgeInsets.all(10),

                  decoration:
                  BoxDecoration(
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

                        child: Image.asset(
                          item['image'].toString(),

                          width: 90,
                          height: 110,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 110,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons
                                    .image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              item['name'].toString(),

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

                            Text(
                              '${item['price']}',

                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(
                                  0xffF83758,
                                ),
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              '${item['desc']}',

                              overflow:
                              TextOverflow.ellipsis,

                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
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

                                  child: IconButton(
                                    padding:
                                    EdgeInsets.zero,

                                    onPressed: () {
                                      decreaseQuantity(
                                          index);
                                    },

                                    icon: const Icon(
                                      Icons.remove,
                                      size: 18,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${item['quantity'] ?? 1}',

                                  style:
                                  const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),
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

                                  child: IconButton(
                                    padding:
                                    EdgeInsets.zero,

                                    onPressed: () {
                                      increaseQuantity(
                                          index);
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

                      IconButton(
                        onPressed: () {
                          removeItem(index);
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

          Container(
            padding:
            const EdgeInsets.all(20),

            decoration:
            const BoxDecoration(
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
                        FontWeight.bold,
                      ),
                    ),

    Text(
    '₹${totalPrice.toStringAsFixed(2)}',


                      style: const TextStyle(
                        fontSize: 20,
                        color:
                        Color(0xffF83758),
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const checkout(),
                        ),
                      );

                    },

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
                        BorderRadius.circular(
                          8,
                        ),
                      ),
                    ),

                    child: const Text(
                      'Proceed to Checkout',

                      style: TextStyle(
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
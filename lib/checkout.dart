import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/check.dart';
import 'package:untitled/Placeorderpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cart_data.dart';

class checkout extends StatefulWidget {
  const checkout({super.key});

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  // ============================================================
  // ADDRESS
  // ============================================================

  String primaryAddress = '';
  String businessAddress = '';

  bool useBusinessAddress = false;

  String get selectedAddress {
    return useBusinessAddress ? businessAddress : primaryAddress;
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  // ============================================================
  // LOAD SAVED ADDRESSES
  // ============================================================

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      primaryAddress = prefs.getString('primaryAddress') ?? '';
      businessAddress = prefs.getString('businessAddress') ?? '';
      useBusinessAddress =
          prefs.getBool('useBusinessAddress') ?? false;

      // Safety check
      if (useBusinessAddress && businessAddress.trim().isEmpty) {
        useBusinessAddress = false;
      }
    });
  }

  // ============================================================
  // PRODUCT PRICE
  // ============================================================

  double getProductPrice(Map<String, dynamic> product) {
    String priceText = product['price']?.toString() ?? '0';

    priceText = priceText
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(priceText) ?? 0;
  }

  // ============================================================
  // PRODUCT QUANTITY
  // ============================================================

  int getProductQuantity(Map<String, dynamic> product) {
    return int.tryParse(
      product['quantity']?.toString() ?? '1',
    ) ??
        1;
  }

  // ============================================================
  // TOTAL ITEMS
  // ============================================================

  int get totalItems {
    int total = 0;

    for (final item in cart.cartItems) {
      total += getProductQuantity(item);
    }

    return total;
  }

  // ============================================================
  // TOTAL PRICE
  // ============================================================

  double get totalPrice {
    double total = 0;

    for (final item in cart.cartItems) {
      final price = getProductPrice(item);
      final quantity = getProductQuantity(item);

      total += price * quantity;
    }

    return total;
  }

  // ============================================================
  // IMAGE ERROR
  // ============================================================

  Widget _imageError() {
    return Container(
      width: 80,
      height: 90,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // API URL + LOCAL ASSET
  // ============================================================

  Widget _buildProductImage(String image) {
    if (image.trim().isEmpty) {
      return _imageError();
    }

    if (image.startsWith('http://') ||
        image.startsWith('https://')) {
      return Image.network(
        image,
        width: 80,
        height: 90,
        fit: BoxFit.cover,
        loadingBuilder: (
            context,
            child,
            loadingProgress,
            ) {
          if (loadingProgress == null) {
            return child;
          }

          return const SizedBox(
            width: 80,
            height: 90,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _imageError();
        },
      );
    }

    return Image.asset(
      image,
      width: 80,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return _imageError();
      },
    );
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  void increaseQuantity(int index) {
    if (index < 0 || index >= cart.cartItems.length) {
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
    if (index < 0 || index >= cart.cartItems.length) {
      return;
    }

    setState(() {
      cart.decreaseQuantity(index);
    });
  }

  // ============================================================
  // ADD PRIMARY ADDRESS
  // ============================================================

  Future<void> addPrimaryAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Check(
          isBusinessAddress: false,
          fromCheckout: true,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null &&
        result.toString().trim().isNotEmpty) {
      final newAddress = result.toString().trim();

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'primaryAddress',
        newAddress,
      );

      await prefs.setBool(
        'useBusinessAddress',
        false,
      );

      if (!mounted) return;

      setState(() {
        primaryAddress = newAddress;
        useBusinessAddress = false;
      });
    }
  }

  // ============================================================
  // ADD BUSINESS ADDRESS
  // ============================================================

  Future<void> addBusinessAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Check(
          isBusinessAddress: true,
          fromCheckout: true,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null &&
        result.toString().trim().isNotEmpty) {
      final newAddress = result.toString().trim();

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'businessAddress',
        newAddress,
      );

      await prefs.setBool(
        'useBusinessAddress',
        true,
      );

      if (!mounted) return;

      setState(() {
        businessAddress = newAddress;
        useBusinessAddress = true;
      });
    }
  }

  // ============================================================
  // ADDRESS BOX
  // ============================================================

  Widget addressBox({
    required String title,
    required String address,
    required VoidCallback onPressed,
    required bool selected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected
              ? Colors.pink
              : Colors.grey.shade300,
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: selected
                ? Colors.pink
                : Colors.grey,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                if (address.trim().isEmpty)
                  const Text(
                    'No address added',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                else
                  Text(
                    address,
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: address.trim().isEmpty
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                borderRadius: address.trim().isEmpty
                    ? null
                    : BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Icon(
                address.trim().isEmpty
                    ? Icons.add
                    : Icons.edit,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget productCard(
      Map<String, dynamic> product,
      int index,
      ) {
    final String name =
        product['name']?.toString() ?? '';

    final String price =
        product['price']?.toString() ?? '₹0';

    final String description =
        product['desc']?.toString() ?? '';

    final String image =
        product['image']?.toString() ?? '';

    final int quantity =
    getProductQuantity(product);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildProductImage(image),
          ),

          const SizedBox(width: 12),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xffF83758),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 10),

                // QUANTITY
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        decreaseQuantity(index);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 12),

                    GestureDetector(
                      onTap: () {
                        increaseQuantity(index);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                        child: const Icon(
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
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
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
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 30,
        ),
        children: [
          // ======================================================
          // DELIVERY ADDRESS
          // ======================================================

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // PERSONAL ADDRESS
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: addressBox(
              title: 'Personal Address',
              address: primaryAddress,
              selected:
              !useBusinessAddress &&
                  primaryAddress.isNotEmpty,
              onPressed: addPrimaryAddress,
            ),
          ),

          const SizedBox(height: 12),

          // BUSINESS ADDRESS
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: addressBox(
              title: 'Business Address',
              address: businessAddress,
              selected:
              useBusinessAddress &&
                  businessAddress.isNotEmpty,
              onPressed: addBusinessAddress,
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // SWITCH
          // ======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Use Business Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          useBusinessAddress
                              ? 'Business address selected'
                              : 'Personal address selected',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value: useBusinessAddress,
                    activeColor: Colors.pink,
                    onChanged: (value) async {
                      if (value &&
                          businessAddress
                              .trim()
                              .isEmpty) {
                        Fluttertoast.showToast(
                          msg:
                          'Please add a Business Address first',
                          toastLength:
                          Toast.LENGTH_SHORT,
                          gravity:
                          ToastGravity.BOTTOM,
                          backgroundColor:
                          Colors.black,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      if (!value &&
                          primaryAddress
                              .trim()
                              .isEmpty) {
                        Fluttertoast.showToast(
                          msg:
                          'Please add a Personal Address first',
                          toastLength:
                          Toast.LENGTH_SHORT,
                          gravity:
                          ToastGravity.BOTTOM,
                          backgroundColor:
                          Colors.black,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      setState(() {
                        useBusinessAddress = value;
                      });

                      final prefs =
                      await SharedPreferences
                          .getInstance();

                      await prefs.setBool(
                        'useBusinessAddress',
                        value,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // SELECTED ADDRESS
          // ======================================================

          if (selectedAddress.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.pink,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      useBusinessAddress
                          ? 'Business Delivery Address'
                          : 'Personal Delivery Address',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      selectedAddress,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 25),

          // ======================================================
          // SHOPPING LIST
          // ======================================================

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'Shopping List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: cart.cartItems.isEmpty
                ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Your cart is empty',
                ),
              ),
            )
                : Column(
              children: List.generate(
                cart.cartItems.length,
                    (index) {
                  return productCard(
                    cart.cartItems[index],
                    index,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // TOTAL SECTION
          // ======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // TOTAL ITEMS
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Items',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$totalItems',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // TOTAL PRICE
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // PLACE ORDER
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // ADDRESS CHECK
                        if (selectedAddress
                            .trim()
                            .isEmpty) {
                          Fluttertoast.showToast(
                            msg:
                            'Please select a delivery address',
                            toastLength:
                            Toast.LENGTH_SHORT,
                            gravity:
                            ToastGravity.BOTTOM,
                            backgroundColor:
                            Colors.black,
                            textColor:
                            Colors.white,
                          );
                          return;
                        }

                        // CART CHECK
                        if (cart.cartItems.isEmpty) {
                          Fluttertoast.showToast(
                            msg:
                            'Your cart is empty',
                            toastLength:
                            Toast.LENGTH_SHORT,
                            gravity:
                            ToastGravity.BOTTOM,
                            backgroundColor:
                            Colors.black,
                            textColor:
                            Colors.white,
                          );
                          return;
                        }

                        // GO TO PLACE ORDER
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PlaceOrderPage(
                                cartItems:
                                List<Map<String, dynamic>>.from(
                                  cart.cartItems,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.pink,
                        foregroundColor:
                        Colors.white,
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Place Order',
                        style:
                        GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
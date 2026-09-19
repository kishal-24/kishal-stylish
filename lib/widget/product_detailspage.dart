import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stylish/screens/cart_page.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../screens/Placeorderpage.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> allProducts;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.allProducts,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage> {

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color primaryPink =
  Color(0xFFF83758);

  static const Color lightPink =
  Color(0xFFFFCCD5);

  static const Color backgroundColor =
  Color(0xFFFDFDFD);

  // ==========================================================
  // SELECTED SIZE
  // ==========================================================

  String selectedSize = '';

  // ==========================================================
  // CATEGORY BASED SIZES
  // DESIGN WILL REMAIN THE SAME
  // ==========================================================

  List<String> get availableSizes {

    final category =
    (widget.product['category'] ?? '')
        .toString()
        .toLowerCase()
        .trim();

    final name =
    (widget.product['name'] ?? '')
        .toString()
        .toLowerCase()
        .trim();

    final originalData =
    widget.product['originalData'];

    String originalCategory = '';

    if (originalData is Map) {
      originalCategory =
          (originalData['category'] ?? '')
              .toString()
              .toLowerCase()
              .trim();
    }

    final combined =
        '$category $originalCategory $name';

    // ========================================================
    // SHOES / SNEAKERS / FOOTWEAR
    // ========================================================

    if (combined.contains('shoe') ||
        combined.contains('sneaker') ||
        combined.contains('footwear') ||
        combined.contains('running')) {
      return [
        '6 UK',
        '7 UK',
        '8 UK',
        '9 UK',
        '10 UK',
      ];
    }

    // ========================================================
    // CLOTHING
    // ========================================================

    if (combined.contains('shirt') ||
        combined.contains('t-shirt') ||
        combined.contains('tshirt') ||
        combined.contains('top') ||
        combined.contains('dress') ||
        combined.contains('clothing') ||
        combined.contains('apparel') ||
        combined.contains('jeans') ||
        combined.contains('pants') ||
        combined.contains('trousers')) {
      return [
        'S',
        'M',
        'L',
        'XL',
        'XXL',
      ];
    }

    // ========================================================
    // WATCH
    // ========================================================

    if (combined.contains('watch')) {
      return [
        'Free Size',
      ];
    }

    // ========================================================
    // DEFAULT
    // ========================================================

    return [
      'Free Size',
    ];
  }

  // ==========================================================
  // PRODUCT IMAGE
  // ==========================================================

  String get productImage {
    return widget.product['image']?.toString() ?? '';
  }

  // ==========================================================
  // PRODUCT NAME
  // ==========================================================

  String get productName {
    return widget.product['name']?.toString() ?? '';
  }

  // ==========================================================
  // PRODUCT DESCRIPTION
  // ==========================================================

  String get productDescription {
    return widget.product['desc']?.toString() ?? '';
  }

  // ==========================================================
  // PRODUCT RATING
  // ==========================================================

  double get productRating {

    final value =
    widget.product['rating'];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }

  // ==========================================================
  // PRODUCT PRICE
  // ==========================================================

  double get productPrice {

    final value =
    widget.product['price'];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }

  // ==========================================================
  // DISCOUNT
  // ==========================================================

  double get discountPercentage {

    final value =
    widget.product['discount'];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }

  // ==========================================================
  // OLD PRICE
  // ==========================================================

  double get oldPrice {

    if (discountPercentage <= 0 ||
        discountPercentage >= 100) {
      return productPrice;
    }

    return productPrice /
        (1 - discountPercentage / 100);
  }

  // ==========================================================
  // RATING STARS
  // ==========================================================

  List<Widget> buildRatingStars(
      double rating,
      ) {

    return List.generate(
      5,
          (index) {

        if (rating >= index + 1) {
          return const Icon(
            Icons.star,
            color: Colors.amber,
            size: 18,
          );
        }

        if (rating >= index + 0.5) {
          return const Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 18,
          );
        }

        return const Icon(
          Icons.star_border,
          color: Colors.grey,
          size: 18,
        );
      },
    );
  }

  // ==========================================================
  // ADD TO CART
  // ==========================================================

  void addToCart() {

    final cartProduct =
    Map<String, dynamic>.from(
      widget.product,
    );

    cartProduct['selectedSize'] =
        selectedSize;

    cartProduct['quantity'] = 1;

    context.read<CartBloc>().add(
      AddCartItem(cartProduct),
    );

    Fluttertoast.showToast(
      msg: 'Added to cart',
      backgroundColor: primaryPink,
      textColor: Colors.white,
    );
  }

  // ==========================================================
  // BUY NOW
  // ==========================================================

  void buyNow() {

    final orderProduct =
    Map<String, dynamic>.from(
      widget.product,
    );

    orderProduct['quantity'] = 1;

    orderProduct['selectedSize'] =
        selectedSize;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlaceOrderPage(
              cartItems: [
                orderProduct,
              ],
              isBuyNow: true,
            ),
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor:
        Colors.white,

        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),

        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        centerTitle: true,

        actions: [

          BlocBuilder<CartBloc, CartState>(
            builder: (
                context,
                state,
                ) {

              final count =
              state is CartLoaded
                  ? state.cartItems
                  .fold<int>(
                0,
                    (
                    total,
                    item,
                    ) =>
                total +
                    (int.tryParse(
                      item['quantity']
                          ?.toString() ??
                          '1',
                    ) ??
                        1),
              )
                  : 0;

              return Stack(
                clipBehavior:
                Clip.none,

                children: [

                  IconButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const CartPage(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons
                          .shopping_cart_outlined,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),

                  if (count > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 19,
                        height: 19,
                        alignment:
                        Alignment.center,

                        decoration:
                        const BoxDecoration(
                          color:
                          primaryPink,
                          shape:
                          BoxShape.circle,
                        ),

                        child: Text(
                          '$count',
                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                            fontSize: 11,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(
            width: 8,
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // ==================================================
            // PRODUCT IMAGE
            // ==================================================

            buildProductImage(),

            // ==================================================
            // PRODUCT INFORMATION
            // ==================================================

            Padding(
              padding:
              const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // ============================================
                  // CATEGORY BASED SIZE
                  // ============================================

                  buildSizeOptions(),

                  const SizedBox(
                    height: 20,
                  ),

                  // ============================================
                  // PRODUCT NAME
                  // ============================================

                  Text(
                    productName,

                    style:
                    GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  // ============================================
                  // SUBTITLE
                  // ============================================

                  Text(
                    'Premium quality product',

                    style:
                    GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ============================================
                  // RATING
                  // ============================================

                  Row(
                    children: [

                      ...buildRatingStars(
                        productRating,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        productRating
                            .toStringAsFixed(1),

                        style:
                        GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // ============================================
                  // PRICE
                  // ============================================

                  Row(
                    children: [

                      Text(
                        '₹${productPrice.toStringAsFixed(0)}',

                        style:
                        GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      if (discountPercentage > 0)
                        Text(
                          '₹${oldPrice.toStringAsFixed(0)}',

                          style:
                          GoogleFonts.poppins(
                            fontSize: 16,
                            color:
                            Colors.grey,
                            decoration:
                            TextDecoration
                                .lineThrough,
                          ),
                        ),

                      const SizedBox(
                        width: 10,
                      ),

                      if (discountPercentage > 0)
                        Text(
                          '${discountPercentage.toStringAsFixed(0)}% OFF',

                          style:
                          GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                            Colors.green,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  // ============================================
                  // MRP
                  // ============================================

                  Text(
                    'MRP incl. all taxes',

                    style:
                    GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ============================================
                  // PRODUCT DETAILS
                  // ============================================

                  Text(
                    'Product Details',

                    style:
                    GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    productDescription,

                    style:
                    GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ============================================
                  // GO TO CART / BUY NOW
                  // ============================================

                  buildCartBuyButtons(),

                  const SizedBox(
                    height: 25,
                  ),

                  // ============================================
                  // DELIVERY
                  // ============================================

                  Container(
                    width:
                    double.infinity,

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      lightPink,

                      borderRadius:
                      BorderRadius.circular(
                        8,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          'Delivery',

                          style:
                          GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Row(
                          children: [

                            const Icon(
                              Icons.access_time,
                              size: 18,
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            Text(
                              'in with 1 hour',

                              style:
                              GoogleFonts.poppins(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // ============================================
                  // VIEW SIMILAR / COMPARE
                  // ============================================

                  Row(
                    children: [

                      Expanded(
                        child: actionBox(
                          icon: Icons
                              .remove_red_eye_outlined,
                          text:
                          'View Similar',
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: actionBox(
                          icon: Icons
                              .compare_arrows,
                          text:
                          'Add to Compare',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // ============================================
                  // SIMILAR PRODUCTS HEADER
                  // ============================================

                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(
                              'Similar To',

                              style:
                              GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 2,
                            ),

                            Text(
                              '${widget.allProducts.length}+ Items',

                              style:
                              GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      smallActionButton(
                        icon: Icons.sort,
                        text: 'Sort',
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      smallActionButton(
                        icon: Icons
                            .filter_alt_outlined,
                        text: 'Filter',
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // ============================================
                  // SIMILAR PRODUCTS
                  // ============================================

                  buildSuggestions(),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CART / BUY BUTTONS
  // ==========================================================

  Widget buildCartBuyButtons() {

    return Row(
      children: [

        // ======================================================
        // GO TO CART
        // ======================================================

        Expanded(
          child: GestureDetector(
            onTap: addToCart,

            child: SizedBox(
              height: 50,

              child: Stack(
                clipBehavior:
                Clip.none,

                alignment:
                Alignment.centerLeft,

                children: [

                  // BLUE BUTTON
                  Container(
                    width:
                    double.infinity,

                    height: 50,

                    margin:
                    const EdgeInsets.only(
                      left: 18,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFF287BEA,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        8,
                      ),
                    ),

                    child: Center(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                          left: 18,
                        ),

                        child: Text(
                          'add to cart',

                          style:
                          GoogleFonts.poppins(
                            color:
                            Colors.white,
                            fontSize: 17,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // BLUE CIRCLE
                  Positioned(
                    left: 0,
                    top: -3,

                    child: Container(
                      width: 55,
                      height: 55,

                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFF1768D5),
                        shape:
                        BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons
                            .shopping_cart_outlined,
                        color:
                        Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        // ======================================================
        // BUY NOW
        // ======================================================

        Expanded(
          child: GestureDetector(
            onTap: buyNow,

            child: SizedBox(
              height: 50,

              child: Stack(
                clipBehavior:
                Clip.none,

                alignment:
                Alignment.centerLeft,

                children: [

                  // GREEN BUTTON
                  Container(
                    width:
                    double.infinity,

                    height: 50,

                    margin:
                    const EdgeInsets.only(
                      left: 18,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFF2ED573,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        8,
                      ),
                    ),

                    child: Center(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                          left: 18,
                        ),

                        child: Text(
                          'Buy Now',

                          style:
                          GoogleFonts.poppins(
                            color:
                            Colors.white,
                            fontSize: 17,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // GREEN CIRCLE
                  Positioned(
                    left: 0,
                    top: -3,

                    child: Container(
                      width: 55,
                      height: 55,

                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFF20C866),
                        shape:
                        BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.touch_app_outlined,
                        color:
                        Colors.white,
                        size: 23,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // FIXED PRODUCT IMAGE
  // ==========================================================

  Widget buildProductImage() {

    return SizedBox(
      height: 500,
      width: double.infinity,

      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(20),

        child: Image.network(
          productImage,

          width: double.infinity,

          height: 500,

          fit: BoxFit.cover,

          errorBuilder:
              (
              context,
              error,
              stackTrace,
              ) {

            return const Center(
              child: Icon(
                Icons
                    .image_not_supported_outlined,
                size: 60,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // CATEGORY BASED SIZE SECTION
  // ==========================================================

  Widget buildSizeOptions() {

    final sizes =
        availableSizes;

    // ========================================================
    // AUTOMATICALLY SELECT FIRST SIZE
    // ========================================================

    if (selectedSize.isEmpty ||
        !sizes.contains(
          selectedSize,
        )) {
      selectedSize =
          sizes.first;
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // ======================================================
        // SELECTED SIZE
        // ======================================================

        Text(
          'Size: $selectedSize',

          style:
          GoogleFonts.poppins(
            fontSize: 18,
            fontWeight:
            FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        // ======================================================
        // SIZE BUTTONS
        // ======================================================

        SingleChildScrollView(
          scrollDirection:
          Axis.horizontal,

          child: Row(
            children:
            sizes.map(
                  (size) {

                return Padding(
                  padding:
                  const EdgeInsets.only(
                    right: 8,
                  ),

                  child:
                  sizeButton(size),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SIZE BUTTON
  // SAME DESIGN FOR EVERY CATEGORY
  // ==========================================================

  Widget sizeButton(
      String size,
      ) {

    final bool isSelected =
        selectedSize == size;

    return GestureDetector(
      onTap: () {

        setState(() {
          selectedSize =
              size;
        });
      },

      child: Container(
        width: 55,
        height: 42,

        alignment:
        Alignment.center,

        decoration:
        BoxDecoration(
          color: isSelected
              ? primaryPink
              : Colors.white,

          border: Border.all(
            color:
            primaryPink,
            width: 1.5,
          ),

          borderRadius:
          BorderRadius.circular(
            6,
          ),
        ),

        child: Text(
          size,

          style:
          GoogleFonts.poppins(
            fontSize: 12,
            fontWeight:
            FontWeight.w600,

            color: isSelected
                ? Colors.white
                : primaryPink,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ACTION BOX
  // ==========================================================

  Widget actionBox({
    required IconData icon,
    required String text,
  }) {

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 18,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.grey[200],

        borderRadius:
        BorderRadius.circular(
          8,
        ),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            size: 22,
          ),

          const SizedBox(
            width: 6,
          ),

          Flexible(
            child: Text(
              text,

              overflow:
              TextOverflow.ellipsis,

              style:
              GoogleFonts.poppins(
                fontSize: 15,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SORT / FILTER BUTTON
  // ==========================================================

  Widget smallActionButton({
    required IconData icon,
    required String text,
  }) {

    return Container(
      height: 32,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.white,

        borderRadius:
        BorderRadius.circular(
          5,
        ),

        border: Border.all(
          color:
          Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            size: 15,
          ),

          const SizedBox(
            width: 3,
          ),

          Text(
            text,

            style:
            GoogleFonts.poppins(
              fontSize: 10,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SIMILAR PRODUCTS
  // ==========================================================

  Widget buildSuggestions() {

    final suggestions =
    widget.allProducts
        .where(
          (product) =>
      product['id'] !=
          widget.product['id'],
    )
        .take(2)
        .toList();

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children:
      suggestions.map(
            (product) {

          return Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 4,
              ),

              child:
              suggestionCard(
                product,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  // ==========================================================
  // SIMILAR PRODUCT CARD
  // ==========================================================

  Widget suggestionCard(
      Map<String, dynamic> product,
      ) {

    final image =
        product['image']
            ?.toString() ??
            '';

    final name =
        product['name']
            ?.toString() ??
            '';

    final description =
        product['desc']
            ?.toString() ??
            '';

    final price =
        product['price']
            ?.toString() ??
            '';

    final rating =
        (product['rating'] as num?)
            ?.toDouble() ??
            0.0;

    return GestureDetector(
      onTap: () {

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsPage(
                  product:
                  product,

                  allProducts:
                  widget.allProducts,
                ),
          ),
        );
      },

      child: Container(
        decoration:
        BoxDecoration(
          color:
          Colors.white,

          borderRadius:
          BorderRadius.circular(
            10,
          ),

          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withValues(
                alpha: 0.05,
              ),

              blurRadius: 5,

              offset:
              const Offset(
                0,
                2,
              ),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // ================================================
            // IMAGE
            // ================================================

            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(
                top: Radius.circular(
                  10,
                ),
              ),

              child: Image.network(
                image,

                height: 300,

                width:
                double.infinity,

                fit:
                BoxFit.cover,

                errorBuilder:
                    (
                    context,
                    error,
                    stackTrace,
                    ) {

                  return Container(
                    height: 300,

                    color:
                    Colors.grey.shade200,

                    child:
                    const Center(
                      child: Icon(
                        Icons
                            .image_not_supported_outlined,
                        size: 40,
                        color:
                        Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ================================================
            // DETAILS
            // ================================================

            Padding(
              padding:
              const EdgeInsets.all(
                7,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    name,

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style:
                    GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    description,

                    maxLines: 2,

                    overflow:
                    TextOverflow.ellipsis,

                    style:
                    GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                      Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    '₹$price',

                    style:
                    GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Row(
                    children: [

                      ...buildRatingStars(
                        rating,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        rating
                            .toStringAsFixed(
                          1,
                        ),

                        style:
                        GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
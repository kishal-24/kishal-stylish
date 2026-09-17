import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stylish/screens/payment.dart';
import 'package:stylish/screens/check.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';


class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  // ============================================================
  // LOCAL UI DATA
  // ============================================================

  bool isFavorite = false;

  String selectedAddress = '';

  bool isBusinessAddress = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadAddress();
  }

  // ============================================================
  // LOAD ADDRESS
  // ============================================================

  Future<void> loadAddress() async {
    final prefs = await SharedPreferences.getInstance();

    // ----------------------------------------------------------
    // CHECKOUT SWITCH
    // ----------------------------------------------------------

    final useBusinessAddress =
        prefs.getBool('useBusinessAddress') ?? false;

    // ----------------------------------------------------------
    // PERSONAL ADDRESS
    // ----------------------------------------------------------

    final fullName =
        prefs.getString('fullName') ?? '';

    final address =
        prefs.getString('address') ?? '';

    final city =
        prefs.getString('city') ?? '';

    final state =
        prefs.getString('state') ?? '';

    final country =
        prefs.getString('country') ?? '';

    // ----------------------------------------------------------
    // BUSINESS ADDRESS
    // ----------------------------------------------------------

    final businessName =
        prefs.getString('businessName') ?? '';

    final businessAddress =
        prefs.getString('businessAddress') ?? '';

    final businessCity =
        prefs.getString('businessCity') ?? '';

    final businessState =
        prefs.getString('businessState') ?? '';

    final businessCountry =
        prefs.getString('businessCountry') ?? '';

    // ----------------------------------------------------------
    // CHECK PERSONAL ADDRESS
    // ----------------------------------------------------------

    final hasPersonalAddress =
        fullName.trim().isNotEmpty ||
            address.trim().isNotEmpty ||
            city.trim().isNotEmpty ||
            state.trim().isNotEmpty ||
            country.trim().isNotEmpty;

    // ----------------------------------------------------------
    // CHECK BUSINESS ADDRESS
    // ----------------------------------------------------------

    final hasBusinessAddress =
        businessName.trim().isNotEmpty ||
            businessAddress.trim().isNotEmpty ||
            businessCity.trim().isNotEmpty ||
            businessState.trim().isNotEmpty ||
            businessCountry.trim().isNotEmpty;

    // ----------------------------------------------------------
    // SELECT ADDRESS
    // ----------------------------------------------------------

    String addressToShow = '';

    bool businessSelected = false;

    // ----------------------------------------------------------
    // BUSINESS SELECTED
    // ----------------------------------------------------------

    if (useBusinessAddress && hasBusinessAddress) {
      businessSelected = true;

      addressToShow =
      '${businessName.trim()}, '
          '${businessAddress.trim()}, '
          '${businessCity.trim()}, '
          '${businessState.trim()}, '
          '${businessCountry.trim()}';
    }

    // ----------------------------------------------------------
    // PERSONAL SELECTED
    // ----------------------------------------------------------

    else if (!useBusinessAddress && hasPersonalAddress) {
      businessSelected = false;

      addressToShow =
      '${fullName.trim()}, '
          '${address.trim()}, '
          '${city.trim()}, '
          '${state.trim()}, '
          '${country.trim()}';
    }

    // ----------------------------------------------------------
    // FALLBACK PERSONAL
    // ----------------------------------------------------------

    else if (hasPersonalAddress) {
      businessSelected = false;

      addressToShow =
      '${fullName.trim()}, '
          '${address.trim()}, '
          '${city.trim()}, '
          '${state.trim()}, '
          '${country.trim()}';
    }

    // ----------------------------------------------------------
    // FALLBACK BUSINESS
    // ----------------------------------------------------------

    else if (hasBusinessAddress) {
      businessSelected = true;

      addressToShow =
      '${businessName.trim()}, '
          '${businessAddress.trim()}, '
          '${businessCity.trim()}, '
          '${businessState.trim()}, '
          '${businessCountry.trim()}';
    }

    if (!mounted) return;

    setState(() {
      selectedAddress = addressToShow;

      isBusinessAddress = businessSelected;
    });
  }

  // ============================================================
  // PRODUCT PRICE
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
  // PRODUCT QUANTITY
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
  // PRODUCT CARD
  // ============================================================

  Widget productCard(
      Map<String, dynamic> product,
      int index,
      ) {
    final quantity =
    getProductQuantity(product);

    final price =
    getProductPrice(product);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ====================================================
          // PRODUCT IMAGE
          // ====================================================

          ClipRRect(
            borderRadius:
            BorderRadius.circular(6),

            child: product['image']
                ?.toString()
                .startsWith('http') ==
                true
                ? Image.network(
              product['image'].toString(),

              width: 80,
              height: 100,

              fit: BoxFit.cover,

              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 80,
                  height: 100,

                  color:
                  Colors.grey.shade200,

                  child: const Icon(
                    Icons
                        .image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            )
                : Image.asset(
              product['image']
                  ?.toString() ??
                  '',

              width: 80,
              height: 100,

              fit: BoxFit.cover,

              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 80,
                  height: 100,

                  color:
                  Colors.grey.shade200,

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

          // ====================================================
          // PRODUCT DETAILS
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // PRODUCT NAME

                Text(
                  product['name']?.toString() ??
                      'Product',

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                // DESCRIPTION

                Text(
                  product['desc']?.toString() ??
                      '',

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 7),

                // PRICE

                Text(
                  '₹ ${price.toStringAsFixed(2)}',

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                // QUANTITY

                Container(
                  height: 28,

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),

                  decoration: BoxDecoration(
                    color:
                    Colors.grey.shade100,

                    borderRadius:
                    BorderRadius.circular(4),
                  ),

                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      const Text(
                        'Qty',

                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        '$quantity',

                        style:
                        const TextStyle(
                          fontSize: 10,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Delivery by 10 May 20XX',

                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT ROW
  // ============================================================

  Widget paymentRow(
      String title,
      String value, {
        Color valueColor = Colors.black,
      }) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        children: [

          Text(
            title,

            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          Text(
            value,

            style: TextStyle(
              fontSize: 11,
              fontWeight:
              FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY ADDRESS CARD
  // ============================================================

  Widget deliveryAddressCard() {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(15),

      margin:
      const EdgeInsets.only(
        bottom: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(8),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ====================================================
          // HEADER
          // ====================================================

          Row(
            children: [

              const Icon(
                Icons.location_on_outlined,

                color:
                Color(0xffF83758),

                size: 23,
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'Delivery Address',

                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

              // CHANGE ADDRESS

              TextButton(
                onPressed: () async {

                  final prefs =
                  await SharedPreferences
                      .getInstance();

                  final currentSelection =
                      prefs.getBool(
                        'useBusinessAddress',
                      ) ??
                          false;

                  final result =
                  await Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (context) => Check(
                        isBusinessAddress:
                        currentSelection,

                        fromCheckout: true,
                      ),
                    ),
                  );

                  if (!mounted) return;

                  await loadAddress();

                  if (result != null &&
                      result
                          .toString()
                          .trim()
                          .isNotEmpty) {
                    await loadAddress();
                  }
                },

                child: const Text(
                  'Change',

                  style: TextStyle(
                    color:
                    Color(0xffF83758),
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ====================================================
          // ADDRESS
          // ====================================================

          if (selectedAddress.isEmpty)
            const Text(
              'No address added',

              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            )
          else
            Text(
              selectedAddress,

              softWrap: true,

              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

          // ====================================================
          // ADDRESS TYPE
          // ====================================================

          if (selectedAddress.isNotEmpty)
            const SizedBox(height: 5),

          if (selectedAddress.isNotEmpty)
            Text(
              isBusinessAddress
                  ? 'Business Address'
                  : 'Personal Address',

              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM PAYMENT BUTTON
  // ============================================================

  Widget bottomPaymentButton(
      List<Map<String, dynamic>> cartItems,
      double totalPrice,
      ) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.08,
            ),

            blurRadius: 8,

            offset:
            const Offset(0, -2),
          ),
        ],
      ),

      child: Row(
        children: [

          // ====================================================
          // TOTAL
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  '₹ ${totalPrice.toStringAsFixed(2)}',

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'View Details',

                  style: TextStyle(
                    fontSize: 14,
                    color:
                    Color(0xffF83758),
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // PROCEED TO PAYMENT
          // ====================================================

          SizedBox(
            width: 250,
            height: 55,

            child: ElevatedButton(
              onPressed: () {

                // ----------------------------------------------
                // CHECK ADDRESS
                // ----------------------------------------------

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

                // ----------------------------------------------
                // CHECK CART
                // ----------------------------------------------

                if (cartItems.isEmpty) {
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

                // ----------------------------------------------
                // GO TO PAYMENT
                // ----------------------------------------------

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder:
                        (context) =>
                            PaymentPage(
                              selectedAddress: selectedAddress,
                            )
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

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    5,
                  ),
                ),
              ),

              child: const Text(
                'Proceed to Payment',

                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
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
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      const Color(0xffFDFDFD),

      // ========================================================
      // APP BAR
      // ========================================================

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

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Shopping Bag',

          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite =
                !isFavorite;
              });
            },

            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,

              color: isFavorite
                  ? Colors.pink
                  : Colors.black,

              size: 22,
            ),
          ),
        ],
      ),

      // ========================================================
      // BLOC LISTENER + BLOC BUILDER
      // ========================================================

      body: SafeArea(
        child: BlocListener<
            CartBloc,
            CartState>(
          // ====================================================
          // LISTENER
          // ====================================================
          //
          // Listener = DO SOMETHING
          //
          // Here we listen for errors.
          // ====================================================

          listener:
              (context, state) {

            if (state is CartError) {
              Fluttertoast.showToast(
                msg: state.message,

                toastLength:
                Toast.LENGTH_SHORT,

                gravity:
                ToastGravity.BOTTOM,

                backgroundColor:
                Colors.black,

                textColor:
                Colors.white,
              );
            }
          },

          // ====================================================
          // BUILDER
          // ====================================================
          //
          // Builder = SHOW DATA
          //
          // CartBloc gives us:
          //
          // state.cartItems
          // state.totalPrice
          // ====================================================

          child: BlocBuilder<
              CartBloc,
              CartState>(
            builder:
                (context, state) {

              // =================================================
              // LOADING
              // =================================================

              if (state
              is CartLoading) {
                return const Center(
                  child:
                  CircularProgressIndicator(),
                );
              }

              // =================================================
              // CART LOADED
              // =================================================

              if (state
              is CartLoaded) {

                // -----------------------------------------------
                // GET CART FROM BLOC
                // -----------------------------------------------

                final cartItems =
                    state.cartItems;

                // -----------------------------------------------
                // GET TOTAL FROM BLOC
                // -----------------------------------------------

                final totalPrice =
                    state.totalPrice;

                // -----------------------------------------------
                // UI
                // -----------------------------------------------

                return Column(
                  children: [

                    // ==========================================
                    // SCROLLABLE CONTENT
                    // ==========================================

                    Expanded(
                      child:
                      SingleChildScrollView(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 15,
                        ),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            const SizedBox(
                              height: 15,
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            // ==================================
                            // CART PRODUCTS
                            // ==================================

                            if (cartItems
                                .isEmpty)
                              Container(
                                width:
                                double.infinity,

                                padding:
                                const EdgeInsets
                                    .all(
                                  30,
                                ),

                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors.white,

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),
                                ),

                                child:
                                const Center(
                                  child:
                                  Text(
                                    'Your cart is empty',

                                    style:
                                    TextStyle(
                                      color:
                                      Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Column(
                                children:
                                List.generate(
                                  cartItems
                                      .length,

                                      (index) {

                                    return productCard(
                                      cartItems[
                                      index],

                                      index,
                                    );
                                  },
                                ),
                              ),

                            const SizedBox(
                              height: 5,
                            ),

                            // ==================================
                            // DELIVERY ADDRESS
                            // ==================================

                            deliveryAddressCard(),

                            // ==================================
                            // COUPON
                            // ==================================

                            Container(
                              width:
                              double.infinity,

                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 15,
                                vertical: 16,
                              ),

                              decoration:
                              BoxDecoration(
                                color:
                                Colors.white,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  8,
                                ),

                                border:
                                Border.all(
                                  color:
                                  Colors.grey
                                      .shade200,
                                ),
                              ),

                              child: Row(
                                children: [

                                  const Icon(
                                    Icons
                                        .local_offer_outlined,

                                    size: 22,

                                    color:
                                    Colors.black,
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  const Text(
                                    'Apply Coupons',

                                    style:
                                    TextStyle(
                                      fontSize:
                                      13,
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                    ),
                                  ),

                                  const Spacer(),

                                  GestureDetector(
                                    onTap: () {
                                      Fluttertoast
                                          .showToast(
                                        msg:
                                        'Select a coupon',

                                        toastLength:
                                        Toast.LENGTH_SHORT,

                                        gravity:
                                        ToastGravity
                                            .BOTTOM,

                                        backgroundColor:
                                        Colors
                                            .black,

                                        textColor:
                                        Colors
                                            .white,
                                      );
                                    },

                                    child:
                                    const Text(
                                      'Select',

                                      style:
                                      TextStyle(
                                        color:
                                        Color(
                                          0xffF83758,
                                        ),

                                        fontSize:
                                        11,

                                        fontWeight:
                                        FontWeight
                                            .w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 25,
                            ),

                            // ==================================
                            // PAYMENT DETAILS TITLE
                            // ==================================

                            const Text(
                              'Order Payment Details',

                              style:
                              TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            // ==================================
                            // PAYMENT DETAILS
                            // ==================================

                            Container(
                              width:
                              double.infinity,

                              padding:
                              const EdgeInsets
                                  .all(
                                15,
                              ),

                              decoration:
                              BoxDecoration(
                                color:
                                Colors.white,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  8,
                                ),

                                border:
                                Border.all(
                                  color:
                                  Colors.grey
                                      .shade200,
                                ),
                              ),

                              child: Column(
                                children: [

                                  // --------------------------------
                                  // ORDER AMOUNT
                                  // --------------------------------

                                  paymentRow(
                                    'Order Amount',

                                    '₹ ${totalPrice.toStringAsFixed(2)}',
                                  ),

                                  // --------------------------------
                                  // CONVENIENCE FEE
                                  // --------------------------------

                                  Row(
                                    children: [

                                      const Text(
                                        'Convenience Fee',

                                        style:
                                        TextStyle(
                                          fontSize:
                                          15,
                                          color:
                                          Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 8,
                                      ),

                                      const Text(
                                        'Know More',

                                        style:
                                        TextStyle(
                                          fontSize:
                                          9,
                                          color:
                                          Color(
                                            0xffF83758,
                                          ),
                                        ),
                                      ),

                                      const Spacer(),

                                      const Text(
                                        '₹ 0',

                                        style:
                                        TextStyle(
                                          fontSize:
                                          11,
                                          color:
                                          Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  // --------------------------------
                                  // DELIVERY FEE
                                  // --------------------------------

                                  paymentRow(
                                    'Delivery Fee',

                                    'Free',

                                    valueColor:
                                    const Color(
                                      0xffF83758,
                                    ),
                                  ),

                                  const Divider(),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // --------------------------------
                                  // ORDER TOTAL
                                  // --------------------------------

                                  Row(
                                    children: [

                                      const Text(
                                        'Order Total',

                                        style:
                                        TextStyle(
                                          fontSize:
                                          15,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                        ),
                                      ),

                                      const Spacer(),

                                      Text(
                                        '₹ ${totalPrice.toStringAsFixed(2)}',

                                        style:
                                        const TextStyle(
                                          fontSize:
                                          13,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==========================================
                    // BOTTOM PAYMENT BUTTON
                    // ==========================================

                    bottomPaymentButton(
                      cartItems,
                      totalPrice,
                    ),
                  ],
                );
              }

              // =================================================
              // ERROR
              // =================================================

              if (state
              is CartError) {
                return Center(
                  child: Text(
                    state.message,
                  ),
                );
              }

              // =================================================
              // INITIAL / UNKNOWN
              // =================================================

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
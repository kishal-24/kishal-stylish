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


  String primaryAddress = '';
  String businessAddress = '';

  bool useBusinessAddress = false;

  String get selectedAddress {
    return useBusinessAddress
        ? businessAddress
        : primaryAddress;
  }

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      primaryAddress = prefs.getString('primaryAddress') ?? '';
      businessAddress = prefs.getString('businessAddress') ?? '';
      useBusinessAddress =
          prefs.getBool('useBusinessAddress') ?? false;
    });
  }

  int get totalItems {
    int total = 0;

    for (var item in cart.cartItems) {
      total += (item['quantity'] ?? 1) as int;
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

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'primaryAddress',
        result.toString(),
      );

      await prefs.setBool(
        'useBusinessAddress',
        false,
      );

      setState(() {
        primaryAddress = result.toString();
        useBusinessAddress = false;
      });
    }
  }
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

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'businessAddress',
        result.toString(),
      );

      await prefs.setBool(
        'useBusinessAddress',
        true,
      );

      setState(() {
        businessAddress = result.toString();
        useBusinessAddress = true;
      });
    }
  }


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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

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

                if (address.isEmpty)

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

                    overflow:
                    TextOverflow.ellipsis,

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

                shape: address.isEmpty
                    ? BoxShape.circle
                    : BoxShape.rectangle,

                borderRadius: address.isEmpty
                    ? null
                    : BorderRadius.circular(6),

                border: Border.all(
                  color: Colors.black,
                ),
              ),

              child: Icon(
                address.isEmpty
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


  Widget productCard(
      Map<String, dynamic> product,
      int index,
      ) {
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              product['image'].toString(),
              width: 80,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  product['name'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${product['price']}',
                  style: const TextStyle(
                    color: Color(0xffF83758),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  '${product['desc']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Row(
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

                    const SizedBox(width: 15),
                    Text(
                      '${product['quantity'] ?? 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 15),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(0xFFFDFDFD),



      appBar: AppBar(
        backgroundColor:
        Colors.white,

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
            fontWeight:
            FontWeight.w900,
          ),
        ),
      ),



      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 30,
        ),

        children: [



          const Padding(
            padding:
            EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Text(
              'Delivery Address',

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 15),



          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: addressBox(
              title:
              'Personal Address',

              address:
              primaryAddress,

              selected:
              !useBusinessAddress &&
                  primaryAddress.isNotEmpty,

              onPressed:
              addPrimaryAddress,
            ),
          ),

          const SizedBox(height: 12),


          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: addressBox(
              title:
              'Business Address',

              address:
              businessAddress,

              selected:
              useBusinessAddress &&
                  businessAddress.isNotEmpty,

              onPressed:
              addBusinessAddress,
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),

              decoration:
              BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(8),

                border: Border.all(
                  color:
                  Colors.grey.shade300,
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
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        const SizedBox(
                          height: 3,
                        ),

                        Text(
                          useBusinessAddress
                              ? 'Business address selected'
                              : 'Personal address selected',

                          style:
                          const TextStyle(
                            fontSize: 10,
                            color:
                            Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value:
                    useBusinessAddress,

                    activeThumbColor:
                    Colors.pink,

                    onChanged: (value) async {
                      if (value && businessAddress.trim().isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please add a Business Address first",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      if (!value && primaryAddress.trim().isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please add a Personal Address first",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      setState(() {
                        useBusinessAddress = value;
                      });

                      final prefs = await SharedPreferences.getInstance();

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

          if (selectedAddress.isNotEmpty)

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Container(
                width: double.infinity,

                padding:
                const EdgeInsets.all(15),

                decoration:
                BoxDecoration(
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

                      style:
                      const TextStyle(
                        fontSize: 13,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      selectedAddress,

                      softWrap: true,

                      style:
                      const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color:
                        Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 25),



          const Padding(
            padding:
            EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Text(
              'Shopping List',

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: cart.cartItems.isEmpty

                ? Container(
              width: double.infinity,

              padding:
              const EdgeInsets.all(
                30,
              ),

              decoration:
              BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: const Center(
                child: Text(
                  'Your cart is empty',
                ),
              ),
            )

                : Column(
              children:
              List.generate(
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

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Container(
              padding:
              const EdgeInsets.all(20),

              decoration:
              const BoxDecoration(
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color:
                    Color(0x20000000),

                    blurRadius: 10,

                    offset:
                    Offset(0, -3),
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

                      Text(
                        'Total Items',

                        style:
                        GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),

              Text(
                '$totalItems',

                        style:
                        GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width:
                    double.infinity,

                    height: 55,

                    child:
                    ElevatedButton(
                      onPressed: () {

                        if (selectedAddress
                            .trim()
                            .isEmpty) {

                          Fluttertoast.showToast(
                            msg: "Please select a delivery address",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );

                          return;
                        }

                        if (cart.cartItems
                            .isEmpty) {

                          Fluttertoast.showToast(
                            msg: "Your cart is empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );

                          return;
                        }



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
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        Colors.pink,

                        foregroundColor:
                        Colors.white,

                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            12,
                          ),
                        ),
                      ),

                      child: Text(
                        'Place Order',

                        style:
                        GoogleFonts.poppins(
                          fontSize: 17,
                          color:
                          Colors.white,
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
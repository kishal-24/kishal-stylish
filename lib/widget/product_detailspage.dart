import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/screens/Placeorderpage.dart';
import 'package:untitled/provider/cart_data.dart';
import 'package:untitled/screens/cart_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> allProducts;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.allProducts,
  });
  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isAddedToCart = false;
  String selectedSize = '';
  bool productHasSize() {
    final String category =
    (widget.product['category'] ?? '').toString().toLowerCase();

    return category.contains('shoe') ||
        category.contains('sneaker') ||
        category.contains('footwear') ||
        category.contains('dress') ||
        category.contains('shirt') ||
        category.contains('top');
  }

  static const Color lightPink = Color(0xFFFFCCD5);

  static const Color backgroundColor = Color(0xFFFDFDFD);
  List<Widget> buildRatingStars(double rating) {
    return List.generate(
      5,
          (index) {
        if (rating >= index + 1) {
          return const Icon(
            Icons.star,
            color: Colors.amber,
            size: 22,
          );
        }

        if (rating >= index + 0.5) {
          return const Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 22,
          );
        }

        return const Icon(
          Icons.star_border,
          color: Colors.grey,
          size: 22,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),

        title: Text(
          'Product Details',

          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          ValueListenableBuilder<int>(
            valueListenable: cart.cartCount,

            builder: (context, count, child) {
              return Stack(
                clipBehavior: Clip.none,

                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.shopping_cart_outlined,
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

                        alignment: Alignment.center,

                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),

                        child: Text(
                          '$count',

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              height: 500,

              width: double.infinity,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.product['image'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Select Size',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  buildSizeOptions(),
                  const SizedBox(height: 25),

                  Text(
                    widget.product['name'] ?? '',

                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 22),

                      const Icon(Icons.star, color: Colors.amber, size: 22),

                      const Icon(Icons.star, color: Colors.amber, size: 22),

                      const Icon(Icons.star, color: Colors.amber, size: 22),

                      const Icon(Icons.star, color: Colors.grey, size: 22),

                      const SizedBox(width: 8),

                      Text(
                        '4.0',

                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  Text(
                    widget.product['desc'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        widget.product['price'] ?? '',

                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        widget.product['oldPrice'] ?? '',

                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        widget.product['discount'] ?? '',

                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedScale(
                          scale: isAddedToCart ? 0.95 : 1.0,
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeInOut,

                          child: GestureDetector(
                            onTap: () async {
                              if (selectedSize.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please select a size",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                );

                                return;
                              }
                              final cartProduct = Map<String, dynamic>.from(widget.product);

                              cartProduct['selectedSize'] = selectedSize;

                              cart.addToCart(cartProduct);;
                              setState(() {
                                isAddedToCart = true;
                              });
                              await Future.delayed(
                                const Duration(milliseconds: 1500),
                              );

                              if (!mounted) return;
                              setState(() {
                                isAddedToCart = false;
                              });
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,

                              height: 56,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),

                                gradient: LinearGradient(
                                  colors: isAddedToCart
                                      ? const [
                                          Color(0xFFA04B43),
                                          Color(0xFF7D3C2E),
                                        ]
                                      : const [
                                          Color(0xFF1976D2),
                                          Color(0xFF1565C0),
                                        ],
                                ),
                              ),

                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),

                                    width: 56,
                                    height: 56,

                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,

                                      gradient: LinearGradient(
                                        colors: isAddedToCart
                                            ? const [
                                                Color(0xFFBB6D66),
                                                Color(0xFFA04B43),
                                              ]
                                            : const [
                                                Color(0xFF42A5F5),
                                                Color(0xFF1565C0),
                                              ],
                                      ),
                                    ),

                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),

                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },

                                      child: Icon(
                                        isAddedToCart
                                            ? Icons.check
                                            : Icons.shopping_cart,

                                        key: ValueKey(isAddedToCart),

                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),

                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: ScaleTransition(
                                                scale: animation,
                                                child: child,
                                              ),
                                            );
                                          },

                                      child: Text(
                                        isAddedToCart
                                            ? 'Added to cart'
                                            : 'Add to cart',

                                        key: ValueKey(isAddedToCart),

                                        overflow: TextOverflow.ellipsis,

                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (selectedSize.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please select a size",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                              );

                              return;
                            }

                            final orderProduct = Map<String, dynamic>.from(widget.product);
                            orderProduct['selectedSize'] = selectedSize;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaceOrderPage(cartItems: [orderProduct]),
                              ),
                            );
                          },

                          child: Container(
                            height: 56,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),

                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CD07D), Color(0xFF52DD86)],
                              ),
                            ),

                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,

                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,

                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4ED380),
                                        Color(0xFF38B765),
                                      ],
                                    ),
                                  ),

                                  child: const Icon(
                                    Icons.touch_app_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Flexible(
                                  child: Text(
                                    'Buy Now',

                                    overflow: TextOverflow.ellipsis,

                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),

                    decoration: BoxDecoration(
                      color: lightPink,

                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Delivery',

                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Row(
                          children: [
                            Icon(Icons.access_time, size: 18),

                            SizedBox(width: 5),

                            Text(
                              'in with 1 hour',

                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: actionBox(
                          icon: Icons.remove_red_eye_outlined,
                          text: 'View Similar',
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: actionBox(
                          icon: Icons.compare_arrows,
                          text: 'Add to Compare',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Similar Products',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildSuggestions(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSuggestions() {
    final suggestions = widget.allProducts
        .where((product) => product['name'] != widget.product['name'])
        .take(2)
        .toList();
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Row(
      children: suggestions
          .map(
            (product) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: suggestionCard(product),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget suggestionCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              product: product,
              allProducts: widget.allProducts,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                product['image'] ?? '',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(7),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    product['name'] ?? '',

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    product['desc'] ?? '',

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product['price'] ?? '',

                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Row(
                    children: [
                      ...buildRatingStars(
                        (widget.product['rating'] as num?)?.toDouble() ?? 0.0,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        ((widget.product['rating'] as num?)?.toDouble() ?? 0.0)
                            .toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  Widget sizeButton(String size) {
    final bool isSelected = selectedSize == size;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },

      child: Container(
        width: 55,

        height: 45,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: isSelected ? Colors.pink : Colors.white,

          borderRadius: BorderRadius.circular(8),

          border: Border.all(color: Colors.pink),
        ),

        child: Text(
          size,

          style: GoogleFonts.poppins(
            fontSize: 15,

            fontWeight: FontWeight.w600,

            color: isSelected ? Colors.white : Colors.pink,
          ),
        ),
      ),
    );
  }
  Widget buildSizeOptions() {
    final String category =
    (widget.product['category'] ?? '').toString().toLowerCase();

    List<String> sizes;

    if (category.contains('shoe') ||
        category.contains('sneaker') ||
        category.contains('footwear')) {
      sizes = ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'];
    } else if (category.contains('dress') ||
        category.contains('shirt') ||
        category.contains('top')) {
      sizes = ['S', 'M', 'L', 'XL', 'XXL'];
    } else if (category.contains('watch')) {
      sizes = ['Standard'];
    } else {
      sizes = ['S', 'M', 'L', 'XL'];
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: sizes.map((size) => sizeButton(size)).toList(),
    );
  }

  Widget actionBox({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),

      decoration: BoxDecoration(
        color: Colors.grey[200],

        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        children: [
          Icon(icon, size: 22),

          const SizedBox(width: 6),

          Flexible(
            child: Text(
              text,

              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

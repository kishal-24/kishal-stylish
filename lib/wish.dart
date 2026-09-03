import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:untitled/custom_appbar.dart';
import 'package:untitled/product_detailspage.dart';
import 'favorite_data.dart';

class wish extends StatefulWidget {
  final bool showDiscount;
  final bool showPrice;
  final bool showDescription;
  final bool showOldPrice;
  final bool showRating;

  const wish({
    super.key,
    this.showDiscount = true,
    this.showPrice = true,
    this.showDescription = true,
    this.showOldPrice = true,
    this.showRating = true,
  });

  @override
  State<wish> createState() => _WishState();
}

class _WishState extends State<wish> {

  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Black Winter...',
      'image': 'assets/black.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹499',
      'oldPrice': '₹999',
      'discount': '40%off',
    },
    {
      'name': 'HRX by Hrithik Roshan',
      'image': 'assets/shirt.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹799',
      'oldPrice': '₹1,499',
      'discount': '40%off',
    },
    {
      'name': 'HRX Sports T-Shirt',
      'image': 'assets/lady.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹699',
      'oldPrice': '₹1,199',
      'discount': '40%off',
    },
    {
      'name': 'Stylish Casual Wear',
      'image': 'assets/pink.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹899',
      'oldPrice': '₹1,499',
      'discount': '40%off',
    },
    {
      'name': 'Premium Fashion',
      'image': 'assets/flare.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹999',
      'oldPrice': '₹1,599',
      'discount': '40%off',
    },
    {
      'name': 'Daily Wear',
      'image': 'assets/denim.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹599',
      'oldPrice': '₹999',
      'discount': '40%off',
    },
    {
      'name': 'classic shoe',
      'image': 'assets/product2.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹799',
      'oldPrice': '₹1,299',
      'discount': '40%off',
    },
    {
      'name': 'Classic Collection',
      'image': 'assets/kurti.jpg',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹749',
      'oldPrice': '₹1,299',
      'discount': '40%off',
    },
    {
      'name': 'Fashion shoe',
      'image': 'assets/product2.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹749',
      'oldPrice': '₹1,299',
      'discount': '40%off',
    },
    {
      'name': 'Casual Collection',
      'image': 'assets/denim.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹749',
      'oldPrice': '₹1,299',
      'discount': '40%off',
    },
    {
      'name': 'Trendy Wear',
      'image': 'assets/lady.png',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹849',
      'oldPrice': '₹1,399',
      'discount': '40%off',
    },
    {
      'name': 'Summer Collection',
      'image': 'assets/kurti.jpg',
      'desc': 'Autumn And Winter Casual cotton-padded jacket...',
      'price': '₹699',
      'oldPrice': '₹1,199',
      'discount': '40%off',
    },
  ];


  List<Map<String, dynamic>> products = [];

  List<Map<String, dynamic>> filteredProducts = [];

  List<Map<String, dynamic>> suggestions = [];


  final TextEditingController searchController =
  TextEditingController();

  String searchText = '';
  @override
  void initState() {
    super.initState();
    products = List<Map<String, dynamic>>.from(
      _allProducts,
    );

    filteredProducts = List<Map<String, dynamic>>.from(
      _allProducts,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchProduct(String keyword) {
    final search = keyword.toLowerCase().trim();

    setState(() {
      if (search.isEmpty) {
        filteredProducts =
        List<Map<String, dynamic>>.from(products);
      } else {
        filteredProducts = products.where((product) {
          final String name =
          product['name'].toString().toLowerCase();

          return name.contains(search);
        }).toList();
      }

      suggestions = [];
    });
  }

  void _toggleFavorite(
      Map<String, dynamic> product) {
    FavoriteData.toggleFavorite(product);
  }


  double getPrice(
      Map<String, dynamic> product) {
    String price =
        product['price']?.toString() ?? '0';

    price = price
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(price) ?? 0;
  }


  void filterProducts(
      double minPrice,
      double maxPrice) {
    setState(() {
      products = _allProducts.where((product) {
        final double price = getPrice(product);

        return price >= minPrice &&
            price <= maxPrice;
      }).toList();
      filteredProducts =
      List<Map<String, dynamic>>.from(products);
    });
  }

  void showAllProducts() {
    setState(() {
      products =
      List<Map<String, dynamic>>.from(
        _allProducts,
      );

      filteredProducts =
      List<Map<String, dynamic>>.from(
        _allProducts,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFFDFDFD),

      appBar: const CustomAppBar(),

      body: SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
        ),

        child: Column(
          children: [

            const SizedBox(height: 10),



            TextField(
              controller: searchController,

              onChanged: (value) {
                setState(() {
                  searchText = value;

                  final String search =
                  value.toLowerCase().trim();

                  if (search.isEmpty) {
                    suggestions = [];
                  } else {
                    suggestions =
                        products.where((product) {
                          final String name =
                          product['name']
                              .toString()
                              .toLowerCase();

                          return name.contains(search);
                        }).toList();
                  }
                });
              },

              onSubmitted: (value) {
                searchProduct(value);
              },

              decoration: InputDecoration(
                hintText: 'Search products',

                prefixIcon:
                const Icon(Icons.search),

                suffixIcon: IconButton(
                  icon:
                  const Icon(Icons.close),

                  onPressed: () {
                    searchController.clear();

                    setState(() {
                      searchText = '';

                      suggestions = [];

                      filteredProducts =
                      List<Map<String, dynamic>>.from(
                        products,
                      );
                    });
                  },
                ),

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),

            if (suggestions.isNotEmpty &&
                searchText.isNotEmpty)
              Container(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                decoration:
                BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(10),

                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                    ),
                  ],
                ),

                child: ListView.builder(
                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  suggestions.length,

                  itemBuilder:
                      (context, index) {

                    final Map<String, dynamic>
                    product =
                    suggestions[index];

                    return ListTile(
                      title: Text(
                        product['name']
                            .toString(),
                      ),

                      onTap: () {
                        final String
                        productName =
                        product['name']
                            .toString();

                        searchController.text =
                            productName;

                        searchProduct(
                            productName);

                        setState(() {
                          searchText =
                              productName;

                          suggestions = [];
                        });
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),



            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  '52,082+ Items',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                Row(
                  children: [


                    GestureDetector(
                      onTap: () {

                        showModalBottomSheet(
                          context: context,

                          backgroundColor:
                          Colors.white,

                          shape:
                          const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(
                              top:
                              Radius.circular(20),
                            ),
                          ),

                          builder:
                              (context) {

                            return Padding(
                              padding:
                              const EdgeInsets.all(
                                20,
                              ),

                              child: Column(
                                mainAxisSize:
                                MainAxisSize.min,

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(
                                    'Sort By',

                                    style:
                                    GoogleFonts
                                        .poppins(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 15),


                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons
                                          .arrow_upward,
                                    ),

                                    title:
                                    const Text(
                                      'Price: Low to High',
                                    ),

                                    onTap: () {
                                      setState(() {
                                        products.sort(
                                              (a, b) =>
                                              getPrice(
                                                a,
                                              ).compareTo(
                                                getPrice(
                                                  b,
                                                ),
                                              ),
                                        );

                                        filteredProducts =
                                        List<
                                            Map<String,
                                                dynamic>>.from(
                                          products,
                                        );
                                      });

                                      Navigator.pop(
                                          context);
                                    },
                                  ),


                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons
                                          .arrow_downward,
                                    ),

                                    title:
                                    const Text(
                                      'Price: High to Low',
                                    ),

                                    onTap: () {
                                      setState(() {
                                        products.sort(
                                              (a, b) =>
                                              getPrice(
                                                b,
                                              ).compareTo(
                                                getPrice(
                                                  a,
                                                ),
                                              ),
                                        );

                                        filteredProducts =
                                        List<
                                            Map<String,
                                                dynamic>>.from(
                                          products,
                                        );
                                      });

                                      Navigator.pop(
                                          context);
                                    },
                                  ),


                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons
                                          .sort_by_alpha,
                                    ),

                                    title:
                                    const Text(
                                      'Name: A to Z',
                                    ),

                                    onTap: () {
                                      setState(() {
                                        products.sort(
                                              (a, b) =>
                                              a['name']
                                                  .toString()
                                                  .compareTo(
                                                b['name']
                                                    .toString(),
                                              ),
                                        );

                                        filteredProducts =
                                        List<
                                            Map<String,
                                                dynamic>>.from(
                                          products,
                                        );
                                      });

                                      Navigator.pop(
                                          context);
                                    },
                                  ),


                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons
                                          .sort_by_alpha,
                                    ),

                                    title:
                                    const Text(
                                      'Name: Z to A',
                                    ),

                                    onTap: () {
                                      setState(() {
                                        products.sort(
                                              (a, b) =>
                                              b['name']
                                                  .toString()
                                                  .compareTo(
                                                a['name']
                                                    .toString(),
                                              ),
                                        );

                                        filteredProducts =
                                        List<
                                            Map<String,
                                                dynamic>>.from(
                                          products,
                                        );
                                      });

                                      Navigator.pop(
                                          context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },

                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),

                          boxShadow: const [
                            BoxShadow(
                              color:
                              Color(0x14000000),
                              blurRadius: 10,
                              offset:
                              Offset(0, 4),
                            ),
                          ],
                        ),

                        child: const Row(
                          children: [

                            Text(
                              'sort',

                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            SizedBox(width: 5),

                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: () {

                        showModalBottomSheet(
                          context: context,

                          backgroundColor:
                          Colors.white,

                          shape:
                          const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(
                              top:
                              Radius.circular(15),
                            ),
                          ),

                          builder:
                              (context) {

                            return Padding(
                              padding:
                              const EdgeInsets.all(
                                20,
                              ),

                              child: Column(
                                mainAxisSize:
                                MainAxisSize.min,

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(
                                    'Filter',

                                    style:
                                    GoogleFonts
                                        .poppins(
                                      fontSize: 25,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 15),
                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons
                                          .currency_rupee,
                                    ),

                                    title:
                                    const Text(
                                      '₹200 to ₹300',
                                    ),

                                    onTap: () {
                                      filterProducts(
                                        200,
                                        300,
                                      );

                                      Navigator.pop(
                                          context);
                                    },
                                  ),
                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons
                                          .currency_rupee,
                                    ),

                                    title:
                                    const Text(
                                      '₹300 to ₹1,000',
                                    ),

                                    onTap: () {
                                      filterProducts(
                                        300,
                                        1000,
                                      );

                                      Navigator.pop(
                                          context);
                                    },
                                  ),

                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons
                                          .currency_rupee,
                                    ),

                                    title:
                                    const Text(
                                      '₹1,000 to ₹10,000',
                                    ),

                                    onTap: () {
                                      filterProducts(
                                        1000,
                                        10000,
                                      );

                                      Navigator.pop(
                                          context);
                                    },
                                  ),

                                  const Divider(),


                                  ListTile(
                                    leading:
                                    const Icon(
                                      Icons.refresh,
                                      color:
                                      Colors.red,
                                    ),

                                    title:
                                    const Text(
                                      'Clear All / Show All',

                                      style:
                                      TextStyle(
                                        color:
                                        Colors.red,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                      ),
                                    ),

                                    onTap: () {
                                      showAllProducts();

                                      Navigator.pop(
                                          context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },

                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),

                          boxShadow: const [
                            BoxShadow(
                              color:
                              Color(0x14000000),
                              blurRadius: 10,
                              offset:
                              Offset(0, 4),
                            ),
                          ],
                        ),

                        child: const Row(
                          children: [

                            Text(
                              'Filter',

                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            SizedBox(width: 5),

                            Icon(
                              Icons
                                  .filter_alt_outlined,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),


            MasonryGridView.count(
              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              crossAxisCount: 2,

              mainAxisSpacing: 10,

              crossAxisSpacing: 10,

              itemCount:
              filteredProducts.length,

              itemBuilder:
                  (context, index) {

                final Map<String, dynamic>
                product =
                filteredProducts[index];

                return productCard(
                  product,
                  index,
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget productCard(
      Map<String, dynamic> product,
      int index,
      ) {

    return ValueListenableBuilder<
        List<Map<String, dynamic>>>(
      valueListenable:
      FavoriteData.favorites,

      builder:
          (context, favorites, child) {

        final bool isEven =
            index.isEven;

        final bool isFavorite =
        favorites.contains(product);

        return GestureDetector(
          onTap: () {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsPage(
                      product: product,

                      allProducts:
                      _allProducts,
                    ),
              ),
            );
          },

          child: Container(
            decoration:
            BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(8),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(
                    alpha: 0.08,
                  ),

                  blurRadius: 5,

                  offset:
                  const Offset(0, 2),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [



                Stack(
                  children: [

                    ClipRRect(
                      borderRadius:
                      const BorderRadius.only(
                        topLeft:
                        Radius.circular(8),
                        topRight:
                        Radius.circular(8),
                      ),

                      child: Image.asset(
                        product['image']
                            ?.toString() ??
                            '',

                        width:
                        double.infinity,

                        height:
                        isEven ? 350 : 200,

                        fit:
                        BoxFit.cover,
                      ),
                    ),



                    Positioned(
                      top: 10,
                      right: 10,

                      child:
                      GestureDetector(
                        onTap: () {
                          _toggleFavorite(
                              product);
                        },

                        child: Container(
                          width: 42,
                          height: 42,

                          decoration:
                          BoxDecoration(
                            color:
                            Colors.white,

                            shape:
                            BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withValues(
                                  alpha: 0.15,
                                ),

                                blurRadius: 5,
                              ),
                            ],
                          ),

                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons
                                .favorite_border,

                            color:
                            isFavorite
                                ? Colors.pink
                                : Colors.black,

                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


                Padding(
                  padding:
                  const EdgeInsets.all(7),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Text(
                        product['name']
                            ?.toString() ??
                            '',

                        maxLines: 1,

                        overflow:
                        TextOverflow
                            .ellipsis,

                        style:
                        GoogleFonts.poppins(
                          fontSize: 18,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          if (widget
                              .showDiscount)
                            Text(
                              product[
                              'discount']
                                  ?.toString() ??
                                  '',

                              style: GoogleFonts
                                  .poppins(
                                fontSize: 14,

                                fontWeight:
                                FontWeight
                                    .bold,

                                color:
                                Colors.pink,
                              ),
                            ),

                          if (widget
                              .showPrice)
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                left: 10,
                              ),

                              child: Text(
                                product[
                                'price']
                                    ?.toString() ??
                                    '',

                                style:
                                GoogleFonts
                                    .poppins(
                                  fontSize: 14,

                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),

                          if (widget
                              .showOldPrice)
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                left: 10,
                              ),

                              child: Text(
                                product[
                                'oldPrice']
                                    ?.toString() ??
                                    '',

                                style:
                                GoogleFonts
                                    .poppins(
                                  fontSize: 13,

                                  decoration:
                                  TextDecoration
                                      .lineThrough,

                                  color:
                                  Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),


                      if (widget.showRating)
                        Row(
                          children: [

                            const Icon(
                              Icons.star,
                              color:
                              Colors.amber,
                              size: 22,
                            ),

                            const Icon(
                              Icons.star,
                              color:
                              Colors.amber,
                              size: 22,
                            ),

                            const Icon(
                              Icons.star,
                              color:
                              Colors.amber,
                              size: 22,
                            ),

                            const Icon(
                              Icons.star,
                              color:
                              Colors.amber,
                              size: 22,
                            ),

                            const Icon(
                              Icons.star,
                              color:
                              Colors.grey,
                              size: 22,
                            ),

                            const SizedBox(
                                width: 8),

                            Text(
                              '4.0',

                              style: GoogleFonts
                                  .poppins(
                                fontSize: 16,

                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ],
                        ),


                      if (widget
                          .showDescription)
                        Padding(
                          padding:
                          const EdgeInsets
                              .only(
                            top: 5,
                          ),

                          child: Text(
                            product['desc']
                                ?.toString() ??
                                '',

                            maxLines: 2,

                            overflow:
                            TextOverflow
                                .ellipsis,

                            style: GoogleFonts
                                .poppins(
                              fontSize: 12,

                              color:
                              Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
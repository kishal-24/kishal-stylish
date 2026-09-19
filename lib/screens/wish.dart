import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';

import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

import '../widget/custom_appbar.dart';
import '../widget/loading_skeleton.dart';
import '../widget/product_detailspage.dart';

class Wish extends StatefulWidget {
  final bool showDiscount;
  final bool showPrice;
  final bool showDescription;
  final bool showOldPrice;
  final bool showRating;

  const Wish({
    super.key,
    this.showDiscount = true,
    this.showPrice = true,
    this.showDescription = true,
    this.showOldPrice = true,
    this.showRating = true,
  });

  @override
  State<Wish> createState() => _WishState();
}

class _WishState extends State<Wish> {
  final TextEditingController searchController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  String searchText = '';

  List<Map<String, dynamic>> suggestions = [];

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

    // Fetch products
    context.read<ProductBloc>().add(
      const FetchProducts(),
    );
  }


  void _scrollListener() {
    if (!scrollController.hasClients) {
      return;
    }

    final position = scrollController.position;

    if (position.pixels >=
        position.maxScrollExtent - 300) {
      final productBloc = context.read<ProductBloc>();

      final currentState = productBloc.state;

      if (currentState is ProductLoaded) {
        if (currentState.hasMore &&
            !currentState.isLoadingMore) {
          productBloc.add(
            const LoadMoreProducts(),
          );
        }
      }
    }
  }


  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;

      final search = value.toLowerCase().trim();

      if (search.isEmpty) {
        suggestions = [];
        return;
      }

      final currentState =
          context.read<ProductBloc>().state;

      if (currentState is ProductLoaded) {
        suggestions = currentState.allProducts
            .where((product) {
          final name =
              product['name']
                  ?.toString()
                  .toLowerCase() ??
                  '';

          return name.contains(search);
        }).toList();
      }
    });

    // BLoC handles actual search
    context.read<ProductBloc>().add(
      SearchProducts(value),
    );
  }


  void _clearSearch() {
    searchController.clear();

    setState(() {
      searchText = '';
      suggestions = [];
    });

    context.read<ProductBloc>().add(
      const SearchProducts(''),
    );
  }


  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();

    super.dispose();
  }


  Widget bottomLoadingSkeleton(ProductState state) {
    if (state is! ProductLoaded) {
      return const SizedBox.shrink();
    }

    if (!state.isLoadingMore) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Skeletonizer(
        enabled: true,
        child: MasonryGridView.count(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: 4,
          itemBuilder: (context, index) {
            return const ProductLoadingSkeleton();
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFFDFDFD),

      appBar: const CustomAppBar(),

      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {

          }
        },

        builder: (context, state) {

          if (state is ProductInitial ||
              state is ProductLoading) {
            return const WishlistSkeleton();
          }



          if (state is ProductError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Failed to load products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      state.message,
                      textAlign:
                      TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProductBloc>()
                            .add(
                          const FetchProducts(),
                        );
                      },
                      child:
                      const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }


          if (state is! ProductLoaded) {
            return const SizedBox.shrink();
          }



          final products = state.products;




          return SingleChildScrollView(
            controller: scrollController,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),


                TextField(
                  controller: searchController,

                  onChanged: _onSearchChanged,

                  onSubmitted: (value) {
                    context
                        .read<ProductBloc>()
                        .add(
                      SearchProducts(value),
                    );

                    setState(() {
                      searchText = value;
                      suggestions = [];
                    });
                  },

                  decoration:
                  InputDecoration(
                    hintText:
                    'Search products',

                    prefixIcon:
                    const Icon(
                      Icons.search,
                    ),

                    suffixIcon:
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                      ),
                      onPressed:
                      _clearSearch,
                    ),

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),


                if (searchText.isNotEmpty)
                  Container(
                    margin:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 10,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                      child: suggestions.isEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(Icons.search_off),
                            const SizedBox(width: 10),
                            Text('No products found'),
                          ],
                        ),
                      )
                          : ListView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount:
                      suggestions.length,
                      itemBuilder: (context, index) {
                        final product =
                        suggestions[index];

                        final name =
                            product['name']
                                ?.toString() ??
                                '';

                        return ListTile(
                          title:
                          Text(name),

                          onTap: () {
                            searchController
                                .text = name;

                            context
                                .read<
                                ProductBloc>()
                                .add(
                              SearchProducts(
                                name,
                              ),
                            );

                            setState(() {
                              searchText =
                                  name;
                              suggestions =
                              [];
                            });
                          },
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 20),



                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Text(
                      '${products.length} Items',
                      style:
                      const TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),

                    Row(
                      children: [
                        // SORT
                        GestureDetector(
                          onTap:
                          showSortBottomSheet,

                          child:
                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                15,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(
                                    0x14000000,
                                  ),
                                  blurRadius:
                                  10,
                                  offset:
                                  Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                            ),
                            child:
                            const Row(
                              children: [
                                Text(
                                  'Sort',
                                  style:
                                  TextStyle(
                                    fontSize:
                                    15,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons
                                      .arrow_forward,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // FILTER
                        GestureDetector(
                          onTap:
                          showFilterBottomSheet,

                          child:
                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                15,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(
                                    0x14000000,
                                  ),
                                  blurRadius:
                                  10,
                                  offset:
                                  Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                            ),
                            child:
                            const Row(
                              children: [
                                Text(
                                  'Filter',
                                  style:
                                  TextStyle(
                                    fontSize:
                                    15,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
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
                  products.length,

                  itemBuilder:
                      (context, index) {
                    final product =
                    products[index];

                    return productCard(
                      product,
                      index,
                      products,
                    );
                  },
                ),


                bottomLoadingSkeleton(
                  state,
                ),

                // =================================================
                // NO MORE
                // =================================================

                if (!state.hasMore)
                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 20,
                      bottom: 30,
                    ),
                    child: Text(
                      'No more products',
                      style:
                      GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }



  void showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
          const EdgeInsets.all(20),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style:
                GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // LOW → HIGH
              ListTile(
                leading: const Icon(
                  Icons.arrow_upward,
                ),
                title: const Text(
                  'Price: Low to High',
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const SortProducts(
                      sortBy: 'price',
                      order: 'asc',
                    ),
                  );

                  Navigator.pop(context);
                },
              ),

              // HIGH → LOW
              ListTile(
                leading: const Icon(
                  Icons.arrow_downward,
                ),
                title: const Text(
                  'Price: High to Low',
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const SortProducts(
                      sortBy: 'price',
                      order: 'desc',
                    ),
                  );

                  Navigator.pop(context);
                },
              ),

              // A → Z
              ListTile(
                leading: const Icon(
                  Icons.sort_by_alpha,
                ),
                title: const Text(
                  'Name: A to Z',
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const SortProducts(
                      sortBy: 'name',
                      order: 'asc',
                    ),
                  );

                  Navigator.pop(context);
                },
              ),

              // Z → A
              ListTile(
                leading: const Icon(
                  Icons.sort_by_alpha,
                ),
                title: const Text(
                  'Name: Z to A',
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const SortProducts(
                      sortBy: 'name',
                      order: 'desc',
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
          const EdgeInsets.all(20),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Filter',
                style:
                GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ₹200 - ₹300
              ListTile(
                leading: const Icon(
                  Icons.currency_rupee,
                ),
                title: const Text(
                  '₹200 to ₹300',
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const FilterProducts(
                      minPrice: 200,
                      maxPrice: 300,
                    ),
                  );

                  Navigator.pop(context);
                },
              ),

              // ₹300 - ₹1000
              ListTile(
                leading: const Icon(
                  Icons.currency_rupee,
                ),
                title: const Text(
                  '₹300 to ₹1,000',
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const FilterProducts(
                      minPrice: 300,
                      maxPrice: 1000,
                    ),
                  );

                  Navigator.pop(context);
                },
              ),

              // ₹1000 - ₹10000
              ListTile(
                leading: const Icon(
                  Icons.currency_rupee,
                ),
                title: const Text(
                  '₹1,000 to ₹10,000',
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const FilterProducts(
                      minPrice: 1000,
                      maxPrice: 10000,
                    ),
                  );

                  Navigator.pop(context);
                },
              ),

              const Divider(),

              // CLEAR
              ListTile(
                leading: const Icon(
                  Icons.refresh,
                  color: Colors.red,
                ),
                title: const Text(
                  'Clear All / Show All',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(
                    const SearchProducts(''),
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Widget productCard(
      Map<String, dynamic> product,
      int index,
      List<Map<String, dynamic>> allProducts,
      ) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        bool isFavorite = false;

        if (state is FavoriteLoaded) {
          isFavorite =
              state.favorites.any(
                    (item) =>
                item['id'] == product['id'],
              );
        }

        final bool isEven = index.isEven;

        final String image =
            product['image']?.toString() ??
                '';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsPage(
                      product: product,
                      allProducts:
                      allProducts,
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
                      const BorderRadius
                          .only(
                        topLeft:
                        Radius.circular(8),
                        topRight:
                        Radius.circular(8),
                      ),
                      child:
                      _buildProductImage(
                        image,
                        isEven
                            ? 350
                            : 200,
                      ),
                    ),

                    // FAVORITE
                    Positioned(
                      top: 10,
                      right: 10,
                      child:
                      GestureDetector(
                        onTap: () {
                          context
                              .read<
                              FavoriteBloc>()
                              .add(
                            ToggleFavorite(
                              product,
                            ),
                          );
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
                            color: isFavorite
                                ? Colors.pink
                                : Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // =================================================
                // DETAILS
                // =================================================

                Padding(
                  padding:
                  const EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      // NAME
                      Text(
                        product['name']
                            ?.toString() ??
                            '',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      // PRICE
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          if (widget.showDiscount)
                            Flexible(
                              child: Text(
                                product[
                                'discount']
                                    ?.toString() ??
                                    '',
                                overflow:
                                TextOverflow
                                    .ellipsis,
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
                            ),

                          if (widget.showPrice)
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                left: 10,
                              ),
                              child: Text(
                                product['price']
                                    ?.toString() ??
                                    '',
                                style: GoogleFonts
                                    .poppins(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),

                          if (widget.showOldPrice)
                            Flexible(
                              child: Padding(
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
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style: GoogleFonts
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
                            ),
                        ],
                      ),

                      // RATING
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
                              width: 8,
                            ),

                            Text(
                              product[
                              'rating']
                                  ?.toString() ??
                                  '4.0',
                              style:
                              GoogleFonts
                                  .poppins(
                                fontSize: 16,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ],
                        ),

                      // DESCRIPTION
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
                            style:
                            GoogleFonts
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

  // ==========================================================
  // PRODUCT IMAGE
  // ==========================================================

  Widget _buildProductImage(
      String image,
      double height,
      ) {
    if (image.isEmpty) {
      return Container(
        width: double.infinity,
        height: height,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.grey,
        ),
      );
    }

    if (image.startsWith('http://') ||
        image.startsWith('https://')) {
      return Image.network(
        image,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,

        loadingBuilder:
            (context, child, progress) {
          if (progress == null) {
            return child;
          }

          return SizedBox(
            width: double.infinity,
            height: height,
            child: const Center(
              child:
              CircularProgressIndicator(),
            ),
          );
        },

        errorBuilder:
            (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: height,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      );
    }

    return Image.asset(
      image,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: height,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
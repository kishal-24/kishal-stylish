import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/widget/product_detailspage.dart';
import 'package:untitled/screens/shop.dart';
import 'package:untitled/widget/custom_appbar.dart';
import 'package:untitled/screens/wish.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/provider/favorite_data.dart';


import '../api/api_service.dart';
import 'dash.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String selectedsort = '';
  String selectedfilter = '';
  List<Map<String, dynamic>> products = [];

  bool isLoading = true;
  String errorMessage = '';

  final ApiService apiService = ApiService();

  @override
  @override
  void initState() {
    super.initState();
    loadHomeProducts();
  }
  Widget buildProductImage(
      String image, {
        double height = 200,
      }) {
    if (image.startsWith('http://') ||
        image.startsWith('https://')) {
      return Image.network(
        image,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return Container(
            width: double.infinity,
            height: height,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image_not_supported,
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
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return Container(
          width: double.infinity,
          height: height,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
          ),
        );
      },
    );
  }
  Future<void> loadHomeProducts() async {
    try {
      final result = await ApiService.getProducts(

      );

      if (!mounted) return;

      setState(() {
        products = result.take(6).toList();

        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }
  final List<Map<String, dynamic>> small = [
    {
      'name': 'Pilots Watch',
      'image': 'assets/watch.png',
      'desc': 'WC Schaffhausen 2021 Pilots Watch SIHH 2019 44mm',
      'price': '₹499',
      'oldPrice': '₹999',
      'discount': '40%off',
    },
    {
      'name': 'White Sneakers',
      'image': 'assets/white.png',
      'desc': 'Labbin White Sneakers For Men and Female',
      'price': '₹799',
      'oldPrice': '₹1,499',
      'discount': '40%off',
    },
  ];
  double getPrice(Map<String, dynamic> product) {
    String price = product['price'] ?? '0';

    price = price.replaceAll('₹', '').replaceAll(',', '').trim();

    return double.tryParse(price) ?? 0;
  }

  void filterProducts(double min, double max) {
    setState(() {
      products = products.where((product) {
        double price = getPrice(product);
        return price >= min && price <= max;
      }).toList();
    });
  }

  void showAllProducts() {
    setState(() {
      products = List.from(products);
    });
  }

  void showFilterBottomSheet() {
    String tempSelectedFilter = selectedfilter;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: const Text('₹200 - ₹300'),
                    trailing: tempSelectedFilter == '200-300'
                        ? const Icon(Icons.check, color: Color(0xffF83758))
                        : null,
                    onTap: () {
                      setModalState(() => tempSelectedFilter = '200-300');
                      setState(() => selectedfilter = '200-300');
                      filterProducts(200, 300);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('₹300 - ₹1,000'),
                    trailing: tempSelectedFilter == '300-1000'
                        ? const Icon(Icons.check, color: Color(0xffF83758))
                        : null,
                    onTap: () {
                      setModalState(() => tempSelectedFilter = '300-1000');
                      setState(() => selectedfilter = '300-1000');
                      filterProducts(300, 1000);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('₹1,000 - ₹10,000'),
                    trailing: tempSelectedFilter == '1000-10000'
                        ? const Icon(Icons.check, color: Color(0xffF83758))
                        : null,
                    onTap: () {
                      setModalState(() => tempSelectedFilter = '1000-10000');
                      setState(() => selectedfilter = '1000-10000');
                      filterProducts(1000, 10000);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Clear All'),
                    onTap: () {
                      setModalState(() => tempSelectedFilter = '');
                      setState(() => selectedfilter = '');
                      showAllProducts();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        SystemNavigator.pop();
      },
      child: Scaffold(
        drawer: const dash(),
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Featured',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  height: 125,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      categoryItem(image: 'assets/beauty.jpg', title: 'Beauty'),

                      categoryItem(image: 'assets/girl.jpg', title: 'Fashion'),

                      categoryItem(image: 'assets/dress.jpg', title: 'Kids'),

                      categoryItem(image: 'assets/t.jpg', title: 'Mens'),

                      categoryItem(image: 'assets/ward.jpg', title: 'Women'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  height: 300,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/women.jpg'),
                      fit: BoxFit.cover,
                    ),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 30),

                      const Text(
                        '50% to 40% off',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'now in products\nAll colors',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const wish(showOldPrice: false),
                            ),
                          );
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),

                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: const Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Text(
                                'Shop Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),

                              SizedBox(width: 5),

                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      width: 10,
                      height: 10,

                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      width: 10,
                      height: 10,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.pink,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      width: 10,
                      height: 10,

                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 130,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Deal of the Day',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Row(
                            children: [
                              Icon(Icons.alarm, color: Colors.white, size: 16),

                              SizedBox(width: 5),

                              Text(
                                '22h 52m 20s remaining',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const wish(showDiscount: false),
                            ),
                          );
                        },

                        child: Container(
                          height: 40,

                          padding: const EdgeInsets.symmetric(horizontal: 10),

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),

                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: const Row(
                            children: [
                              Text(
                                'View all',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),

                              SizedBox(width: 5),

                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 400,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: products.length,

                    itemBuilder: (context, index) {
                      return productCard(products[index]);
                    },
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  height: 150,

                  child: Row(
                    children: [
                      Image.asset('assets/spl.png'),

                      const SizedBox(width: 30),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: const [
                            Text(
                              'Special Offers',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              'We make sure you get the offer you need at best prices',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 180,

                  child: Row(
                    children: [
                      Image.asset('assets/yellow.png', width: 70),

                      Image.asset('assets/heels.png', width: 70),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              'Flat and heels',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Text('Stand a chance to get rewarded'),

                            const SizedBox(height: 10),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const shop(),
                                  ),
                                );
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 12,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.red,

                                  borderRadius: BorderRadius.circular(5),
                                ),

                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Text(
                                      'Visit Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                      ),
                                    ),

                                    SizedBox(width: 5),

                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 110,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Trending products',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.white,
                                size: 16,
                              ),

                              SizedBox(width: 5),

                              Text(
                                'End date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        height: 40,

                        padding: const EdgeInsets.symmetric(horizontal: 10),

                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),

                          borderRadius: BorderRadius.circular(5),
                        ),

                        child: const Row(
                          children: [
                            Text(
                              'View all',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),

                            SizedBox(width: 5),

                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 400,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: small.length,

                    itemBuilder: (context, index) {
                      return smallcard(small[index]);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(5),

                  width: double.infinity,
                  height: 400,

                  child: Column(
                    children: [
                      Image.asset(
                        'assets/hot.png',
                        height: 300,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                'New Arrivals',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              Text(
                                'summer 25 Collections',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {},

                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.pink,

                                borderRadius: BorderRadius.circular(5),
                              ),

                              child: const Row(
                                children: [
                                  Text(
                                    'View all',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),

                                  SizedBox(width: 5),

                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Sponsored',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 400,

                  child: Image.asset('assets/mask.png', fit: BoxFit.cover),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Up to 50% off',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryItem({required String image, required String title}) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            width: 65,
            height: 65,

            color: Colors.white,

            child: Image.asset(image, width: 65, height: 65, fit: BoxFit.cover),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget productCard(Map<String, dynamic> product) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: FavoriteData.favorites,

      builder: (context, favorites, child) {
        final bool isFavorite = FavoriteData.isFavorite(product);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                  product: product,
                  allProducts: products,
                ),
              ),
            );
          },

          child: Container(
            width: 250,
            height: 380,

            margin: const EdgeInsets.only(right: 15, top: 10),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),

                      child: buildProductImage(
                        product['image']?.toString() ?? '',
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,

                      child: GestureDetector(
                        onTap: () {
                          FavoriteData.toggleFavorite(product);
                        },

                        child: Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 5,
                              ),
                            ],
                          ),

                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,

                            color: isFavorite ? Colors.pink : Colors.black,

                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        product['name'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        product['desc'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Text(
                            product['price'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            product['oldPrice'] ?? '',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            product['discount'] ?? '',
                            style: const TextStyle(
                              color: Colors.pink,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),

                          Icon(Icons.star, color: Colors.amber, size: 18),

                          Icon(Icons.star, color: Colors.amber, size: 18),

                          Icon(Icons.star, color: Colors.amber, size: 18),

                          Icon(Icons.star, color: Colors.grey, size: 18),
                        ],
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

  Widget smallcard(Map<String, dynamic> product) {
    final bool isFavorite = FavoriteData.isFavorite(product);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsPage(product: product, allProducts: products),
          ),
        );
      },

      child: Container(
        width: 250,
        height: 380,

        margin: const EdgeInsets.only(right: 15, top: 10),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(10),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),

                  child: Image.asset(
                    product['image'] ?? '',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,

                  child: GestureDetector(
                    onTap: () {
                      FavoriteData.toggleFavorite(product);
                    },

                    child: Container(
                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 5,
                          ),
                        ],
                      ),

                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,

                        color: isFavorite ? Colors.pink : Colors.black,

                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.all(8),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    product['name'] ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product['desc'] ?? '',
                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(color: Colors.black, fontSize: 13),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        product['price'] ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        product['oldPrice'] ?? '',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        product['discount'] ?? '',
                        style: const TextStyle(
                          color: Colors.pink,
                          fontSize: 12,
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

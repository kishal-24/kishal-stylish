import 'package:flutter/material.dart';
import 'package:untitled/provider/favorite_data.dart';
import 'package:untitled/widget/product_detailspage.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: FavoriteData.favorites,

        builder: (context, favorites, child) {
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'No Favorites',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Your favorite products will appear here',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(15),

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),

            itemCount: favorites.length,

            itemBuilder: (context, index) {
              final product = favorites[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        product: product,
                        allProducts: favorites,
                      ),
                    ),
                  );
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
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
                            borderRadius:
                            const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),

                            child: Image.asset(
                              product['image'] ?? '',

                              width: double.infinity,
                              height: 180,

                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            top: 8,
                            right: 8,

                            child: GestureDetector(
                              onTap: () {
                                FavoriteData.toggleFavorite(
                                  product,
                                );
                              },

                              child: Container(
                                width: 40,
                                height: 40,

                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                  size: 23,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              product['name'] ?? '',

                              maxLines: 1,

                              overflow:
                              TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              product['desc'] ?? '',

                              maxLines: 2,

                              overflow:
                              TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Text(
                                  product['price'] ?? '',

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  product['oldPrice'] ?? '',

                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration:
                                    TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Text(
                              product['discount'] ?? '',

                              style: const TextStyle(
                                color: Colors.pink,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                  size: 17,
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
            },
          );
        },
      ),
    );
  }
}
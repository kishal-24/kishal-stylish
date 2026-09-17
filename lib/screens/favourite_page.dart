import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';


class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {

          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          if (state is FavoriteError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }

          if (state is FavoriteLoaded) {
            final favorites = state.favorites;

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
                      'No Favorites Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add products to your favorites',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 15,
                childAspectRatio: 0.68,
              ),

              itemCount: favorites.length,

              itemBuilder: (context, index) {
                final product = favorites[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // Image
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                              const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.network(
                                product['image']?.toString() ?? '',
                                width: double.infinity,
                                fit: BoxFit.cover,

                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),


                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<FavoriteBloc>()
                                      .add(
                                    RemoveFavorite(index),
                                  );
                                },
                                child: Container(
                                  padding:
                                  const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFF83758),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name']?.toString() ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              product['desc']?.toString() ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              product['price']?.toString() ?? '₹0',
                              style: const TextStyle(
                                color: Color(0xFFF83758),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }


          return const SizedBox();
        },
      ),
    );
  }
}
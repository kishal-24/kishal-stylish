import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Bone.circle(size: 100),
              const SizedBox(height: 30),
              const Bone(width: 180, height: 20),
              const SizedBox(height: 25),
              const Bone(width: 300, height: 55),
              const SizedBox(height: 15),
              const Bone(width: 300, height: 55),
              const SizedBox(height: 20),
              const Bone(width: 300, height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class WishlistSkeleton extends StatelessWidget {
  const WishlistSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 10,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, index) {
          return const ProductLoadingSkeleton();
        },
      ),
    );
  }
}

class ProductLoadingSkeleton extends StatelessWidget {
  const ProductLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 6,
            child: Bone(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Bone(width: 120, height: 16),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Bone(width: 45, height: 15),
                    SizedBox(width: 8),
                    Bone(width: 55, height: 15),
                  ],
                ),
                const SizedBox(height: 8),
                const Bone(width: 80, height: 16),
                const SizedBox(height: 8),
                const Bone(width: 140, height: 14),
                const SizedBox(height: 5),
                const Bone(width: 100, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

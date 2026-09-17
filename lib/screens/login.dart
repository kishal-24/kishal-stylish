import 'package:flutter/material.dart';
import 'package:stylish/screens/actual.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  PageController pageController = PageController();

  int currentPage = 1;
  int selectedDot = 0;

  final List<String> productImages = [
    "assets/fashion.png",
    "assets/sales.png",
    "assets/shop.png",
  ];

  final List<String> productheading = [
    "Get Fashion",
    "Get order",
    "Get sales"
  ];

  final List<String> productdesc = [
    "Nike Air Max Shoes\nComfortable running shoes for daily use",
    "Adidas Running Shoes\nPerfect shoes for sports and running",
    "Puma Casual Shoes\n"
        "Stylish shoes for everyday use\n"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text(
          "$currentPage / ${productImages.length}",
          style: const TextStyle(
            fontSize: 25,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const actual(),
                  ),
                );
              },
              child: const Text(
                'skip',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: PageView.builder(
        controller: pageController,
        itemCount: productImages.length,

        onPageChanged: (index) {
          setState(() {
            currentPage = index + 1;
            selectedDot = index;
          });
        },

        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 100),

                SizedBox(
                  height: 500,
                  child: Image.asset(
                    productImages[index],
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  productheading[index],
                  style: const TextStyle(
                    fontSize: 40,
                    height: 1.6,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  productdesc[index],
                  style: const TextStyle(
                    fontSize: 25,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical:20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: List.generate(
                  productImages.length,
                      (index) {
                    return AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),

                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,vertical:10
                      ),

                      width: selectedDot == index ? 30 : 8,
                      height: 8,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),

                        color: selectedDot == index
                            ? Colors.black
                            : Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: currentPage > 1
                        ? () {
                      pageController.previousPage(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
                    child: const Text(
                      'Prev',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (currentPage < productImages.length) {
                        pageController.nextPage(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const actual(),
                          ),
                        );
                      }
                    },

                    child: Text(
                      currentPage == productImages.length
                          ? "Get started"
                          : "Next",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
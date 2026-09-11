import 'package:flutter/material.dart';
import 'package:untitled/screens/cart_page.dart';
import 'package:untitled/screens/check.dart';
import 'package:untitled/screens/favourite_page.dart';
import 'package:untitled/screens/home.dart';

class bot extends StatefulWidget {
  const bot({super.key});

  @override
  State<bot> createState() => _BotState();
}

class _BotState extends State<bot> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const home(),
    const FavouritePage(),
    const CartPage(),
    const home(),
    const Check(),
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,

        onPopInvokedWithResult: (didPop, result) {
          if (selectedIndex != 0) {
            setState(() {
              selectedIndex = 0;
            });
          }
        },

      child: Scaffold(
        body: pages[selectedIndex],

        bottomNavigationBar: BottomNavigationBar(

          backgroundColor:
          const Color(0xFFF9F9F9),

          type:
          BottomNavigationBarType.fixed,

          currentIndex:
          selectedIndex,

          selectedIconTheme:
          const IconThemeData(
            size: 35,
          ),

          unselectedIconTheme:
          const IconThemeData(
            size: 35,
          ),

          showSelectedLabels: true,

          showUnselectedLabels: true,

          selectedItemColor:
          Colors.pink,

          unselectedItemColor:
          Colors.black,

          selectedLabelStyle:
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),

          unselectedLabelStyle:
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          onTap: (index) {

            setState(() {
              selectedIndex = index;
            });
          },
          items: [

            // HOME
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),

              activeIcon: Icon(
                Icons.home,
              ),

              label: 'Home',
            ),

            const BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
              ),

              activeIcon: Icon(
                Icons.favorite,
              ),

              label: 'Wishlist',
            ),

            BottomNavigationBarItem(

              icon: Transform.translate(
                offset:
                const Offset(0, -15),

                child: Container(

                  width: 90,
                  height: 90,

                  decoration:
                  const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),

              activeIcon:
              Transform.translate(
                offset:
                const Offset(0, -15),

                child: Container(

                  width: 90,
                  height: 90,

                  decoration:
                  const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

              label: '',
            ),

            const BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
              ),

              activeIcon: Icon(
                Icons.search,
              ),

              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outlined,
              ),

              activeIcon: Icon(
                Icons.person_outlined
              ),

              label: 'profile',
            ),
        ],
      ),
    ),
  );
  }
}
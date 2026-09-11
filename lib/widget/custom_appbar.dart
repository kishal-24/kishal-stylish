  import 'package:flutter/material.dart';
import 'package:untitled/provider/cart_data.dart';
import 'package:untitled/screens/cart_page.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/dash.png',
              ),
            ),
          );
        },
      ),
      centerTitle: true,

      title: Image.asset(
        'assets/logo.png',
        height: 45,
      ),
      actions:  [

        ValueListenableBuilder<int>(

          valueListenable:
          cart.cartCount,

          builder:
              (context, count, child) {

            return Stack(

              clipBehavior:
              Clip.none,

              children: [

                IconButton(

                  onPressed: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                        const CartPage(),
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

                      alignment:
                      Alignment.center,

                      decoration:
                      const BoxDecoration(
                        color: Colors.pink,
                        shape:
                        BoxShape.circle,
                      ),

                      child: Text(
                        '$count',

                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight:
                          FontWeight.bold,
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
    );
    
  }
}
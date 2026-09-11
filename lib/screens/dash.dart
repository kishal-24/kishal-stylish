import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'actual.dart';

class dash extends StatefulWidget {
  const dash({super.key});

  @override
  State<dash> createState() => _dashState();
}

class _dashState extends State<dash> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          const DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: selectedIndex == 0
                  ? Colors.pink
                  : Colors.black,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: selectedIndex == 0
                    ? Colors.pink
                    : Colors.black,
              ),
            ),
            tileColor: selectedIndex == 0
                ? Colors.pink.withValues(alpha: 0.1)
                : null,
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),

          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: selectedIndex == 1
                  ? Colors.pink
                  : Colors.black,
            ),
            title: Text(
              'Cart',
              style: TextStyle(
                color: selectedIndex == 1
                    ? Colors.pink
                    : Colors.black,
              ),
            ),
            tileColor: selectedIndex == 1
                ? Colors.pink.withValues(alpha: 0.1)
                : null,
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: selectedIndex == 2
                  ? Colors.pink
                  : Colors.black,
            ),
            title: Text(
              'Wishlist',
              style: TextStyle(
                color: selectedIndex == 2
                    ? Colors.pink
                    : Colors.black,
              ),
            ),
            tileColor: selectedIndex == 2
                ? Colors.pink.withValues(alpha: 0.1)
                : null,
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),onTap: () async {
            final prefs = await SharedPreferences.getInstance();


            await prefs.setBool('isLoggedIn', false);


            await prefs.remove('fullName');
            await prefs.remove('address');
            await prefs.remove('city');
            await prefs.remove('state');
            await prefs.remove('country');


            await prefs.remove('businessName');
            await prefs.remove('businessAddress');
            await prefs.remove('businessCity');
            await prefs.remove('businessState');
            await prefs.remove('businessCountry');

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => actual(),
              ),
                  (route) => false,
            );
          },
          ),
        ],
      ),
    );

  }
}
import 'package:flutter/material.dart';
import 'package:untitled/bot.dart';
class str extends StatefulWidget {
  const str({super.key});

  @override
  State<str> createState() => _strState();
}

class _strState extends State<str> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context,


            );
          }
        },
   child:Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/un.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 550),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(5),
                  child: const Text(
                    "you want",
                    style: TextStyle(fontSize: 60,
                    fontWeight:FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(5),
                  child: const Text(
                    "authentic here",
                    style: TextStyle(fontSize: 60,
                    fontWeight:FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(5),
                  child: const Text(
                    "you go!",
                    style: TextStyle(fontSize: 60,
                    fontWeight:FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                child: const Text(
                  "find it here buy it now",
                  style: TextStyle(fontSize: 30,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Column(
              children: [Padding(padding: EdgeInsets.all(60),
              child:GestureDetector(
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const bot()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "get started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              )],
              ),
            ],
          ),
        ),
      ),
   ),
      );
  }
}

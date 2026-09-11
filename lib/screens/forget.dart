import 'package:flutter/material.dart';
import 'package:untitled/screens/actual.dart';

class forget extends StatefulWidget {
  const forget({super.key});

  @override
  State<forget> createState() => _forgetState();
}

class _forgetState extends State<forget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
    children:[
    Padding(padding: const EdgeInsets.only( top: 100,
    left: 40,
    right: 180,
    ),
    child: const Text(
    "Forget pasword?",
    style: TextStyle(
    fontSize: 70,
    fontWeight: FontWeight.w800
      ,
    ),
    ),
    ),
    Center(
    child: Column(
    children: [
    const SizedBox(height: 50),
    SizedBox(
    width: 460,
    height: 80,
    child: TextField(
    decoration: InputDecoration(
    hintText: "Enter an email address",
    hintStyle:const TextStyle(
    fontSize:22
    ),
    prefixIcon: const Icon(Icons.email),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical:30
    ),

    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
            const Padding(
                padding: EdgeInsets.only(top: 40, right: 100, left: 50),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '*', style: TextStyle(color: Colors.pink)),
                      TextSpan(
                          text: ' We will send you a message to set or reset your new password',
                      style:TextStyle(
                        fontSize:18
                      )),
                    ],
                  ),
                )),
            const SizedBox(height:50,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 190, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
              ),
              child:GestureDetector(
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>const actual()));
                },
                child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
  }
}

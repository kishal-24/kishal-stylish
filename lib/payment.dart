
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/bot.dart';

class PaymentPage extends StatefulWidget {
final double totalAmount;

const PaymentPage({
super.key,
required this.totalAmount,
});

@override
State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
bool isLoading = false;

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xffFDFDFD),
appBar: AppBar(
backgroundColor: const Color(0xffFDFDFD),
elevation: 0,
centerTitle: true,

leading: IconButton(
icon: const Icon(
Icons.arrow_back_ios_new,
color: Colors.black,
size: 20,
),
onPressed: () {
Navigator.pop(context);
},
),

title: const Text(
'Checkout',
style: TextStyle(
color: Colors.black,
fontSize: 18,
fontWeight: FontWeight.w600,
),
),
),


body: SingleChildScrollView(
padding: const EdgeInsets.all(15),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

const SizedBox(height: 20),

const Text(
'Order Summary',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Order',
style: TextStyle(
fontSize: 14,
color: Colors.grey,
),
),

Text(
'₹ ${widget.totalAmount.toStringAsFixed(2)}',
style: const TextStyle(
fontSize: 14,
),
),
],
),

const SizedBox(height: 15),

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: const [
Text(
'Shipping',
style: TextStyle(
fontSize: 14,
color: Colors.grey,
),
),

Text(
'₹ 30',
style: TextStyle(
fontSize: 14,
),
),
],
),

const Divider(
height: 30,
),

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Total',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),

Text(
'₹ ${(widget.totalAmount + 30).toStringAsFixed(2)}',
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
],
),

const SizedBox(height: 30),
const Text(
'Payment Method',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),
TextField(
readOnly: false,
decoration: InputDecoration(
prefixIcon: Padding(
padding: const EdgeInsets.all(12),
child: Image.asset(
'assets/visa.png',
width: 54,
height: 54,
),
),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
),
),
),

const SizedBox(height: 15),
TextField(
readOnly: false,
decoration: InputDecoration(
prefixIcon: Padding(
padding: const EdgeInsets.all(12),
child: Image.asset(
'assets/paypal.png',
width: 54,
height: 54,
),
),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
),
),
),

const SizedBox(height: 15),

TextField(
readOnly: false,
decoration: InputDecoration(
prefixIcon: Padding(
padding: const EdgeInsets.all(12),
child: Image.asset(
'assets/maes.png',
width: 54,
height: 54,
),
),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
),
),
),

const SizedBox(height: 30),
Center(
child: SizedBox(
width: 250,
height: 55,

child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.pink,
disabledBackgroundColor: Colors.pink,

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),

onPressed: isLoading
? null
    : () async {
setState(() {
isLoading = true;
});
showDialog(
context: context,
barrierDismissible: false,
barrierColor: Colors.black54,

builder: (dialogContext) {
return Center(
child: Material(
color: Colors.transparent,

child: Container(
width: 400,
height: 180,

decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(20),
),

child: Padding(
padding:
const EdgeInsets.all(20),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                'assets/DONE.json',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                                repeat: false,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Payment completed successfully',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
),
),
),
);
},
);


await Future.delayed(
const Duration(seconds: 5),
);

if (!mounted) return;
Navigator.of(context).pop();


Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => const bot(),
),
);
},
child: isLoading
? const Text(
'Processing...',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
color: Colors.white,
),
)
    : const Text(
'Continue',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),
),
),
),

const SizedBox(height: 20),
],
),
),
);
}
}

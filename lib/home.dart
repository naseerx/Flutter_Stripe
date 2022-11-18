import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntentData;
  String money = 10.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('PAYMENT METHOD (STRIPE) '),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Center(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          minimumSize: const Size(250, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'STRIPE PAYMENT',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          makePayment();
        },
      )),
    );
  }

  payFee() {
    // here you can upload data to firebase or database

    // try {
    //   if (kDebugMode) {
    //     print('database');
    //   }
    //   // User? user = FirebaseAuth.instance.currentUser;
    //   FirebaseFirestore.instance.collection('register users').doc().set({
    //     'uid': user!.uid,
    //   });
    //   Navigator.pop(context);
    //   Fluttertoast.showToast(msg: 'Registration Done');
    // } catch (e) {
    //   Fluttertoast.showToast(msg: e.toString());
    // }
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData =
          await createPaymentIntent(money, 'USD'); //json.decode(response.body);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});
      displayPaymentSheet();
    } catch (e, s) {
      if (kDebugMode) {
        print(s);
      }
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        payFee();

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        }
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51L8PzGKEp9uhBKrrWhzpS6OoCZSlUfjEakjHRoLwBOrcSLeUDUZZw1QbX7BgWXjV6w9SMcDLAUlRzorynyrC1OrV00c4HIw4Ns',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}

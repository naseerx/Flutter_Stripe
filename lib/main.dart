import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'home.dart';

void main() {
  Stripe.publishableKey =
      'pk_test_51L8PzGKEp9uhBKrrUaQGs8uNSewO9Lm85zYGJSJZ2I5nlYSnBtGRBa7Abky4uTxR4LYx2TMjkwJ48HJ6CZKVwLFo003wdImXQs';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

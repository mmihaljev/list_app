import 'package:flutter/material.dart';
import 'package:shopping_list_app/Screens/home.dart';
import 'Database/sql_helper.dart';
import 'Screens/openingAnimation.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'ShoppingList',
        theme: ThemeData(
        ),
        home: const OpenAnimation());
  }
}
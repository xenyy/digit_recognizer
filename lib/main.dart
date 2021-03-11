import 'package:flutter/material.dart';
import 'package:flutter_tf_digit_recognizer/app/draw.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscribe for more it\'s free',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Rubik'
      ),
      home: Draw(),
    );
  }
}

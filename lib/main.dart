import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(ScrabbleApp());
}

class ScrabbleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrabble',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

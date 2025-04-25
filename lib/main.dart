import 'package:flutter/material.dart';
import 'views/home_screen.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controllers.dart';
import '../models/player.dart';

void main() {
  const langueParDefaut = 'Français'; 

  runApp(
    ChangeNotifierProvider(
      create: (context) => GameController.fromPlayers(
         [
          Player(name: "Joueur 1"),
          Player(name: "Joueur 2"),
        ],
        langueParDefaut,
      ),
      child: ScrabbleApp(),
    ),
  );
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

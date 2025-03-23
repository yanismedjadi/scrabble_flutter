import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/lettre.dart';
import '../controllers/game_controllers.dart';
import 'widgets/board.dart';
import '../controllers/placement_validator.dart';
class GameBoardScreen extends StatefulWidget {
  @override
  _GameBoardScreenState createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  static const int boardSize = 15;
  late GameController controller;
  List<List<Lettre?>> board = List.generate(boardSize, (_) => List.filled(boardSize, null));
  List<Offset> lettresPoseeCeTour = [];

  @override
  void initState() {
    super.initState();
    controller = GameController(Player(name: "Vous"));
  }

  @override
  Widget build(BuildContext context) {
    double gridSize = MediaQuery.of(context).size.width * 0.95;
    double tileSize = gridSize / boardSize;

    return Scaffold(
      appBar: AppBar(title: Text('Scrabble - ${controller.player.name}')),
      body: Column(
        children: [
          // Lettres du joueur
          Container(
            height: 80,
            padding: EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.player.letters.map((lettre) {
                return Draggable<Lettre>(
                  data: lettre,
                  feedback: Material(child: _lettreTile(lettre.lettre, Colors.blue)),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: _lettreTile(lettre.lettre, Colors.blue),
                  ),
                  child: _lettreTile(lettre.lettre, Colors.blue),
                );
              }).toList(),
            ),
          ),

          // Plateau de jeu via composant séparé
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                  aspectRatio: 1,
                child : PlateauWidget(
                  board: board,
                  tileSize: tileSize,
                  onLettrePlacee: (lettre, row, col) {
                    setState(() {
                      board[row][col] = lettre;
                      controller.jouerLettre(lettre);
                      lettresPoseeCeTour.add(Offset(row.toDouble(), col.toDouble()));
                    });
                  },
                ),
              ),
            ),
          ),
          // Bouton pour valider le mot
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (PlacementValidator.estPremierTour(board)) {
                  print("c'est le premier tour");
                }
                //bool estValide = PlacementValidator.validerPlacement(board, lettresPoseeCeTour);
                //if (estValide) {
                  //print("✅ Mot valide !");
                  // À compléter : calcul des points, recompléter lettres, etc.
                //} else {
                  //print("❌ Mot invalide : placement incorrect.");
                //}
              },
              child: Text("Envoyer le mot"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lettreTile(String lettre, Color couleur) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          lettre,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

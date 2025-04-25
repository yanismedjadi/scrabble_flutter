import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/lettre.dart';
import '../controllers/game_controllers.dart';
import 'widgets/board.dart';
import 'dart:ui' show Color, Offset;
import '../controllers/score_calculator.dart';
import 'end_screen.dart';

import 'widgets/joker.dart';

class GameBoardScreen extends StatefulWidget {
  final List<Player> players;
  final String langue;

const GameBoardScreen({
    super.key, 
    required this.players,
    required this.langue,
  });
  @override
  _GameBoardScreenState createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  static const int boardSize = 15;
  late GameController controller;
  List<List<Lettre?>> board = List.generate(boardSize, (_) => List.filled(boardSize, null));
  List<Offset> lettresPoseesCeTour = [];
  List<Offset> lettresDejaPosees = [];
  String? _errorMessage;
  

  @override
  void initState() {
  super.initState();
  controller = GameController.fromPlayers(widget.players,widget.langue);
  controller.addListener(_refreshUI);
  
}
void _refreshUI() {
    if (mounted) setState(() {}); // <-- Nouvelle méthode
  }
  @override
  void dispose() {
  controller.removeListener(_refreshUI); // Désabonnement
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    double gridSize = MediaQuery.of(context).size.width * 0.95;
    double tileSize = gridSize / boardSize;
    return Scaffold(
      appBar: AppBar(title: Text('${controller.joueurActuel.name}')),
      body: Column(
        children: [
          // Score panel en haut
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8.0),
            child: _scorePanel(),
          ),

          // Lettres du joueur
          Container(
            height: 80,
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.joueurActuel.letters.map((lettre) {
                return Draggable<Lettre>(
                  data: lettre,
                  feedback: Material(child: _lettreTile(lettre, const Color(0xFF8B5A2B))),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: _lettreTile(lettre, const Color(0xFF8B5A2B)),
                  ),
                  child: _lettreTile(lettre, const Color(0xFF8B5A2B)),
                );
              }).toList(),
            ),
          ),

          // Plateau de jeu (plein écran restant)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: PlateauWidget(
                  lettresPoseesCeTour: lettresPoseesCeTour,
                  board: board,
                  tileSize: tileSize,
                  onLettrePlacee: (lettre, row, col) {
                    if (lettre.estJoker()) {
                      // Demande à l'utilisateur de choisir une lettre pour le joker
                      demanderLettrePourJoker(context,widget.langue).then((choisie) {
                        if (choisie != null) {
                          setState(() {
                            lettre.remplace = choisie;// Met à jour la lettre avec celle choisie
                            board[row][col] = lettre;  // Met à jour le plateau
                            lettresPoseesCeTour.add(Offset(row.toDouble(), col.toDouble())); // Ajoute la position
                            controller.jouerLettre(lettre);
                          });
                        }
                      });
                    } else {
                      setState(() {
                        board[row][col] = lettre;  // Si ce n'est pas un joker, place la lettre normalement
                        lettresPoseesCeTour.add(Offset(row.toDouble(), col.toDouble()));  // Ajoute la position
                        controller.jouerLettre(lettre);
                      });
                    }
                  },
                  onLettreRetiree: (lettre, row, col) {
                    setState(() {
                      board[row][col] = null;
                      lettresPoseesCeTour.removeWhere((o) => o.dx.toInt() == row && o.dy.toInt() == col);
                    });
                  },
                ),
              ),
            ),
          ),

          // Bouton envoyer le mot
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (_errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(child: Text(_errorMessage!)),
                      ],
                    ),
                  ),
                ElevatedButton(
                    onPressed: () {
                      String errorMsg = controller.erreurMessage(
                        widget.langue,
                        board,
                        lettresDejaPosees,
                        lettresPoseesCeTour
                      );
                      print(lettresPoseesCeTour);
                      if (errorMsg.isEmpty) {
                        // Tout est valide
                        lettresDejaPosees.addAll(lettresPoseesCeTour);
                        controller.finDeTour(board, lettresDejaPosees, lettresPoseesCeTour);
                        if (controller.estPartieTerminee()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FinDePartieScreen(joueurs: controller.getJoueurs),
                            ),
                          );
                          return;
                        }
                        setState(() => _errorMessage = null);
                      } else {
                        // Afficher l'erreur et retirer les lettres
                        setState(() => _errorMessage = errorMsg);
                        controller.retirerLettresPosees(board, lettresPoseesCeTour);
                      }
                    },
                    child: Text("Envoyer le mot"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lettreTile(Lettre lettre, Color couleur) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              lettre.lettre,
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            right: 3,
            bottom: 1,
            child: Text(
              lettre.valeur > 0 ? lettre.valeur.toString() : "",
              style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scorePanel() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: controller.getJoueurs.map((joueur) {
      final bool estActif = joueur == controller.joueurActuel;
      
      return Row(
        children: [
          Icon(
            Icons.person,
            size: 16,
            color: estActif ? Colors.red : Colors.grey, 
          ),
          const SizedBox(width: 4),
          Text(
            "${joueur.name} : ${joueur.score} pts",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: estActif ? Colors.red : Colors.black, 
            ),
          ),
        ],
      );
    }).toList(),
  );
}
}

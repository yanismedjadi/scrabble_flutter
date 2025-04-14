import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/lettre.dart';
import '../controllers/game_controllers.dart';
import '../controllers/placement_validator.dart';
import 'widgets/board.dart';
import 'dart:ui' show Color, Offset;
import '../controllers/score_calculator.dart';
import '../controllers/verificateur_mots.dart';

class GameBoardScreen extends StatefulWidget {
  final List<Player> players;

  const GameBoardScreen({super.key, required this.players});

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
  final verificateur = VerificateurMots('assets/dictionnaire.txt');

  @override
  void initState() {
    super.initState();
    controller = GameController.fromPlayers(widget.players);
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
                    setState(() {
                      board[row][col] = lettre;
                      lettresPoseesCeTour.add(Offset(row.toDouble(), col.toDouble()));
                      controller.jouerLettre(lettre);
                    });
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
                    bool estValide = controller.validerMot(board, lettresDejaPosees, lettresPoseesCeTour);
                    bool tousValides = verificateur.verifierMots(board, lettresPoseesCeTour);
                    if (estValide && tousValides) {
                      lettresDejaPosees.addAll(lettresPoseesCeTour);
                      controller.finDeTour(board, lettresDejaPosees, lettresPoseesCeTour);
                      setState(() => _errorMessage = null);
                    } else {
                      if (!PlacementValidator.estAligne(lettresPoseesCeTour)) {
                        setState(() => _errorMessage = "Les lettres doivent être alignées en ligne droite");
                        controller.retirerLettresPosees(board, lettresPoseesCeTour);
                        return;
                      }
                      if (!PlacementValidator.allConnected(board, lettresPoseesCeTour)) {
                        setState(() => _errorMessage = "Les lettres doivent être connectées");
                        controller.retirerLettresPosees(board, lettresPoseesCeTour);
                        return;
                      }
                      if (controller.estPremierTour() && !PlacementValidator.toucheCentre(lettresPoseesCeTour)) {
                        setState(() => _errorMessage = "Le premier mot doit passer par la case centrale (★)");
                        controller.retirerLettresPosees(board, lettresPoseesCeTour);
                        return;
                      }
                      if (!controller.estPremierTour() && !PlacementValidator.estConnecte(board, lettresDejaPosees, lettresPoseesCeTour)) {
                        setState(() => _errorMessage = "Le mot doit être connecté à un mot existant");
                        controller.retirerLettresPosees(board, lettresPoseesCeTour);
                        return;
                      }
                    }
                    if (!tousValides) {
                      setState(() => _errorMessage = "Mot invalide");
                      controller.retirerLettresPosees(board, lettresPoseesCeTour);
                      return;
                    }
                  },
                  child: Text("Envoyer le mot"),
                ),
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
        return Row(
          children: [
            Icon(Icons.person, size: 16),
            SizedBox(width: 4),
            Text(
              "${joueur.name} : ${joueur.score} pts",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}

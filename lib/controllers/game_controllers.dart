import 'dart:ui';

import '../models/player.dart';
import '../models/sac_lettres.dart';
import '../models/lettre.dart';
import 'placement_validator.dart';
import 'verificateur_mots.dart';
import 'score_calculator.dart';

class GameController {
  final List<Player> joueurs;
  final SacLettres sacLettres;
  int joueurActuelIndex = 0;
  int numeroTour = 1;
  int pointsCeTour = 0;

  VerificateurMots verificateur = VerificateurMots('assets/dictionnaire.txt');

  GameController.fromPlayers(this.joueurs) : sacLettres = SacLettres() {
    for (var joueur in joueurs) {
      joueur.letters = List.generate(7, (_) => sacLettres.tirerLettre()!).whereType<Lettre>().toList();
    }
  }

  GameController(Player joueur1, Player joueur2)
      : joueurs = [joueur1, joueur2],
        sacLettres = SacLettres() {
    initialiserLettres();
  }

  Player get joueurActuel => joueurs[joueurActuelIndex];

  void updateScore(Player player, int newScore) {
    joueurActuel.updateScore(newScore);
  }

  void initialiserLettres() {
    for (var joueur in joueurs) {
      joueur.letters = List.generate(7, (_) => sacLettres.tirerLettre()!)
          .whereType<Lettre>()
          .toList();
    }
  }

  bool jouerLettre(Lettre lettre) {
    if (joueurActuel.letters.contains(lettre)) {
      joueurActuel.letters.remove(lettre);
      return true;
    }
    return false;
  }

  void completerLettres() {
    while (joueurActuel.letters.length < 7) {
      final lettre = sacLettres.tirerLettre();
      if (lettre == null) break;
      joueurActuel.letters.add(lettre);
    }
  }

  void passerAuJoueurSuivant() {
    joueurActuelIndex = (joueurActuelIndex + 1) % joueurs.length;
    numeroTour++;
  }

  bool estPremierTour() => numeroTour == 1;

  bool estPartieTerminee() {
    return sacLettres.list.isEmpty &&
        joueurs.any((p) => p.letters.isEmpty);
  }

  List<Player> get getJoueurs => joueurs;

  bool validerMot(List<List<Lettre?>> board, List<Offset> dejaPosees, List<Offset> positions) {
    if (positions.isEmpty) return false;
    if (estPremierTour()) {
      return PlacementValidator.estAligne(positions) &&
          PlacementValidator.toucheCentre(positions) &&
          PlacementValidator.allConnected(board, positions) &&
          verificateur.verifierMots(board, positions);
    } else {
      return PlacementValidator.estAligne(positions) &&
          PlacementValidator.estConnecte(board, dejaPosees, positions) &&
          PlacementValidator.allConnected(board, positions) &&
          verificateur.verifierMots(board, positions);
    }
  }

  void retirerLettresPosees(
      List<List<Lettre?>> board, List<Offset> lettresPoseesCeTour) {
    for (final pos in lettresPoseesCeTour) {
      int row = pos.dx.toInt();
      int col = pos.dy.toInt();

      final lettre = board[row][col];
      if (lettre != null) {
        joueurActuel.letters.add(lettre);
        board[row][col] = null;
      }
    }
    lettresPoseesCeTour.clear();
  }

  void finDeTour(List<List<Lettre?>> board, List<Offset> dejaPosees, List<Offset> lettresPoseesCeTour) {
    this.pointsCeTour = ScoreCalculator.calculScore(board, dejaPosees, lettresPoseesCeTour);
    updateScore(joueurActuel, this.pointsCeTour);
    this.pointsCeTour = 0;
    completerLettres();
    lettresPoseesCeTour.clear();
    print(pointsCeTour);
    print('score ${joueurActuel.name} : ${joueurActuel.score}');
    print('-----------fin de tour-------------------');
    passerAuJoueurSuivant();
  }
}

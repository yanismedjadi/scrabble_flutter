import 'dart:ui';

import 'package:flutter/foundation.dart';
import '../controllers/verificateur_mots.dart';
import '../models/player.dart';
import '../models/sac_lettres.dart';
import '../models/lettre.dart';
import 'placement_validator.dart';
import 'score_calculator.dart';

class GameController extends ChangeNotifier {
  final List<Player> joueurs;
  final SacLettres sacLettres;
  final String langue;
  int joueurActuelIndex = 0;
  int numeroTour = 1;
  int pointsCeTour = 0;
  late VerificateurMots verificateur;
  List<Offset> _bonusDejaUtilises = [];

  GameController.fromPlayers(this.joueurs,this.langue) : sacLettres = SacLettres(langue: langue) {
  _initGame(); 
  verificateur = VerificateurMots (langue);
}
  Future<void> _initGame() async {
   try {
    await sacLettres.initialiser();
    initialiserLettres();
  } catch (e) {
    throw Exception('Erreur initialisation: $e');
  }
   notifyListeners();
}

  Player get joueurActuel => joueurs[joueurActuelIndex];

  void updateScore(Player player, int newScore) {
    player.updateScore(newScore);
  }

 
 void initialiserLettres() {
  if (sacLettres.lettres.isEmpty) throw Exception('Sac non initialisé');
  
  for (final joueur in joueurs) {
    joueur.letters = [];
    for (int i = 0; i < 7; i++) {
      final lettre = sacLettres.tirerLettre();
      if (lettre != null) joueur.letters.add(lettre);
    }
    
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
    return sacLettres.lettres.isEmpty &&
        joueurs.any((p) => p.letters.isEmpty);
  }

  List<Player> get getJoueurs => joueurs;

  bool validerMot(List<List<Lettre?>> board, List<Offset> dejaPosees, List<Offset> positions) {
    if (positions.isEmpty) return false;
    if (estPremierTour()) {
      return PlacementValidator.estAligne(positions) &&
          PlacementValidator.toucheCentre(positions) &&
          PlacementValidator.allConnected(board, positions) ;
    } else {
      return PlacementValidator.estAligne(positions) &&
          PlacementValidator.estConnecte(board, dejaPosees, positions) &&
          PlacementValidator.allConnected(board, positions) ;
          
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
    this.pointsCeTour = ScoreCalculator.calculScore(board, dejaPosees, lettresPoseesCeTour, _bonusDejaUtilises);
    updateScore(joueurActuel, this.pointsCeTour);
    this.pointsCeTour = 0;
    completerLettres();
    lettresPoseesCeTour.clear();
    passerAuJoueurSuivant();
  }

  //AFFICHER LES MESSAGES D'ERREUR DE CHAQUES LANGUES


  String erreurMessage(String langue, List<List<Lettre?>> board, List<Offset> dejaPosees, List<Offset> positions) {
  bool tousValides = verificateur.verifierMots(board, positions);
  Set<String> mots = verificateur.recupereMots(board, positions);

  if (!PlacementValidator.estAligne(positions)) {
    return _getAlignmentError(langue);
  }
  if (!PlacementValidator.allConnected(board, positions)) {
    return _getConnectionError(langue);
  }
  if (estPremierTour() && !PlacementValidator.toucheCentre(positions)) {
    return _getCenterError(langue);
  }
  if (!estPremierTour() && !PlacementValidator.estConnecte(board, dejaPosees, positions)) {
    return _getExistingConnectionError(langue);
  }
  if (!tousValides) {
    return _getInvalidWordsError(langue, mots);
  }
  
  return "";
}
String _getAlignmentError(String langue) {
  switch (langue) {
    case 'Kabyle': return "Isekkilen ilaq ad ilin derren";
    case 'Anglais': return "Letters must be aligned in a straight line";
    default: return "Les lettres doivent être alignées en ligne droite";
  }
}
String _getConnectionError(String langue) {
  switch (langue) {
    case 'Kabyle': return "Isekkilen ilaq ad ilin qqnen";
    case 'Anglais': return "Letters must be connected";
    default: return "Les lettres doivent être connectées";
  }
}
String _getCenterError(String langue) {
  switch (langue) {
    case 'Kabyle': return "Ameslay amezwaru ilaq ad i3edi si tlemmast (★)";
    case 'Anglais': return "The first word must go through the center square (★)";
    default: return "Le premier mot doit passer par la case centrale (★)";
  }
}
String _getExistingConnectionError(String langue) {
  switch (langue) {
    case 'Kabyle': return "awal ilaq ad yili iqqen ar usekil yellan ";
    case 'Anglais': return "The word must be connected to an existing word";
    default: return "Le mot doit être connecté à un mot existant";
  }
}
String _getInvalidWordsError(String langue,Set<String>  mots) {
  switch (langue) {
    case 'Kabyle': return "Ur Isehha ara  : ${mots.join(', ')}".toLowerCase();
    case 'Anglais': return "Invalid words: ${mots.join(', ')}".toLowerCase();
    default: return "Mots invalides : ${mots.join(', ')}".toLowerCase();
  }
}
}
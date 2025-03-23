import '../models/player.dart';
import '../models/sac_lettres.dart';
import '../models/lettre.dart';

class GameController {
  final List<Player> joueurs;
  final SacLettres sacLettres;
  int joueurActuelIndex = 0;
  int numeroTour = 1;

  GameController(Player joueur1, Player joueur2)
      : joueurs = [joueur1, joueur2],
        sacLettres = SacLettres() {
    initialiserLettres();
  }

  Player get joueurActuel => joueurs[joueurActuelIndex];

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

  void ajouterPoints(int points) {
    joueurActuel.score += points;
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
}

//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import '../models/player.dart';
import '../models/sac_lettres.dart';
import '../models/lettre.dart';

class GameController {
  final Player player;
  final SacLettres sacLettres;

  GameController(this.player) : sacLettres = SacLettres() {
    initialiserLettres();
  }

  void initialiserLettres() {
    player.letters = List.generate(7, (_) => sacLettres.tirerLettre()!).whereType<Lettre>().toList();
  }

  bool jouerLettre(Lettre lettre) {
    if (player.letters.contains(lettre)) {
      Lettre l = lettre;
      player.letters.remove(lettre);
      return true;
    }
    return false;
  }

  void ajouterPoints(int points) {
    player.score += points;
  }
}

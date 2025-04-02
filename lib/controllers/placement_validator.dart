// 📄 lib/controllers/placement_validator.dart
import '../models/lettre.dart';
import 'dart:ui';

class PlacementValidator {
  static const int boardSize = 15;
  final List<List<String?>> bonusBoard = List.generate(15, (_) => List.filled(15, null));


  /// Vérifie si le premier mot passe par le centre (7,7)
  static bool toucheCentre(List<Offset> positions) {
    return positions.any((p) => p.dx == 7 && p.dy == 7);
  }

  static void trierLettres(List<Offset> poseesCeTour, bool estHorizontal) {
    poseesCeTour.sort((Offset a, Offset b) {
      if (!estHorizontal) {
        if (a.dx < b.dx) {
          return -1;  // a vient avant b
        } else if (a.dx > b.dx) {
          return 1;   // a vient après b
        } else {
          return 0;   // a et b sont égaux sur l'axe horizontal
        }
      } else {
        if (a.dy < b.dy) {
          return -1;  // a vient avant b
        } else if (a.dy > b.dy) {
          return 1;   // a vient après b
        } else {
          return 0;   // a et b sont égaux sur l'axe vertical
        }
      }
    });
  }


  /// verifie s'il y'a pas de vide entre les lettre
  static bool allConnected(List<List<Lettre?>> board, List<Offset> poseesCeTour){
    bool isHorizontal =  poseesCeTour.every((p) => p.dx == poseesCeTour[0].dx);
    trierLettres(poseesCeTour, isHorizontal);
    print(poseesCeTour);
    return aucunEspaceVide(board, poseesCeTour, isHorizontal);
  }

  static bool aucunEspaceVide(List<List<Lettre?>> board, List<Offset> poseesCeTour, bool estHorizontal) {
    int fixe = 0;
    int debut = 0;
    int fin = 0;
    if (estHorizontal) {
      fixe = poseesCeTour[0].dx.toInt();
      debut = poseesCeTour.first.dy.toInt();
      fin = poseesCeTour.last.dy.toInt();
    }else {
      fixe = poseesCeTour[0].dy.toInt();
      debut = poseesCeTour.first.dx.toInt();
      fin = poseesCeTour.last.dx.toInt();
    }

    for (int i = debut; i < fin + 1; i++) {
      int x = estHorizontal ? fixe : i;
      int y = estHorizontal ? i : fixe;

      // Vérifie si la case actuelle est occupée
      if (board[x][y] == null) {
        // Case vide détectée entre les lettres posées
        return false;
      }
    }

    return true;
  }

  /// Vérifie si les lettres posées ce tour sont alignées
  static bool estAligne(List<Offset> positions) {
    if (positions.length <= 1) {
      return true;
    }
    final toutesSurLigne = positions.every((p) => p.dx == positions[0].dx);
    final toutesSurColonne = positions.every((p) => p.dy == positions[0].dy);
    return toutesSurLigne || toutesSurColonne;
  }
  static bool _compar(bool isHorizontal,int indice,Offset p){
    if(isHorizontal) {
      return p.dx == indice;
    }else {
      return p.dy == indice;
    }
  }

  /// Vérifie si le mot est connecté à une lettre déjà existante
  static bool estConnecte(List<List<Lettre?>> board, List<Offset> dejaPosees, List<Offset> positions) {
    for (final pos in positions) {
      final voisins = [
        Offset(pos.dx - 1, pos.dy),
        Offset(pos.dx + 1, pos.dy),
        Offset(pos.dx, pos.dy - 1),
        Offset(pos.dx, pos.dy + 1),
      ];
      for (final v in voisins) {
        if (dejaPosees.contains(v)) {
          return true;
        }
      }
    }
    return false;
  }

}